//! Examples for the Flexbox & Grid utilities: one `pub fn <Slug>Example() -> Element`
//! per page, rendered under the original theme. The gallery shows each
//! function's source in the Code accordion under its example.
//!
//! Pages: flex-basis, flex-direction, flex-wrap, flex, flex-grow, flex-shrink, order, grid-template-columns, grid-column, grid-template-rows, grid-row, grid-auto-flow, grid-auto-columns, grid-auto-rows, gap, justify-content, justify-items, justify-self, align-content, align-items, align-self, place-content, place-items, place-self

pub fn Examples(slug: &str) -> Element {
    match slug {
        _ => <super::reference::NoExample />,
    }
}
