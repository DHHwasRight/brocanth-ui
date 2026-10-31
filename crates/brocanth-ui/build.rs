//! Rebuilds the committed assets, behind the `rebuild-assets` feature.
//!
//! The outputs are committed, as in brocanth-admin: an app that depends on
//! this crate needs neither Node nor the Tailwind CLI, and does not compile
//! rolldown.
//!
//! With the feature on (`mise run build` turns it on):
//! 1. The Tailwind CLI compiles `styles/ui.css` to
//!    `assets/brocanth-ui/ui.css`. It scans `src/` and the glue, so the
//!    output holds only the classes the components use.
//! 2. `brocanth_bundle::build()` (rolldown) bundles
//!    `assets/brocanth-ui/_boot.js` with Zag from `node_modules` into
//!    `assets/brocanth-ui/boot.js`, and each kind's glue into a chunk in
//!    `public/brocanth-ui/chunks/`.
//!
//! `src/assets.rs` then embeds both directories with `brocanth_assets::assets!`.

fn main() {
    println!("cargo:rerun-if-changed=build.rs");
    #[cfg(feature = "rebuild-assets")]
    rebuild::run();
}

#[cfg(feature = "rebuild-assets")]
mod rebuild {
    use std::path::Path;
    use std::process::Command;

    pub fn run() {
        println!("cargo:rerun-if-changed=styles");
        println!("cargo:rerun-if-changed=src");
        println!("cargo:rerun-if-changed=assets/brocanth-ui/_glue");
        println!("cargo:rerun-if-changed=package-lock.json");
        println!("cargo:rerun-if-env-changed=TAILWINDCSS");

        tailwind();

        if !Path::new("node_modules/@zag-js").is_dir() {
            panic!(
                "brocanth-ui: node_modules is missing.\nhelp: run `npm ci` in crates/brocanth-ui"
            );
        }
        let report = brocanth_bundle::build().unwrap_or_else(|error| panic!("{error}"));
        for file in report.written {
            println!("cargo:warning=brocanth-ui: wrote {}", file.display());
        }
    }

    fn tailwind() {
        let cli = std::env::var("TAILWINDCSS").unwrap_or_else(|_| "tailwindcss".into());
        let output = Command::new(&cli)
            .args(["--input", "styles/ui.css", "--output", "assets/brocanth-ui/ui.css", "--minify"])
            .output()
            .unwrap_or_else(|error| {
                panic!("brocanth-ui: cannot run `{cli}`: {error}\nhelp: build through mise, or set TAILWINDCSS to the Tailwind v4 CLI")
            });
        if !output.status.success() {
            panic!(
                "brocanth-ui: `{cli}` failed:\n{}",
                String::from_utf8_lossy(&output.stderr)
            );
        }
    }
}
