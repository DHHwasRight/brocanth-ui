//! Select with a styled list. Zag `@zag-js/select` (select.ts) adds the
//! keyboard, typeahead and placement. The server renders a hidden native
//! `<select>` with the same options: the form posts it, with or without
//! the glue. For plain forms, `NativeSelect` needs no JavaScript at all.

/// `options` are `(value, label)`; `value` may be empty (then the
/// placeholder shows). `id` must be unique on the page.
pub fn Select(id: &str, name: &str, label: &str, value: &str, placeholder: &str, options: &[(&str, &str)]) -> Element {
    <div id={id} data-ui="select" data-part="root" data-value={value} data-name={name} class="grid w-full gap-2">
        <label data-part="label" class="text-sm font-control leading-none text-heading">{label}</label>
        <div data-part="control">
            <button type="button" data-part="trigger" class="flex h-control w-full cursor-pointer items-center justify-between gap-2 rounded-md border border-input bg-background px-3 text-sm text-foreground shadow-control outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 data-[placeholder-shown]:text-muted-foreground">
                <span data-part="value-text" data-placeholder={placeholder} class="truncate">{selected_label(options, value, placeholder)}</span>
                <span data-part="indicator" class="text-muted-foreground [&_svg]:size-4">{! crate::icons::CHEVRON_DOWN }</span>
            </button>
        </div>
        <div data-part="positioner" class="z-50">
            <div data-part="content" hidden class="ui-pop max-h-[min(18rem,var(--available-height))] overflow-y-auto rounded-md border bg-popover p-1 text-popover-foreground shadow-overlay outline-none">
                for (option, option_label) in options {
                    <div data-part="item" data-value={option} data-label={option_label} class="relative flex cursor-pointer items-center gap-2 rounded-sm py-1.5 pr-8 pl-2 text-sm outline-none select-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50 data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground">
                        <span data-part="item-text">{option_label}</span>
                        <span data-part="item-indicator" hidden?={*option != value} class="absolute right-2 flex size-4 items-center justify-center [&_svg]:size-4">{! crate::icons::CHECK }</span>
                    </div>
                }
            </div>
        </div>
        <select data-part="hidden-select" name={name} tabindex="-1" aria-hidden="true" class="sr-only">
            <option value=""></option>
            for (option, option_label) in options {
                <option value={option} selected?={*option == value}>{option_label}</option>
            }
        </select>
    </div>
}

fn selected_label<'a>(options: &[(&str, &'a str)], value: &str, placeholder: &'a str) -> &'a str {
    options.iter().find(|(option, _)| *option == value).map_or(placeholder, |(_, label)| label)
}
