//! Examples for the Borders utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: border-radius, border-width, border-color, border-style, outline-width, outline-color, outline-style, outline-offset

pub fn Examples(slug: &str) -> Element {
    match slug {
        "border-radius" => <BorderRadiusExample />,
        "border-width" => <BorderWidthExample />,
        "border-color" => <BorderColorExample />,
        "border-style" => <BorderStyleExample />,
        "outline-width" => <OutlineWidthExample />,
        "outline-color" => <OutlineColorExample />,
        "outline-style" => <OutlineStyleExample />,
        "outline-offset" => <OutlineOffsetExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

pub fn BorderRadiusExample() -> Element {
    <div class="grid gap-6">
        <div class="grid grid-cols-2 gap-4 sm:grid-cols-4">
            <div class="grid gap-2"><div class="h-16 rounded-sm bg-primary"></div><Caption text="rounded-sm" /></div>
            <div class="grid gap-2"><div class="h-16 rounded-md bg-primary"></div><Caption text="rounded-md" /></div>
            <div class="grid gap-2"><div class="h-16 rounded-lg bg-primary"></div><Caption text="rounded-lg" /></div>
            <div class="grid gap-2"><div class="h-16 rounded-xl bg-primary"></div><Caption text="rounded-xl" /></div>
        </div>
        <div class="flex items-center gap-3">
            <span class="rounded-badge bg-success-muted px-2 py-0.5 text-xs text-success">Paid</span>
            <span class="rounded-badge bg-muted px-2 py-0.5 text-xs text-muted-foreground">Draft</span>
            <Caption text="rounded-badge" />
        </div>
    </div>
}

pub fn BorderWidthExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><div class="rounded-md border p-3 text-sm">Invoice #1042 · $240.00</div><Caption text="border" /></div>
        <div class="grid gap-2"><div class="rounded-md border-2 border-primary p-3 text-sm">Selected plan · Pro</div><Caption text="border-2" /></div>
        <div class="grid gap-2"><div class="border-b-2 border-primary pb-2 text-sm font-control">Payouts</div><Caption text="border-b-2" /></div>
        <div class="grid gap-2"><div class="rounded-md border-l-4 border-warning bg-warning-muted p-3 text-sm">Card expires next month.</div><Caption text="border-l-4" /></div>
    </div>
}

pub fn BorderColorExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><div class="rounded-md border border-border bg-card p-3 text-sm">Balance · $8,120.00</div><Caption text="border-border" /></div>
        <div class="grid gap-2"><div class="flex h-control items-center rounded-md border border-input px-3 text-sm text-muted-foreground">billing@acme.com</div><Caption text="border-input" /></div>
        <div class="grid gap-2"><div class="rounded-md border-2 border-primary p-3 text-sm">Default payment method</div><Caption text="border-primary" /></div>
        <div class="grid gap-2"><div class="rounded-md border border-destructive p-3 text-sm text-destructive">Payment failed</div><Caption text="border-destructive" /></div>
    </div>
}

pub fn BorderStyleExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2"><div class="rounded-md border-2 border-solid p-3 text-sm">Invoice paid</div><Caption text="border-solid" /></div>
        <div class="grid gap-2"><div class="rounded-md border-2 border-dashed border-input p-3 text-center text-sm text-muted-foreground">Drop receipts here</div><Caption text="border-dashed" /></div>
        <div class="grid gap-2"><div class="rounded-md border-2 border-dotted p-3 text-sm">Pending review</div><Caption text="border-dotted" /></div>
        <div class="grid gap-2"><div class="rounded-md border-4 border-double border-primary p-3 text-sm">Final notice</div><Caption text="border-double" /></div>
    </div>
}

pub fn OutlineWidthExample() -> Element {
    <div class="flex flex-wrap items-center gap-8 p-2">
        <div class="grid gap-3"><button type="button" class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground outline outline-offset-2 outline-primary">Pay $49.00</button><Caption text="outline" /></div>
        <div class="grid gap-3"><button type="button" class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground outline-2 outline-offset-2 outline-primary">Pay $49.00</button><Caption text="outline-2" /></div>
        <div class="grid gap-3"><button type="button" class="rounded-md bg-primary px-4 py-2 text-sm text-primary-foreground outline-4 outline-offset-2 outline-primary">Pay $49.00</button><Caption text="outline-4" /></div>
    </div>
}

pub fn OutlineColorExample() -> Element {
    <div class="flex flex-wrap items-center gap-8 p-2">
        <div class="grid gap-3"><div class="rounded-md border bg-card px-3 py-2 text-sm outline-2 outline-offset-2 outline-ring">Card number</div><Caption text="outline-ring" /></div>
        <div class="grid gap-3"><div class="rounded-md border bg-card px-3 py-2 text-sm outline-4 outline-ring/50">Card number</div><Caption text="outline-ring/50" /></div>
        <div class="grid gap-3"><div class="rounded-md border bg-card px-3 py-2 text-sm outline-2 outline-offset-2 outline-primary">Card number</div><Caption text="outline-primary" /></div>
        <div class="grid gap-3"><div class="rounded-md border bg-card px-3 py-2 text-sm outline-2 outline-offset-2 outline-destructive">Card number</div><Caption text="outline-destructive" /></div>
    </div>
}

pub fn OutlineStyleExample() -> Element {
    <div class="flex flex-wrap items-center gap-8 p-2">
        <div class="grid gap-3"><div class="rounded-md bg-muted px-3 py-2 text-sm outline-2 outline-offset-2 outline-primary outline-solid">Payout</div><Caption text="outline-solid" /></div>
        <div class="grid gap-3"><div class="rounded-md bg-muted px-3 py-2 text-sm outline-2 outline-offset-2 outline-primary outline-dashed">Payout</div><Caption text="outline-dashed" /></div>
        <div class="grid gap-3"><div class="rounded-md bg-muted px-3 py-2 text-sm outline-2 outline-offset-2 outline-primary outline-dotted">Payout</div><Caption text="outline-dotted" /></div>
        <div class="grid gap-3"><div class="rounded-md bg-muted px-3 py-2 text-sm outline-4 outline-offset-2 outline-primary outline-double">Payout</div><Caption text="outline-double" /></div>
    </div>
}

pub fn OutlineOffsetExample() -> Element {
    <div class="flex flex-wrap items-center gap-8 p-2">
        <div class="grid gap-3"><div class="rounded-md border bg-card px-3 py-2 text-sm outline-2 outline-offset-0 outline-ring">Refund</div><Caption text="outline-offset-0" /></div>
        <div class="grid gap-3"><div class="rounded-md border bg-card px-3 py-2 text-sm outline-2 outline-offset-2 outline-ring">Refund</div><Caption text="outline-offset-2" /></div>
        <div class="grid gap-3"><div class="rounded-md border bg-card px-3 py-2 text-sm outline-2 outline-offset-4 outline-ring">Refund</div><Caption text="outline-offset-4" /></div>
        <div class="grid gap-3"><div class="rounded-md border bg-card px-3 py-2 text-sm outline-2 -outline-offset-4 outline-ring">Refund</div><Caption text="-outline-offset-4" /></div>
    </div>
}
