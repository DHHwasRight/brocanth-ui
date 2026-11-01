//! Examples for the Transforms utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: backface-visibility, perspective, perspective-origin, rotate, scale, skew, transform, transform-origin, transform-style, translate, zoom

pub fn Examples(slug: &str) -> Element {
    match slug {
        "backface-visibility" => <BackfaceVisibilityExample />,
        "perspective" => <PerspectiveExample />,
        "perspective-origin" => <PerspectiveOriginExample />,
        "rotate" => <RotateExample />,
        "scale" => <ScaleExample />,
        "skew" => <SkewExample />,
        "transform" => <TransformExample />,
        "transform-origin" => <TransformOriginExample />,
        "transform-style" => <TransformStyleExample />,
        "translate" => <TranslateExample />,
        "zoom" => <ZoomExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

pub fn BackfaceVisibilityExample() -> Element {
    <div class="flex flex-wrap gap-8">
        <div class="grid gap-2">
            <div class="flex h-20 w-32 rotate-y-180 items-center justify-center rounded-md bg-primary text-sm text-primary-foreground backface-visible">Visa 4242</div>
            <Caption text="rotate-y-180 backface-visible" />
        </div>
        <div class="grid gap-2">
            <div class="h-20 w-32 rounded-md border border-dashed">
                <div class="flex size-full rotate-y-180 items-center justify-center rounded-md bg-primary text-sm text-primary-foreground backface-hidden">Visa 4242</div>
            </div>
            <Caption text="rotate-y-180 backface-hidden" />
        </div>
    </div>
}

pub fn PerspectiveExample() -> Element {
    <div class="grid gap-6 sm:grid-cols-3">
        <div class="grid gap-2 perspective-dramatic">
            <div class="flex h-20 rotate-x-45 items-center justify-center rounded-md bg-chart-1 text-sm text-white">$1,250.00</div>
            <Caption text="perspective-dramatic" />
        </div>
        <div class="grid gap-2 perspective-normal">
            <div class="flex h-20 rotate-x-45 items-center justify-center rounded-md bg-chart-2 text-sm text-white">$1,250.00</div>
            <Caption text="perspective-normal" />
        </div>
        <div class="grid gap-2 perspective-distant">
            <div class="flex h-20 rotate-x-45 items-center justify-center rounded-md bg-chart-3 text-sm text-white">$1,250.00</div>
            <Caption text="perspective-distant" />
        </div>
    </div>
}

pub fn PerspectiveOriginExample() -> Element {
    <div class="grid gap-6 sm:grid-cols-3">
        <div class="grid gap-2 perspective-near perspective-origin-top-left">
            <div class="flex h-20 rotate-x-30 rotate-y-30 items-center justify-center rounded-md bg-primary text-sm text-primary-foreground">Payout</div>
            <Caption text="perspective-origin-top-left" />
        </div>
        <div class="grid gap-2 perspective-near perspective-origin-center">
            <div class="flex h-20 rotate-x-30 rotate-y-30 items-center justify-center rounded-md bg-primary text-sm text-primary-foreground">Payout</div>
            <Caption text="perspective-origin-center" />
        </div>
        <div class="grid gap-2 perspective-near perspective-origin-bottom-right">
            <div class="flex h-20 rotate-x-30 rotate-y-30 items-center justify-center rounded-md bg-primary text-sm text-primary-foreground">Payout</div>
            <Caption text="perspective-origin-bottom-right" />
        </div>
    </div>
}

pub fn RotateExample() -> Element {
    <div class="flex flex-wrap gap-10 p-4">
        <div class="grid justify-items-center gap-3"><div class="size-16 rotate-6 rounded-md bg-chart-1"></div><Caption text="rotate-6" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 rotate-45 rounded-md bg-chart-2"></div><Caption text="rotate-45" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 -rotate-12 rounded-md bg-chart-3"></div><Caption text="-rotate-12" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 rotate-x-50 rotate-z-45 rounded-md bg-chart-4"></div><Caption text="rotate-x-50 rotate-z-45" /></div>
    </div>
}

pub fn ScaleExample() -> Element {
    <div class="flex flex-wrap gap-10 p-4">
        <div class="grid justify-items-center gap-3"><div class="size-16 scale-75 rounded-md bg-chart-1"></div><Caption text="scale-75" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 scale-100 rounded-md bg-chart-2"></div><Caption text="scale-100" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 scale-125 rounded-md bg-chart-3"></div><Caption text="scale-125" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 scale-x-50 rounded-md bg-chart-4"></div><Caption text="scale-x-50" /></div>
    </div>
}

pub fn SkewExample() -> Element {
    <div class="flex flex-wrap gap-10 p-4">
        <div class="grid justify-items-center gap-3"><div class="size-16 skew-3 rounded-md bg-chart-1"></div><Caption text="skew-3" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 skew-x-12 rounded-md bg-chart-2"></div><Caption text="skew-x-12" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 -skew-y-6 rounded-md bg-chart-3"></div><Caption text="-skew-y-6" /></div>
    </div>
}

pub fn TransformExample() -> Element {
    <div class="flex flex-wrap gap-10 p-4">
        <div class="grid justify-items-center gap-3"><div class="size-16 transform-gpu rotate-12 scale-110 rounded-md bg-chart-1"></div><Caption text="transform-gpu rotate-12 scale-110" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 transform-[matrix(1,0.2,0,1,0,0)] rounded-md bg-chart-2"></div><Caption text="transform-[matrix(1,0.2,0,1,0,0)]" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 rotate-12 transform-none rounded-md bg-chart-3"></div><Caption text="rotate-12 transform-none" /></div>
    </div>
}

pub fn TransformOriginExample() -> Element {
    <div class="flex flex-wrap gap-10 p-4">
        <div class="grid justify-items-center gap-3"><div class="size-16 rounded-md bg-muted"><div class="size-16 origin-center rotate-45 rounded-md bg-primary/70"></div></div><Caption text="origin-center" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 rounded-md bg-muted"><div class="size-16 origin-top-left rotate-12 rounded-md bg-primary/70"></div></div><Caption text="origin-top-left" /></div>
        <div class="grid justify-items-center gap-3"><div class="size-16 rounded-md bg-muted"><div class="size-16 origin-bottom rotate-12 rounded-md bg-primary/70"></div></div><Caption text="origin-bottom" /></div>
    </div>
}

pub fn TransformStyleExample() -> Element {
    <div class="flex flex-wrap gap-10 p-4 perspective-near">
        <div class="grid gap-3">
            <div class="flex size-24 rotate-y-30 items-center justify-center rounded-md bg-chart-2 transform-3d">
                <div class="size-12 translate-z-8 rotate-x-45 rounded-md bg-chart-4"></div>
            </div>
            <Caption text="transform-3d" />
        </div>
        <div class="grid gap-3">
            <div class="flex size-24 rotate-y-30 items-center justify-center rounded-md bg-chart-2 transform-flat">
                <div class="size-12 translate-z-8 rotate-x-45 rounded-md bg-chart-4"></div>
            </div>
            <Caption text="transform-flat" />
        </div>
    </div>
}

pub fn TranslateExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><div class="h-20 rounded-md bg-muted"><div class="size-10 translate-x-6 translate-y-4 rounded-md bg-primary"></div></div><Caption text="translate-x-6 translate-y-4" /></div>
        <div class="grid gap-2"><div class="h-20 rounded-md bg-muted"><div class="size-10 translate-x-1/2 rounded-md bg-primary"></div></div><Caption text="translate-x-1/2" /></div>
        <div class="grid gap-2"><div class="h-20 rounded-md bg-muted"><div class="size-10 translate-full rounded-md bg-primary"></div></div><Caption text="translate-full" /></div>
    </div>
}

pub fn ZoomExample() -> Element {
    <div class="flex flex-wrap items-start gap-6">
        <div class="grid gap-2"><div class="zoom-75 rounded-md border bg-card p-3 text-sm shadow-control">Total due: $84.00</div><Caption text="zoom-75" /></div>
        <div class="grid gap-2"><div class="zoom-100 rounded-md border bg-card p-3 text-sm shadow-control">Total due: $84.00</div><Caption text="zoom-100" /></div>
        <div class="grid gap-2"><div class="zoom-125 rounded-md border bg-card p-3 text-sm shadow-control">Total due: $84.00</div><Caption text="zoom-125" /></div>
    </div>
}
