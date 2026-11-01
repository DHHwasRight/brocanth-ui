//! Tabs. Zag `@zag-js/tabs` (tabs.ts) adds the arrow keys, Home/End and the
//! roving focus. The server renders the open tab, so the page is right
//! before the glue loads.
//!
//! Tabs that load their panel from the server are links, not this
//! component: put `TabsLink`s in a `TabsList`, outside `Tabs`, so no glue
//! mounts and each tab is an ordinary link (dp-swap can boost it).
//!
//! The look comes from tokens: shadcn draws a pill on a muted track;
//! the original theme draws an underline on a divider.

pub fn Tabs(id: &str, value: &str, children: Element) -> Element {
    <div id={id} data-ui="tabs" data-part="root" data-value={value} class="flex flex-col gap-3">{children}</div>
}

pub fn TabsList(label: &str, children: Element) -> Element {
    <div data-part="list" role="tablist" aria-label={label} class="inline-flex h-control w-fit items-center rounded-(--ui-tabs-list-radius) bg-(--ui-tabs-list) p-(--ui-tabs-list-pad) text-muted-foreground [box-shadow:var(--ui-tabs-list-shadow)]">{children}</div>
}

pub fn TabsTrigger(value: &str, selected: bool, children: Element) -> Element {
    <button type="button" data-part="trigger" data-value={value} role="tab" aria-selected={selected} class="inline-flex h-full flex-1 cursor-pointer items-center justify-center gap-1.5 rounded-(--ui-tabs-trigger-radius) px-3 text-sm font-control whitespace-nowrap transition-[color,box-shadow] outline-none hover:text-heading focus-visible:ring-[3px] focus-visible:ring-ring/50 aria-selected:bg-(--ui-tabs-active) aria-selected:text-(--ui-tabs-active-text) aria-selected:[box-shadow:var(--ui-tabs-active-shadow)] [&_svg]:size-4">
        {children}
    </button>
}

pub fn TabsContent(value: &str, selected: bool, children: Element) -> Element {
    <div data-part="content" data-value={value} role="tabpanel" tabindex="0" hidden?={!selected} class="text-sm outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50 rounded-md">{children}</div>
}

/// A tab that is a link: its panel is another page. Same look as
/// `TabsTrigger`; `selected` marks the current page's tab.
pub fn TabsLink(href: &str, selected: bool, children: Element) -> Element {
    <a href={href} role="tab" aria-selected={selected} class="inline-flex h-full flex-1 cursor-pointer items-center justify-center gap-1.5 rounded-(--ui-tabs-trigger-radius) px-3 text-sm font-control whitespace-nowrap transition-[color,box-shadow] outline-none hover:text-heading focus-visible:ring-[3px] focus-visible:ring-ring/50 aria-selected:bg-(--ui-tabs-active) aria-selected:text-(--ui-tabs-active-text) aria-selected:[box-shadow:var(--ui-tabs-active-shadow)] [&_svg]:size-4">
        {children}
    </a>
}
