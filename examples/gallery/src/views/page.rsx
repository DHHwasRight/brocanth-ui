use std::collections::HashMap;

use crate::catalog::{count, count_without_js, Js, GROUPS};
use crate::code::Tab;
use brocanth_ui::components::head::UiScripts;
use super::demo::Demo;

pub fn Page(code: &HashMap<&str, Vec<Tab>>) -> Element {
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
            <title>brocanth-ui</title>
            <script>{! THEME_SCRIPT }</script>
            <link rel="stylesheet" href="gallery.css">
            <UiScripts />
        </head>
        <body class="g-body">
            <header class="g-top">
                <a class="g-brand" href="#top"><span class="g-brand-mark"></span><span class="g-brand-name">brocanth-ui</span></a>
                <nav class="g-top-nav" aria-label="Sections">
                    <a href="#top" class="is-current">Components</a>
                    <a href="#tokens">Themes</a>
                </nav>
                <ThemeSwitch />
            </header>
            <div class="g-shell">
                <aside class="g-side" aria-label="Components">
                    for group in GROUPS {
                        <div class="g-side-group">
                            <div class="g-side-title">{group.name}</div>
                            for entry in group.entries {
                                <a class="g-side-link" href={format!("#{}", entry.slug)}>{entry.name}<i class={dot_class(entry.js)} title={entry.js.label()}></i></a>
                            }
                        </div>
                    }
                </aside>
                <main class="g-main" id="top">
                    <ViewSwitch />
                    <div class="g-page">
                        <div class="g-eyebrow">Design system · rsx + Tailwind + Zag</div>
                        <h1 class="g-h1">One markup, two themes</h1>
                        <p class="g-lead">
                            Every shadcn/ui component, rendered on the server by rsx. Each example renders the same calls twice:
                            on the left under the shadcn tokens, on the right under the original tokens. Only
                            <code class="g-code">data-ui-theme</code> differs.
                        </p>
                        <div class="g-callout" id="tokens">
                            <strong>{count_without_js()} of {count()} components ship no JavaScript.</strong>
                            <span class="g-legend"><span class="g-badge js-none">No JS</span> HTML, CSS and platform features</span>
                            <span class="g-legend"><span class="g-badge js-glue">Glue</span> under 1 KB, no Zag</span>
                            <span class="g-legend"><span class="g-badge js-zag">Zag</span> a state machine, loaded on first use</span>
                        </div>
                        for group in GROUPS {
                            <h2 class="g-group-title">{group.name}</h2>
                            for entry in group.entries {
                                <section class="g-section" id={entry.slug} aria-labelledby={format!("{}-title", entry.slug)}>
                                    <div class="g-section-head">
                                        <h3 class="g-h2" id={format!("{}-title", entry.slug)}>{entry.name}</h3>
                                        <span class={format!("g-badge {}", entry.js.class())}>{entry.js.label()}</span>
                                    </div>
                                    <p class="g-muted">{entry.blurb}</p>
                                    <div class="g-pair">
                                        <div class="g-pane" data-ui-theme="shadcn">
                                            <div class="g-pane-label"><span>shadcn/ui</span></div>
                                            <div class="g-pane-body"><Demo slug={entry.slug} p="shadcn" /></div>
                                        </div>
                                        <div class="g-pane" data-ui-theme="original">
                                            <div class="g-pane-label"><span>Original</span></div>
                                            <div class="g-pane-body"><Demo slug={entry.slug} p="original" /></div>
                                        </div>
                                    </div>
                                    <CodePanel slug={entry.slug} tabs={&code[entry.slug]} />
                                </section>
                            }
                        }
                    </div>
                </main>
            </div>
        </body>
    </html>
}

/// The sources under an example: CSS-only tabs (radios), so the gallery
/// adds no script. The panel opens with the same motion as the accordion.
fn CodePanel(slug: &str, tabs: &[Tab]) -> Element {
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

fn langs(tabs: &[Tab]) -> &'static str {
    if tabs.iter().any(|tab| tab.label == "Glue") { "rsx · ts" } else { "rsx" }
}

fn dot_class(js: Js) -> &'static str {
    js.class()
}

/// Which styles the examples show. It floats at the top right of the page,
/// so it stays in reach at any scroll position. Radios and `:has()` in
/// gallery.css do the work; THEME_SCRIPT only remembers the choice.
fn ViewSwitch() -> Element {
    <fieldset class="g-view">
        <legend class="sr-only">Show</legend>
        <label title="The original theme only"><input type="radio" name="view" value="original">Original</label>
        <label title="shadcn/ui only"><input type="radio" name="view" value="shadcn">shadcn</label>
        <label title="Both, side by side"><input type="radio" name="view" value="both" checked>Compare</label>
    </fieldset>
}

fn ThemeSwitch() -> Element {
    <button type="button" class="g-theme-switch" id="theme-switch" aria-label="Dark mode">
        <svg class="moon" width="16" height="16" viewBox="0 0 16 16" aria-hidden="true"><path d="M13.5 9.6A5.6 5.6 0 0 1 6.4 2.5a5.6 5.6 0 1 0 7.1 7.1z" fill="currentColor"></path></svg>
        <svg class="sun" width="16" height="16" viewBox="0 0 16 16" aria-hidden="true"><circle cx="8" cy="8" r="3" fill="currentColor"></circle><path d="M8 1v2M8 13v2M1 8h2M13 8h2M3 3l1.4 1.4M11.6 11.6L13 13M3 13l1.4-1.4M11.6 4.4L13 3" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"></path></svg>
    </button>
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
  // The view switch: remember the choice, restore it once the page is parsed.
  var view = "brocanth-ui-view";
  document.addEventListener("change", function (event) {
    if (event.target.name === "view") try { localStorage.setItem(view, event.target.value); } catch (e) {}
  });
  document.addEventListener("DOMContentLoaded", function () {
    try {
      var input = document.querySelector('.g-view input[value="' + localStorage.getItem(view) + '"]');
      if (input) input.checked = true;
    } catch (e) {}
  });
})();"##;
