//! Keyboard key. No JavaScript.

pub fn Kbd(children: Element) -> Element {
    <kbd class="pointer-events-none inline-flex h-5 min-w-5 items-center justify-center gap-1 rounded-sm border bg-muted px-1 font-sans text-xs font-control text-muted-foreground select-none">{children}</kbd>
}

pub fn KbdGroup(children: Element) -> Element {
    <span class="inline-flex items-center gap-1">{children}</span>
}
