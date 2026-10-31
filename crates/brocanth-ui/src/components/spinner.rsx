//! Spinner. No JavaScript.

pub fn Spinner(label: &str) -> Element {
    <span role="status" aria-label={label} class="inline-flex size-4 animate-spin text-muted-foreground [&_svg]:size-full">{! crate::icons::LOADER }</span>
}
