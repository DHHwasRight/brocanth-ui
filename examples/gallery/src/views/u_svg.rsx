//! Examples for the SVG utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: fill, stroke, stroke-width

pub fn Examples(slug: &str) -> Element {
    match slug {
        "fill" => <FillExample />,
        "stroke" => <StrokeExample />,
        "stroke-width" => <StrokeWidthExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

pub fn FillExample() -> Element {
    <div class="flex flex-wrap gap-8">
        <div class="grid justify-items-center gap-2">
            <svg viewBox="0 0 24 24" class="size-12 fill-primary"><path d="M3 6a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2zm0 3v3h18V9z" /></svg>
            <Caption text="fill-primary" />
        </div>
        <div class="grid justify-items-center gap-2">
            <svg viewBox="0 0 24 24" class="size-12 fill-chart-2"><path d="M3 6a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2zm0 3v3h18V9z" /></svg>
            <Caption text="fill-chart-2" />
        </div>
        <div class="grid justify-items-center gap-2">
            <svg viewBox="0 0 24 24" class="size-12 fill-success"><path d="M3 6a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2zm0 3v3h18V9z" /></svg>
            <Caption text="fill-success" />
        </div>
        <div class="grid justify-items-center gap-2 text-destructive">
            <svg viewBox="0 0 24 24" class="size-12 fill-current"><path d="M3 6a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2zm0 3v3h18V9z" /></svg>
            <Caption text="fill-current" />
        </div>
    </div>
}

pub fn StrokeExample() -> Element {
    <div class="flex flex-wrap gap-8">
        <div class="grid justify-items-center gap-2">
            <svg viewBox="0 0 64 32" class="h-12 w-24 fill-none stroke-primary stroke-2"><polyline points="2,28 16,18 28,22 42,8 62,4" /></svg>
            <Caption text="stroke-primary" />
        </div>
        <div class="grid justify-items-center gap-2">
            <svg viewBox="0 0 64 32" class="h-12 w-24 fill-none stroke-chart-2 stroke-2"><polyline points="2,20 16,24 28,12 42,16 62,6" /></svg>
            <Caption text="stroke-chart-2" />
        </div>
        <div class="grid justify-items-center gap-2">
            <svg viewBox="0 0 64 32" class="h-12 w-24 fill-none stroke-destructive stroke-2"><polyline points="2,4 16,10 28,8 42,20 62,28" /></svg>
            <Caption text="stroke-destructive" />
        </div>
    </div>
}

pub fn StrokeWidthExample() -> Element {
    <div class="flex flex-wrap gap-8">
        <div class="grid justify-items-center gap-2">
            <svg viewBox="0 0 24 24" class="size-12 fill-none stroke-chart-1 stroke-1"><circle cx="12" cy="12" r="9" /><path d="M8 12l3 3 5-6" /></svg>
            <Caption text="stroke-1" />
        </div>
        <div class="grid justify-items-center gap-2">
            <svg viewBox="0 0 24 24" class="size-12 fill-none stroke-chart-1 stroke-2"><circle cx="12" cy="12" r="9" /><path d="M8 12l3 3 5-6" /></svg>
            <Caption text="stroke-2" />
        </div>
        <div class="grid justify-items-center gap-2">
            <svg viewBox="0 0 24 24" class="size-12 fill-none stroke-chart-1 stroke-[3.5]"><circle cx="12" cy="12" r="9" /><path d="M8 12l3 3 5-6" /></svg>
            <Caption text="stroke-[3.5]" />
        </div>
    </div>
}
