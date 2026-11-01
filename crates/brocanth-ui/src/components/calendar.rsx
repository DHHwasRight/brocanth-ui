//! Calendar and date picker. No JavaScript for the calendar.
//!
//! - The server renders one month. Each day is a radio input, so the
//!   selected date posts with the form and arrow keys move the selection.
//! - Previous and next are links to `<nav_base>month=YYYY-MM`. With dp-swap
//!   loaded, they fetch that page and swap in only this calendar
//!   (`dp-select`); without it, they load the page. The app's handler reads
//!   `month` and renders the calendar again.
//! - On a static site, which cannot read a query, `nav_base` is a path with
//!   `{month}` in it (`/calendar/start/{month}`): the link is that path with
//!   the month in place, one prerendered page per month.
//!
//! The date picker adds one small glue file (date-picker.js, no Zag): it
//! writes the chosen date into the trigger and closes the popover.

use crate::date::{Date, Month, WEEKDAYS};
use crate::{class, ButtonSize, ButtonVariant};

/// `month` is `YYYY-MM`; `selected` and `today` are `YYYY-MM-DD` or empty.
/// `nav_base` ends in `?` or `&`, or holds `{month}`.
pub fn Calendar(id: &str, name: &str, month: &str, selected: &str, today: &str, nav_base: &str) -> Element {
    let shown = shown_month(month, selected, today);
    let selected = Date::parse(selected);
    let today = Date::parse(today);
    let target = format!("#{id}");
    <div id={id} data-calendar class="w-fit rounded-md border bg-background p-3 text-foreground">
        <div class="relative flex h-8 items-center justify-center">
            <a href={nav_href(nav_base, shown.previous())} dp-get={nav_href(nav_base, shown.previous())} dp-target={&target} dp-select={&target} dp-swap="outerHTML" aria-label="Previous month" class={nav_class("left-0")}>{! crate::icons::CHEVRON_LEFT }</a>
            <div aria-live="polite" class="text-sm font-control text-heading">{shown.title()}</div>
            <a href={nav_href(nav_base, shown.next())} dp-get={nav_href(nav_base, shown.next())} dp-target={&target} dp-select={&target} dp-swap="outerHTML" aria-label="Next month" class={nav_class("right-0")}>{! crate::icons::CHEVRON_RIGHT }</a>
        </div>
        <table class="mt-3 border-collapse" role="presentation">
            <thead>
                <tr>
                    for day in WEEKDAYS {
                        <th scope="col" class="size-8 text-[0.8rem] font-normal text-muted-foreground">{day}</th>
                    }
                </tr>
            </thead>
            <tbody>
                for week in shown.weeks() {
                    <tr>
                        for cell in week {
                            <td class="p-0 text-center">
                                <label class={day_class(cell.outside, Some(cell.date) == today)} aria-label={cell.date.human()}>
                                    <input type="radio" name={name} value={cell.date.to_string()} checked?={Some(cell.date) == selected} data-human={cell.date.human()} class="sr-only">
                                    {cell.date.day}
                                </label>
                            </td>
                        }
                    </tr>
                }
            </tbody>
        </table>
    </div>
}

fn shown_month(month: &str, selected: &str, today: &str) -> Month {
    Month::parse(month)
        .or_else(|| Date::parse(selected).map(Month::of))
        .or_else(|| Date::parse(today).map(Month::of))
        .unwrap_or(Month { year: 2026, month: 1 })
}

fn nav_href(base: &str, month: Month) -> String {
    if base.contains("{month}") {
        base.replace("{month}", &month.to_string())
    } else {
        format!("{base}month={month}")
    }
}

fn nav_class(side: &str) -> String {
    format!("absolute {side} inline-flex size-7 items-center justify-center rounded-md border border-input bg-background text-foreground opacity-70 shadow-control hover:opacity-100 [&_svg]:size-4")
}

fn day_class(outside: bool, today: bool) -> &'static str {
    match (outside, today) {
        (true, _) => "inline-flex size-8 cursor-pointer items-center justify-center rounded-md text-sm text-muted-foreground/60 hover:bg-accent has-[:checked]:bg-primary has-[:checked]:text-primary-foreground has-[:focus-visible]:ring-[3px] has-[:focus-visible]:ring-ring/50",
        (false, true) => "inline-flex size-8 cursor-pointer items-center justify-center rounded-md bg-accent text-sm font-control text-accent-foreground hover:bg-accent has-[:checked]:bg-primary has-[:checked]:text-primary-foreground has-[:focus-visible]:ring-[3px] has-[:focus-visible]:ring-ring/50",
        (false, false) => "inline-flex size-8 cursor-pointer items-center justify-center rounded-md text-sm text-foreground transition-colors hover:bg-accent hover:text-accent-foreground has-[:checked]:bg-primary has-[:checked]:text-primary-foreground has-[:focus-visible]:ring-[3px] has-[:focus-visible]:ring-ring/50",
    }
}

/// A button that shows the date, with the calendar in a popover. `id`
/// must be a CSS identifier.
pub fn DatePicker(id: &str, name: &str, month: &str, selected: &str, today: &str, nav_base: &str, placeholder: &str) -> Element {
    let popover = format!("{id}-popover");
    <div id={id} data-ui="date-picker" class="contents">
        <button type="button" commandfor={&popover} command="toggle-popover" class={format!("{} w-56 justify-start font-normal", class::button(ButtonVariant::Outline, ButtonSize::Md))} style={format!("anchor-name: --{popover}")}>
            {! crate::icons::CALENDAR }
            <span data-part="value" data-placeholder={placeholder} class="data-[empty]:text-muted-foreground" { ...[("data-empty", Date::parse(selected).is_none())] }>{picker_label(selected, placeholder)}</span>
        </button>
        <div id={&popover} popover data-anchored class="ui-pop inset-auto m-0 mt-1 rounded-md shadow-overlay [position-area:block-end_span-inline-end] [position-try-fallbacks:flip-block]" style={format!("position-anchor: --{popover}")}>
            <Calendar id={&format!("{id}-calendar")} name={name} month={month} selected={selected} today={today} nav_base={nav_base} />
        </div>
    </div>
}

fn picker_label(selected: &str, placeholder: &str) -> String {
    Date::parse(selected).map_or_else(|| placeholder.to_string(), Date::human)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn nav_href_appends_a_query_or_fills_a_path() {
        let may = Month { year: 2026, month: 5 };
        assert_eq!(nav_href("/demo?", may), "/demo?month=2026-05");
        assert_eq!(nav_href("/calendar/start/{month}", may), "/calendar/start/2026-05");
    }
}
