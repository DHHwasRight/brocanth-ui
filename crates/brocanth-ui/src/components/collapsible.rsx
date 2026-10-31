//! Collapsible. No JavaScript: `<details>`/`<summary>`.

pub fn Collapsible(title: &str, open: bool, children: Element) -> Element {
    <details class="ui-collapse group" open?={open}>
        <summary class="flex cursor-pointer items-center justify-between gap-4 rounded-md px-4 py-2 text-sm font-control text-heading outline-none hover:bg-accent focus-visible:ring-[3px] focus-visible:ring-ring/50 [&_svg]:size-4 [&_svg]:text-muted-foreground">
            {title}
            {! crate::icons::CHEVRONS_UP_DOWN }
        </summary>
        <div class="grid gap-2 pt-2">{children}</div>
    </details>
}
