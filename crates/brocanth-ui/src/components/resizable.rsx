//! Resizable panels. Zag `@zag-js/splitter` (resizable.ts) adds the drag
//! and the keyboard (arrows on the handle). The server renders the sizes,
//! so the layout does not move when the glue loads.

/// `vertical` stacks the panels. `id` must be unique on the page.
pub fn Resizable(id: &str, vertical: bool, children: Element) -> Element {
    <div id={id} data-ui="resizable" data-part="root" data-orientation={orientation(vertical)} class="flex size-full data-[orientation=vertical]:flex-col">{children}</div>
}

/// `size` and `min` are percentages of the group.
pub fn ResizablePanel(id: &str, size: u8, min: u8, children: Element) -> Element {
    <div data-part="panel" data-id={id} data-size={size} data-min={min} class="overflow-hidden" style={format!("flex: {size} 1 0px")}>{children}</div>
}

/// The handle between panels `before` and `after`.
pub fn ResizableHandle(before: &str, after: &str) -> Element {
    <div data-part="resize-trigger" data-id={format!("{before}:{after}")} role="separator" tabindex="0" class="relative flex w-px shrink-0 cursor-col-resize items-center justify-center bg-border outline-none after:absolute after:inset-y-0 after:-left-1 after:w-2 focus-visible:ring-[3px] focus-visible:ring-ring/50 data-[orientation=vertical]:h-px data-[orientation=vertical]:w-full data-[orientation=vertical]:cursor-row-resize">
        <span class="z-10 flex h-4 w-3 items-center justify-center rounded-xs border bg-border text-muted-foreground [&_svg]:size-2.5">{! crate::icons::GRIP_VERTICAL }</span>
    </div>
}

fn orientation(vertical: bool) -> &'static str {
    if vertical { "vertical" } else { "horizontal" }
}
