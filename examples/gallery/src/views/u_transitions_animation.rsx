//! Examples for the Transitions & Animation utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.

pub fn Examples(slug: &str) -> Element {
    match slug {
        "transition-property" => <TransitionPropertyExample />,
        "transition-behavior" => <TransitionBehaviorExample />,
        "transition-duration" => <TransitionDurationExample />,
        "transition-timing-function" => <TransitionTimingFunctionExample />,
        "transition-delay" => <TransitionDelayExample />,
        "animation" => <AnimationExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

pub fn TransitionPropertyExample() -> Element {
    <div class="grid gap-4">
        <Caption text="Hover each button." />
        <div class="flex flex-wrap gap-6">
            <div class="grid justify-items-center gap-2">
                <button class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground shadow-control transition-colors duration-300 hover:bg-chart-2">Pay $49.00</button>
                <Caption text="transition-colors" />
            </div>
            <div class="grid justify-items-center gap-2">
                <button class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground shadow-control transition-transform duration-300 hover:scale-110">Pay $49.00</button>
                <Caption text="transition-transform" />
            </div>
            <div class="grid justify-items-center gap-2">
                <button class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground shadow-control transition-none hover:scale-110 hover:bg-chart-2">Pay $49.00</button>
                <Caption text="transition-none" />
            </div>
        </div>
    </div>
}

pub fn TransitionBehaviorExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="group grid gap-2 rounded-md border p-3">
            <div class="text-sm text-heading">Hover for the receipt</div>
            <div class="hidden rounded-md bg-muted p-2 text-sm opacity-0 transition-all transition-normal duration-500 group-hover:block group-hover:opacity-100 starting:group-hover:opacity-0">Paid $49.00 by card</div>
            <Caption text="transition-normal: vanishes at once on leave" />
        </div>
        <div class="group grid gap-2 rounded-md border p-3">
            <div class="text-sm text-heading">Hover for the receipt</div>
            <div class="hidden rounded-md bg-muted p-2 text-sm opacity-0 transition-all transition-discrete duration-500 group-hover:block group-hover:opacity-100 starting:group-hover:opacity-0">Paid $49.00 by card</div>
            <Caption text="transition-discrete: fades out on leave" />
        </div>
    </div>
}

pub fn TransitionDurationExample() -> Element {
    <div class="grid gap-4">
        <Caption text="Hover the card: each bar fills at its own speed." />
        <div class="group grid gap-3 rounded-md border bg-card p-4 shadow-control">
            <div class="h-2 w-1/4 rounded-full bg-chart-1 transition-all duration-150 group-hover:w-full"></div>
            <Caption text="duration-150" />
            <div class="h-2 w-1/4 rounded-full bg-chart-2 transition-all duration-500 group-hover:w-full"></div>
            <Caption text="duration-500" />
            <div class="h-2 w-1/4 rounded-full bg-chart-3 transition-all duration-1000 group-hover:w-full"></div>
            <Caption text="duration-1000" />
        </div>
    </div>
}

pub fn TransitionTimingFunctionExample() -> Element {
    <div class="grid gap-4">
        <Caption text="Hover the card: same duration, different curves." />
        <div class="group grid gap-3 rounded-md border bg-card p-4 shadow-control">
            <div class="size-6 rounded-full bg-chart-1 transition-transform duration-1000 ease-linear group-hover:translate-x-48"></div>
            <Caption text="ease-linear" />
            <div class="size-6 rounded-full bg-chart-2 transition-transform duration-1000 ease-in group-hover:translate-x-48"></div>
            <Caption text="ease-in" />
            <div class="size-6 rounded-full bg-chart-3 transition-transform duration-1000 ease-out group-hover:translate-x-48"></div>
            <Caption text="ease-out" />
            <div class="size-6 rounded-full bg-chart-4 transition-transform duration-1000 ease-in-out group-hover:translate-x-48"></div>
            <Caption text="ease-in-out" />
        </div>
    </div>
}

pub fn TransitionDelayExample() -> Element {
    <div class="grid gap-4">
        <Caption text="Hover the card: each step waits a little longer." />
        <div class="group flex flex-wrap gap-4 rounded-md border bg-card p-4 shadow-control">
            <div class="grid justify-items-center gap-2">
                <div class="rounded-md bg-muted px-3 py-2 text-sm transition-colors delay-0 duration-300 group-hover:bg-primary group-hover:text-primary-foreground">Charged</div>
                <Caption text="delay-0" />
            </div>
            <div class="grid justify-items-center gap-2">
                <div class="rounded-md bg-muted px-3 py-2 text-sm transition-colors delay-300 duration-300 group-hover:bg-primary group-hover:text-primary-foreground">Settled</div>
                <Caption text="delay-300" />
            </div>
            <div class="grid justify-items-center gap-2">
                <div class="rounded-md bg-muted px-3 py-2 text-sm transition-colors delay-700 duration-300 group-hover:bg-primary group-hover:text-primary-foreground">Paid out</div>
                <Caption text="delay-700" />
            </div>
        </div>
    </div>
}

pub fn AnimationExample() -> Element {
    <div class="grid gap-6">
        <div class="flex flex-wrap items-end gap-8">
            <div class="grid justify-items-center gap-2"><div class="size-8 animate-spin rounded-full border-4 border-muted border-t-primary"></div><Caption text="animate-spin" /></div>
            <div class="grid justify-items-center gap-2"><span class="relative flex size-3"><span class="absolute inline-flex size-full animate-ping rounded-full bg-chart-2 opacity-75"></span><span class="relative inline-flex size-3 rounded-full bg-chart-2"></span></span><Caption text="animate-ping" /></div>
            <div class="grid justify-items-center gap-2"><div class="h-4 w-28 animate-pulse rounded-md bg-muted"></div><Caption text="animate-pulse" /></div>
            <div class="grid justify-items-center gap-2"><div class="size-8 animate-bounce rounded-full bg-primary"></div><Caption text="animate-bounce" /></div>
        </div>
        <Caption text="Hover a box to replay its entrance." />
        <div class="flex flex-wrap gap-6">
            <div class="grid gap-2"><div class="rounded-md border bg-card p-3 text-sm shadow-control hover:animate-content-in">Invoice INV-1042 sent</div><Caption text="hover:animate-content-in" /></div>
            <div class="grid gap-2"><div class="rounded-md bg-overlay p-3 text-sm text-white hover:animate-overlay-in">Overlay fades in</div><Caption text="hover:animate-overlay-in" /></div>
        </div>
    </div>
}
