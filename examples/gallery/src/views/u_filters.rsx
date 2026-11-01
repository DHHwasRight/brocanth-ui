//! Examples for the Filters utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.

pub fn Examples(slug: &str) -> Element {
    match slug {
        "filter" => <FilterExample />,
        "filter-blur" => <FilterBlurExample />,
        "filter-brightness" => <FilterBrightnessExample />,
        "filter-contrast" => <FilterContrastExample />,
        "filter-drop-shadow" => <FilterDropShadowExample />,
        "filter-grayscale" => <FilterGrayscaleExample />,
        "filter-hue-rotate" => <FilterHueRotateExample />,
        "filter-invert" => <FilterInvertExample />,
        "filter-saturate" => <FilterSaturateExample />,
        "filter-sepia" => <FilterSepiaExample />,
        "backdrop-filter" => <BackdropFilterExample />,
        "backdrop-filter-blur" => <BackdropFilterBlurExample />,
        "backdrop-filter-brightness" => <BackdropFilterBrightnessExample />,
        "backdrop-filter-contrast" => <BackdropFilterContrastExample />,
        "backdrop-filter-grayscale" => <BackdropFilterGrayscaleExample />,
        "backdrop-filter-hue-rotate" => <BackdropFilterHueRotateExample />,
        "backdrop-filter-invert" => <BackdropFilterInvertExample />,
        "backdrop-filter-opacity" => <BackdropFilterOpacityExample />,
        "backdrop-filter-saturate" => <BackdropFilterSaturateExample />,
        "backdrop-filter-sepia" => <BackdropFilterSepiaExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

/// A wide sample picture: a gradient in the chart colours with a mark in the middle.
const PICTURE: &str = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='480' height='240'%3E%3Cdefs%3E%3ClinearGradient id='g' x2='1' y2='1'%3E%3Cstop offset='0' stop-color='%23625afa'/%3E%3Cstop offset='1' stop-color='%230570de'/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect width='480' height='240' fill='url(%23g)'/%3E%3Ccircle cx='240' cy='120' r='48' fill='white' fill-opacity='.85'/%3E%3C/svg%3E";

pub fn FilterExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover filter-none"><Caption text="filter-none" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover filter-[blur(2px)_grayscale(1)]"><Caption text="filter-[blur(2px)_grayscale(1)]" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover blur-xs hover:filter-none"><Caption text="blur-xs hover:filter-none (hover it)" /></div>
    </div>
}

pub fn FilterBlurExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover blur-none"><Caption text="blur-none" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover blur-sm"><Caption text="blur-sm" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover blur-lg"><Caption text="blur-lg" /></div>
    </div>
}

pub fn FilterBrightnessExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover brightness-50"><Caption text="brightness-50" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover brightness-100"><Caption text="brightness-100" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover brightness-150"><Caption text="brightness-150" /></div>
    </div>
}

pub fn FilterContrastExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover contrast-50"><Caption text="contrast-50" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover contrast-100"><Caption text="contrast-100" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover contrast-200"><Caption text="contrast-200" /></div>
    </div>
}

pub fn FilterDropShadowExample() -> Element {
    <div class="flex flex-wrap gap-8">
        <div class="grid justify-items-center gap-2">
            <div class="flex size-20 items-center justify-center rounded-full bg-card text-sm text-heading drop-shadow-sm">$12</div>
            <Caption text="drop-shadow-sm" />
        </div>
        <div class="grid justify-items-center gap-2">
            <div class="flex size-20 items-center justify-center rounded-full bg-card text-sm text-heading drop-shadow-xl">$48</div>
            <Caption text="drop-shadow-xl" />
        </div>
        <div class="grid justify-items-center gap-2">
            <div class="flex size-20 items-center justify-center rounded-full bg-card text-sm text-heading drop-shadow-lg drop-shadow-primary/50">$96</div>
            <Caption text="drop-shadow-lg drop-shadow-primary/50" />
        </div>
    </div>
}

pub fn FilterGrayscaleExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover grayscale-0"><Caption text="grayscale-0" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover grayscale-50"><Caption text="grayscale-50" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover grayscale"><Caption text="grayscale" /></div>
    </div>
}

pub fn FilterHueRotateExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover hue-rotate-60"><Caption text="hue-rotate-60" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover hue-rotate-180"><Caption text="hue-rotate-180" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover -hue-rotate-90"><Caption text="-hue-rotate-90" /></div>
    </div>
}

pub fn FilterInvertExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover invert-0"><Caption text="invert-0" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover invert-25"><Caption text="invert-25" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover invert"><Caption text="invert" /></div>
    </div>
}

pub fn FilterSaturateExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover saturate-50"><Caption text="saturate-50" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover saturate-100"><Caption text="saturate-100" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover saturate-200"><Caption text="saturate-200" /></div>
    </div>
}

pub fn FilterSepiaExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover sepia-0"><Caption text="sepia-0" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover sepia-50"><Caption text="sepia-50" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-24 w-full rounded-md object-cover sepia"><Caption text="sepia" /></div>
    </div>
}

pub fn BackdropFilterExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md bg-white/20 text-sm text-white backdrop-filter-none">Balance $1,240.00</div></div>
            <Caption text="backdrop-filter-none" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md bg-white/20 text-sm text-white backdrop-filter-[blur(4px)_saturate(1.8)]">Balance $1,240.00</div></div>
            <Caption text="backdrop-filter-[blur(4px)_saturate(1.8)]" />
        </div>
    </div>
}

pub fn BackdropFilterBlurExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md bg-white/20 text-sm text-white backdrop-blur-none">Payout sent</div></div>
            <Caption text="backdrop-blur-none" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md bg-white/20 text-sm text-white backdrop-blur-sm">Payout sent</div></div>
            <Caption text="backdrop-blur-sm" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md bg-white/20 text-sm text-white backdrop-blur-lg">Payout sent</div></div>
            <Caption text="backdrop-blur-lg" />
        </div>
    </div>
}

pub fn BackdropFilterBrightnessExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-brightness-50">Due in 3 days</div></div>
            <Caption text="backdrop-brightness-50" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-brightness-100">Due in 3 days</div></div>
            <Caption text="backdrop-brightness-100" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-brightness-150">Due in 3 days</div></div>
            <Caption text="backdrop-brightness-150" />
        </div>
    </div>
}

pub fn BackdropFilterContrastExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-contrast-50">Invoice paid</div></div>
            <Caption text="backdrop-contrast-50" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-contrast-125">Invoice paid</div></div>
            <Caption text="backdrop-contrast-125" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-contrast-200">Invoice paid</div></div>
            <Caption text="backdrop-contrast-200" />
        </div>
    </div>
}

pub fn BackdropFilterGrayscaleExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-grayscale-0">Plan archived</div></div>
            <Caption text="backdrop-grayscale-0" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-grayscale-50">Plan archived</div></div>
            <Caption text="backdrop-grayscale-50" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-grayscale">Plan archived</div></div>
            <Caption text="backdrop-grayscale" />
        </div>
    </div>
}

pub fn BackdropFilterHueRotateExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-hue-rotate-90">Trial ends soon</div></div>
            <Caption text="backdrop-hue-rotate-90" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-hue-rotate-180">Trial ends soon</div></div>
            <Caption text="backdrop-hue-rotate-180" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white -backdrop-hue-rotate-60">Trial ends soon</div></div>
            <Caption text="-backdrop-hue-rotate-60" />
        </div>
    </div>
}

pub fn BackdropFilterInvertExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-invert-0">Refund issued</div></div>
            <Caption text="backdrop-invert-0" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-invert-50">Refund issued</div></div>
            <Caption text="backdrop-invert-50" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-heading backdrop-invert">Refund issued</div></div>
            <Caption text="backdrop-invert" />
        </div>
    </div>
}

pub fn BackdropFilterOpacityExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-invert backdrop-opacity-10">Card expiring</div></div>
            <Caption text="backdrop-invert backdrop-opacity-10" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-invert backdrop-opacity-60">Card expiring</div></div>
            <Caption text="backdrop-invert backdrop-opacity-60" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-heading backdrop-invert backdrop-opacity-95">Card expiring</div></div>
            <Caption text="backdrop-invert backdrop-opacity-95" />
        </div>
    </div>
}

pub fn BackdropFilterSaturateExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-saturate-0">Usage synced</div></div>
            <Caption text="backdrop-saturate-0" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-saturate-50">Usage synced</div></div>
            <Caption text="backdrop-saturate-50" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-saturate-200">Usage synced</div></div>
            <Caption text="backdrop-saturate-200" />
        </div>
    </div>
}

pub fn BackdropFilterSepiaExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-sepia-0">Statement ready</div></div>
            <Caption text="backdrop-sepia-0" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-sepia-50">Statement ready</div></div>
            <Caption text="backdrop-sepia-50" />
        </div>
        <div class="grid gap-2">
            <div class="relative h-32 overflow-hidden rounded-md"><img src={PICTURE} alt="" class="size-full object-cover">
                <div class="absolute inset-6 flex items-center justify-center rounded-md border border-white/40 text-sm text-white backdrop-sepia">Statement ready</div></div>
            <Caption text="backdrop-sepia" />
        </div>
    </div>
}
