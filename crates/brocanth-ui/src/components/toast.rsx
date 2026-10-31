//! Toasts (shadcn's Sonner). Zag `@zag-js/toast` (toaster.ts) stacks them,
//! times them out, pauses on hover and page idle, and adds the Alt+T
//! hotkey. Put one `Toaster` in the layout.
//!
//! The server raises a toast with `Toast` (a flash message) in any page or
//! dp-swap response, or with dpmutate's `DP-Trigger: {"ui:toast": {...}}`
//! response header. `ToastButton` raises one from a click.

/// `placement`: `top-start`, `top`, `top-end`, `bottom-start`, `bottom`,
/// `bottom-end`. A page usually has one toaster, `id="toaster"`; a toast
/// that names no toaster goes to every toaster on the page.
pub fn Toaster(id: &str, placement: &str) -> Element {
    <div id={id} data-ui="toaster" data-placement={placement}>
        <div data-part="group"></div>
        <template data-part="template">
            <div data-part="root" class="ui-toast grid w-[min(22rem,calc(100vw-2rem))] grid-cols-[1fr_auto] items-start gap-x-3 gap-y-1 rounded-lg border bg-popover p-4 text-sm text-popover-foreground shadow-overlay data-[type=error]:border-destructive/40 data-[type=success]:border-success/40 data-[type=warning]:border-warning/40">
                <div data-part="title" class="font-control text-heading"></div>
                <button type="button" data-part="close-trigger" aria-label="Dismiss" class="row-span-2 inline-flex size-6 cursor-pointer items-center justify-center rounded-sm text-muted-foreground hover:bg-accent [&_svg]:size-4">{! crate::icons::X }</button>
                <div data-part="description" class="text-muted-foreground empty:hidden"></div>
            </div>
        </template>
    </div>
}

/// A toast from the server. `kind`: `info`, `success`, `warning`, `error`.
/// `toaster` is the toaster's id, or empty for any.
pub fn Toast(toaster: &str, kind: &str, title: &str, description: &str) -> Element {
    <div data-toast data-toaster={toaster} data-type={kind} data-title={title} data-description={description} hidden></div>
}

/// A button that raises a toast when clicked.
pub fn ToastButton(toaster: &str, variant: crate::ButtonVariant, kind: &str, title: &str, description: &str, children: Element) -> Element {
    <button type="button" data-toast-trigger data-toaster={toaster} data-type={kind} data-title={title} data-description={description} class={crate::class::button(variant, crate::ButtonSize::Md)}>{children}</button>
}
