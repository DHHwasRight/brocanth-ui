//! The files this crate publishes, embedded and fingerprinted by
//! `brocanth_assets::assets!`:
//!
//! - `assets/brocanth-ui/ui.css`: the stylesheet, both themes
//! - `assets/brocanth-ui/boot.js`: the glue entry (fingerprinted)
//! - `public/brocanth-ui/chunks/*.js`: one chunk per Zag-backed kind, plus
//!   shared Zag code. The names carry a content hash already, and the entry
//!   imports them by relative URL, so they are not fingerprinted again.
//!
//! Every path starts with `brocanth-ui/`, so it cannot collide with the
//! app's own files. The app serves this crate's files next to its own:
//!
//! ```ignore
//! fn serve_asset(request: &Request) -> Option<Response> {
//!     if let Some(file) = brocanth_ui::assets::lookup(&request.path) {
//!         return Some(/* same response as for crate::assets */);
//!     }
//!     let asset = crate::assets::lookup(&request.path)?;
//!     ...
//! }
//! ```
//!
//! For a static export, pass `brocanth_ui::assets::ASSETS` to
//! `Export::assets` too.

brocanth_assets::assets!("assets", "public");

#[cfg(test)]
mod tests {
    use super::*;

    fn text(logical: &str) -> &'static str {
        let asset = ASSETS
            .iter()
            .find(|a| a.logical == logical)
            .unwrap_or_else(|| panic!("{logical} is published"));
        std::str::from_utf8(asset.body).unwrap()
    }

    #[test]
    fn the_glue_entry_is_published_with_a_fingerprint() {
        let url = url("brocanth-ui/boot.js");
        assert!(
            url.starts_with("/brocanth-ui/boot.") && url.ends_with(".js"),
            "{url}"
        );
        assert!(lookup(url).is_some());
    }

    #[test]
    fn every_chunk_the_entry_imports_is_published() {
        let boot = text("brocanth-ui/boot.js");
        let mut found = 0;
        for piece in boot.split("./chunks/").skip(1) {
            let name = &piece[..piece.find(".js").expect("chunk name ends in .js") + 3];
            let published = format!("/brocanth-ui/chunks/{name}");
            assert!(
                lookup(&published).is_some(),
                "{published} is imported but not published"
            );
            found += 1;
        }
        assert!(
            found >= 9,
            "the entry imports one chunk per kind, found {found}"
        );
    }

    #[test]
    fn the_bundle_has_no_node_globals() {
        for asset in ASSETS.iter().filter(|a| a.logical.ends_with(".js")) {
            let code = std::str::from_utf8(asset.body).unwrap();
            assert!(
                !code.contains("process.env"),
                "{} reads process.env",
                asset.logical
            );
        }
    }

    #[test]
    fn the_stylesheet_holds_both_themes() {
        let css = text("brocanth-ui/ui.css");
        assert!(css.contains("[data-ui-theme=stripe]"));
        assert!(css.contains("[data-ui-theme=shadcn]"));
        assert!(css.contains("#625afa"), "the Stripe brand colour");
        assert!(
            css.contains("light-dark("),
            "tokens follow the colour scheme"
        );
    }
}
