//! Examples for the Layout utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.

pub fn Examples(slug: &str) -> Element {
    match slug {
        "aspect-ratio" => <AspectRatioExample />,
        "columns" => <ColumnsExample />,
        "break-after" => <BreakAfterExample />,
        "break-before" => <BreakBeforeExample />,
        "break-inside" => <BreakInsideExample />,
        "box-decoration-break" => <BoxDecorationBreakExample />,
        "box-sizing" => <BoxSizingExample />,
        "display" => <DisplayExample />,
        "float" => <FloatExample />,
        "clear" => <ClearExample />,
        "isolation" => <IsolationExample />,
        "object-fit" => <ObjectFitExample />,
        "object-position" => <ObjectPositionExample />,
        "overflow" => <OverflowExample />,
        "overscroll-behavior" => <OverscrollBehaviorExample />,
        "position" => <PositionExample />,
        "top-right-bottom-left" => <TopRightBottomLeftExample />,
        "visibility" => <VisibilityExample />,
        "z-index" => <ZIndexExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

/// A wide sample picture: a gradient in the chart colours with a mark in the middle.
const PICTURE: &str = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='480' height='240'%3E%3Cdefs%3E%3ClinearGradient id='g' x2='1' y2='1'%3E%3Cstop offset='0' stop-color='%23625afa'/%3E%3Cstop offset='1' stop-color='%230570de'/%3E%3C/linearGradient%3E%3C/defs%3E%3Crect width='480' height='240' fill='url(%23g)'/%3E%3Ccircle cx='240' cy='120' r='48' fill='white' fill-opacity='.85'/%3E%3C/svg%3E";

pub fn AspectRatioExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="aspect-square rounded-md bg-primary"></div>
            <Caption text="aspect-square" />
        </div>
        <div class="grid gap-2">
            <div class="aspect-video rounded-md bg-chart-2"></div>
            <Caption text="aspect-video" />
        </div>
        <div class="grid gap-2">
            <div class="aspect-3/2 rounded-md bg-chart-3"></div>
            <Caption text="aspect-3/2" />
        </div>
    </div>
}

pub fn ColumnsExample() -> Element {
    <div class="columns-3 gap-4 text-sm text-foreground">
        for n in 1..=9 {
            <div class="mb-4 break-inside-avoid rounded-md border bg-card p-3 shadow-control">
                <div class="font-control text-heading">{format!("Invoice #{}", 1040 + n)}</div>
                <div class="text-muted-foreground">{format!("${}.00", n * 120)}</div>
            </div>
        }
    </div>
}

pub fn BreakAfterExample() -> Element {
    <div class="columns-2 gap-6 text-sm">
        <p class="break-after-column rounded-md bg-muted p-3">Summary: three payments, one refund. <Caption text="break-after-column" /></p>
        <p class="rounded-md border p-3">Details start in the next column.</p>
        <p class="rounded-md border p-3">Fees and taxes.</p>
    </div>
}

pub fn BreakBeforeExample() -> Element {
    <div class="columns-2 gap-6 text-sm">
        <p class="rounded-md border p-3">Payments received this week.</p>
        <p class="break-before-column rounded-md bg-muted p-3">Payouts start a new column. <Caption text="break-before-column" /></p>
    </div>
}

pub fn BreakInsideExample() -> Element {
    <div class="columns-2 gap-6 text-sm">
        <div class="mb-4 rounded-md border p-3">Short note.</div>
        <div class="break-inside-avoid-column rounded-md border bg-muted p-3">
            This card never splits across two columns, however long it gets: the whole receipt stays together.
            <div class="mt-2"><Caption text="break-inside-avoid-column" /></div>
        </div>
        <div class="mt-4 rounded-md border p-3">Another note.</div>
    </div>
}

pub fn BoxDecorationBreakExample() -> Element {
    <div class="grid gap-4 text-sm leading-8 sm:grid-cols-2">
        <div>
            <span class="box-decoration-slice rounded-md bg-primary px-2 text-primary-foreground">Refunds issued within 180 days of the payment</span>
            <div><Caption text="box-decoration-slice" /></div>
        </div>
        <div>
            <span class="box-decoration-clone rounded-md bg-primary px-2 text-primary-foreground">Refunds issued within 180 days of the payment</span>
            <div><Caption text="box-decoration-clone" /></div>
        </div>
    </div>
}

pub fn BoxSizingExample() -> Element {
    <div class="flex flex-wrap gap-6">
        <div class="grid gap-2">
            <div class="box-border size-28 border-8 border-primary/40 bg-muted p-4 text-xs">112px with border</div>
            <Caption text="box-border" />
        </div>
        <div class="grid gap-2">
            <div class="box-content size-28 border-8 border-primary/40 bg-muted p-4 text-xs">112px plus border</div>
            <Caption text="box-content" />
        </div>
    </div>
}

pub fn DisplayExample() -> Element {
    <div class="grid gap-4 text-sm">
        <p>
            Card ending in <span class="inline rounded-sm bg-muted px-1 font-mono">4242</span> was charged
            <span class="inline-block rounded-md bg-success-muted px-2 text-success">$49.00</span> today.
        </p>
        <div class="flex gap-2"><div class="rounded-md bg-muted px-3 py-2">flex</div><div class="rounded-md bg-muted px-3 py-2">items</div></div>
        <div class="grid grid-cols-3 gap-2"><div class="rounded-md bg-muted p-2">grid</div><div class="rounded-md bg-muted p-2">of</div><div class="rounded-md bg-muted p-2">three</div></div>
        <div class="hidden">Hidden: not rendered.</div>
        <Caption text="inline · inline-block · flex · grid · hidden" />
    </div>
}

pub fn FloatExample() -> Element {
    <div class="text-sm text-foreground">
        <div class="float-right mb-2 ml-4 size-24 rounded-md bg-primary"></div>
        <p>
            The badge floats to the right and the text wraps around it. Payouts are sent every business day, two days after the
            payment, to the bank account on file. A payout that fails returns to the balance.
        </p>
        <div class="clear-both pt-2"><Caption text="float-right" /></div>
    </div>
}

pub fn ClearExample() -> Element {
    <div class="text-sm">
        <div class="float-left mr-4 size-16 rounded-md bg-chart-2"></div>
        <div class="float-right ml-4 size-16 rounded-md bg-chart-3"></div>
        <p class="clear-left rounded-md bg-muted p-3">This paragraph clears the left float and starts below it.</p>
        <div class="clear-both pt-2"><Caption text="clear-left" /></div>
    </div>
}

pub fn IsolationExample() -> Element {
    <div class="flex flex-wrap gap-6">
        <div class="grid gap-2">
            <div class="isolate flex size-32 items-center justify-center rounded-md bg-chart-2">
                <div class="size-16 rounded-full bg-chart-4 mix-blend-multiply"></div>
            </div>
            <Caption text="isolate" />
        </div>
        <div class="grid gap-2">
            <div class="isolation-auto flex size-32 items-center justify-center rounded-md bg-chart-2">
                <div class="size-16 rounded-full bg-chart-4 mix-blend-multiply"></div>
            </div>
            <Caption text="isolation-auto" />
        </div>
    </div>
}

pub fn ObjectFitExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-32 w-full rounded-md bg-muted object-contain"><Caption text="object-contain" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-32 w-full rounded-md bg-muted object-cover"><Caption text="object-cover" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="h-32 w-full rounded-md bg-muted object-fill"><Caption text="object-fill" /></div>
    </div>
}

pub fn ObjectPositionExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><img src={PICTURE} alt="" class="size-32 rounded-md bg-muted object-cover object-left"><Caption text="object-left" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="size-32 rounded-md bg-muted object-cover object-center"><Caption text="object-center" /></div>
        <div class="grid gap-2"><img src={PICTURE} alt="" class="size-32 rounded-md bg-muted object-cover object-right"><Caption text="object-right" /></div>
    </div>
}

pub fn OverflowExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <div class="h-24 overflow-hidden rounded-md border p-3 text-sm">
                The full terms of service run long. This box clips what does not fit, so the rest of the agreement is hidden from view.
            </div>
            <Caption text="overflow-hidden" />
        </div>
        <div class="grid gap-2">
            <div class="h-24 overflow-y-auto rounded-md border p-3 text-sm">
                The full terms of service run long. This box scrolls, so the reader can get to every clause of the agreement,
                including the part about disputes and refunds.
            </div>
            <Caption text="overflow-y-auto" />
        </div>
    </div>
}

pub fn OverscrollBehaviorExample() -> Element {
    <div class="grid gap-2">
        <div class="h-32 overflow-y-auto overscroll-contain rounded-md border">
            for n in 1..=12 {
                <div class="border-b px-3 py-2 font-mono text-xs last:border-0">{format!("evt_{n:02} · payment.succeeded")}</div>
            }
        </div>
        <Caption text="overscroll-contain: scrolling past the end does not scroll the page" />
    </div>
}

pub fn PositionExample() -> Element {
    <div class="relative h-36 rounded-md border bg-muted p-3 text-sm">
        <span class="font-control text-heading">relative</span>
        <div class="absolute right-3 bottom-3 rounded-md bg-primary px-3 py-1 text-primary-foreground">absolute right-3 bottom-3</div>
        <div class="sticky top-0 mt-2 w-fit rounded-md bg-card px-2 py-1 shadow-control">sticky top-0</div>
    </div>
}

pub fn TopRightBottomLeftExample() -> Element {
    <div class="grid grid-cols-3 gap-4">
        <div class="grid gap-2"><div class="relative size-24 rounded-md bg-muted"><div class="absolute top-0 left-0 size-10 rounded-md bg-primary"></div></div><Caption text="top-0 left-0" /></div>
        <div class="grid gap-2"><div class="relative size-24 rounded-md bg-muted"><div class="absolute inset-x-0 top-0 h-10 rounded-md bg-primary"></div></div><Caption text="inset-x-0 top-0" /></div>
        <div class="grid gap-2"><div class="relative size-24 rounded-md bg-muted"><div class="absolute inset-4 rounded-md bg-primary"></div></div><Caption text="inset-4" /></div>
    </div>
}

pub fn VisibilityExample() -> Element {
    <div class="grid gap-2">
        <div class="flex gap-2">
            <div class="rounded-md bg-muted px-4 py-2 text-sm">Paid</div>
            <div class="invisible rounded-md bg-muted px-4 py-2 text-sm">Pending</div>
            <div class="rounded-md bg-muted px-4 py-2 text-sm">Refunded</div>
        </div>
        <Caption text="invisible: the middle item keeps its space" />
    </div>
}

pub fn ZIndexExample() -> Element {
    <div class="flex">
        <div class="z-30 flex size-20 items-center justify-center rounded-full bg-chart-1 text-xs text-white ring-4 ring-background">z-30</div>
        <div class="z-20 -ml-6 flex size-20 items-center justify-center rounded-full bg-chart-2 text-xs text-white ring-4 ring-background">z-20</div>
        <div class="z-10 -ml-6 flex size-20 items-center justify-center rounded-full bg-chart-3 text-xs text-white ring-4 ring-background">z-10</div>
    </div>
}
