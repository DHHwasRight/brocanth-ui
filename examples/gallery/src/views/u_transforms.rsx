//! Examples for the Transforms utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: backface-visibility, perspective, perspective-origin, rotate, scale, skew, transform, transform-origin, transform-style, translate, zoom

pub fn Examples(slug: &str) -> Element {
    match slug {
        _ => <super::reference::NoExample />,
    }
}
