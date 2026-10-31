//! Dialog, alert dialog, sheet and drawer: native `<dialog>`, opened by
//! invoker buttons (`commandfor` + `command`). No JavaScript.
//!
//! The browser gives each of them: the top layer (no ancestor clips it, so
//! no portal), a focus trap, Escape to close, focus back on the trigger,
//! `inert` on the rest of the page, and `::backdrop`. `closedby="any"`
//! closes on a click outside; boot.js adds that for an engine without it.
//!
//! ```text
//! <DialogTrigger target="invite" variant={ButtonVariant::Primary}>Invite</DialogTrigger>
//! <Dialog id="invite" title="Invite a teammate" description="They get an email.">
//!     ...form...
//!     <DialogFooter>
//!         <DialogClose target="invite" variant={ButtonVariant::Outline}>Cancel</DialogClose>
//!     </DialogFooter>
//! </Dialog>
//! ```
//!
//! A form inside with `method="dialog"` closes the dialog on submit; a form
//! with `dp-post` sends it and the response can swap the dialog's body.

use crate::{class, ButtonSize, ButtonVariant};

const PANEL: &str = "fixed gap-4 border bg-popover p-6 text-popover-foreground shadow-overlay open:grid";

pub fn Dialog(id: &str, title: &str, description: &str, children: Element) -> Element {
    <dialog id={id} closedby="any" aria-labelledby={format!("{id}-title")} class={format!("{PANEL} m-auto w-[calc(100%-2rem)] max-w-lg rounded-lg")}>
        <Header id={id} title={title} description={description} />
        {children}
        <CornerClose target={id} />
    </dialog>
}

/// An alert dialog asks for a decision: an outside click does not close it
/// (`closedby="closerequest"`: Escape still does), and it has no corner
/// close button. Put `AlertDialogCancel` first:
/// it takes the focus when the dialog opens.
pub fn AlertDialog(id: &str, title: &str, description: &str, children: Element) -> Element {
    <dialog id={id} role="alertdialog" closedby="closerequest" aria-labelledby={format!("{id}-title")} class={format!("{PANEL} m-auto w-[calc(100%-2rem)] max-w-lg rounded-lg")}>
        <Header id={id} title={title} description={description} />
        {children}
    </dialog>
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum SheetSide {
    Top,
    #[default]
    Right,
    Bottom,
    Left,
}

fn sheet_class(side: SheetSide) -> &'static str {
    match side {
        SheetSide::Right => "fixed inset-y-0 right-0 left-auto m-0 flex h-dvh max-h-none w-3/4 max-w-sm flex-col gap-4 border-l bg-popover p-6 text-popover-foreground shadow-overlay translate-x-full open:translate-x-0 starting:open:translate-x-full",
        SheetSide::Left => "fixed inset-y-0 left-0 right-auto m-0 flex h-dvh max-h-none w-3/4 max-w-sm flex-col gap-4 border-r bg-popover p-6 text-popover-foreground shadow-overlay -translate-x-full open:translate-x-0 starting:open:-translate-x-full",
        SheetSide::Top => "fixed inset-x-0 top-0 bottom-auto m-0 flex h-auto w-full max-w-none flex-col gap-4 border-b bg-popover p-6 text-popover-foreground shadow-overlay -translate-y-full open:translate-y-0 starting:open:-translate-y-full",
        SheetSide::Bottom => "fixed inset-x-0 bottom-0 top-auto m-0 flex h-auto w-full max-w-none flex-col gap-4 border-t bg-popover p-6 text-popover-foreground shadow-overlay translate-y-full open:translate-y-0 starting:open:translate-y-full",
    }
}

/// A dialog that slides in from an edge of the screen.
pub fn Sheet(id: &str, side: SheetSide, title: &str, description: &str, children: Element) -> Element {
    <dialog id={id} closedby="any" aria-labelledby={format!("{id}-title")} class={sheet_class(side)}>
        <Header id={id} title={title} description={description} />
        <div class="flex-1 overflow-y-auto">{children}</div>
        <CornerClose target={id} />
    </dialog>
}

/// A bottom sheet with a grab handle, for phones. The handle is drawn only:
/// dragging it would need JavaScript, so Escape, the backdrop and the close
/// buttons close it.
pub fn Drawer(id: &str, title: &str, description: &str, children: Element) -> Element {
    <dialog id={id} closedby="any" aria-labelledby={format!("{id}-title")} class="fixed inset-x-0 bottom-0 top-auto m-0 flex h-auto max-h-[80vh] w-full max-w-none flex-col gap-4 rounded-t-xl border-t bg-popover px-6 pt-3 pb-6 text-popover-foreground shadow-overlay translate-y-full open:translate-y-0 starting:open:translate-y-full">
        <div aria-hidden="true" class="mx-auto h-1.5 w-12 shrink-0 rounded-full bg-muted"></div>
        <div class="mx-auto grid w-full max-w-md gap-4">
            <Header id={id} title={title} description={description} />
            {children}
        </div>
    </dialog>
}

fn Header(id: &str, title: &str, description: &str) -> Element {
    <div class="grid gap-2 pr-6 text-left">
        <h2 id={format!("{id}-title")} class="text-lg leading-none font-heading text-heading">{title}</h2>
        if !description.is_empty() {
            <p class="text-sm text-muted-foreground">{description}</p>
        }
    </div>
}

fn CornerClose(target: &str) -> Element {
    <button type="button" commandfor={target} command="close" aria-label="Close" class="absolute top-4 right-4 inline-flex size-6 cursor-pointer items-center justify-center rounded-sm text-muted-foreground opacity-70 transition-opacity outline-none hover:bg-accent hover:opacity-100 focus-visible:ring-[3px] focus-visible:ring-ring/50 [&_svg]:size-4">
        {! crate::icons::X }
    </button>
}

pub fn DialogFooter(children: Element) -> Element {
    <div class="flex flex-col-reverse gap-2 sm:flex-row sm:justify-end">{children}</div>
}

/// Opens the dialog, sheet or drawer with id `target`.
pub fn DialogTrigger(target: &str, variant: ButtonVariant, children: Element) -> Element {
    <button type="button" commandfor={target} command="show-modal" class={class::button(variant, ButtonSize::Md)}>{children}</button>
}

/// Closes the dialog with id `target`.
pub fn DialogClose(target: &str, variant: ButtonVariant, children: Element) -> Element {
    <button type="button" commandfor={target} command="close" class={class::button(variant, ButtonSize::Md)}>{children}</button>
}

/// The safe action of an alert dialog. `autofocus`: the browser focuses it
/// when the dialog opens.
pub fn AlertDialogCancel(target: &str, children: Element) -> Element {
    <button type="button" commandfor={target} command="close" autofocus class={class::button(ButtonVariant::Outline, ButtonSize::Md)}>{children}</button>
}
