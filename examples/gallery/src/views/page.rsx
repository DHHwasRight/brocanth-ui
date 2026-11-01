use std::collections::HashMap;

use crate::catalog::{count, count_without_js, Js, GROUPS};
use crate::code::Tab;
use super::demo::Demo;
use super::shell::{CodePanel, Shell};

pub fn Page(css: &str, code: &HashMap<&str, Vec<Tab>>) -> Element {
    <Shell title="brocanth-ui · Components" root="" css={css} tab="components">
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
    </Shell>
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


