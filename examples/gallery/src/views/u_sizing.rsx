//! Examples for the Sizing utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: width, min-width, max-width, height, min-height, max-height, inline-size, min-inline-size, max-inline-size, block-size, min-block-size, max-block-size

pub fn Examples(slug: &str) -> Element {
    match slug {
        "width" => <WidthExample />,
        "min-width" => <MinWidthExample />,
        "max-width" => <MaxWidthExample />,
        "height" => <HeightExample />,
        "min-height" => <MinHeightExample />,
        "max-height" => <MaxHeightExample />,
        "inline-size" => <InlineSizeExample />,
        "min-inline-size" => <MinInlineSizeExample />,
        "max-inline-size" => <MaxInlineSizeExample />,
        "block-size" => <BlockSizeExample />,
        "min-block-size" => <MinBlockSizeExample />,
        "max-block-size" => <MaxBlockSizeExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

/// The payment terms used by the height examples.
const TERMS: &str = "Invoices are due 30 days after issue. Late payments carry a 1.5% monthly fee. Disputes must reach us within 60 days of the charge, with the invoice number and a short reason.";

pub fn WidthExample() -> Element {
    <div class="grid gap-2 text-sm">
        <div class="w-24 rounded-md bg-primary px-2 py-1 text-primary-foreground">w-24</div>
        <div class="w-48 rounded-md bg-primary px-2 py-1 text-primary-foreground">w-48</div>
        <div class="w-1/2 rounded-md bg-chart-2 px-2 py-1 text-primary-foreground">w-1/2</div>
        <div class="w-full rounded-md bg-chart-3 px-2 py-1 text-primary-foreground">w-full</div>
        <Caption text="w-24 · w-48 · w-1/2 · w-full" />
    </div>
}

pub fn MinWidthExample() -> Element {
    <div class="grid gap-2">
        <div class="flex w-64 gap-2 rounded-md border p-2 text-sm">
            <div class="min-w-36 rounded-md bg-primary px-2 py-1 text-primary-foreground">Amount</div>
            <div class="w-48 rounded-md bg-muted px-2 py-1">Monthly plan</div>
        </div>
        <Caption text="min-w-36: the first item does not shrink below 144px" />
    </div>
}

pub fn MaxWidthExample() -> Element {
    <div class="grid gap-2 text-sm">
        <div class="max-w-xs rounded-md border bg-card p-3 shadow-control">Your payout of $2,140.00 is on its way and arrives in two business days.</div>
        <Caption text="max-w-xs" />
        <div class="max-w-md rounded-md border bg-card p-3 shadow-control">Your payout of $2,140.00 is on its way and arrives in two business days.</div>
        <Caption text="max-w-md" />
    </div>
}

pub fn HeightExample() -> Element {
    <div class="flex items-end gap-4">
        <div class="grid gap-2"><div class="h-8 w-16 rounded-md bg-chart-1"></div><Caption text="h-8" /></div>
        <div class="grid gap-2"><div class="h-16 w-16 rounded-md bg-chart-2"></div><Caption text="h-16" /></div>
        <div class="grid gap-2"><div class="h-24 w-16 rounded-md bg-chart-3"></div><Caption text="h-24" /></div>
        <div class="grid gap-2"><div class="h-32 w-16 rounded-md bg-chart-4"></div><Caption text="h-32" /></div>
    </div>
}

pub fn MinHeightExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid content-start gap-2">
            <div class="min-h-0 rounded-md border p-3 text-sm">No invoices yet.</div>
            <Caption text="min-h-0" />
        </div>
        <div class="grid content-start gap-2">
            <div class="min-h-28 rounded-md border p-3 text-sm">No invoices yet.</div>
            <Caption text="min-h-28" />
        </div>
    </div>
}

pub fn MaxHeightExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid content-start gap-2">
            <div class="max-h-16 overflow-hidden rounded-md border p-3 text-sm">{TERMS}</div>
            <Caption text="max-h-16 overflow-hidden" />
        </div>
        <div class="grid content-start gap-2">
            <div class="max-h-24 overflow-y-auto rounded-md border p-3 text-sm">{TERMS}</div>
            <Caption text="max-h-24 overflow-y-auto" />
        </div>
    </div>
}

pub fn InlineSizeExample() -> Element {
    <div class="flex flex-wrap items-start gap-6">
        <div class="grid gap-2">
            <div class="inline-40 rounded-md bg-primary px-2 py-1 text-sm text-primary-foreground">Customer</div>
            <Caption text="inline-40, horizontal text" />
        </div>
        <div class="grid gap-2">
            <div class="inline-24 rounded-md bg-chart-2 px-1 py-2 text-sm text-primary-foreground [writing-mode:vertical-rl]">Customer</div>
            <Caption text="inline-24, vertical text" />
        </div>
    </div>
}

pub fn MinInlineSizeExample() -> Element {
    <div class="grid gap-2">
        <div class="flex w-64 gap-2 rounded-md border p-2 text-sm">
            <div class="min-inline-32 rounded-md bg-primary px-2 py-1 text-primary-foreground">Amount</div>
            <div class="w-56 rounded-md bg-muted px-2 py-1">Description of the charge</div>
        </div>
        <Caption text="min-inline-32" />
    </div>
}

pub fn MaxInlineSizeExample() -> Element {
    <div class="grid gap-2 text-sm">
        <div class="max-inline-xs rounded-md border bg-card p-3 shadow-control">A refund of $35.00 goes back to the card ending in 4242.</div>
        <Caption text="max-inline-xs" />
        <div class="max-inline-sm rounded-md border bg-card p-3 shadow-control">A refund of $35.00 goes back to the card ending in 4242.</div>
        <Caption text="max-inline-sm" />
    </div>
}

pub fn BlockSizeExample() -> Element {
    <div class="flex items-end gap-4">
        <div class="grid gap-2"><div class="block-10 w-20 rounded-md bg-chart-1"></div><Caption text="block-10" /></div>
        <div class="grid gap-2"><div class="block-20 w-20 rounded-md bg-chart-2"></div><Caption text="block-20" /></div>
        <div class="grid gap-2"><div class="block-28 w-20 rounded-md bg-chart-3"></div><Caption text="block-28" /></div>
    </div>
}

pub fn MinBlockSizeExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid content-start gap-2">
            <div class="min-block-0 rounded-md border p-3 text-sm">No payouts this week.</div>
            <Caption text="min-block-0" />
        </div>
        <div class="grid content-start gap-2">
            <div class="min-block-28 rounded-md border p-3 text-sm">No payouts this week.</div>
            <Caption text="min-block-28" />
        </div>
    </div>
}

pub fn MaxBlockSizeExample() -> Element {
    <div class="grid gap-2">
        <div class="max-block-24 overflow-y-auto rounded-md border p-3 text-sm">{TERMS}</div>
        <Caption text="max-block-24 overflow-y-auto" />
    </div>
}
