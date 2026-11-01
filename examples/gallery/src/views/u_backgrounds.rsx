//! Examples for the Backgrounds utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: background-attachment, background-clip, background-color, background-image, background-origin, background-position, background-repeat, background-size

pub fn Examples(slug: &str) -> Element {
    match slug {
        "background-attachment" => <BackgroundAttachmentExample />,
        "background-clip" => <BackgroundClipExample />,
        "background-color" => <BackgroundColorExample />,
        "background-image" => <BackgroundImageExample />,
        "background-origin" => <BackgroundOriginExample />,
        "background-position" => <BackgroundPositionExample />,
        "background-repeat" => <BackgroundRepeatExample />,
        "background-size" => <BackgroundSizeExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

/// A wide sample picture as a background image: a gradient in the chart colours with a mark in the middle.
const PICTURE: &str = "background-image: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='480' height='240'%3E%3Cdefs%3E%3ClinearGradient id='g' x2='1' y2='1'%3E%3Cstop offset='0' stop-color='%23625afa'/%3E%3Cstop offset='1' stop-color='%230570de'/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect width='480' height='240' fill='url(%23g)'/%3E%3Ccircle cx='240' cy='120' r='48' fill='white' fill-opacity='.85'/%3E%3C/svg%3E\")";

/// A small 32px mark as a background image: one dot in the primary colour.
const MARK: &str = "background-image: url(\"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='32' height='32'%3E%3Ccircle cx='16' cy='16' r='10' fill='%23625afa'/%3E%3C/svg%3E\")";

pub fn BackgroundAttachmentExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="h-32 overflow-y-auto rounded-md bg-cover bg-scroll text-sm text-white" style={PICTURE}>
                <p class="h-64 p-3">Scroll this box: the picture stays with the box, not with the payout notes.</p>
            </div>
            <Caption text="bg-scroll" />
        </div>
        <div class="grid gap-2">
            <div class="h-32 overflow-y-auto rounded-md bg-cover bg-local text-sm text-white" style={PICTURE}>
                <p class="h-64 p-3">Scroll this box: the picture moves with the payout notes.</p>
            </div>
            <Caption text="bg-local" />
        </div>
        <div class="grid gap-2">
            <div class="h-32 overflow-y-auto rounded-md bg-cover bg-fixed text-sm text-white" style={PICTURE}>
                <p class="h-64 p-3">Scroll the page: the picture stays fixed to the window.</p>
            </div>
            <Caption text="bg-fixed" />
        </div>
    </div>
}

pub fn BackgroundClipExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-4">
        <div class="grid gap-2">
            <div class="rounded-md border-8 border-dashed border-primary/40 bg-chart-2 bg-clip-border p-4 text-xs text-white">Card</div>
            <Caption text="bg-clip-border" />
        </div>
        <div class="grid gap-2">
            <div class="rounded-md border-8 border-dashed border-primary/40 bg-chart-2 bg-clip-padding p-4 text-xs text-white">Card</div>
            <Caption text="bg-clip-padding" />
        </div>
        <div class="grid gap-2">
            <div class="rounded-md border-8 border-dashed border-primary/40 bg-chart-2 bg-clip-content p-4 text-xs text-white">Card</div>
            <Caption text="bg-clip-content" />
        </div>
        <div class="grid gap-2">
            <div class="bg-linear-to-r from-chart-1 to-chart-3 bg-clip-text text-3xl font-bold text-transparent">$12,480</div>
            <Caption text="bg-clip-text" />
        </div>
    </div>
}

pub fn BackgroundColorExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-4">
        <div class="grid gap-2">
            <div class="rounded-md bg-primary p-4 text-sm text-primary-foreground">Pay invoice</div>
            <Caption text="bg-primary" />
        </div>
        <div class="grid gap-2">
            <div class="rounded-md bg-muted p-4 text-sm text-muted-foreground">Draft</div>
            <Caption text="bg-muted" />
        </div>
        <div class="grid gap-2">
            <div class="rounded-md border bg-card p-4 text-sm text-card-foreground">Card ending 4242</div>
            <Caption text="bg-card" />
        </div>
        <div class="grid gap-2">
            <div class="rounded-md bg-success-muted p-4 text-sm text-success">Payout sent</div>
            <Caption text="bg-success-muted" />
        </div>
    </div>
}

pub fn BackgroundImageExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="flex aspect-video items-end rounded-lg bg-linear-to-r from-primary to-chart-2 p-3 font-mono text-sm text-white">•••• 4242</div>
            <Caption text="bg-linear-to-r from-primary to-chart-2" />
        </div>
        <div class="grid gap-2">
            <div class="flex aspect-video items-end rounded-lg bg-radial from-chart-3 to-chart-1 p-3 font-mono text-sm text-white">•••• 1881</div>
            <Caption text="bg-radial from-chart-3 to-chart-1" />
        </div>
        <div class="grid gap-2">
            <div class="flex aspect-video items-end rounded-lg bg-conic-180 from-chart-1 via-chart-4 to-chart-1 p-3 font-mono text-sm text-white">•••• 0005</div>
            <Caption text="bg-conic-180 from-chart-1 via-chart-4" />
        </div>
    </div>
}

pub fn BackgroundOriginExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="size-28 rounded-md border-8 border-dashed border-primary/30 bg-muted bg-no-repeat bg-origin-border p-4" style={MARK}></div>
            <Caption text="bg-origin-border" />
        </div>
        <div class="grid gap-2">
            <div class="size-28 rounded-md border-8 border-dashed border-primary/30 bg-muted bg-no-repeat bg-origin-padding p-4" style={MARK}></div>
            <Caption text="bg-origin-padding" />
        </div>
        <div class="grid gap-2">
            <div class="size-28 rounded-md border-8 border-dashed border-primary/30 bg-muted bg-no-repeat bg-origin-content p-4" style={MARK}></div>
            <Caption text="bg-origin-content" />
        </div>
    </div>
}

pub fn BackgroundPositionExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="h-24 rounded-md border bg-card bg-top-left bg-no-repeat" style={MARK}></div>
            <Caption text="bg-top-left" />
        </div>
        <div class="grid gap-2">
            <div class="h-24 rounded-md border bg-card bg-center bg-no-repeat" style={MARK}></div>
            <Caption text="bg-center" />
        </div>
        <div class="grid gap-2">
            <div class="h-24 rounded-md border bg-card bg-bottom-right bg-no-repeat" style={MARK}></div>
            <Caption text="bg-bottom-right" />
        </div>
    </div>
}

pub fn BackgroundRepeatExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-4">
        <div class="grid gap-2">
            <div class="h-24 rounded-md border bg-card bg-repeat" style={MARK}></div>
            <Caption text="bg-repeat" />
        </div>
        <div class="grid gap-2">
            <div class="h-24 rounded-md border bg-card bg-repeat-x" style={MARK}></div>
            <Caption text="bg-repeat-x" />
        </div>
        <div class="grid gap-2">
            <div class="h-24 rounded-md border bg-card bg-repeat-space" style={MARK}></div>
            <Caption text="bg-repeat-space" />
        </div>
        <div class="grid gap-2">
            <div class="h-24 rounded-md border bg-card bg-no-repeat" style={MARK}></div>
            <Caption text="bg-no-repeat" />
        </div>
    </div>
}

pub fn BackgroundSizeExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="h-32 rounded-md bg-muted bg-auto bg-center bg-no-repeat" style={PICTURE}></div>
            <Caption text="bg-auto" />
        </div>
        <div class="grid gap-2">
            <div class="h-32 rounded-md bg-muted bg-cover bg-center bg-no-repeat" style={PICTURE}></div>
            <Caption text="bg-cover" />
        </div>
        <div class="grid gap-2">
            <div class="h-32 rounded-md bg-muted bg-contain bg-center bg-no-repeat" style={PICTURE}></div>
            <Caption text="bg-contain" />
        </div>
    </div>
}
