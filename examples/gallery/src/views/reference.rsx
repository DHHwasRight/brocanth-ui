//! The Utilities tab: Tailwind's utility pages with brocanth-ui's
//! configuration, and the Configuration guide that replaces Installation.

use crate::code::Tab;
use crate::reference::{lead, Category, Page, CATEGORIES};
use super::examples::UtilityExample;
use super::shell::{CodePanel, Shell};

/// One utility page: quick reference (compiled through our theme), a live
/// example under the original theme, and its code.
pub fn UtilityPage(css: &str, category: &Category, page: &Page, rows: &[(String, String, bool)], code: &[Tab], previous: Option<&Page>, next: Option<&Page>) -> Element {
    <Shell title={&format!("{} · brocanth-ui utilities", page.title)} root="../" css={css} tab="utilities">
        <ReferenceSide current={&page.slug} />
        <main class="g-main" id="top">
            <article class="g-page g-doc" data-ui-theme="original">
                <div class="g-eyebrow">{&category.name}</div>
                <h1 class="g-h1">{&page.title}</h1>
                <p class="g-lead">{lead(page)}</p>

                <h2 class="g-doc-h2">Quick reference</h2>
                <div class="g-ref">
                    <table>
                        <thead><tr><th scope="col">Class</th><th scope="col">Styles</th></tr></thead>
                        <tbody>
                            for (name, styles, ours) in rows {
                                <tr>
                                    <td>
                                        <code class="g-ref-class">{name}</code>
                                        if *ours {
                                            <span class="g-ref-ours" title="Added or changed by brocanth-ui's configuration">ours</span>
                                        }
                                    </td>
                                    <td><pre class="g-ref-css">{styles}</pre></td>
                                </tr>
                            }
                        </tbody>
                    </table>
                </div>

                <h2 class="g-doc-h2">Example</h2>
                <div class="g-pane">
                    <div class="g-pane-body"><UtilityExample category={&category.name} slug={&page.slug} /></div>
                </div>
                if !code.is_empty() {
                    <CodePanel slug={&page.slug} tabs={code} />
                }

                <nav class="g-pager" aria-label="Pages">
                    if let Some(previous) = previous {
                        <a href={format!("{}.html", previous.slug)}><span>Previous</span>{&previous.title}</a>
                    }
                    if let Some(next) = next {
                        <a class="g-pager-next" href={format!("{}.html", next.slug)}><span>Next</span>{&next.title}</a>
                    }
                </nav>
            </article>
        </main>
    </Shell>
}

/// The sidebar of the Utilities tab: the guide, then every category.
pub fn ReferenceSide(current: &str) -> Element {
    <aside class="g-side" aria-label="Utilities">
        <div class="g-side-group">
            <div class="g-side-title">Getting started</div>
            <a class={side_class(current, "index")} href="index.html">Configuration</a>
        </div>
        for category in CATEGORIES.iter() {
            <div class="g-side-group">
                <div class="g-side-title">{&category.name}</div>
                for page in &category.pages {
                    <a class={side_class(current, &page.slug)} href={format!("{}.html", page.slug)}>{&page.title}</a>
                }
            </div>
        }
    </aside>
}

fn side_class(current: &str, slug: &str) -> &'static str {
    if current == slug { "g-side-link is-current" } else { "g-side-link" }
}

/// Shown until a page has its own example.
pub fn NoExample() -> Element {
    <p class="text-sm text-muted-foreground">No example yet.</p>
}
