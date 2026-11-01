//! Examples for the Accessibility utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: forced-color-adjust

pub fn Examples(slug: &str) -> Element {
    match slug {
        "forced-color-adjust" => <ForcedColorAdjustExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

pub fn ForcedColorAdjustExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <div class="forced-color-adjust-auto flex gap-2 rounded-md border bg-card p-3 shadow-control">
                <span class="size-8 rounded-md bg-chart-1"></span>
                <span class="size-8 rounded-md bg-chart-2"></span>
                <span class="size-8 rounded-md bg-chart-3"></span>
            </div>
            <Caption text="forced-color-adjust-auto: swatches lose their colours in forced-colours mode" />
        </div>
        <div class="grid gap-2">
            <div class="forced-color-adjust-none flex gap-2 rounded-md border bg-card p-3 shadow-control">
                <span class="size-8 rounded-md bg-chart-1"></span>
                <span class="size-8 rounded-md bg-chart-2"></span>
                <span class="size-8 rounded-md bg-chart-3"></span>
            </div>
            <Caption text="forced-color-adjust-none: the card brand colours stay" />
        </div>
    </div>
}
