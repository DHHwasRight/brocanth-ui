//! The Utilities tab: Tailwind's utility pages with brocanth-ui's
//! configuration, and the Configuration guide that replaces Installation.

use crate::code::Tab;
use crate::reference::{lead, Category, Page, CATEGORIES};
use super::examples::UtilityExample;
use super::shell::{CodePanel, PageTitle, Shell, LAYER_2};

/// One utility page: quick reference (compiled through our theme), a live
/// example under the original theme, and its code.
pub fn UtilityPage(base: &str, css: &str, category: &Category, page: &Page, rows: &[(String, String, bool)], code: &[Tab], previous: Option<&Page>, next: Option<&Page>) -> Element {
    <Shell title={&title(&page.title)} base={base} css={css} tab="utilities">
        <ReferenceSide current={&page.slug} oob={false} />
        <main class="g-main" id="top" dp-layout="/utilities">{! LAYER_2.0 }
            <PageTitle title={&title(&page.title)} />
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
                <div class="g-pane" dp-boost="false">
                    <div class="g-pane-body"><UtilityExample category={&category.name} slug={&page.slug} /></div>
                </div>
                if !code.is_empty() {
                    <CodePanel slug={&page.slug} tabs={code} />
                }

                <nav class="g-pager" aria-label="Pages">
                    if let Some(previous) = previous {
                        <a href={format!("/utilities/{}/", previous.slug)}><span>Previous</span>{&previous.title}</a>
                    }
                    if let Some(next) = next {
                        <a class="g-pager-next" href={format!("/utilities/{}/", next.slug)}><span>Next</span>{&next.title}</a>
                    }
                </nav>
            </article>
        {! LAYER_2.1 }</main>
    </Shell>
}

pub fn title(page: &str) -> String {
    format!("{page} · brocanth-ui utilities")
}

/// The sidebar of the Utilities tab: the guide, then every category. A
/// layer-2 partial carries it out of band (`oob`), so the current page
/// follows a partial navigation.
pub fn ReferenceSide(current: &str, oob: bool) -> Element {
    <aside class="g-side" id="utilities-side" aria-label="Utilities" { ...[("dp-swap-oob", oob.then_some("outerHTML"))] }>
        <div class="g-side-group">
            <div class="g-side-title">Getting started</div>
            <a class={side_class(current, "index")} href="/utilities/">Configuration</a>
        </div>
        for category in CATEGORIES.iter() {
            <div class="g-side-group">
                <div class="g-side-title">{&category.name}</div>
                for page in &category.pages {
                    <a class={side_class(current, &page.slug)} href={format!("/utilities/{}/", page.slug)}>{&page.title}</a>
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
