//! Button. No JavaScript.
//!
//! <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[("type", "submit")]}>
//!     Save
//! </Button>

use crate::{class, ButtonSize, ButtonVariant};

/// `type` defaults to `button`, so a button in a form does not submit it by
/// accident. Pass `("type", "submit")` in `attrs` to submit.
pub fn Button(variant: ButtonVariant, size: ButtonSize, attrs: &[(&str, &str)], children: Element) -> Element {
    <button type={button_type(attrs)} class={class::button(variant, size)} { ...attrs.iter().copied().filter(|(name, _)| *name != "type") }>
        {children}
    </button>
}

/// A link that looks like a button.
pub fn ButtonLink(href: &str, variant: ButtonVariant, size: ButtonSize, children: Element) -> Element {
    <a href={href} class={class::button(variant, size)}>{children}</a>
}

fn button_type<'a>(attrs: &[(&str, &'a str)]) -> &'a str {
    attrs.iter().find(|(name, _)| *name == "type").map_or("button", |(_, value)| value)
}
