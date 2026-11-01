//! Renders the gallery to static files: `cargo run -p gallery -- <out-dir>`.
//!
//! The page shows every component twice, side by side: once under the
//! shadcn theme and once under the original theme. Both columns render
//! the same rsx calls; only `data-theme` on the column differs.

use std::{env, fs, path::PathBuf};

use rsx::Template;

mod catalog;
mod code;
mod highlight;

mod views {
    rsx::load_dir!("src/views");
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let out = PathBuf::from(
        env::args()
            .nth(1)
            .unwrap_or_else(|| "target/gallery".into()),
    );
    for asset in &brocanth_ui::assets::ASSETS {
        let path = out.join(asset.published.trim_start_matches('/'));
        fs::create_dir_all(path.parent().unwrap())?;
        fs::write(path, asset.body)?;
    }

    // Compiled by build.rs: the gallery's own Tailwind run, which also
    // scans brocanth-ui's sources.
    fs::write(
        out.join("gallery.css"),
        include_str!(concat!(env!("OUT_DIR"), "/gallery.css")),
    )?;

    let code = code::all();
    let html = views::page::Page { code: &code }.render_to_string()?;
    // Relative URLs, so the export works below any path, not only at `/`.
    let html = html.replace("\"/brocanth-ui/", "\"brocanth-ui/");
    fs::write(out.join("index.html"), html)?;
    println!("wrote {}/index.html", out.display());
    Ok(())
}
