//! Form structure: field sets, descriptions and errors. No JavaScript.
//! The server validates; a field with an error renders `FieldError` and
//! passes `("aria-invalid", "true")` to its control.

pub fn FieldSet(legend: &str, description: &str, children: Element) -> Element {
    <fieldset class="flex flex-col gap-6">
        <legend class="mb-1 text-base font-heading text-heading">{legend}</legend>
        // A legend is not a flex item, so the description sits right under it.
        if !description.is_empty() {
            <p class="text-sm text-muted-foreground">{description}</p>
        }
        {children}
    </fieldset>
}

pub fn FieldDescription(children: Element) -> Element {
    <p class="text-[13px] leading-normal text-muted-foreground">{children}</p>
}

/// `id` lets the control point at it with `aria-describedby`.
pub fn FieldError(id: &str, message: &str) -> Element {
    <p id={id} role="alert" class="text-[13px] font-control text-destructive">{message}</p>
}

pub fn FieldSeparator() -> Element {
    <div class="relative -my-2 h-5 text-sm"><div class="absolute inset-x-0 top-1/2 h-px bg-border"></div></div>
}
