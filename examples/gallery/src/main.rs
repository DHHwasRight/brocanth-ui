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
mod reference;

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

    // Components: index.html. Utilities: utilities/index.html (the guide)
    // and one page per utility. Asset URLs are relative to each page.
    let page = |root: &str, html: String| {
        html.replace("\"/brocanth-ui/", &format!("\"{root}brocanth-ui/"))
    };

    let code = code::all();
    let html = views::page::Page {
        css: &css_name,
        code: &code,
    }
    .render_to_string()?;
    fs::write(out.join("index.html"), page("", html))?;

    let utilities = out.join("utilities");
    fs::create_dir_all(&utilities)?;
    let guide = code::guide();
    let html = views::guide::GuidePage {
        css: &css_name,
        code: &guide,
    }
    .render_to_string()?;
    fs::write(utilities.join("index.html"), page("../", html))?;

    let examples = code::utilities();
    let pages: Vec<_> = reference::CATEGORIES
        .iter()
        .flat_map(|c| c.pages.iter().map(move |p| (c, p)))
        .collect();
    for (i, (category, utility)) in pages.iter().enumerate() {
        // "ours": a class the index adds (tokens), or one whose CSS reads our variables.
        let rows: Vec<(String, String, bool)> = utility
            .classes
            .iter()
            .map(|row| {
                let styles = reference::styles(row);
                let ours = row.ours || styles.contains("--ui-") || styles.contains("-control");
                (row.name.clone(), styles, ours)
            })
            .collect();
        let html = views::reference::UtilityPage {
            css: &css_name,
            category,
            page: utility,
            rows: &rows,
            code: &examples[&utility.slug],
            previous: i.checked_sub(1).map(|p| pages[p].1),
            next: pages.get(i + 1).map(|(_, p)| *p),
        }
        .render_to_string()?;
        fs::write(
            utilities.join(format!("{}.html", utility.slug)),
            page("../", html),
        )?;
    }
    println!(
        "wrote {}/index.html and {} utility pages",
        out.display(),
        pages.len()
    );
    Ok(())
}

/// FNV-1a: enough to tell two builds of the stylesheet apart.
fn fnv(bytes: &[u8]) -> u64 {
    bytes.iter().fold(0xcbf2_9ce4_8422_2325, |hash, byte| {
        (hash ^ u64::from(*byte)).wrapping_mul(0x0100_0000_01b3)
    })
}
