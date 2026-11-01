//! Examples for the SVG utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: fill, stroke, stroke-width

pub fn Examples(slug: &str) -> Element {
    match slug {
        _ => <super::reference::NoExample />,
    }
}
