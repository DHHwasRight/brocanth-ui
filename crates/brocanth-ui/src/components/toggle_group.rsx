//! Toggle group. No JavaScript: radios (one value) or checkboxes (several),
//! drawn as joined toggle buttons. Native radios already move with the
//! arrow keys.

use super::toggle::toggle_class;

/// `items` are `(value, label, content)`; `content` is raw HTML.
pub fn ToggleGroup(name: &str, label: &str, multiple: bool, items: &[(&str, &str, &str)], selected: &[&str]) -> Element {
    <div role="group" aria-label={label} class="inline-flex w-fit items-center rounded-md border shadow-control [&>label]:rounded-none [&>label:first-child]:rounded-l-md [&>label:last-child]:rounded-r-md [&>label+label]:border-l">
        for (value, item_label, content) in items {
            <label title={item_label} class={toggle_class()}>
                <input type={input_kind(multiple)} name={name} value={value} aria-label={item_label} checked?={selected.contains(value)} class="sr-only">
                {! content }
            </label>
        }
    </div>
}

fn input_kind(multiple: bool) -> &'static str {
    if multiple { "checkbox" } else { "radio" }
}
