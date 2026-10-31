//! The `<head>` tags every page needs: the stylesheet, and the glue entry
//! that mounts `[data-ui]` components. Both URLs are fingerprinted.
//!
//! There is no inline script, so brocanth's default CSP
//! (`script-src 'self'`) needs no change.

pub fn UiHead() -> Element {
    <link rel="stylesheet" href={crate::assets::url("brocanth-ui/ui.css")}>
    <UiScripts />
}

/// The glue entry alone, for an app that compiles its own Tailwind with this
/// crate's tokens and sources (see examples/gallery).
pub fn UiScripts() -> Element {
    <script type="module" src={crate::assets::url("brocanth-ui/boot.js")}></script>
}
