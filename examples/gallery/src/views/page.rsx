use crate::catalog::{count, count_without_js, Js, GROUPS};
use brocanth_ui::components::head::UiScripts;
use super::demo::Demo;

pub fn Page() -> Element {
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
                <a class="g-brand" href="#top"><span class="g-brand-mark"></span>brocanth-ui</a>
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
                    <div class="g-page">
                        <div class="g-eyebrow">Design system · rsx + Tailwind + Zag</div>
                        <h1 class="g-h1">One markup, two themes</h1>
                        <p class="g-lead">
                            Every shadcn/ui component, rendered on the server by rsx. Each example renders the same calls twice:
                            on the left under the shadcn tokens, on the right under the docs.stripe.com tokens. Only
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
                                        <div class="g-pane" data-ui-theme="stripe">
                                            <div class="g-pane-label"><span>docs.stripe.com</span></div>
                                            <div class="g-pane-body"><Demo slug={entry.slug} p="stripe" /></div>
                                        </div>
                                    </div>
                                </section>
                            }
                        }
                    </div>
                </main>
            </div>
        </body>
    </html>
}

fn dot_class(js: Js) -> &'static str {
    js.class()
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
})();"##;
