//! Examples for the Filters utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: filter, filter-blur, filter-brightness, filter-contrast, filter-drop-shadow, filter-grayscale, filter-hue-rotate, filter-invert, filter-saturate, filter-sepia, backdrop-filter, backdrop-filter-blur, backdrop-filter-brightness, backdrop-filter-contrast, backdrop-filter-grayscale, backdrop-filter-hue-rotate, backdrop-filter-invert, backdrop-filter-opacity, backdrop-filter-saturate, backdrop-filter-sepia

pub fn Examples(slug: &str) -> Element {
    match slug {
        _ => <super::reference::NoExample />,
    }
}
