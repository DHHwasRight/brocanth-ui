//! Examples for the Interactivity utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: accent-color, appearance, caret-color, color-scheme, cursor, field-sizing, pointer-events, resize, scroll-behavior, scrollbar-color, scrollbar-width, scrollbar-gutter, scroll-margin, scroll-padding, scroll-snap-align, scroll-snap-stop, scroll-snap-type, touch-action, user-select, will-change

pub fn Examples(slug: &str) -> Element {
    match slug {
        _ => <super::reference::NoExample />,
    }
}
