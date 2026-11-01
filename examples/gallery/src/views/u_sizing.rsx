//! Examples for the Sizing utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: width, min-width, max-width, height, min-height, max-height, inline-size, min-inline-size, max-inline-size, block-size, min-block-size, max-block-size

pub fn Examples(slug: &str) -> Element {
    match slug {
        _ => <super::reference::NoExample />,
    }
}
