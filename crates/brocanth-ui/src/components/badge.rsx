//! Badge. No JavaScript.

use crate::{class, BadgeVariant};

pub fn Badge(variant: BadgeVariant, children: Element) -> Element {
    <span class={class::badge(variant)}>{children}</span>
}
