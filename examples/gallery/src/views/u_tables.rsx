//! Examples for the Tables utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.

pub fn Examples(slug: &str) -> Element {
    match slug {
        "border-collapse" => <BorderCollapseExample />,
        "border-spacing" => <BorderSpacingExample />,
        "table-layout" => <TableLayoutExample />,
        "caption-side" => <CaptionSideExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

pub fn BorderCollapseExample() -> Element {
    <div class="grid gap-6 text-sm sm:grid-cols-2">
        <div class="grid gap-2">
            <table class="border-collapse border">
                <tr><th class="border bg-muted p-2 text-left text-heading">Invoice</th><th class="border bg-muted p-2 text-right text-heading">Amount</th></tr>
                <tr><td class="border p-2">INV-1041</td><td class="border p-2 text-right">$120.00</td></tr>
                <tr><td class="border p-2">INV-1042</td><td class="border p-2 text-right">$89.50</td></tr>
            </table>
            <Caption text="border-collapse" />
        </div>
        <div class="grid gap-2">
            <table class="border-separate border">
                <tr><th class="border bg-muted p-2 text-left text-heading">Invoice</th><th class="border bg-muted p-2 text-right text-heading">Amount</th></tr>
                <tr><td class="border p-2">INV-1041</td><td class="border p-2 text-right">$120.00</td></tr>
                <tr><td class="border p-2">INV-1042</td><td class="border p-2 text-right">$89.50</td></tr>
            </table>
            <Caption text="border-separate" />
        </div>
    </div>
}

pub fn BorderSpacingExample() -> Element {
    <div class="grid gap-6 text-sm sm:grid-cols-2">
        <div class="grid gap-2">
            <table class="border-separate border-spacing-1">
                <tr><td class="rounded-md border p-2">Starter</td><td class="rounded-md border p-2 text-right">$19</td></tr>
                <tr><td class="rounded-md border p-2">Growth</td><td class="rounded-md border p-2 text-right">$79</td></tr>
            </table>
            <Caption text="border-spacing-1" />
        </div>
        <div class="grid gap-2">
            <table class="border-separate border-spacing-x-4 border-spacing-y-2">
                <tr><td class="rounded-md border p-2">Starter</td><td class="rounded-md border p-2 text-right">$19</td></tr>
                <tr><td class="rounded-md border p-2">Growth</td><td class="rounded-md border p-2 text-right">$79</td></tr>
            </table>
            <Caption text="border-spacing-x-4 border-spacing-y-2" />
        </div>
    </div>
}

pub fn TableLayoutExample() -> Element {
    <div class="grid gap-6 text-sm">
        <div class="grid gap-2">
            <table class="table-auto w-full border-collapse border">
                <tr><td class="border p-2">Customer</td><td class="border p-2">Acme Logistics International</td><td class="border p-2">$4,200.00</td></tr>
                <tr><td class="border p-2">Plan</td><td class="border p-2">Enterprise, billed yearly</td><td class="border p-2">$350.00</td></tr>
            </table>
            <Caption text="table-auto: columns fit their content" />
        </div>
        <div class="grid gap-2">
            <table class="table-fixed w-full border-collapse border">
                <tr><td class="border p-2">Customer</td><td class="border p-2">Acme Logistics International</td><td class="border p-2">$4,200.00</td></tr>
                <tr><td class="border p-2">Plan</td><td class="border p-2">Enterprise, billed yearly</td><td class="border p-2">$350.00</td></tr>
            </table>
            <Caption text="table-fixed: columns share the width equally" />
        </div>
    </div>
}

pub fn CaptionSideExample() -> Element {
    <div class="grid gap-6 text-sm sm:grid-cols-2">
        <div class="grid gap-2">
            <table class="w-full border-collapse border">
                <caption class="caption-top pb-2 text-left text-muted-foreground">Payouts, October</caption>
                <tr><td class="border p-2">Oct 14</td><td class="border p-2 text-right">$2,310.00</td></tr>
                <tr><td class="border p-2">Oct 28</td><td class="border p-2 text-right">$1,875.40</td></tr>
            </table>
            <Caption text="caption-top" />
        </div>
        <div class="grid gap-2">
            <table class="w-full border-collapse border">
                <caption class="caption-bottom pt-2 text-left text-muted-foreground">Payouts, October</caption>
                <tr><td class="border p-2">Oct 14</td><td class="border p-2 text-right">$2,310.00</td></tr>
                <tr><td class="border p-2">Oct 28</td><td class="border p-2 text-right">$1,875.40</td></tr>
            </table>
            <Caption text="caption-bottom" />
        </div>
    </div>
}
