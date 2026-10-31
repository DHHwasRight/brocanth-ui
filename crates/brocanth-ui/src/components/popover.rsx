//! Popover: the native `popover` attribute, opened by an invoker button and
//! placed with CSS anchor positioning. No JavaScript.
//!
//! The browser gives it the top layer, light dismiss (outside click,
//! Escape), and one open popover at a time. Where anchor positioning is
//! missing, the popover centres on the screen (theme.css).
//!
//! `id` must be a CSS identifier too (letters, digits, `-`, `_`): it names
//! the anchor (`--<id>`).

use crate::{class, ButtonSize, ButtonVariant};

pub fn PopoverTrigger(target: &str, variant: ButtonVariant, children: Element) -> Element {
    <button type="button" commandfor={target} command="toggle-popover" class={class::button(variant, ButtonSize::Md)} style={format!("anchor-name: --{target}")}>{children}</button>
}

pub fn PopoverContent(id: &str, label: &str, children: Element) -> Element {
    <div id={id} popover data-anchored role="dialog" aria-label={label} class="ui-pop inset-auto m-0 mt-1 w-72 rounded-md border bg-popover p-4 text-popover-foreground shadow-overlay outline-none [position-area:block-end_span-inline-end] [position-try-fallbacks:flip-block,flip-inline]" style={format!("position-anchor: --{id}")}>
        {children}
    </div>
}
