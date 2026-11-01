//! Examples for the Effects utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: box-shadow, text-shadow, opacity, mix-blend-mode, background-blend-mode, mask-clip, mask-composite, mask-image, mask-mode, mask-origin, mask-position, mask-repeat, mask-size, mask-type

pub fn Examples(slug: &str) -> Element {
    match slug {
        "box-shadow" => <BoxShadowExample />,
        "text-shadow" => <TextShadowExample />,
        "opacity" => <OpacityExample />,
        "mix-blend-mode" => <MixBlendModeExample />,
        "background-blend-mode" => <BackgroundBlendModeExample />,
        "mask-clip" => <MaskClipExample />,
        "mask-composite" => <MaskCompositeExample />,
        "mask-image" => <MaskImageExample />,
        "mask-mode" => <MaskModeExample />,
        "mask-origin" => <MaskOriginExample />,
        "mask-position" => <MaskPositionExample />,
        "mask-repeat" => <MaskRepeatExample />,
        "mask-size" => <MaskSizeExample />,
        "mask-type" => <MaskTypeExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

/// A wide sample picture as a background image: a gradient in the chart colours with a mark in the middle.
const PICTURE: &str = "background-image: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='480' height='240'%3E%3Cdefs%3E%3ClinearGradient id='g' x2='1' y2='1'%3E%3Cstop offset='0' stop-color='%23625afa'/%3E%3Cstop offset='1' stop-color='%230570de'/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect width='480' height='240' fill='url(%23g)'/%3E%3Ccircle cx='240' cy='120' r='48' fill='white' fill-opacity='.85'/%3E%3C/svg%3E\")";

/// A 32px dot as a mask image.
const DOT: &str = "mask-image: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='32' height='32'%3E%3Ccircle cx='16' cy='16' r='10'/%3E%3C/svg%3E\")";

/// A mask that keeps the whole box, so only the mask clip shows.
const SOLID: &str = "mask-image: linear-gradient(black, black)";

/// Two overlapping circles as two mask layers.
const TWO_CIRCLES: &str = "mask-image: radial-gradient(circle at 35% 50%, black 36px, transparent 37px), radial-gradient(circle at 65% 50%, black 36px, transparent 37px)";

/// An opaque mask that goes from white to black: alpha keeps all of it, luminance fades it.
const WHITE_TO_BLACK: &str = "mask-image: linear-gradient(to right, white, black)";

pub fn BoxShadowExample() -> Element {
    <div class="grid gap-6 p-2 sm:grid-cols-4">
        <div class="grid gap-3"><div class="rounded-md bg-card p-4 text-sm shadow-control">Invoice #1042</div><Caption text="shadow-control" /></div>
        <div class="grid gap-3"><div class="rounded-md bg-card p-4 text-sm shadow-overlay">Invoice #1042</div><Caption text="shadow-overlay" /></div>
        <div class="grid gap-3"><div class="rounded-md bg-card p-4 text-sm shadow-sm">Invoice #1042</div><Caption text="shadow-sm" /></div>
        <div class="grid gap-3"><div class="rounded-md bg-card p-4 text-sm shadow-lg">Invoice #1042</div><Caption text="shadow-lg" /></div>
    </div>
}

pub fn TextShadowExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><div class="text-3xl font-bold text-heading text-shadow-xs">$4,210.00</div><Caption text="text-shadow-xs" /></div>
        <div class="grid gap-2"><div class="text-3xl font-bold text-heading text-shadow-lg">$4,210.00</div><Caption text="text-shadow-lg" /></div>
        <div class="grid gap-2"><div class="text-3xl font-bold text-heading text-shadow-lg text-shadow-primary/40">$4,210.00</div><Caption text="text-shadow-primary/40" /></div>
    </div>
}

pub fn OpacityExample() -> Element {
    <div class="flex flex-wrap gap-6">
        <div class="grid gap-2"><button type="button" class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground opacity-100">Pay invoice</button><Caption text="opacity-100" /></div>
        <div class="grid gap-2"><button type="button" class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground opacity-75">Pay invoice</button><Caption text="opacity-75" /></div>
        <div class="grid gap-2"><button type="button" class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground opacity-50">Pay invoice</button><Caption text="opacity-50" /></div>
        <div class="grid gap-2"><button type="button" class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground opacity-25">Pay invoice</button><Caption text="opacity-25" /></div>
    </div>
}

pub fn MixBlendModeExample() -> Element {
    <div class="grid grid-cols-2 gap-4 sm:grid-cols-4">
        <div class="grid gap-2"><div class="isolate flex h-24 items-center justify-center rounded-md bg-muted"><div class="size-16 rounded-full bg-chart-1"></div><div class="-ml-8 size-16 rounded-full bg-chart-3 mix-blend-normal"></div></div><Caption text="mix-blend-normal" /></div>
        <div class="grid gap-2"><div class="isolate flex h-24 items-center justify-center rounded-md bg-muted"><div class="size-16 rounded-full bg-chart-1"></div><div class="-ml-8 size-16 rounded-full bg-chart-3 mix-blend-multiply"></div></div><Caption text="mix-blend-multiply" /></div>
        <div class="grid gap-2"><div class="isolate flex h-24 items-center justify-center rounded-md bg-muted"><div class="size-16 rounded-full bg-chart-1"></div><div class="-ml-8 size-16 rounded-full bg-chart-3 mix-blend-screen"></div></div><Caption text="mix-blend-screen" /></div>
        <div class="grid gap-2"><div class="isolate flex h-24 items-center justify-center rounded-md bg-muted"><div class="size-16 rounded-full bg-chart-1"></div><div class="-ml-8 size-16 rounded-full bg-chart-3 mix-blend-difference"></div></div><Caption text="mix-blend-difference" /></div>
    </div>
}

pub fn BackgroundBlendModeExample() -> Element {
    <div class="grid grid-cols-2 gap-4 sm:grid-cols-4">
        <div class="grid gap-2"><div class="h-24 rounded-md bg-chart-3 bg-cover bg-center bg-blend-normal" style={PICTURE}></div><Caption text="bg-blend-normal" /></div>
        <div class="grid gap-2"><div class="h-24 rounded-md bg-chart-3 bg-cover bg-center bg-blend-multiply" style={PICTURE}></div><Caption text="bg-blend-multiply" /></div>
        <div class="grid gap-2"><div class="h-24 rounded-md bg-chart-3 bg-cover bg-center bg-blend-screen" style={PICTURE}></div><Caption text="bg-blend-screen" /></div>
        <div class="grid gap-2"><div class="h-24 rounded-md bg-chart-3 bg-cover bg-center bg-blend-luminosity" style={PICTURE}></div><Caption text="bg-blend-luminosity" /></div>
    </div>
}

pub fn MaskClipExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><div class="rounded-md border-8 border-dashed border-chart-3 bg-primary p-4 text-sm text-primary-foreground mask-clip-border" style={SOLID}>Payout $920</div><Caption text="mask-clip-border" /></div>
        <div class="grid gap-2"><div class="rounded-md border-8 border-dashed border-chart-3 bg-primary p-4 text-sm text-primary-foreground mask-clip-padding" style={SOLID}>Payout $920</div><Caption text="mask-clip-padding" /></div>
        <div class="grid gap-2"><div class="rounded-md border-8 border-dashed border-chart-3 bg-primary p-4 text-sm text-primary-foreground mask-clip-content" style={SOLID}>Payout $920</div><Caption text="mask-clip-content" /></div>
    </div>
}

pub fn MaskCompositeExample() -> Element {
    <div class="grid grid-cols-2 gap-4 sm:grid-cols-4">
        <div class="grid gap-2"><div class="h-24 rounded-md bg-primary mask-add" style={TWO_CIRCLES}></div><Caption text="mask-add" /></div>
        <div class="grid gap-2"><div class="h-24 rounded-md bg-primary mask-subtract" style={TWO_CIRCLES}></div><Caption text="mask-subtract" /></div>
        <div class="grid gap-2"><div class="h-24 rounded-md bg-primary mask-intersect" style={TWO_CIRCLES}></div><Caption text="mask-intersect" /></div>
        <div class="grid gap-2"><div class="h-24 rounded-md bg-primary mask-exclude" style={TWO_CIRCLES}></div><Caption text="mask-exclude" /></div>
    </div>
}

pub fn MaskImageExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <ul class="h-28 overflow-hidden rounded-md border text-sm mask-b-from-40%">
                for n in 1..=6 {
                    <li class="border-b px-3 py-1.5">{format!("Payment #{} · ${}.00", 2200 + n, n * 35)}</li>
                }
            </ul>
            <Caption text="mask-b-from-40%" />
        </div>
        <div class="grid gap-2"><div class="h-28 rounded-md bg-cover mask-r-from-30%" style={PICTURE}></div><Caption text="mask-r-from-30%" /></div>
        <div class="grid gap-2"><div class="h-28 rounded-md bg-cover mask-radial-from-40%" style={PICTURE}></div><Caption text="mask-radial-from-40%" /></div>
    </div>
}

pub fn MaskModeExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><div class="h-20 rounded-md bg-primary mask-alpha" style={WHITE_TO_BLACK}></div><Caption text="mask-alpha: the opaque gradient keeps everything" /></div>
        <div class="grid gap-2"><div class="h-20 rounded-md bg-primary mask-luminance" style={WHITE_TO_BLACK}></div><Caption text="mask-luminance: black hides, white shows" /></div>
    </div>
}

pub fn MaskOriginExample() -> Element {
    <div class="flex flex-wrap gap-6">
        <div class="grid gap-2"><div class="w-fit rounded-md border border-dashed border-input"><div class="size-28 border-8 border-chart-3 bg-primary p-4 mask-no-repeat mask-origin-border" style={DOT}></div></div><Caption text="mask-origin-border" /></div>
        <div class="grid gap-2"><div class="w-fit rounded-md border border-dashed border-input"><div class="size-28 border-8 border-chart-3 bg-primary p-4 mask-no-repeat mask-origin-padding" style={DOT}></div></div><Caption text="mask-origin-padding" /></div>
        <div class="grid gap-2"><div class="w-fit rounded-md border border-dashed border-input"><div class="size-28 border-8 border-chart-3 bg-primary p-4 mask-no-repeat mask-origin-content" style={DOT}></div></div><Caption text="mask-origin-content" /></div>
    </div>
}

pub fn MaskPositionExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><div class="rounded-md border border-dashed border-input"><div class="h-24 bg-primary mask-top-left mask-no-repeat" style={DOT}></div></div><Caption text="mask-top-left" /></div>
        <div class="grid gap-2"><div class="rounded-md border border-dashed border-input"><div class="h-24 bg-primary mask-center mask-no-repeat" style={DOT}></div></div><Caption text="mask-center" /></div>
        <div class="grid gap-2"><div class="rounded-md border border-dashed border-input"><div class="h-24 bg-primary mask-bottom-right mask-no-repeat" style={DOT}></div></div><Caption text="mask-bottom-right" /></div>
    </div>
}

pub fn MaskRepeatExample() -> Element {
    <div class="grid grid-cols-2 gap-4 sm:grid-cols-4">
        <div class="grid gap-2"><div class="h-24 rounded-md bg-linear-to-r from-chart-1 to-chart-3 mask-repeat" style={DOT}></div><Caption text="mask-repeat" /></div>
        <div class="grid gap-2"><div class="h-24 rounded-md bg-linear-to-r from-chart-1 to-chart-3 mask-repeat-x" style={DOT}></div><Caption text="mask-repeat-x" /></div>
        <div class="grid gap-2"><div class="h-24 rounded-md bg-linear-to-r from-chart-1 to-chart-3 mask-repeat-space" style={DOT}></div><Caption text="mask-repeat-space" /></div>
        <div class="grid gap-2"><div class="h-24 rounded-md bg-linear-to-r from-chart-1 to-chart-3 mask-no-repeat" style={DOT}></div><Caption text="mask-no-repeat" /></div>
    </div>
}

pub fn MaskSizeExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><div class="rounded-md border border-dashed border-input"><div class="h-24 bg-linear-to-r from-chart-1 to-chart-3 mask-auto mask-center mask-no-repeat" style={DOT}></div></div><Caption text="mask-auto" /></div>
        <div class="grid gap-2"><div class="rounded-md border border-dashed border-input"><div class="h-24 bg-linear-to-r from-chart-1 to-chart-3 mask-contain mask-center mask-no-repeat" style={DOT}></div></div><Caption text="mask-contain" /></div>
        <div class="grid gap-2"><div class="rounded-md border border-dashed border-input"><div class="h-24 bg-linear-to-r from-chart-1 to-chart-3 mask-cover mask-center mask-no-repeat" style={DOT}></div></div><Caption text="mask-cover" /></div>
    </div>
}

pub fn MaskTypeExample() -> Element {
    <div class="flex flex-wrap gap-8">
        <div class="grid gap-2">
            <svg class="h-20 w-32" viewBox="0 0 120 80" aria-hidden="true">
                <mask id="mask-type-alpha-demo" class="mask-type-alpha"><rect width="120" height="80" fill="black"></rect><circle cx="60" cy="40" r="28" fill="white"></circle></mask>
                <rect class="fill-primary" width="120" height="80" rx="8" mask="url(#mask-type-alpha-demo)"></rect>
            </svg>
            <Caption text="mask-type-alpha" />
        </div>
        <div class="grid gap-2">
            <svg class="h-20 w-32" viewBox="0 0 120 80" aria-hidden="true">
                <mask id="mask-type-luminance-demo" class="mask-type-luminance"><rect width="120" height="80" fill="black"></rect><circle cx="60" cy="40" r="28" fill="white"></circle></mask>
                <rect class="fill-primary" width="120" height="80" rx="8" mask="url(#mask-type-luminance-demo)"></rect>
            </svg>
            <Caption text="mask-type-luminance" />
        </div>
    </div>
}
