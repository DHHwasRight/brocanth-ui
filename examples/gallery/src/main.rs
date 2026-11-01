//! Exports the gallery to static files: `cargo run -p gallery -- <out-dir>`.
//!
//! The gallery is a small application: [`Site::handle`] answers a request
//! for a page, and brocanth-static runs every path through it. It writes
//! each page twice: as a document, and as one partial per layout depth
//! (`partials/<depth>/<path>`), which dp-swap fetches when JavaScript runs.
//! Without JavaScript the links load the documents.
//!
//! `GALLERY_BASE` is the path the site is served under: `/brocanth-ui` on
//! GitHub Pages, empty (the default) at the root.

use std::collections::HashMap;
use std::{env, path::PathBuf};

use brocanth_server::{Request, Response};
use rsx::Template;

mod catalog;
mod charts_data;
mod code;
mod highlight;
mod reference;

mod views {
    rsx::load_dir!("src/views");
}

use views::shell::{LAYER_1, LAYER_2};

/// What every page needs, prepared once.
struct Site {
    base: String,
    css: String,
    components: HashMap<&'static str, Vec<code::Tab>>,
    guide: HashMap<&'static str, Vec<code::Tab>>,
    examples: HashMap<String, Vec<code::Tab>>,
    charts: HashMap<&'static str, Vec<code::Tab>>,
}

impl Site {
    /// A page, whole or as the partial for `DP-Partial: <depth>`.
    fn handle(&self, request: &Request) -> Response {
        let depth = request
            .header("DP-Partial")
            .and_then(|d| d.parse::<u32>().ok());
        let path = request.path.trim_end_matches('/');
        let page = match path {
            "" => self.components(),
            "/utilities" => self.guide(),
            "/charts" => self.charts_overview(),
            _ => {
                if let Some(slug) = path.strip_prefix("/utilities/") {
                    self.utility(slug)
                } else if let Some(kind) = path.strip_prefix("/charts/") {
                    self.chart(kind)
                } else {
                    None
                }
            }
        };
        let Some((html, tab, current)) = page else {
            return Response::html(404, NOT_FOUND);
        };
        match depth {
            None => Response::html(200, html),
            Some(depth) => Response::html(200, partial(&html, depth, tab, &current)),
        }
    }

    fn components(&self) -> Option<(String, &'static str, String)> {
        let page = views::page::Page {
            base: &self.base,
            css: &self.css,
            code: &self.components,
        };
        Some((page.render_to_string().ok()?, "components", String::new()))
    }

    fn guide(&self) -> Option<(String, &'static str, String)> {
        let page = views::guide::GuidePage {
            base: &self.base,
            css: &self.css,
            code: &self.guide,
        };
        Some((
            page.render_to_string().ok()?,
            "utilities",
            "index".to_string(),
        ))
    }

    fn utility(&self, slug: &str) -> Option<(String, &'static str, String)> {
        let pages: Vec<_> = reference::CATEGORIES
            .iter()
            .flat_map(|c| c.pages.iter().map(move |p| (c, p)))
            .collect();
        let i = pages.iter().position(|(_, page)| page.slug == slug)?;
        let (category, utility) = pages[i];
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
        let page = views::reference::UtilityPage {
            base: &self.base,
            css: &self.css,
            category,
            page: utility,
            rows: &rows,
            code: &self.examples[&utility.slug],
            previous: i.checked_sub(1).map(|p| pages[p].1),
            next: pages.get(i + 1).map(|(_, p)| *p),
        };
        Some((page.render_to_string().ok()?, "utilities", slug.to_string()))
    }

    fn charts_overview(&self) -> Option<(String, &'static str, String)> {
        let sections = charts_data::overview();
        let page = views::charts::ChartsOverview {
            base: &self.base,
            css: &self.css,
            sections: &sections,
        };
        Some((page.render_to_string().ok()?, "charts", "index".to_string()))
    }

    fn chart(&self, kind: &str) -> Option<(String, &'static str, String)> {
        let entry = charts_data::entry(kind)?;
        let group = charts_data::group_of(kind)?;
        let all: Vec<&str> = charts_data::kinds().collect();
        let i = all.iter().position(|k| *k == kind)?;
        let previous = i.checked_sub(1).and_then(|p| charts_data::entry(all[p]));
        let next = all.get(i + 1).and_then(|k| charts_data::entry(k));
        let page = views::charts::ChartPage {
            base: &self.base,
            css: &self.css,
            group: group.name,
            entry: &entry,
            code: self.charts.get(kind).map_or(&[], Vec::as_slice),
            previous: previous.as_ref(),
            next: next.as_ref(),
        };
        Some((page.render_to_string().ok()?, "charts", kind.to_string()))
    }
}

/// The partial for a depth: the content of that layout layer, and what
/// sits outside it but changes with the page, out of band: the current tab,
/// and at depth 2 the sidebar of the page's section (Utilities or Charts),
/// with its current page.
///
/// A page without the requested layer answers with its deepest one: the
/// client picks the depth from the page it leaves, so every depth must
/// answer for every page.
fn partial(html: &str, depth: u32, tab: &str, current: &str) -> String {
    let layer = |(open, close): (&str, &str)| {
        let start = html.find(open)? + open.len();
        let end = html[start..].find(close)? + start;
        Some(&html[start..end])
    };
    let (content, depth) = match depth {
        2.. => layer(LAYER_2)
            .map(|c| (c, 2))
            .or_else(|| layer(LAYER_1).map(|c| (c, 1))),
        _ => layer(LAYER_1).map(|c| (c, 1)),
    }
    .unwrap_or((html, 1));
    let mut out = content.to_string();
    if let Ok(nav) = (views::shell::TopNav { tab, oob: true }).render_to_string() {
        out.push_str(&nav);
    }
    if depth == 2 {
        // The sidebar of the page's section: the tab names the section.
        let side = match tab {
            "utilities" => {
                (views::reference::ReferenceSide { current, oob: true }).render_to_string()
            }
            "charts" => (views::charts::ChartsSide { current, oob: true }).render_to_string(),
            _ => Ok(String::new()),
        };
        if let Ok(side) = side {
            out.push_str(&side);
        }
    }
    out
}

const NOT_FOUND: &str = r#"<!DOCTYPE html><html lang="en"><meta charset="utf-8"><title>Not found · brocanth-ui</title><p style="font:16px system-ui;margin:4rem auto;max-width:32rem">This page does not exist. <a href="/">Back to the gallery</a>.</p></html>"#;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let out = PathBuf::from(
        env::args()
            .nth(1)
            .unwrap_or_else(|| "target/gallery".into()),
    );
    let base = env::var("GALLERY_BASE").unwrap_or_default();

    // Compiled by build.rs: the gallery's own Tailwind run, which also
    // scans brocanth-ui's sources. The name carries a content hash: a host
    // that caches by name (GitHub Pages: 10 minutes) would otherwise serve
    // the old stylesheet with the new page.
    let css: &'static str = include_str!(concat!(env!("OUT_DIR"), "/gallery.css"));
    let css_name = format!("gallery.{:08x}.css", fnv(css.as_bytes()) as u32);
    let css_path: &'static str = Box::leak(format!("/{css_name}").into_boxed_str());

    let site = Site {
        base: base.clone(),
        css: css_name,
        components: code::all(),
        guide: code::guide(),
        examples: code::utilities(),
        charts: code::charts(),
    };

    let mut paths = vec!["/".to_string(), "/utilities".to_string()];
    paths.extend(
        reference::CATEGORIES
            .iter()
            .flat_map(|c| c.pages.iter().map(|p| format!("/utilities/{}", p.slug))),
    );
    paths.push("/charts".to_string());
    paths.extend(charts_data::kinds().map(|kind| format!("/charts/{kind}")));

    let mut assets: Vec<(&'static str, &'static [u8])> = brocanth_ui::assets::ASSETS
        .iter()
        .map(|asset| (asset.published, asset.body))
        .collect();
    assets.push((css_path, css.as_bytes()));
    assets.push(("/dpswap.min.js", include_bytes!("../public/dpswap.min.js")));

    let export = brocanth_static::Export::new(&out)
        .base(&base)
        .partials(2)
        .paths(paths)
        .assets(assets);
    let runtime = tokio::runtime::Builder::new_current_thread().build()?;
    let report =
        runtime.block_on(export.run(|request| std::future::ready(site.handle(&request))))?;
    println!("export: {report} in {}", out.display());
    Ok(())
}

/// FNV-1a: enough to tell two builds of the stylesheet apart.
fn fnv(bytes: &[u8]) -> u64 {
    bytes.iter().fold(0xcbf2_9ce4_8422_2325, |hash, byte| {
        (hash ^ u64::from(*byte)).wrapping_mul(0x0100_0000_01b3)
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    fn site() -> Site {
        Site {
            base: String::new(),
            css: "gallery.css".into(),
            components: code::all(),
            guide: code::guide(),
            examples: code::utilities(),
            charts: code::charts(),
        }
    }

    fn body(response: Response) -> String {
        match response.body {
            brocanth_server::Body::Bytes(bytes) => String::from_utf8(bytes.to_vec()).unwrap(),
            _ => panic!("a page is a finished body"),
        }
    }

    #[test]
    fn a_layer_two_partial_is_the_content_with_the_tab_and_sidebar_out_of_band() {
        let request = Request::new(brocanth::routing::Verb::Get, "/utilities/z-index")
            .with_header("DP-Partial", "2");
        let html = body(site().handle(&request));
        assert!(!html.contains("<html"), "a partial is not a document");
        assert!(
            !html.contains(r#"<header class="g-top""#),
            "the top bar stays on the page"
        );
        assert!(
            html.contains("ZIndexExample") || html.contains("z-30"),
            "the content is there"
        );
        assert!(html.contains(r#"id="top-nav" aria-label="Sections" dp-swap-oob="outerHTML""#));
        assert!(html.contains(r#"id="utilities-side""#) && html.contains("dp-swap-oob"));
    }

    #[test]
    fn a_page_without_layer_two_answers_depth_two_with_layer_one() {
        let request =
            Request::new(brocanth::routing::Verb::Get, "/").with_header("DP-Partial", "2");
        let html = body(site().handle(&request));
        assert!(html.contains("One markup, two themes"));
        assert!(!html.contains("<html"));
    }

    #[test]
    fn a_chart_partial_carries_the_charts_sidebar_out_of_band() {
        let request = Request::new(brocanth::routing::Verb::Get, "/charts/heatmap")
            .with_header("DP-Partial", "2");
        let html = body(site().handle(&request));
        assert!(!html.contains("<html"), "a partial is not a document");
        assert!(html.contains("var(--d3s-series-0)") || html.contains("var(--d3s-seq-"));
        assert!(html.contains(r#"id="charts-side" aria-label="Charts" dp-swap-oob="outerHTML""#));
        assert!(html.contains(r#"<a class="g-side-link is-current" href="/charts/heatmap/">"#));
        assert!(!html.contains(r#"id="utilities-side""#));
    }

    #[test]
    fn an_unknown_path_is_a_404() {
        let site = site();
        for path in ["/nope", "/charts/sparkle", "/utilities/nope"] {
            let request = Request::new(brocanth::routing::Verb::Get, path);
            assert_eq!(site.handle(&request).status, 404, "{path}");
        }
    }
}
