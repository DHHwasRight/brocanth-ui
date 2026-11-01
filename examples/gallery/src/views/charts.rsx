//! The Charts tab: the d3set chart gallery, server-rendered with d3set-ssr.
//! Every chart is SVG and HTML from the server, with no script. Its colours
//! are CSS variables that the page's theme sets (`--d3s-*`, theme.css).

use crate::charts_data::{example_rows, inline_code, plain, Entry, Example, Thumb, GROUPS};
use crate::code::Tab;
use brocanth_ui::charts::Chart;
use super::shell::{CodePanel, PageTitle, Shell, LAYER_2};

/// The drawing width of a chart on a chart page: the pane at 1440 px. The
/// SVG scales down in a narrower window.
const CHART_WIDTH: f64 = 960.0;

/// `/charts`: what the tab is, and every kind as a small chart.
pub fn ChartsOverview(base: &str, css: &str, sections: &[(&str, Vec<Thumb>)]) -> Element {
    <Shell title={&title("Charts")} base={base} css={css} tab="charts">
        <ChartsSide current="index" oob={false} />
        <main class="g-main" id="top" dp-layout="/charts">{! LAYER_2.0 }
            <PageTitle title={&title("Charts")} />
            <article class="g-page g-doc" data-ui-theme="original">
                <div class="g-eyebrow">d3set-ssr</div>
                <h1 class="g-h1">Charts rendered on the server</h1>
                <p class="g-lead">
                    Every chart on these pages is drawn in Rust with rsx: the scales, ticks and markup of the d3set library, as SVG
                    and HTML. The page is complete with no JavaScript. The marks take their colours from the theme around them,
                    light or dark.
                </p>
                for (group, thumbs) in sections {
                    <h2 class="g-doc-h2">{group}</h2>
                    <div class="g-thumbs">
                        for thumb in thumbs {
                            <a class="g-thumb" href={href(thumb.kind)}>
                                <div class="g-thumb-chart">{! &thumb.html }</div>
                                <div class="g-thumb-text">
                                    <strong>{thumb.name}</strong>
                                    <span>{! inline_code(thumb.summary) }</span>
                                </div>
                            </a>
                        }
                    </div>
                }
            </article>
        {! LAYER_2.1 }</main>
    </Shell>
}

/// `/charts/<kind>`: one kind, its examples, and the code that builds them.
pub fn ChartPage(base: &str, css: &str, group: &str, entry: &Entry, code: &[Tab], previous: Option<&Entry>, next: Option<&Entry>) -> Element {
    <Shell title={&title(entry.name)} base={base} css={css} tab="charts">
        <ChartsSide current={entry.kind} oob={false} />
        <main class="g-main" id="top" dp-layout="/charts">{! LAYER_2.0 }
            <PageTitle title={&title(entry.name)} />
            <article class="g-page g-doc" data-ui-theme="original">
                <div class="g-eyebrow">{group}</div>
                <h1 class="g-h1">{entry.name}</h1>
                <p class="g-lead">{! inline_code(entry.summary) }</p>

                <div class="g-pane">
                    <div class="g-pane-label"><span>Server-rendered SVG, no script</span><span>{feeds(&entry.examples)}</span></div>
                    <div class="g-pane-body"><ChartExamples examples={&entry.examples} /></div>
                </div>
                if !code.is_empty() {
                    <CodePanel slug={entry.kind} tabs={code} />
                }

                <nav class="g-pager" aria-label="Pages">
                    if let Some(previous) = previous {
                        <a href={href(previous.kind)}><span>Previous</span>{previous.name}</a>
                    }
                    if let Some(next) = next {
                        <a class="g-pager-next" href={href(next.kind)}><span>Next</span>{next.name}</a>
                    }
                </nav>
            </article>
        {! LAYER_2.1 }</main>
    </Shell>
}

/// The examples of a kind: brocanth-ui's Chart, one card each, on the
/// sample rows of its feed.
pub fn ChartExamples(examples: &[Example]) -> Element {
    <div class="g-chart-list">
        for example in examples {
            <Chart title={example.title} description={&plain(example.note)} spec={&example.spec} rows={example_rows(example.feed)} width={CHART_WIDTH} />
        }
    </div>
}

/// The sidebar of the Charts tab: the overview, then every group. A layer-2
/// partial carries it out of band (`oob`), so the current page follows a
/// partial navigation.
pub fn ChartsSide(current: &str, oob: bool) -> Element {
    <aside class="g-side" id="charts-side" aria-label="Charts" { ...[("dp-swap-oob", oob.then_some("outerHTML"))] }>
        <div class="g-side-group">
            <div class="g-side-title">d3set</div>
            <a class={side_class(current, "index")} href="/charts/">Overview</a>
        </div>
        for group in GROUPS.iter() {
            <div class="g-side-group">
                <div class="g-side-title">{group.name}</div>
                for kind in group.kinds.iter() {
                    <a class={side_class(current, kind)} href={href(kind)}>{name(kind)}</a>
                }
            </div>
        }
    </aside>
}

pub fn title(page: &str) -> String {
    format!("{page} · brocanth-ui charts")
}

fn href(kind: &str) -> String {
    format!("/charts/{kind}/")
}

fn name(kind: &str) -> &'static str {
    crate::charts_data::entry(kind).map_or("", |e| e.name)
}

fn side_class(current: &str, kind: &str) -> &'static str {
    if current == kind { "g-side-link is-current" } else { "g-side-link" }
}

/// The feeds the examples read: `feed: ops · sales`.
fn feeds(examples: &[Example]) -> String {
    let mut names: Vec<&str> = Vec::new();
    for example in examples {
        let name = example.feed.name();
        if !names.contains(&name) {
            names.push(name);
        }
    }
    format!("feed: {}", names.join(" · "))
}
