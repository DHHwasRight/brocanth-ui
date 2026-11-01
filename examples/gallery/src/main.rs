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
    // scans brocanth-ui's sources. The name carries a content hash: a host
    // that caches by name (GitHub Pages: 10 minutes) would otherwise serve
    // the old stylesheet with the new page.
    let css = include_str!(concat!(env!("OUT_DIR"), "/gallery.css"));
    let css_name = format!("gallery.{:08x}.css", fnv(css.as_bytes()) as u32);
    fs::write(out.join(&css_name), css)?;

    let code = code::all();
    let html = views::page::Page { code: &code }.render_to_string()?;
    // Relative URLs, so the export works below any path, not only at `/`.
    let html = html.replace("\"/brocanth-ui/", "\"brocanth-ui/");
    let html = html.replace("href=\"gallery.css\"", &format!("href=\"{css_name}\""));
    fs::write(out.join("index.html"), html)?;
    println!("wrote {}/index.html", out.display());
    Ok(())
}

/// FNV-1a: enough to tell two builds of the stylesheet apart.
fn fnv(bytes: &[u8]) -> u64 {
    bytes.iter().fold(0xcbf2_9ce4_8422_2325, |hash, byte| {
        (hash ^ u64::from(*byte)).wrapping_mul(0x0100_0000_01b3)
    })
}
