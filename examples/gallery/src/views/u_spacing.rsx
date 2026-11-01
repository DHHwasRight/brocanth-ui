//! Examples for the Spacing utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: padding, margin

pub fn Examples(slug: &str) -> Element {
    match slug {
        "padding" => <PaddingExample />,
        "margin" => <MarginExample />,
        _ => <super::reference::NoExample />,
    }
}

/// A small caption under a variant: the class it shows.
fn Caption(text: &str) -> Element {
    <code class="font-mono text-xs text-muted-foreground">{text}</code>
}

pub fn PaddingExample() -> Element {
    <div class="flex flex-wrap items-start gap-6 text-sm">
        <div class="grid gap-2">
            <div class="w-fit rounded-md bg-primary p-2 text-primary-foreground">Invoice</div>
            <Caption text="p-2" />
        </div>
        <div class="grid gap-2">
            <div class="w-fit rounded-md bg-primary p-6 text-primary-foreground">Invoice</div>
            <Caption text="p-6" />
        </div>
        <div class="grid gap-2">
            <div class="w-fit rounded-md bg-primary px-8 py-1 text-primary-foreground">Invoice</div>
            <Caption text="px-8 py-1" />
        </div>
        <div class="grid gap-2">
            <div class="w-fit rounded-md bg-primary ps-10 pt-6 pe-2 pb-1 text-primary-foreground">Invoice</div>
            <Caption text="ps-10 pt-6 pe-2 pb-1" />
        </div>
    </div>
}

pub fn MarginExample() -> Element {
    <div class="flex flex-wrap items-start gap-6 text-sm">
        <div class="grid gap-2">
            <div class="rounded-md border border-dashed bg-muted"><div class="m-4 rounded-md bg-primary px-3 py-2 text-primary-foreground">Payout</div></div>
            <Caption text="m-4" />
        </div>
        <div class="grid gap-2">
            <div class="rounded-md border border-dashed bg-muted"><div class="mx-8 my-1 rounded-md bg-primary px-3 py-2 text-primary-foreground">Payout</div></div>
            <Caption text="mx-8 my-1" />
        </div>
        <div class="grid gap-2">
            <div class="w-40 rounded-md border border-dashed bg-muted py-2"><div class="mx-auto w-20 rounded-md bg-primary py-2 text-center text-primary-foreground">Payout</div></div>
            <Caption text="mx-auto" />
        </div>
        <div class="grid gap-2">
            <div class="rounded-md border border-dashed bg-muted p-4 pt-8"><div class="-mt-6 rounded-md bg-primary px-3 py-2 text-primary-foreground">Payout</div></div>
            <Caption text="-mt-6" />
        </div>
    </div>
}
