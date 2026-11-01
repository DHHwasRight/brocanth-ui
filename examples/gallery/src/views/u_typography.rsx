//! Examples for the Typography utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.

pub fn Examples(slug: &str) -> Element {
    match slug {
        "font-family" => <FontFamilyExample />,
        "font-size" => <FontSizeExample />,
        "font-smoothing" => <FontSmoothingExample />,
        "font-style" => <FontStyleExample />,
        "font-weight" => <FontWeightExample />,
        "font-stretch" => <FontStretchExample />,
        "font-variant-numeric" => <FontVariantNumericExample />,
        "font-feature-settings" => <FontFeatureSettingsExample />,
        "letter-spacing" => <LetterSpacingExample />,
        "line-clamp" => <LineClampExample />,
        "line-height" => <LineHeightExample />,
        "list-style-image" => <ListStyleImageExample />,
        "list-style-position" => <ListStylePositionExample />,
        "list-style-type" => <ListStyleTypeExample />,
        "text-align" => <TextAlignExample />,
        "color" => <ColorExample />,
        "text-decoration-line" => <TextDecorationLineExample />,
        "text-decoration-color" => <TextDecorationColorExample />,
        "text-decoration-style" => <TextDecorationStyleExample />,
        "text-decoration-thickness" => <TextDecorationThicknessExample />,
        "text-underline-offset" => <TextUnderlineOffsetExample />,
        "text-transform" => <TextTransformExample />,
        "text-overflow" => <TextOverflowExample />,
        "text-wrap" => <TextWrapExample />,
        "text-indent" => <TextIndentExample />,
        "tab-size" => <TabSizeExample />,
        "vertical-align" => <VerticalAlignExample />,
        "white-space" => <WhiteSpaceExample />,
        "word-break" => <WordBreakExample />,
        "overflow-wrap" => <OverflowWrapExample />,
        "hyphens" => <HyphensExample />,
        "content" => <ContentExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

/// A long description for the clamp, wrap and overflow examples.
const NOTE: &str = "Payouts are sent every business day, two days after the payment clears, to the bank account on file. A payout that fails returns to the available balance and we email the account owner with the reason.";

pub fn FontFamilyExample() -> Element {
    <div class="grid gap-4">
        <div class="grid gap-1">
            <p class="font-sans text-lg text-heading">Invoice INV-2041 is paid</p>
            <Caption text="font-sans" />
        </div>
        <div class="grid gap-1">
            <p class="font-serif text-lg text-heading">Invoice INV-2041 is paid</p>
            <Caption text="font-serif" />
        </div>
        <div class="grid gap-1">
            <p class="font-mono text-lg text-heading">sk_live_51Hx9a2Lm0qT</p>
            <Caption text="font-mono" />
        </div>
    </div>
}

pub fn FontSizeExample() -> Element {
    <div class="grid gap-3 text-heading">
        <div class="flex items-baseline gap-4"><span class="text-xs">Total due $1,240.00</span><Caption text="text-xs" /></div>
        <div class="flex items-baseline gap-4"><span class="text-sm">Total due $1,240.00</span><Caption text="text-sm" /></div>
        <div class="flex items-baseline gap-4"><span class="text-base">Total due $1,240.00</span><Caption text="text-base" /></div>
        <div class="flex items-baseline gap-4"><span class="text-xl">Total due $1,240.00</span><Caption text="text-xl" /></div>
        <div class="flex items-baseline gap-4"><span class="text-3xl">Total due $1,240.00</span><Caption text="text-3xl" /></div>
    </div>
}

pub fn FontSmoothingExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2 rounded-md bg-primary p-4 text-primary-foreground">
            <p class="antialiased">Your payout of $8,420.15 is on its way.</p>
            <Caption text="antialiased" />
        </div>
        <div class="grid gap-2 rounded-md bg-primary p-4 text-primary-foreground">
            <p class="subpixel-antialiased">Your payout of $8,420.15 is on its way.</p>
            <Caption text="subpixel-antialiased" />
        </div>
    </div>
}

pub fn FontStyleExample() -> Element {
    <div class="grid gap-4 text-sm text-foreground">
        <div class="grid gap-1">
            <p class="italic">Draft: this invoice is not finalized yet.</p>
            <Caption text="italic" />
        </div>
        <div class="grid gap-1 italic">
            <p class="not-italic">Finalized on March 3 and sent to the customer.</p>
            <Caption text="not-italic" />
        </div>
    </div>
}

pub fn FontWeightExample() -> Element {
    <div class="grid gap-3 text-lg text-heading">
        <div class="flex items-baseline gap-4"><span class="font-normal">Acme Corp</span><Caption text="font-normal" /></div>
        <div class="flex items-baseline gap-4"><span class="font-control">Acme Corp</span><Caption text="font-control" /></div>
        <div class="flex items-baseline gap-4"><span class="font-heading">Acme Corp</span><Caption text="font-heading" /></div>
        <div class="flex items-baseline gap-4"><span class="font-bold">Acme Corp</span><Caption text="font-bold" /></div>
    </div>
}

pub fn FontStretchExample() -> Element {
    <div class="grid gap-3 text-lg text-heading">
        <div class="flex items-baseline gap-4"><span class="font-stretch-condensed">Monthly recurring revenue</span><Caption text="font-stretch-condensed" /></div>
        <div class="flex items-baseline gap-4"><span class="font-stretch-normal">Monthly recurring revenue</span><Caption text="font-stretch-normal" /></div>
        <div class="flex items-baseline gap-4"><span class="font-stretch-expanded">Monthly recurring revenue</span><Caption text="font-stretch-expanded" /></div>
        <p class="text-xs text-muted-foreground">The effect shows only with a font that has a width axis.</p>
    </div>
}

pub fn FontVariantNumericExample() -> Element {
    <div class="grid gap-6 sm:grid-cols-2">
        <div class="grid gap-2">
            <div class="grid justify-end rounded-md border bg-card p-3 text-right text-sm shadow-control">
                <span class="proportional-nums">$1,111.11</span>
                <span class="proportional-nums">$8,908.00</span>
            </div>
            <Caption text="proportional-nums" />
        </div>
        <div class="grid gap-2">
            <div class="grid justify-end rounded-md border bg-card p-3 text-right text-sm shadow-control">
                <span class="tabular-nums">$1,111.11</span>
                <span class="tabular-nums">$8,908.00</span>
            </div>
            <Caption text="tabular-nums" />
        </div>
        <div class="grid gap-2">
            <span class="slashed-zero font-mono text-sm">acct_0O0O0100</span>
            <Caption text="slashed-zero" />
        </div>
        <div class="grid gap-2">
            <span class="diagonal-fractions text-sm">Billed 1/2 of the month</span>
            <Caption text="diagonal-fractions" />
        </div>
    </div>
}

pub fn FontFeatureSettingsExample() -> Element {
    <div class="grid gap-4 text-lg text-heading">
        <div class="grid gap-1">
            <span>Order 1010 · $110.10</span>
            <Caption text="(default)" />
        </div>
        <div class="grid gap-1">
            <span class="font-features-['tnum','zero']">Order 1010 · $110.10</span>
            <Caption text="font-features-['tnum','zero']" />
        </div>
        <div class="grid gap-1">
            <span class="font-features-['smcp']">Order 1010 · $110.10</span>
            <Caption text="font-features-['smcp']" />
        </div>
    </div>
}

pub fn LetterSpacingExample() -> Element {
    <div class="grid gap-3 text-heading">
        <div class="flex items-baseline gap-4"><span class="tracking-tight">Upcoming invoice</span><Caption text="tracking-tight" /></div>
        <div class="flex items-baseline gap-4"><span class="tracking-normal">Upcoming invoice</span><Caption text="tracking-normal" /></div>
        <div class="flex items-baseline gap-4"><span class="tracking-widest text-xs uppercase">Upcoming invoice</span><Caption text="tracking-widest" /></div>
    </div>
}

pub fn LineClampExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2 rounded-md border bg-card p-4 shadow-control">
            <p class="line-clamp-2 text-sm text-foreground">{NOTE}</p>
            <Caption text="line-clamp-2" />
        </div>
        <div class="grid gap-2 rounded-md border bg-card p-4 shadow-control">
            <p class="line-clamp-3 text-sm text-foreground">{NOTE}</p>
            <Caption text="line-clamp-3" />
        </div>
    </div>
}

pub fn LineHeightExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <p class="text-sm/5 rounded-md bg-muted p-3">{NOTE}</p>
            <Caption text="text-sm/5" />
        </div>
        <div class="grid gap-2">
            <p class="text-sm/7 rounded-md bg-muted p-3">{NOTE}</p>
            <Caption text="text-sm/7" />
        </div>
        <div class="grid gap-2">
            <p class="leading-loose rounded-md bg-muted p-3 text-sm">{NOTE}</p>
            <Caption text="leading-loose" />
        </div>
    </div>
}

pub fn ListStyleImageExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <ul class="list-image-(--dot) pl-5 text-sm text-foreground" style="--dot: url(data:image/svg+xml,%3Csvg%20xmlns=%27http://www.w3.org/2000/svg%27%20width=%2710%27%20height=%2710%27%3E%3Ccircle%20cx=%275%27%20cy=%275%27%20r=%274%27%20fill=%27%23625afa%27/%3E%3C/svg%3E)">
                <li>Card payments</li>
                <li>Bank transfers</li>
                <li>Instant payouts</li>
            </ul>
            <Caption text="list-image-(--dot)" />
        </div>
        <div class="grid gap-2">
            <ul class="list-image-none list-disc pl-5 text-sm text-foreground">
                <li>Card payments</li>
                <li>Bank transfers</li>
                <li>Instant payouts</li>
            </ul>
            <Caption text="list-image-none" />
        </div>
    </div>
}

pub fn ListStylePositionExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <ul class="list-inside list-disc rounded-md bg-muted p-3 text-sm">
                <li>Retry failed payments after three days</li>
                <li>Email the customer a receipt</li>
            </ul>
            <Caption text="list-inside" />
        </div>
        <div class="grid gap-2">
            <ul class="list-outside list-disc rounded-md bg-muted py-3 pr-3 pl-8 text-sm">
                <li>Retry failed payments after three days</li>
                <li>Email the customer a receipt</li>
            </ul>
            <Caption text="list-outside" />
        </div>
    </div>
}

pub fn ListStyleTypeExample() -> Element {
    <div class="grid gap-4 text-sm sm:grid-cols-3">
        <div class="grid gap-2">
            <ul class="list-disc pl-5"><li>Create a customer</li><li>Attach a card</li><li>Start a subscription</li></ul>
            <Caption text="list-disc" />
        </div>
        <div class="grid gap-2">
            <ol class="list-decimal pl-5"><li>Create a customer</li><li>Attach a card</li><li>Start a subscription</li></ol>
            <Caption text="list-decimal" />
        </div>
        <div class="grid gap-2">
            <ul class="list-none"><li>Create a customer</li><li>Attach a card</li><li>Start a subscription</li></ul>
            <Caption text="list-none" />
        </div>
    </div>
}

pub fn TextAlignExample() -> Element {
    <div class="grid gap-3 text-sm">
        <div class="rounded-md border bg-card p-3 text-left shadow-control">Subtotal $980.00 <div><Caption text="text-left" /></div></div>
        <div class="rounded-md border bg-card p-3 text-center shadow-control">Thank you for your payment <div><Caption text="text-center" /></div></div>
        <div class="rounded-md border bg-card p-3 text-right shadow-control">Total $1,078.00 <div><Caption text="text-right" /></div></div>
    </div>
}

pub fn ColorExample() -> Element {
    <div class="grid gap-2 text-sm">
        <div class="flex items-baseline gap-4"><span class="text-heading">Invoice INV-2041</span><Caption text="text-heading" /></div>
        <div class="flex items-baseline gap-4"><span class="text-foreground">Billed to Acme Corp</span><Caption text="text-foreground" /></div>
        <div class="flex items-baseline gap-4"><span class="text-muted-foreground">Due in 14 days</span><Caption text="text-muted-foreground" /></div>
        <div class="flex items-baseline gap-4"><span class="text-primary">Send reminder</span><Caption text="text-primary" /></div>
        <div class="flex items-baseline gap-4"><span class="text-success">Paid</span><Caption text="text-success" /></div>
        <div class="flex items-baseline gap-4"><span class="text-warning">Payment retrying</span><Caption text="text-warning" /></div>
        <div class="flex items-baseline gap-4"><span class="text-destructive">Card declined</span><Caption text="text-destructive" /></div>
        <div class="flex items-baseline gap-4"><span class="text-link">View in dashboard</span><Caption text="text-link" /></div>
    </div>
}

pub fn TextDecorationLineExample() -> Element {
    <div class="grid gap-3 text-sm text-foreground">
        <div class="flex items-baseline gap-4"><span class="underline">View the invoice</span><Caption text="underline" /></div>
        <div class="flex items-baseline gap-4"><span class="overline">View the invoice</span><Caption text="overline" /></div>
        <div class="flex items-baseline gap-4"><span><span class="line-through text-muted-foreground">$49.00</span> $39.00</span><Caption text="line-through" /></div>
        <div class="flex items-baseline gap-4"><a class="text-link underline hover:no-underline">Download PDF</a><Caption text="hover:no-underline" /></div>
    </div>
}

pub fn TextDecorationColorExample() -> Element {
    <div class="grid gap-3 text-sm text-foreground">
        <div class="flex items-baseline gap-4"><span class="underline decoration-primary decoration-2">Upgrade plan</span><Caption text="decoration-primary" /></div>
        <div class="flex items-baseline gap-4"><span class="underline decoration-success decoration-2">Payment received</span><Caption text="decoration-success" /></div>
        <div class="flex items-baseline gap-4"><span class="underline decoration-destructive decoration-wavy">Invalid tax ID</span><Caption text="decoration-destructive" /></div>
    </div>
}

pub fn TextDecorationStyleExample() -> Element {
    <div class="grid gap-3 text-sm text-foreground">
        <div class="flex items-baseline gap-4"><span class="underline decoration-solid">Billing address</span><Caption text="decoration-solid" /></div>
        <div class="flex items-baseline gap-4"><span class="underline decoration-double">Billing address</span><Caption text="decoration-double" /></div>
        <div class="flex items-baseline gap-4"><span class="underline decoration-dotted">Billing address</span><Caption text="decoration-dotted" /></div>
        <div class="flex items-baseline gap-4"><span class="underline decoration-dashed">Billing address</span><Caption text="decoration-dashed" /></div>
        <div class="flex items-baseline gap-4"><span class="underline decoration-wavy decoration-destructive">Billing address</span><Caption text="decoration-wavy" /></div>
    </div>
}

pub fn TextDecorationThicknessExample() -> Element {
    <div class="grid gap-3 text-sm text-foreground">
        <div class="flex items-baseline gap-4"><span class="underline decoration-1 decoration-primary">Manage payment methods</span><Caption text="decoration-1" /></div>
        <div class="flex items-baseline gap-4"><span class="underline decoration-2 decoration-primary">Manage payment methods</span><Caption text="decoration-2" /></div>
        <div class="flex items-baseline gap-4"><span class="underline decoration-4 decoration-primary">Manage payment methods</span><Caption text="decoration-4" /></div>
        <div class="flex items-baseline gap-4"><span class="underline decoration-from-font decoration-primary">Manage payment methods</span><Caption text="decoration-from-font" /></div>
    </div>
}

pub fn TextUnderlineOffsetExample() -> Element {
    <div class="grid gap-3 text-sm text-link">
        <div class="flex items-baseline gap-4"><span class="underline underline-offset-1">Open customer portal</span><Caption text="underline-offset-1" /></div>
        <div class="flex items-baseline gap-4"><span class="underline underline-offset-4">Open customer portal</span><Caption text="underline-offset-4" /></div>
        <div class="flex items-baseline gap-4"><span class="underline underline-offset-8">Open customer portal</span><Caption text="underline-offset-8" /></div>
    </div>
}

pub fn TextTransformExample() -> Element {
    <div class="grid gap-3 text-sm text-foreground">
        <div class="flex items-baseline gap-4"><span class="uppercase">past due</span><Caption text="uppercase" /></div>
        <div class="flex items-baseline gap-4"><span class="lowercase">EUR</span><Caption text="lowercase" /></div>
        <div class="flex items-baseline gap-4"><span class="capitalize">annual pro plan</span><Caption text="capitalize" /></div>
        <div class="flex items-baseline gap-4"><span class="normal-case">Annual Pro plan</span><Caption text="normal-case" /></div>
    </div>
}

pub fn TextOverflowExample() -> Element {
    <div class="grid gap-4 text-sm">
        <div class="grid gap-1">
            <p class="truncate rounded-md bg-muted p-2">{NOTE}</p>
            <Caption text="truncate" />
        </div>
        <div class="grid gap-1">
            <p class="overflow-hidden text-ellipsis whitespace-nowrap rounded-md bg-muted p-2">{NOTE}</p>
            <Caption text="text-ellipsis" />
        </div>
        <div class="grid gap-1">
            <p class="overflow-hidden text-clip whitespace-nowrap rounded-md bg-muted p-2">{NOTE}</p>
            <Caption text="text-clip" />
        </div>
    </div>
}

pub fn TextWrapExample() -> Element {
    <div class="grid gap-4 text-heading sm:grid-cols-3">
        <div class="grid gap-2">
            <p class="text-wrap max-w-56 rounded-md bg-muted p-3 text-lg">Collect payments from customers in over forty countries</p>
            <Caption text="text-wrap" />
        </div>
        <div class="grid gap-2">
            <p class="text-balance max-w-56 rounded-md bg-muted p-3 text-lg">Collect payments from customers in over forty countries</p>
            <Caption text="text-balance" />
        </div>
        <div class="grid gap-2">
            <p class="text-pretty max-w-56 rounded-md bg-muted p-3 text-lg">Collect payments from customers in over forty countries</p>
            <Caption text="text-pretty" />
        </div>
    </div>
}

pub fn TextIndentExample() -> Element {
    <div class="grid gap-4 text-sm text-foreground sm:grid-cols-2">
        <div class="grid gap-2">
            <p class="indent-8">{NOTE}</p>
            <Caption text="indent-8" />
        </div>
        <div class="grid gap-2">
            <p class="-indent-4 pl-4">{NOTE}</p>
            <Caption text="-indent-4" />
        </div>
    </div>
}

pub fn TabSizeExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <pre class="tab-2 rounded-md bg-muted p-3 font-mono text-xs">{"invoice:\n\tid: in_1042\n\tamount: 4900"}</pre>
            <Caption text="tab-2" />
        </div>
        <div class="grid gap-2">
            <pre class="tab-8 rounded-md bg-muted p-3 font-mono text-xs">{"invoice:\n\tid: in_1042\n\tamount: 4900"}</pre>
            <Caption text="tab-8" />
        </div>
    </div>
}

pub fn VerticalAlignExample() -> Element {
    <div class="grid gap-3 text-sm text-foreground">
        <div>Balance <span class="inline-block size-6 rounded-sm bg-primary align-baseline"></span> today <Caption text="align-baseline" /></div>
        <div>Balance <span class="inline-block size-6 rounded-sm bg-primary align-middle"></span> today <Caption text="align-middle" /></div>
        <div>Balance <span class="inline-block size-6 rounded-sm bg-primary align-text-top"></span> today <Caption text="align-text-top" /></div>
        <div>Fee 2.9% <span class="align-super text-xs text-muted-foreground">1</span> per charge <Caption text="align-super" /></div>
    </div>
}

pub fn WhiteSpaceExample() -> Element {
    <div class="grid gap-4 text-sm">
        <div class="grid gap-1">
            <p class="whitespace-normal rounded-md bg-muted p-2">{"Line one:   Acme Corp\nLine two:   42 Market St"}</p>
            <Caption text="whitespace-normal" />
        </div>
        <div class="grid gap-1">
            <p class="whitespace-pre rounded-md bg-muted p-2">{"Line one:   Acme Corp\nLine two:   42 Market St"}</p>
            <Caption text="whitespace-pre" />
        </div>
        <div class="grid gap-1">
            <p class="whitespace-pre-line rounded-md bg-muted p-2">{"Line one:   Acme Corp\nLine two:   42 Market St"}</p>
            <Caption text="whitespace-pre-line" />
        </div>
    </div>
}

pub fn WordBreakExample() -> Element {
    <div class="grid gap-4 text-sm sm:grid-cols-2">
        <div class="grid gap-2">
            <p class="break-normal w-40 rounded-md bg-muted p-3">Webhook endpoint https://api.acme.example/billing/webhooks/events</p>
            <Caption text="break-normal" />
        </div>
        <div class="grid gap-2">
            <p class="break-all w-40 rounded-md bg-muted p-3">Webhook endpoint https://api.acme.example/billing/webhooks/events</p>
            <Caption text="break-all" />
        </div>
    </div>
}

pub fn OverflowWrapExample() -> Element {
    <div class="grid gap-4 text-sm sm:grid-cols-2">
        <div class="grid gap-2">
            <p class="wrap-normal w-40 overflow-hidden rounded-md bg-muted p-3">Key: sk_live_51Hx9a2Lm0qTzYvB8cD3eF</p>
            <Caption text="wrap-normal" />
        </div>
        <div class="grid gap-2">
            <p class="wrap-break-word w-40 rounded-md bg-muted p-3">Key: sk_live_51Hx9a2Lm0qTzYvB8cD3eF</p>
            <Caption text="wrap-break-word" />
        </div>
    </div>
}

pub fn HyphensExample() -> Element {
    <div class="grid gap-4 text-sm sm:grid-cols-3" lang="en">
        <div class="grid gap-2">
            <p class="hyphens-none w-28 rounded-md bg-muted p-3">Internationalization of invoices</p>
            <Caption text="hyphens-none" />
        </div>
        <div class="grid gap-2">
            <p class="hyphens-manual w-28 rounded-md bg-muted p-3">{"Internation\u{00AD}alization of invoices"}</p>
            <Caption text="hyphens-manual" />
        </div>
        <div class="grid gap-2">
            <p class="hyphens-auto w-28 rounded-md bg-muted p-3">Internationalization of invoices</p>
            <Caption text="hyphens-auto" />
        </div>
    </div>
}

pub fn ContentExample() -> Element {
    <div class="grid gap-3 text-sm text-foreground">
        <div class="flex items-baseline gap-4">
            <span class="before:mr-1 before:text-muted-foreground before:content-['Due:']">March 31</span>
            <Caption text="before:content-['Due:']" />
        </div>
        <div class="flex items-baseline gap-4">
            <a class="text-link after:ml-1 after:content-['→']">View invoice</a>
            <Caption text="after:content-['→']" />
        </div>
        <div class="flex items-baseline gap-4">
            <span class="after:ml-0.5 after:text-destructive after:content-['*']">Billing email</span>
            <Caption text="after:content-['*']" />
        </div>
    </div>
}
