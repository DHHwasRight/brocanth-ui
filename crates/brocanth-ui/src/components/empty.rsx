//! Empty state. No JavaScript.

/// `children` holds the actions (buttons, links).
pub fn Empty(title: &str, description: &str, children: Element) -> Element {
    <div class="flex min-w-0 flex-1 flex-col items-center justify-center gap-6 rounded-lg border border-dashed p-6 text-center text-balance md:p-12">
        <div class="flex max-w-sm flex-col items-center gap-2">
            <div class="mb-2 flex size-10 items-center justify-center rounded-lg bg-muted text-heading [&_svg]:size-6">{! crate::icons::INBOX }</div>
            <div class="text-lg font-heading tracking-tight text-heading">{title}</div>
            <p class="text-sm/relaxed text-muted-foreground">{description}</p>
        </div>
        <div class="flex w-full max-w-sm min-w-0 flex-wrap items-center justify-center gap-2">{children}</div>
    </div>
}
