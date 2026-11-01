//! The page shell every gallery page shares: head, top bar with the two
//! tabs, and the theme switch.
//!
//! Links are root-relative; brocanth-static adds the base path on export.
//! `dp-boost` on <body> turns them into partial navigations into `#shell`,
//! layer 1 (dp-swap finds layer 2 itself, from the markers). Layer 1 of the
//! layout is everything under the top bar (`dp-layout="/"`). The Utilities
//! pages add layer 2, their content next to the sidebar. The comments
//! LAYER_1 and LAYER_2 mark the layers, so the handler can answer
//! `DP-Partial: <depth>` with that layer alone (see main.rs).

use crate::code::Tab;
use brocanth_ui::components::head::UiScripts;

pub const LAYER_1: (&str, &str) = ("<!--dp-layer-1-->", "<!--/dp-layer-1-->");
pub const LAYER_2: (&str, &str) = ("<!--dp-layer-2-->", "<!--/dp-layer-2-->");

/// `base` is the path the site is served under ("" or "/brocanth-ui"):
/// dp-swap needs it to find the partials.
pub fn Shell(title: &str, base: &str, css: &str, tab: &str, children: Element) -> Element {
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
            <title>{title}</title>
            <script>{! THEME_SCRIPT }</script>
            <link rel="stylesheet" href={format!("/{css}")}>
            // A static host cannot read DP-Partial: dp-swap fetches partials/<depth>/<path>.
            <meta name="dp-config" content={format!(r#"{{"partialDir":"partials","base":"{base}"}}"#)}>
            <script src="/dpswap.min.js" defer></script>
            <UiScripts />
        </head>
        <body class="g-body" dp-boost dp-target="#shell">
            <header class="g-top">
                <a class="g-brand" href="/"><span class="g-brand-mark"></span><span class="g-brand-name">brocanth-ui</span></a>
                <TopNav tab={tab} oob={false} />
                <ThemeSwitch />
            </header>
            <div class="g-shell" id="shell" dp-layout="/">{! LAYER_1.0 }{children}{! LAYER_1.1 }</div>
        </body>
    </html>
}

/// The two tabs. A partial carries them out of band (`oob`), so the current
/// tab follows a partial navigation.
pub fn TopNav(tab: &str, oob: bool) -> Element {
    <nav class="g-top-nav" id="top-nav" aria-label="Sections" { ...[("dp-swap-oob", oob.then_some("outerHTML"))] }>
        <a href="/" class={current(tab, "components")}>Components</a>
        <a href="/utilities/" class={current(tab, "utilities")}>Utilities</a>
    </nav>
}

/// The page title, inside the layer a partial replaces: the gallery script
/// copies it to <title> after a partial navigation.
pub fn PageTitle(title: &str) -> Element {
    <template data-page-title={title}></template>
}

fn current(tab: &str, name: &str) -> &'static str {
    if tab == name { "is-current" } else { "" }
}

fn ThemeSwitch() -> Element {
    <button type="button" class="g-theme-switch" id="theme-switch" aria-label="Dark mode">
        <svg class="moon" width="16" height="16" viewBox="0 0 16 16" aria-hidden="true"><path d="M13.5 9.6A5.6 5.6 0 0 1 6.4 2.5a5.6 5.6 0 1 0 7.1 7.1z" fill="currentColor"></path></svg>
        <svg class="sun" width="16" height="16" viewBox="0 0 16 16" aria-hidden="true"><circle cx="8" cy="8" r="3" fill="currentColor"></circle><path d="M8 1v2M8 13v2M1 8h2M13 8h2M3 3l1.4 1.4M11.6 11.6L13 13M3 13l1.4-1.4M11.6 4.4L13 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"></path></svg>
    </button>
}

/// The sources under an example: CSS-only tabs (radios), so the gallery
/// adds no script. The panel opens with the same motion as the accordion.
pub fn CodePanel(slug: &str, tabs: &[Tab]) -> Element {
    <details class="g-src ui-collapse">
        <summary>
            <span>Code</span>
            <span class="g-src-langs">{langs(tabs)}</span>
        </summary>
        <div class="g-src-body">
            for (i, tab) in tabs.iter().enumerate() {
                <input type="radio" name={format!("code-{slug}")} id={format!("code-{slug}-{i}")} checked?={i == 0} class="g-src-radio">
            }
            <div class="g-src-tabs">
                for (i, tab) in tabs.iter().enumerate() {
                    <label for={format!("code-{slug}-{i}")}>{tab.label}</label>
                }
            </div>
            <div class="g-src-panels">
                for tab in tabs {
                    <div class="g-src-panel">
                        <div class="g-src-path">{&tab.path}</div>
                        {! &tab.html }
                    </div>
                }
            </div>
        </div>
    </details>
}

/// The file types in the tabs: `rsx · ts`.
fn langs(tabs: &[Tab]) -> String {
    let mut out: Vec<&str> = Vec::new();
    for tab in tabs {
        let ext = tab.path.rsplit('.').next().unwrap_or("");
        if !out.contains(&ext) {
            out.push(ext);
        }
    }
    out.join(" · ")
}

// The d3set gallery's switch: the system until a click stores a choice in
// data-theme on <html>. Every colour is a light-dark() pair, so a switch
// repaints without a reload.
const THEME_SCRIPT: &str = r##"(function () {
  var key = "brocanth-ui-theme", root = document.documentElement;
  try { var stored = localStorage.getItem(key); if (stored) root.dataset.theme = stored; } catch (e) {}
  document.addEventListener("click", function (event) {
    if (!(event.target instanceof Element) || !event.target.closest("#theme-switch")) return;
    var dark = root.dataset.theme ? root.dataset.theme === "dark" : matchMedia("(prefers-color-scheme: dark)").matches;
    root.dataset.theme = dark ? "light" : "dark";
    try { localStorage.setItem(key, root.dataset.theme); } catch (e) {}
  });
  // The view switch: the stored choice goes on <html data-view> now, before
  // the first paint; Original when nothing is stored. A change updates it.
  var view = "brocanth-ui-view";
  try { root.dataset.view = localStorage.getItem(view) || "original"; } catch (e) { root.dataset.view = "original"; }
  document.addEventListener("change", function (event) {
    if (event.target.name !== "view") return;
    root.dataset.view = event.target.value;
    try { localStorage.setItem(view, event.target.value); } catch (e) {}
  });
  // After a partial navigation: the new page's title, and the top of the
  // page unless the link went to an anchor.
  document.addEventListener("dp:afterSwap", function (event) {
    var marker = event.target.querySelector && event.target.querySelector("template[data-page-title]");
    if (marker) document.title = marker.getAttribute("data-page-title");
    if (!location.hash) window.scrollTo(0, 0);
    var input = document.querySelector('.g-view input[value="' + root.dataset.view + '"]');
    if (input) input.checked = true;
  });
  // The radios follow, for the keyboard and for screen readers.
  document.addEventListener("DOMContentLoaded", function () {
    var input = document.querySelector('.g-view input[value="' + root.dataset.view + '"]');
    if (input) input.checked = true;
  });
})();"##;
