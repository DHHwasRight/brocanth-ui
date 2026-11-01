//! Examples for the Interactivity utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: accent-color, appearance, caret-color, color-scheme, cursor, field-sizing, pointer-events, resize, scroll-behavior, scrollbar-color, scrollbar-width, scrollbar-gutter, scroll-margin, scroll-padding, scroll-snap-align, scroll-snap-stop, scroll-snap-type, touch-action, user-select, will-change

pub fn Examples(slug: &str) -> Element {
    match slug {
        "accent-color" => <AccentColorExample />,
        "appearance" => <AppearanceExample />,
        "caret-color" => <CaretColorExample />,
        "color-scheme" => <ColorSchemeExample />,
        "cursor" => <CursorExample />,
        "field-sizing" => <FieldSizingExample />,
        "pointer-events" => <PointerEventsExample />,
        "resize" => <ResizeExample />,
        "scroll-behavior" => <ScrollBehaviorExample />,
        "scrollbar-color" => <ScrollbarColorExample />,
        "scrollbar-width" => <ScrollbarWidthExample />,
        "scrollbar-gutter" => <ScrollbarGutterExample />,
        "scroll-margin" => <ScrollMarginExample />,
        "scroll-padding" => <ScrollPaddingExample />,
        "scroll-snap-align" => <ScrollSnapAlignExample />,
        "scroll-snap-stop" => <ScrollSnapStopExample />,
        "scroll-snap-type" => <ScrollSnapTypeExample />,
        "touch-action" => <TouchActionExample />,
        "user-select" => <UserSelectExample />,
        "will-change" => <WillChangeExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

/// A short list of ledger rows, to fill the scroll demos.
fn Rows(count: u32) -> Element {
    <div>
        for n in 1..=count {
            <div class="border-b px-3 py-2 font-mono text-xs last:border-0">{format!("in_{:04} · ${}.00", 2000 + n, n * 15)}</div>
        }
    </div>
}

pub fn AccentColorExample() -> Element {
    <div class="grid gap-4 text-sm sm:grid-cols-3">
        <div class="grid gap-2"><label class="flex items-center gap-2"><input type="checkbox" checked class="accent-primary">Email receipts</label><Caption text="accent-primary" /></div>
        <div class="grid gap-2"><label class="flex items-center gap-2"><input type="checkbox" checked class="accent-chart-3">Retry failed payments</label><Caption text="accent-chart-3" /></div>
        <div class="grid gap-2"><input type="range" min="0" max="100" value="60" class="accent-success"><Caption text="accent-success" /></div>
    </div>
}

pub fn AppearanceExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <select class="appearance-auto rounded-md border px-2 py-1 text-sm"><option>Monthly</option><option>Yearly</option></select>
            <Caption text="appearance-auto" />
        </div>
        <div class="grid gap-2">
            <select class="appearance-none rounded-md border bg-card px-3 py-1 text-sm shadow-control"><option>Monthly</option><option>Yearly</option></select>
            <Caption text="appearance-none" />
        </div>
    </div>
}

pub fn CaretColorExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><input value="Acme Inc." class="caret-primary rounded-md border px-3 py-1.5 text-sm"><Caption text="caret-primary" /></div>
        <div class="grid gap-2"><input value="billing@acme.test" class="caret-destructive rounded-md border px-3 py-1.5 text-sm"><Caption text="caret-destructive" /></div>
    </div>
}

pub fn ColorSchemeExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2 scheme-light"><input type="date" value="2026-11-01" class="rounded-md border px-2 py-1 text-sm"><Caption text="scheme-light" /></div>
        <div class="grid gap-2 rounded-md bg-heading p-2 scheme-dark"><input type="date" value="2026-11-01" class="rounded-md border px-2 py-1 text-sm text-white"><Caption text="scheme-dark" /></div>
    </div>
}

pub fn CursorExample() -> Element {
    <div class="flex flex-wrap gap-3 text-sm">
        <div class="cursor-pointer rounded-md bg-primary px-3 py-2 text-primary-foreground">cursor-pointer</div>
        <div class="cursor-wait rounded-md bg-muted px-3 py-2">cursor-wait</div>
        <div class="cursor-not-allowed rounded-md bg-muted px-3 py-2 opacity-60">cursor-not-allowed</div>
        <div class="cursor-help rounded-md border px-3 py-2">cursor-help</div>
        <div class="cursor-grab rounded-md border px-3 py-2">cursor-grab</div>
    </div>
}

pub fn FieldSizingExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><textarea rows="2" class="field-sizing-fixed w-full rounded-md border p-2 text-sm">Type a note for this refund.</textarea><Caption text="field-sizing-fixed" /></div>
        <div class="grid gap-2"><textarea class="field-sizing-content min-h-10 w-full rounded-md border p-2 text-sm">This box grows as you type more lines.</textarea><Caption text="field-sizing-content" /></div>
    </div>
}

pub fn PointerEventsExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <div class="relative"><input placeholder="Search payments" class="w-full rounded-md border py-1.5 pr-3 pl-8 text-sm"><span class="pointer-events-auto absolute top-1.5 left-2 text-muted-foreground">⌕</span></div>
            <Caption text="pointer-events-auto: clicks on the icon miss the input" />
        </div>
        <div class="grid gap-2">
            <div class="relative"><input placeholder="Search payments" class="w-full rounded-md border py-1.5 pr-3 pl-8 text-sm"><span class="pointer-events-none absolute top-1.5 left-2 text-muted-foreground">⌕</span></div>
            <Caption text="pointer-events-none: clicks pass to the input" />
        </div>
    </div>
}

pub fn ResizeExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><textarea class="resize-none rounded-md border p-2 text-sm">Memo</textarea><Caption text="resize-none" /></div>
        <div class="grid gap-2"><textarea class="resize-y rounded-md border p-2 text-sm">Memo</textarea><Caption text="resize-y" /></div>
        <div class="grid gap-2"><div class="resize h-16 overflow-auto rounded-md border bg-muted p-2 text-sm">Drag the corner.</div><Caption text="resize" /></div>
    </div>
}

pub fn ScrollBehaviorExample() -> Element {
    <div class="grid gap-2">
        <div class="flex gap-3 text-sm"><a class="text-link" href="#u-sb-top">Top</a><a class="text-link" href="#u-sb-end">Last invoice</a></div>
        <div class="h-32 overflow-y-auto scroll-smooth rounded-md border">
            <div id="u-sb-top"></div>
            <Rows count={12} />
            <div id="u-sb-end" class="px-3 py-2 text-xs text-heading">End of the ledger</div>
        </div>
        <Caption text="scroll-smooth: the links glide instead of jump" />
    </div>
}

pub fn ScrollbarColorExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><div class="h-28 overflow-y-auto rounded-md border scrollbar-thumb-primary scrollbar-track-muted"><Rows count={10} /></div><Caption text="scrollbar-thumb-primary scrollbar-track-muted" /></div>
        <div class="grid gap-2"><div class="h-28 overflow-y-auto rounded-md border scrollbar-thumb-chart-3 scrollbar-track-transparent"><Rows count={10} /></div><Caption text="scrollbar-thumb-chart-3" /></div>
    </div>
}

pub fn ScrollbarWidthExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><div class="h-28 overflow-y-auto rounded-md border scrollbar-auto"><Rows count={10} /></div><Caption text="scrollbar-auto" /></div>
        <div class="grid gap-2"><div class="h-28 overflow-y-auto rounded-md border scrollbar-thin"><Rows count={10} /></div><Caption text="scrollbar-thin" /></div>
        <div class="grid gap-2"><div class="h-28 overflow-y-auto rounded-md border scrollbar-none"><Rows count={10} /></div><Caption text="scrollbar-none" /></div>
    </div>
}

pub fn ScrollbarGutterExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><div class="h-28 overflow-auto rounded-md border scrollbar-gutter-auto"><Rows count={3} /></div><Caption text="scrollbar-gutter-auto" /></div>
        <div class="grid gap-2"><div class="h-28 overflow-auto rounded-md border scrollbar-gutter-stable"><Rows count={3} /></div><Caption text="scrollbar-gutter-stable" /></div>
        <div class="grid gap-2"><div class="h-28 overflow-auto rounded-md border scrollbar-gutter-both"><Rows count={3} /></div><Caption text="scrollbar-gutter-both" /></div>
    </div>
}

pub fn ScrollMarginExample() -> Element {
    <div class="grid gap-2">
        <div class="flex gap-3 text-sm"><a class="text-link" href="#u-sm-plain">Fees</a><a class="text-link" href="#u-sm-margin">Taxes</a></div>
        <div class="h-32 overflow-y-auto rounded-md border">
            <Rows count={8} />
            <div id="u-sm-plain" class="bg-muted px-3 py-2 text-sm">Fees: lands at the very top</div>
            <Rows count={8} />
            <div id="u-sm-margin" class="scroll-mt-12 bg-muted px-3 py-2 text-sm">Taxes: lands 3rem below the top</div>
            <Rows count={8} />
        </div>
        <Caption text="scroll-mt-12" />
    </div>
}

pub fn ScrollPaddingExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><div class="flex snap-x snap-mandatory gap-3 overflow-x-auto rounded-md bg-muted p-3">
            for _ in 1..=6 { <div class="h-16 w-32 shrink-0 snap-start rounded-md bg-chart-1"></div> }
        </div><Caption text="scroll-p-0 (default)" /></div>
        <div class="grid gap-2"><div class="flex snap-x snap-mandatory scroll-px-8 gap-3 overflow-x-auto rounded-md bg-muted p-3">
            for _ in 1..=6 { <div class="h-16 w-32 shrink-0 snap-start rounded-md bg-chart-2"></div> }
        </div><Caption text="scroll-px-8" /></div>
    </div>
}

pub fn ScrollSnapAlignExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><div class="flex snap-x snap-mandatory gap-3 overflow-x-auto rounded-md bg-muted p-3">
            for n in 1..=6 { <div class="flex h-16 w-3/4 shrink-0 snap-start items-center justify-center rounded-md bg-card text-sm shadow-control">{format!("Plan {n}")}</div> }
        </div><Caption text="snap-start" /></div>
        <div class="grid gap-2"><div class="flex snap-x snap-mandatory gap-3 overflow-x-auto rounded-md bg-muted p-3">
            for n in 1..=6 { <div class="flex h-16 w-3/4 shrink-0 snap-center items-center justify-center rounded-md bg-card text-sm shadow-control">{format!("Plan {n}")}</div> }
        </div><Caption text="snap-center" /></div>
    </div>
}

pub fn ScrollSnapStopExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><div class="flex snap-x snap-mandatory gap-3 overflow-x-auto rounded-md bg-muted p-3">
            for n in 1..=8 { <div class="flex h-16 w-full shrink-0 snap-center snap-normal items-center justify-center rounded-md bg-card text-sm shadow-control">{format!("Step {n}")}</div> }
        </div><Caption text="snap-normal: a fast swipe skips steps" /></div>
        <div class="grid gap-2"><div class="flex snap-x snap-mandatory gap-3 overflow-x-auto rounded-md bg-muted p-3">
            for n in 1..=8 { <div class="flex h-16 w-full shrink-0 snap-center snap-always items-center justify-center rounded-md bg-card text-sm shadow-control">{format!("Step {n}")}</div> }
        </div><Caption text="snap-always: stops at every step" /></div>
    </div>
}

pub fn ScrollSnapTypeExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><div class="h-32 snap-y snap-mandatory overflow-y-auto rounded-md border">
            for n in 1..=6 { <div class="flex h-32 snap-start items-center justify-center border-b text-sm">{format!("Invoice {n} of 6")}</div> }
        </div><Caption text="snap-y snap-mandatory" /></div>
        <div class="grid gap-2"><div class="h-32 snap-y snap-proximity overflow-y-auto rounded-md border">
            for n in 1..=6 { <div class="flex h-32 snap-start items-center justify-center border-b text-sm">{format!("Invoice {n} of 6")}</div> }
        </div><Caption text="snap-y snap-proximity" /></div>
    </div>
}

pub fn TouchActionExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2"><div class="touch-auto h-24 overflow-auto rounded-md border"><Rows count={8} /></div><Caption text="touch-auto" /></div>
        <div class="grid gap-2"><div class="touch-pan-y h-24 overflow-auto rounded-md border"><Rows count={8} /></div><Caption text="touch-pan-y" /></div>
        <div class="grid gap-2"><div class="touch-none h-24 overflow-auto rounded-md border"><Rows count={8} /></div><Caption text="touch-none: no touch scroll" /></div>
    </div>
}

pub fn UserSelectExample() -> Element {
    <div class="grid gap-4 text-sm sm:grid-cols-3">
        <div class="grid gap-2"><p class="select-none rounded-md bg-muted p-3">Pay now</p><Caption text="select-none" /></div>
        <div class="grid gap-2"><p class="select-text rounded-md bg-muted p-3">Select part of this memo.</p><Caption text="select-text" /></div>
        <div class="grid gap-2"><p class="select-all rounded-md bg-muted p-3 font-mono">acct_1Nv0FA2eZ</p><Caption text="select-all: one click picks the key" /></div>
    </div>
}

pub fn WillChangeExample() -> Element {
    <div class="flex flex-wrap gap-6">
        <div class="grid gap-2"><div class="will-change-transform rounded-md bg-card px-4 py-3 text-sm shadow-control transition-transform hover:-translate-y-1">Upgrade plan</div><Caption text="will-change-transform" /></div>
        <div class="grid gap-2"><div class="will-change-scroll h-16 overflow-y-auto rounded-md border"><Rows count={5} /></div><Caption text="will-change-scroll" /></div>
        <div class="grid gap-2"><div class="will-change-auto rounded-md bg-muted px-4 py-3 text-sm">Static badge</div><Caption text="will-change-auto" /></div>
    </div>
}
