//! Examples for the Typography utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: font-family, font-size, font-smoothing, font-style, font-weight, font-stretch, font-variant-numeric, font-feature-settings, letter-spacing, line-clamp, line-height, list-style-image, list-style-position, list-style-type, text-align, color, text-decoration-line, text-decoration-color, text-decoration-style, text-decoration-thickness, text-underline-offset, text-transform, text-overflow, text-wrap, text-indent, tab-size, vertical-align, white-space, word-break, overflow-wrap, hyphens, content

pub fn Examples(slug: &str) -> Element {
    match slug {
        _ => <super::reference::NoExample />,
    }
}
