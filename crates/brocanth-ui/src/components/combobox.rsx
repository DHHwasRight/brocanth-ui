//! Combobox: an input that filters a list. Zag `@zag-js/combobox`
//! (combobox.ts) adds the keyboard, filtering and placement. A hidden input
//! posts the chosen value; the visible input holds its label.
//! For a short list with no styling needs, `<input list>` with a
//! `<datalist>` needs no JavaScript.

/// `options` are `(value, label)`. `id` must be unique on the page.
pub fn Combobox(id: &str, name: &str, label: &str, value: &str, placeholder: &str, options: &[(&str, &str)]) -> Element {
    <div id={id} data-ui="combobox" data-part="root" data-value={value} data-placeholder={placeholder} class="grid w-full gap-2">
        <label data-part="label" class="text-sm font-control leading-none text-heading">{label}</label>
        <div data-part="control" class="relative">
            <input data-part="input" placeholder={placeholder} value={label_of(options, value)} autocomplete="off" class="flex h-control w-full min-w-0 rounded-md border border-input bg-background pr-9 pl-3 text-sm text-foreground shadow-control outline-none placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50">
            <button type="button" data-part="trigger" tabindex="-1" aria-label="Show options" class="absolute inset-y-0 right-0 flex w-9 cursor-pointer items-center justify-center text-muted-foreground [&_svg]:size-4">{! crate::icons::CHEVRONS_UP_DOWN }</button>
        </div>
        <input type="hidden" name={name} value={value} data-part="value-input">
        <div data-part="positioner" class="z-50">
            <div data-part="content" hidden class="ui-pop max-h-[min(18rem,var(--available-height))] overflow-y-auto rounded-md border bg-popover p-1 text-popover-foreground shadow-overlay outline-none">
                for (option, option_label) in options {
                    <div data-part="item" data-value={option} data-label={option_label} class="relative flex cursor-pointer items-center gap-2 rounded-sm py-1.5 pr-8 pl-2 text-sm outline-none select-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50 data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground">
                        <span data-part="item-text">{option_label}</span>
                        <span data-part="item-indicator" hidden?={*option != value} class="absolute right-2 flex size-4 items-center justify-center [&_svg]:size-4">{! crate::icons::CHECK }</span>
                    </div>
                }
                <div data-part="empty" hidden class="py-6 text-center text-sm text-muted-foreground">No results.</div>
            </div>
        </div>
    </div>
}

fn label_of<'a>(options: &[(&str, &'a str)], value: &str) -> &'a str {
    options.iter().find(|(option, _)| *option == value).map_or("", |(_, label)| label)
}
