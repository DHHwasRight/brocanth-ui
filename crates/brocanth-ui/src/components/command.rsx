//! Command palette: a filter input over a list of actions. Zag
//! `@zag-js/listbox` (command.ts) adds the filtering and the keyboard from
//! the input. Put it inside a `Dialog` for a ⌘K palette.

pub fn Command(id: &str, placeholder: &str, children: Element) -> Element {
    <div id={id} data-ui="command" data-part="root" class="flex w-full flex-col overflow-hidden rounded-lg border bg-popover text-popover-foreground shadow-control">
        <div class="flex h-11 items-center gap-2 border-b px-3 text-muted-foreground [&_svg]:size-4 [&_svg]:shrink-0">
            {! crate::icons::SEARCH }
            <input data-part="input" placeholder={placeholder} autocomplete="off" class="h-full w-full bg-transparent text-sm text-foreground outline-none placeholder:text-muted-foreground">
        </div>
        <div data-part="content" class="max-h-72 overflow-y-auto p-1 outline-none">
            {children}
            <div data-part="empty" hidden class="py-6 text-center text-sm text-muted-foreground">No results found.</div>
        </div>
    </div>
}

/// `id` names the group for `aria-labelledby`; unique on the page.
pub fn CommandGroup(id: &str, heading: &str, children: Element) -> Element {
    <div data-part="item-group" data-group={id} class="overflow-hidden p-1">
        <div data-part="item-group-label" data-group={id} class="px-2 py-1.5 text-xs font-control text-muted-foreground">{heading}</div>
        {children}
    </div>
}

/// `href` may be empty: then the item only emits `ui:select`. `icon` is
/// raw HTML and may be empty.
pub fn CommandItem(value: &str, href: &str, icon: &str, shortcut: &str, children: Element) -> Element {
    if href.is_empty() {
        <div data-part="item" data-value={value} class={item_class()}>{! icon }<span>{children}</span><Shortcut text={shortcut} /></div>
    } else {
        <a data-part="item" data-value={value} href={href} class={item_class()}>{! icon }<span>{children}</span><Shortcut text={shortcut} /></a>
    }
}

pub fn CommandSeparator() -> Element {
    <div role="separator" class="-mx-1 h-px bg-border"></div>
}

fn Shortcut(text: &str) -> Element {
    if !text.is_empty() {
        <span class="ml-auto text-xs tracking-widest text-muted-foreground">{text}</span>
    }
}

fn item_class() -> &'static str {
    "relative flex cursor-pointer items-center gap-2 rounded-sm px-2 py-1.5 text-sm outline-none select-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50 data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground [&_svg]:size-4 [&_svg]:text-muted-foreground"
}
