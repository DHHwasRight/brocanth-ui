//! Examples for the Flexbox & Grid utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: flex-basis, flex-direction, flex-wrap, flex, flex-grow, flex-shrink, order, grid-template-columns, grid-column, grid-template-rows, grid-row, grid-auto-flow, grid-auto-columns, grid-auto-rows, gap, justify-content, justify-items, justify-self, align-content, align-items, align-self, place-content, place-items, place-self

pub fn Examples(slug: &str) -> Element {
    match slug {
        "flex-basis" => <FlexBasisExample />,
        "flex-direction" => <FlexDirectionExample />,
        "flex-wrap" => <FlexWrapExample />,
        "flex" => <FlexExample />,
        "flex-grow" => <FlexGrowExample />,
        "flex-shrink" => <FlexShrinkExample />,
        "order" => <OrderExample />,
        "grid-template-columns" => <GridTemplateColumnsExample />,
        "grid-column" => <GridColumnExample />,
        "grid-template-rows" => <GridTemplateRowsExample />,
        "grid-row" => <GridRowExample />,
        "grid-auto-flow" => <GridAutoFlowExample />,
        "grid-auto-columns" => <GridAutoColumnsExample />,
        "grid-auto-rows" => <GridAutoRowsExample />,
        "gap" => <GapExample />,
        "justify-content" => <JustifyContentExample />,
        "justify-items" => <JustifyItemsExample />,
        "justify-self" => <JustifySelfExample />,
        "align-content" => <AlignContentExample />,
        "align-items" => <AlignItemsExample />,
        "align-self" => <AlignSelfExample />,
        "place-content" => <PlaceContentExample />,
        "place-items" => <PlaceItemsExample />,
        "place-self" => <PlaceSelfExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

pub fn FlexBasisExample() -> Element {
    <div class="grid gap-2">
        <div class="flex gap-2 text-sm text-primary-foreground">
            <div class="basis-1/4 rounded-md bg-chart-1 p-3">Customer</div>
            <div class="basis-1/4 rounded-md bg-chart-2 p-3">Invoice</div>
            <div class="basis-1/2 rounded-md bg-chart-3 p-3">Amount due</div>
        </div>
        <Caption text="basis-1/4 · basis-1/4 · basis-1/2" />
        <div class="flex gap-2 text-sm">
            <div class="basis-32 rounded-md bg-muted p-3">Status</div>
            <div class="basis-64 rounded-md bg-muted p-3">Description</div>
        </div>
        <Caption text="basis-32 · basis-64" />
    </div>
}

pub fn FlexDirectionExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <div class="flex flex-row gap-2 text-sm">
                <div class="rounded-md bg-muted px-3 py-2">Draft</div>
                <div class="rounded-md bg-muted px-3 py-2">Open</div>
                <div class="rounded-md bg-success-muted px-3 py-2 text-success">Paid</div>
            </div>
            <Caption text="flex-row" />
        </div>
        <div class="grid gap-2">
            <div class="flex flex-col gap-2 text-sm">
                <div class="rounded-md bg-muted px-3 py-2">Draft</div>
                <div class="rounded-md bg-muted px-3 py-2">Open</div>
                <div class="rounded-md bg-success-muted px-3 py-2 text-success">Paid</div>
            </div>
            <Caption text="flex-col" />
        </div>
        <div class="grid gap-2">
            <div class="flex flex-row-reverse justify-end gap-2 text-sm">
                <div class="rounded-md bg-muted px-3 py-2">Draft</div>
                <div class="rounded-md bg-muted px-3 py-2">Open</div>
                <div class="rounded-md bg-success-muted px-3 py-2 text-success">Paid</div>
            </div>
            <Caption text="flex-row-reverse" />
        </div>
    </div>
}

pub fn FlexWrapExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <div class="flex w-56 flex-nowrap gap-2 overflow-hidden rounded-md border p-2 text-xs">
                for tag in ["USD", "EUR", "GBP", "JPY", "CAD", "AUD"] {
                    <span class="rounded-md bg-muted px-2 py-1">{tag}</span>
                }
            </div>
            <Caption text="flex-nowrap" />
        </div>
        <div class="grid gap-2">
            <div class="flex w-56 flex-wrap gap-2 rounded-md border p-2 text-xs">
                for tag in ["USD", "EUR", "GBP", "JPY", "CAD", "AUD"] {
                    <span class="rounded-md bg-muted px-2 py-1">{tag}</span>
                }
            </div>
            <Caption text="flex-wrap" />
        </div>
    </div>
}

pub fn FlexExample() -> Element {
    <div class="grid gap-2">
        <div class="flex gap-2 rounded-md border p-2 text-sm">
            <div class="flex-none rounded-md bg-muted px-3 py-2">flex-none</div>
            <div class="flex-1 rounded-md bg-primary px-3 py-2 text-primary-foreground">flex-1</div>
            <div class="flex-auto rounded-md bg-chart-2 px-3 py-2 text-primary-foreground">flex-auto</div>
            <div class="flex-initial rounded-md bg-muted px-3 py-2">flex-initial</div>
        </div>
        <Caption text="flex-none · flex-1 · flex-auto · flex-initial" />
    </div>
}

pub fn FlexGrowExample() -> Element {
    <div class="grid gap-2">
        <div class="flex gap-2 text-sm">
            <div class="grow-0 rounded-md bg-muted px-3 py-2">Logo</div>
            <div class="grow rounded-md bg-primary px-3 py-2 text-primary-foreground">Search invoices</div>
            <div class="grow-0 rounded-md bg-muted px-3 py-2">Account</div>
        </div>
        <Caption text="grow-0 · grow · grow-0" />
    </div>
}

pub fn FlexShrinkExample() -> Element {
    <div class="grid gap-2">
        <div class="flex w-72 gap-2 rounded-md border p-2 text-sm">
            <div class="w-32 shrink-0 rounded-md bg-primary px-3 py-2 text-primary-foreground">$1,250.00</div>
            <div class="w-48 shrink rounded-md bg-muted px-3 py-2">Annual plan, 5 seats</div>
        </div>
        <Caption text="shrink-0 · shrink" />
    </div>
}

pub fn OrderExample() -> Element {
    <div class="grid gap-2">
        <div class="flex gap-2 text-sm">
            <div class="order-3 rounded-md bg-muted px-3 py-2">1 · Review</div>
            <div class="order-1 rounded-md bg-primary px-3 py-2 text-primary-foreground">2 · Customer</div>
            <div class="order-2 rounded-md bg-chart-2 px-3 py-2 text-primary-foreground">3 · Payment</div>
            <div class="order-last rounded-md bg-success-muted px-3 py-2 text-success">4 · Done</div>
        </div>
        <Caption text="order-3 · order-1 · order-2 · order-last" />
    </div>
}

pub fn GridTemplateColumnsExample() -> Element {
    <div class="grid gap-4">
        <div class="grid grid-cols-4 gap-2 text-sm">
            for n in 1..=8 {
                <div class="rounded-md bg-muted p-2">{format!("INV-{}", 2000 + n)}</div>
            }
        </div>
        <Caption text="grid-cols-4" />
        <div class="grid grid-cols-[1fr_auto] gap-2 text-sm">
            <div class="rounded-md bg-muted p-2">Pro plan, monthly</div>
            <div class="rounded-md bg-primary p-2 text-primary-foreground">$49.00</div>
        </div>
        <Caption text="grid-cols-[1fr_auto]" />
    </div>
}

pub fn GridColumnExample() -> Element {
    <div class="grid gap-2">
        <div class="grid grid-cols-6 gap-2 text-sm">
            <div class="col-span-4 rounded-md bg-primary p-2 text-primary-foreground">col-span-4 · Description</div>
            <div class="col-span-2 rounded-md bg-muted p-2">col-span-2 · Total</div>
            <div class="col-start-2 col-end-6 rounded-md bg-chart-2 p-2 text-primary-foreground">col-start-2 col-end-6</div>
            <div class="col-span-full rounded-md bg-muted p-2">col-span-full · Notes</div>
        </div>
        <Caption text="col-span-4 · col-start-2 col-end-6 · col-span-full" />
    </div>
}

pub fn GridTemplateRowsExample() -> Element {
    <div class="grid gap-2">
        <div class="grid h-40 grid-flow-col grid-rows-3 gap-2 text-sm">
            for n in 1..=6 {
                <div class="rounded-md bg-muted p-2">{format!("Payout #{}", n)}</div>
            }
        </div>
        <Caption text="grid-rows-3 grid-flow-col" />
    </div>
}

pub fn GridRowExample() -> Element {
    <div class="grid gap-2">
        <div class="grid h-40 grid-flow-col grid-rows-3 gap-2 text-sm">
            <div class="row-span-3 rounded-md bg-primary p-2 text-primary-foreground">row-span-3</div>
            <div class="col-span-2 rounded-md bg-muted p-2">Balance</div>
            <div class="row-span-2 col-span-2 rounded-md bg-chart-2 p-2 text-primary-foreground">row-span-2</div>
        </div>
        <Caption text="row-span-3 · row-span-2" />
    </div>
}

pub fn GridAutoFlowExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <div class="grid grid-flow-row grid-cols-3 gap-2 text-sm">
                for n in 1..=5 {
                    <div class="rounded-md bg-muted p-2">{n}</div>
                }
            </div>
            <Caption text="grid-flow-row" />
        </div>
        <div class="grid gap-2">
            <div class="grid grid-flow-col grid-rows-2 gap-2 text-sm">
                for n in 1..=5 {
                    <div class="rounded-md bg-muted p-2">{n}</div>
                }
            </div>
            <Caption text="grid-flow-col" />
        </div>
    </div>
}

pub fn GridAutoColumnsExample() -> Element {
    <div class="grid gap-4">
        <div class="grid auto-cols-max grid-flow-col gap-2 text-sm">
            <div class="rounded-md bg-muted p-2">Jan</div>
            <div class="rounded-md bg-muted p-2">February payouts</div>
            <div class="rounded-md bg-muted p-2">Mar</div>
        </div>
        <Caption text="auto-cols-max" />
        <div class="grid auto-cols-fr grid-flow-col gap-2 text-sm">
            <div class="rounded-md bg-muted p-2">Jan</div>
            <div class="rounded-md bg-muted p-2">February payouts</div>
            <div class="rounded-md bg-muted p-2">Mar</div>
        </div>
        <Caption text="auto-cols-fr" />
    </div>
}

pub fn GridAutoRowsExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div class="grid gap-2">
            <div class="grid auto-rows-min grid-cols-2 gap-2 text-sm">
                <div class="rounded-md bg-muted p-2">Card</div>
                <div class="rounded-md bg-muted p-2">Bank transfer, settles in two to three business days</div>
            </div>
            <Caption text="auto-rows-min" />
        </div>
        <div class="grid gap-2">
            <div class="grid auto-rows-16 grid-cols-2 gap-2 text-sm">
                <div class="rounded-md bg-muted p-2">Card</div>
                <div class="rounded-md bg-muted p-2">Wallet</div>
                <div class="rounded-md bg-muted p-2">Bank</div>
            </div>
            <Caption text="auto-rows-16" />
        </div>
    </div>
}

pub fn GapExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="grid grid-cols-2 gap-1">
                for _ in 0..4 { <div class="h-8 rounded-md bg-primary"></div> }
            </div>
            <Caption text="gap-1" />
        </div>
        <div class="grid gap-2">
            <div class="grid grid-cols-2 gap-4">
                for _ in 0..4 { <div class="h-8 rounded-md bg-primary"></div> }
            </div>
            <Caption text="gap-4" />
        </div>
        <div class="grid gap-2">
            <div class="grid grid-cols-2 gap-x-6 gap-y-1">
                for _ in 0..4 { <div class="h-8 rounded-md bg-primary"></div> }
            </div>
            <Caption text="gap-x-6 gap-y-1" />
        </div>
    </div>
}

pub fn JustifyContentExample() -> Element {
    <div class="grid gap-2 text-sm">
        <div class="flex justify-start gap-2 rounded-md border p-2"><span class="rounded-md bg-muted px-3 py-1">Cancel</span><span class="rounded-md bg-primary px-3 py-1 text-primary-foreground">Pay</span></div>
        <Caption text="justify-start" />
        <div class="flex justify-center gap-2 rounded-md border p-2"><span class="rounded-md bg-muted px-3 py-1">Cancel</span><span class="rounded-md bg-primary px-3 py-1 text-primary-foreground">Pay</span></div>
        <Caption text="justify-center" />
        <div class="flex justify-between gap-2 rounded-md border p-2"><span class="rounded-md bg-muted px-3 py-1">Cancel</span><span class="rounded-md bg-primary px-3 py-1 text-primary-foreground">Pay</span></div>
        <Caption text="justify-between" />
        <div class="flex justify-end gap-2 rounded-md border p-2"><span class="rounded-md bg-muted px-3 py-1">Cancel</span><span class="rounded-md bg-primary px-3 py-1 text-primary-foreground">Pay</span></div>
        <Caption text="justify-end" />
    </div>
}

pub fn JustifyItemsExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="grid justify-items-start gap-2 rounded-md border p-2 text-sm"><span class="rounded-md bg-muted px-2">$12.00</span><span class="rounded-md bg-muted px-2">$4,800.00</span></div>
            <Caption text="justify-items-start" />
        </div>
        <div class="grid gap-2">
            <div class="grid justify-items-center gap-2 rounded-md border p-2 text-sm"><span class="rounded-md bg-muted px-2">$12.00</span><span class="rounded-md bg-muted px-2">$4,800.00</span></div>
            <Caption text="justify-items-center" />
        </div>
        <div class="grid gap-2">
            <div class="grid justify-items-end gap-2 rounded-md border p-2 text-sm"><span class="rounded-md bg-muted px-2">$12.00</span><span class="rounded-md bg-muted px-2">$4,800.00</span></div>
            <Caption text="justify-items-end" />
        </div>
    </div>
}

pub fn JustifySelfExample() -> Element {
    <div class="grid gap-2">
        <div class="grid justify-items-stretch gap-2 rounded-md border p-2 text-sm">
            <span class="justify-self-start rounded-md bg-muted px-2 py-1">justify-self-start</span>
            <span class="justify-self-center rounded-md bg-primary px-2 py-1 text-primary-foreground">justify-self-center</span>
            <span class="justify-self-end rounded-md bg-muted px-2 py-1">justify-self-end</span>
            <span class="justify-self-stretch rounded-md bg-muted px-2 py-1">justify-self-stretch</span>
        </div>
        <Caption text="justify-items-stretch on the grid" />
    </div>
}

pub fn AlignContentExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="flex h-36 flex-wrap content-start gap-2 rounded-md border p-2 text-xs">
                for n in 1..=5 { <span class="w-16 rounded-md bg-muted p-1">{format!("cus_{}", n)}</span> }
            </div>
            <Caption text="content-start" />
        </div>
        <div class="grid gap-2">
            <div class="flex h-36 flex-wrap content-center gap-2 rounded-md border p-2 text-xs">
                for n in 1..=5 { <span class="w-16 rounded-md bg-muted p-1">{format!("cus_{}", n)}</span> }
            </div>
            <Caption text="content-center" />
        </div>
        <div class="grid gap-2">
            <div class="flex h-36 flex-wrap content-between gap-2 rounded-md border p-2 text-xs">
                for n in 1..=5 { <span class="w-16 rounded-md bg-muted p-1">{format!("cus_{}", n)}</span> }
            </div>
            <Caption text="content-between" />
        </div>
    </div>
}

pub fn AlignItemsExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="flex h-24 items-start gap-2 rounded-md border p-2 text-sm"><span class="rounded-md bg-muted px-2 py-1">Refund</span><span class="rounded-md bg-primary px-2 py-4 text-primary-foreground">$20</span></div>
            <Caption text="items-start" />
        </div>
        <div class="grid gap-2">
            <div class="flex h-24 items-center gap-2 rounded-md border p-2 text-sm"><span class="rounded-md bg-muted px-2 py-1">Refund</span><span class="rounded-md bg-primary px-2 py-4 text-primary-foreground">$20</span></div>
            <Caption text="items-center" />
        </div>
        <div class="grid gap-2">
            <div class="flex h-24 items-end gap-2 rounded-md border p-2 text-sm"><span class="rounded-md bg-muted px-2 py-1">Refund</span><span class="rounded-md bg-primary px-2 py-4 text-primary-foreground">$20</span></div>
            <Caption text="items-end" />
        </div>
    </div>
}

pub fn AlignSelfExample() -> Element {
    <div class="grid gap-2">
        <div class="flex h-28 items-stretch gap-2 rounded-md border p-2 text-sm">
            <span class="self-start rounded-md bg-muted px-2 py-1">self-start</span>
            <span class="self-center rounded-md bg-primary px-2 py-1 text-primary-foreground">self-center</span>
            <span class="self-end rounded-md bg-muted px-2 py-1">self-end</span>
            <span class="self-stretch rounded-md bg-muted px-2 py-1">self-stretch</span>
        </div>
        <Caption text="items-stretch on the row" />
    </div>
}

pub fn PlaceContentExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="grid h-32 grid-cols-2 place-content-start gap-2 rounded-md border p-2">
                for _ in 0..4 { <div class="size-8 rounded-md bg-chart-1"></div> }
            </div>
            <Caption text="place-content-start" />
        </div>
        <div class="grid gap-2">
            <div class="grid h-32 grid-cols-2 place-content-center gap-2 rounded-md border p-2">
                for _ in 0..4 { <div class="size-8 rounded-md bg-chart-1"></div> }
            </div>
            <Caption text="place-content-center" />
        </div>
        <div class="grid gap-2">
            <div class="grid h-32 grid-cols-2 place-content-between gap-2 rounded-md border p-2">
                for _ in 0..4 { <div class="size-8 rounded-md bg-chart-1"></div> }
            </div>
            <Caption text="place-content-between" />
        </div>
    </div>
}

pub fn PlaceItemsExample() -> Element {
    <div class="grid gap-4 sm:grid-cols-3">
        <div class="grid gap-2">
            <div class="grid h-32 grid-cols-2 place-items-start gap-2 rounded-md border p-2">
                for _ in 0..4 { <div class="size-8 rounded-md bg-chart-2"></div> }
            </div>
            <Caption text="place-items-start" />
        </div>
        <div class="grid gap-2">
            <div class="grid h-32 grid-cols-2 place-items-center gap-2 rounded-md border p-2">
                for _ in 0..4 { <div class="size-8 rounded-md bg-chart-2"></div> }
            </div>
            <Caption text="place-items-center" />
        </div>
        <div class="grid gap-2">
            <div class="grid h-32 grid-cols-2 place-items-end gap-2 rounded-md border p-2">
                for _ in 0..4 { <div class="size-8 rounded-md bg-chart-2"></div> }
            </div>
            <Caption text="place-items-end" />
        </div>
    </div>
}

pub fn PlaceSelfExample() -> Element {
    <div class="grid gap-2">
        <div class="grid h-40 grid-cols-3 gap-2 text-xs">
            <div class="rounded-md bg-muted"></div>
            <div class="place-self-start rounded-md bg-primary p-2 text-primary-foreground">place-self-start</div>
            <div class="rounded-md bg-muted"></div>
            <div class="rounded-md bg-muted"></div>
            <div class="place-self-center rounded-md bg-primary p-2 text-primary-foreground">place-self-center</div>
            <div class="place-self-end rounded-md bg-primary p-2 text-primary-foreground">place-self-end</div>
        </div>
        <Caption text="place-self-start · place-self-center · place-self-end" />
    </div>
}
