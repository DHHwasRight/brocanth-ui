//! Design-system components for brocanth apps.
//!
//! - Markup: rsx components in `src/components/*.rsx`, rendered on the server.
//! - Style: Tailwind classes that read theme variables (`styles/theme.css`).
//!   Two themes ship: shadcn (default) and the original theme
//!   (`data-ui-theme="original"` on any ancestor).
//! - Behaviour: static components ship no JavaScript. Stateful ones
//!   (dialog, ...) carry `data-ui="<kind>"`, and
//!   `assets/brocanth-ui/_glue/<kind>.js` drives them with a Zag.js machine.
//!   rolldown (`brocanth-bundle`) bundles the glue; see build.rs.
//!
//! ```ignore
//! use brocanth_ui::components::{button::Button, dialog::*, head::UiHead};
//! use brocanth_ui::{ButtonSize, ButtonVariant};
//! ```
//!
//! Put `<UiHead />` in the layout's
//! `<head>`, and serve [`assets::lookup`] in front of the router.

pub mod assets;
pub mod date;
pub mod icons;
mod variants;

pub use variants::{BadgeVariant, ButtonSize, ButtonVariant};

/// The rsx components. One module per file in `src/components`.
///
/// Components that take `attrs: &[(&str, &str)]` spread them on their main
/// element. Use it for `name`, `disabled`, `dp-*` attributes, and so on.
pub mod components {
    rsx::load_dir!("src/components");
}

/// The chart component (feature `charts`), and the d3set-ssr types it takes.
#[cfg(feature = "charts")]
pub mod charts {
    pub use self::chart::Chart;
    pub use d3set_ssr::{Agg, Row, Spec};
    rsx::load_dir!("src/charts");
}

/// Class lists, for markup that is not one of the components.
/// Each returns the same classes the matching component uses.
pub mod class {
    pub use crate::variants::{badge, button, card_surface, input, input_bare, select};
}
