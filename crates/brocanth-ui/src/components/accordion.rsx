//! Accordion. No JavaScript: `<details>`/`<summary>`. Items with the same
//! `name` are exclusive (one open at a time); the browser enforces it.
//! Find-in-page opens a closed item that holds the match.

/// Groups items. Pass the same `name` to each `AccordionItem` for "one
/// open at a time", or an empty name for "any number open".
pub fn Accordion(children: Element) -> Element {
    <div class="w-full divide-y border-b">{children}</div>
}

pub fn AccordionItem(name: &str, title: &str, open: bool, children: Element) -> Element {
    <details class="group" open?={open} { ...[("name", non_empty(name))] }>
        <summary class="flex cursor-pointer items-start justify-between gap-4 rounded-md py-4 text-left text-sm font-control text-heading outline-none transition-all hover:underline focus-visible:ring-[3px] focus-visible:ring-ring/50 [&_svg]:size-4 [&_svg]:shrink-0 [&_svg]:translate-y-0.5 [&_svg]:text-muted-foreground [&_svg]:transition-transform group-open:[&_svg]:rotate-180">
            {title}
            {! crate::icons::CHEVRON_DOWN }
        </summary>
        <div class="pb-4 text-sm text-foreground">{children}</div>
    </details>
}

fn non_empty(value: &str) -> Option<&str> {
    (!value.is_empty()).then_some(value)
}
