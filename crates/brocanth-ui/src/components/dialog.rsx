//! Dialog. Behaviour comes from `assets/glue/dialog.js` (Zag `@zag-js/dialog`).
//!
//! ```text
//! <Dialog id="invite" role="dialog">
//!     <DialogTrigger variant={ButtonVariant::Primary}>Invite</DialogTrigger>
//!     <DialogContent title="Invite a teammate" description="They get an email.">
//!         ...form...
//!         <DialogFooter>
//!             <DialogClose variant={ButtonVariant::Outline}>Cancel</DialogClose>
//!         </DialogFooter>
//!     </DialogContent>
//! </Dialog>
//! ```
//!
//! The server renders the closed state: the backdrop and the content carry
//! `hidden`, and the positioner lets clicks through. So the page is correct
//! before the glue loads, and the trigger works once it does.
//!
//! Every node Zag drives has `data-part`. The glue matches parts to the
//! nearest `data-ui` root, so dialogs can nest.

use crate::{class, ButtonSize, ButtonVariant};

/// `id` must be unique on the page: Zag derives its element ids from it.
/// `role` is `"dialog"` or `"alertdialog"`. An alert dialog does not close
/// on an outside click.
pub fn Dialog(id: &str, role: &str, children: Element) -> Element {
    <div id={id} data-ui="dialog" data-scope="dialog" data-role={role} data-close-on-outside={role != "alertdialog"} class="contents">
        {children}
    </div>
}

pub fn DialogTrigger(variant: ButtonVariant, children: Element) -> Element {
    <button type="button" data-scope="dialog" data-part="trigger" aria-haspopup="dialog" aria-expanded="false" data-state="closed" class={class::button(variant, ButtonSize::Md)}>
        {children}
    </button>
}

/// The overlay: backdrop, positioner, content, title, description and the
/// corner close button. `description` may be empty.
pub fn DialogContent(title: &str, description: &str, children: Element) -> Element {
    <div data-scope="dialog" data-part="backdrop" data-state="closed" hidden class="fixed inset-0 z-50 bg-overlay data-[state=open]:animate-overlay-in"></div>
    <div data-scope="dialog" data-part="positioner" style="pointer-events: none" class="fixed inset-0 z-50 flex items-center justify-center p-4">
        <div data-scope="dialog" data-part="content" data-state="closed" role="dialog" tabindex="-1" hidden class="relative grid w-full max-w-lg gap-4 rounded-lg border bg-popover p-6 text-popover-foreground shadow-overlay outline-none data-[state=open]:animate-content-in">
            <div class="grid gap-2 pr-6">
                <h2 data-scope="dialog" data-part="title" class="text-lg font-heading leading-none text-heading">{title}</h2>
                if !description.is_empty() {
                    <p data-scope="dialog" data-part="description" class="text-sm text-muted-foreground">{description}</p>
                }
            </div>
            {children}
            <button type="button" data-scope="dialog" data-part="close-trigger" aria-label="Close" class="absolute right-4 top-4 inline-flex size-6 cursor-pointer items-center justify-center rounded-sm text-muted-foreground opacity-70 transition-opacity hover:bg-accent hover:opacity-100 focus-visible:outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="size-4" aria-hidden="true">
                    <path d="M18 6 6 18"></path>
                    <path d="m6 6 12 12"></path>
                </svg>
            </button>
        </div>
    </div>
}

pub fn DialogFooter(children: Element) -> Element {
    <div class="flex flex-col-reverse gap-2 sm:flex-row sm:justify-end">{children}</div>
}

/// A button that closes the dialog. Zag's close-trigger part, styled as a
/// button. An alert dialog focuses it on open, so make it the safe action.
pub fn DialogClose(variant: ButtonVariant, children: Element) -> Element {
    <button type="button" data-scope="dialog" data-part="close-trigger" data-close-primary class={class::button(variant, ButtonSize::Md)}>
        {children}
    </button>
}
