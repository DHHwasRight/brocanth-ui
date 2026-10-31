//! Form fields. No JavaScript.

use crate::class;

/// `attrs` carries `name`, `value`, `placeholder`, `required`, ...
pub fn Input(id: &str, kind: &str, attrs: &[(&str, &str)]) -> Element {
    <input id={id} type={kind} class={class::input()} { ...attrs.iter().copied() }>
}

pub fn Label(target: &str, children: Element) -> Element {
    <label for={target} class="flex select-none items-center gap-2 text-sm font-control leading-none text-heading">
        {children}
    </label>
}

/// A label, a field and an optional hint, stacked.
pub fn Field(id: &str, label: &str, hint: &str, children: Element) -> Element {
    <div class="grid gap-2">
        <Label target={id}>{label}</Label>
        {children}
        if !hint.is_empty() {
            <p class="text-[13px] text-muted-foreground">{hint}</p>
        }
    </div>
}
