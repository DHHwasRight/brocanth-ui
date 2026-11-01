//! The Charts tab: the d3set gallery's catalog and sample data, ported
//! from d3set/rust/gallery (src/catalog.rs, src/data.rs).
//!
//! Two feeds, as in d3set: `ops` (request logs from 24 hosts) and `sales`
//! (orders). The generator is seeded and the clock is fixed, so every export
//! draws the same rows. There is no live feed: the charts are server-rendered
//! SVG and HTML, with no script.

use std::sync::{Arc, LazyLock};

use d3set_ssr::time::iso;
use d3set_ssr::{render, Agg, Column, Level, Row, Spec, Threshold, LIGHT};

/// The chart kinds, in d3set's navigation order and groups.
pub struct Group {
    pub name: &'static str,
    pub kinds: &'static [&'static str],
}

pub const GROUPS: &[Group] = &[
    Group {
        name: "Time series",
        kinds: &["timeseries", "line", "area"],
    },
    Group {
        name: "Categories",
        kinds: &["bar", "toplist", "change", "table"],
    },
    Group {
        name: "Composition",
        kinds: &["pie", "donut", "treemap", "sunburst", "funnel"],
    },
    Group {
        name: "Distribution",
        kinds: &["histogram", "boxplot", "heatmap", "timeheatmap", "scatter"],
    },
    Group {
        name: "Single value",
        kinds: &["kpi", "gauge", "slo"],
    },
    Group {
        name: "Monitoring",
        kinds: &["hostmap", "status", "stream", "note"],
    },
];

/// Every kind, in navigation order.
pub fn kinds() -> impl Iterator<Item = &'static str> {
    GROUPS.iter().flat_map(|g| g.kinds.iter().copied())
}

/// The group a kind sits in.
pub fn group_of(kind: &str) -> Option<&'static Group> {
    GROUPS.iter().find(|g| g.kinds.contains(&kind))
}

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum Feed {
    Ops,
    Sales,
}

impl Feed {
    pub fn name(self) -> &'static str {
        match self {
            Feed::Ops => "ops",
            Feed::Sales => "sales",
        }
    }
}

pub struct Example {
    pub title: &'static str,
    pub note: &'static str,
    pub feed: Feed,
    pub spec: Spec,
}

pub struct Entry {
    pub kind: &'static str,
    pub name: &'static str,
    pub summary: &'static str,
    pub examples: Vec<Example>,
}

fn ex(title: &'static str, note: &'static str, feed: Feed, spec: Spec) -> Example {
    Example {
        title,
        note,
        feed,
        spec,
    }
}

/// A kind's name, summary and examples. `None` for an unknown kind.
pub fn entry(kind: &str) -> Option<Entry> {
    let (kind, name, summary, examples) = match kind {
        "timeseries" => ("timeseries", "Time series", "Values over time, bucketed automatically, as lines, areas, or stacked bars. Threshold rules draw marker lines.", timeseries()),
        "line" => ("line", "Line", "One line per series over a time or number axis, with monotone curves.", line()),
        "area" => ("area", "Area", "Filled areas, stacked by default; `stacked: false` overlaps them.", area()),
        "bar" => ("bar", "Bar", "Values per category: grouped or stacked, vertical or horizontal, with `limit` for the largest.", bar()),
        "toplist" => ("toplist", "Top list", "A ranked list with bars, colored by threshold rules.", toplist()),
        "change" => ("change", "Change", "The last window against the window before it, per series.", change()),
        "table" => ("table", "Table", "Sortable rows, raw or grouped, with formats and conditional colors.", table()),
        "pie" => ("pie", "Pie", "Share of a total by category.", pie()),
        "donut" => ("donut", "Donut", "A pie with a hole: the same data, easier to read with many slices.", donut()),
        "treemap" => ("treemap", "Treemap", "Nested rectangles sized by value, grouped by series.", treemap()),
        "sunburst" => ("sunburst", "Sunburst", "Two-level share of a total: inner ring per series, outer ring per category.", sunburst()),
        "funnel" => ("funnel", "Funnel", "Conversion between the stages of a process.", funnel()),
        "histogram" => ("histogram", "Histogram", "The distribution of one number in bins.", histogram()),
        "boxplot" => ("boxplot", "Box plot", "Quartiles, whiskers at 1.5 × IQR, and outliers per category.", boxplot()),
        "heatmap" => ("heatmap", "Heatmap", "Two categories crossed, colored by value.", heatmap()),
        "timeheatmap" => ("timeheatmap", "Time heatmap", "How values spread over time: time buckets × value bins, colored by count.", timeheatmap()),
        "scatter" => ("scatter", "Scatter", "One dot per row; a size field makes a bubble chart.", scatter()),
        "kpi" => ("kpi", "KPI", "A big number, with a trend line and the change against the previous bucket.", kpi()),
        "gauge" => ("gauge", "Gauge", "One value on an arc between a minimum and a maximum.", gauge()),
        "slo" => ("slo", "Service level objective", "The share of good events against a target, and the error budget left.", slo()),
        "hostmap" => ("hostmap", "Host map", "One hexagon per entity, grouped, colored by value or status.", hostmap()),
        "status" => ("status", "Check status", "The latest state per entity, worst first.", status()),
        "stream" => ("stream", "Event stream", "Log lines, newest first, colored by level.", stream()),
        "note" => ("note", "Note", "Static text that explains a dashboard. It reads no data.", note()),
        _ => return None,
    };
    Some(Entry {
        kind,
        name,
        summary,
        examples,
    })
}

// ---- The examples of each kind. The Code panel of a chart page shows the
// ---- function of its kind.

fn latency() -> Vec<Threshold> {
    vec![
        Threshold::new(">", 500.0, Level::Critical),
        Threshold::new(">", 250.0, Level::Warning),
    ]
}

pub fn timeseries() -> Vec<Example> {
    vec![
        ex(
            "Requests by service",
            "`display: bars`, count per auto bucket.",
            Feed::Ops,
            Spec::new("timeseries")
                .x("at")
                .y("id")
                .series("service")
                .aggregate(Agg::Count)
                .display("bars"),
        ),
        ex(
            "Average latency",
            "Line per service with warning and critical markers.",
            Feed::Ops,
            Spec::new("timeseries")
                .x("at")
                .y("latency")
                .series("service")
                .aggregate(Agg::Avg)
                .thresholds(latency()),
        ),
        ex(
            "Requests by region",
            "`display: area`, stacked.",
            Feed::Ops,
            Spec::new("timeseries")
                .x("at")
                .y("id")
                .series("region")
                .aggregate(Agg::Count)
                .display("area"),
        ),
    ]
}

pub fn line() -> Vec<Example> {
    vec![ex(
        "Revenue per minute",
        "Sum per 1-minute bucket, one line per region.",
        Feed::Sales,
        Spec::new("line")
            .x("at")
            .y("amount")
            .series("region")
            .aggregate(Agg::Sum)
            .interval("1m")
            .format("$~s"),
    )]
}

pub fn area() -> Vec<Example> {
    vec![
        ex(
            "Revenue by product",
            "Stacked per 1-minute bucket.",
            Feed::Sales,
            Spec::new("area")
                .x("at")
                .y("amount")
                .series("product")
                .aggregate(Agg::Sum)
                .interval("1m")
                .format("$~s"),
        ),
        ex(
            "Latency by region",
            "Overlapping (`stacked: false`), average per 30 s.",
            Feed::Ops,
            Spec::new("area")
                .x("at")
                .y("latency")
                .series("region")
                .aggregate(Agg::Avg)
                .interval("30s")
                .stacked(false),
        ),
    ]
}

pub fn bar() -> Vec<Example> {
    vec![
        ex(
            "Revenue by product",
            "Grouped by region.",
            Feed::Sales,
            Spec::new("bar")
                .x("product")
                .y("amount")
                .series("region")
                .format("$~s"),
        ),
        ex(
            "Revenue by customer",
            "Stacked and horizontal.",
            Feed::Sales,
            Spec::new("bar")
                .x("customer")
                .y("amount")
                .series("product")
                .stacked(true)
                .horizontal(true)
                .format("$~s"),
        ),
        ex(
            "Slowest hosts",
            "Average latency, top 6 and \"Other\".",
            Feed::Ops,
            Spec::new("bar")
                .x("host")
                .y("latency")
                .aggregate(Agg::Avg)
                .limit(6)
                .format(",.0f"),
        ),
    ]
}

pub fn toplist() -> Vec<Example> {
    vec![ex(
        "Slowest hosts",
        "Average latency, warning above 250 ms.",
        Feed::Ops,
        Spec::new("toplist")
            .x("host")
            .y("latency")
            .aggregate(Agg::Avg)
            .thresholds(latency())
            .format(",.0f"),
    )]
}

pub fn change() -> Vec<Example> {
    vec![ex(
        "Errors per service",
        "Last 5 minutes; a decrease is good.",
        Feed::Ops,
        Spec::new("change")
            .x("at")
            .y("errors")
            .series("service")
            .window("5m")
            .decrease_is_good(true),
    )]
}

pub fn table() -> Vec<Example> {
    vec![
        ex(
            "Top customers",
            "Group mode: one line per customer.",
            Feed::Sales,
            Spec::new("table")
                .x("customer")
                .y("amount")
                .aggregate(Agg::Sum)
                .format("$,.0f"),
        ),
        ex(
            "Latest requests",
            "Raw mode with chosen columns.",
            Feed::Ops,
            Spec::new("table").limit(50).columns(vec![
                Column::new("at").label("Time"),
                Column::new("host"),
                Column::new("service"),
                Column::new("status"),
                Column {
                    thresholds: latency(),
                    ..Column::new("latency").label("Latency (ms)")
                },
            ]),
        ),
    ]
}

pub fn pie() -> Vec<Example> {
    vec![ex(
        "Orders by product",
        "Count of orders.",
        Feed::Sales,
        Spec::new("pie")
            .x("product")
            .y("amount")
            .aggregate(Agg::Count),
    )]
}

pub fn donut() -> Vec<Example> {
    vec![ex(
        "Revenue by region",
        "Sum of order amounts.",
        Feed::Sales,
        Spec::new("donut").x("region").y("amount").format("$~s"),
    )]
}

pub fn treemap() -> Vec<Example> {
    vec![ex(
        "Revenue by region and product",
        "Grouped by region.",
        Feed::Sales,
        Spec::new("treemap")
            .x("product")
            .series("region")
            .y("amount")
            .format("$~s"),
    )]
}

pub fn sunburst() -> Vec<Example> {
    vec![ex(
        "Requests by region and service",
        "Count of requests.",
        Feed::Ops,
        Spec::new("sunburst")
            .x("service")
            .series("region")
            .y("id")
            .aggregate(Agg::Count),
    )]
}

pub fn funnel() -> Vec<Example> {
    vec![ex(
        "Conversion",
        "Count per stage, sorted by size.",
        Feed::Sales,
        Spec::new("funnel")
            .x("stage")
            .y("id")
            .aggregate(Agg::Count)
            .option("sort", true),
    )]
}

pub fn histogram() -> Vec<Example> {
    vec![
        ex(
            "Order size",
            "15 bins.",
            Feed::Sales,
            Spec::new("histogram").y("amount").bins(15).format("$~s"),
        ),
        ex(
            "Latency",
            "30 bins: the slow tail shows on the right.",
            Feed::Ops,
            Spec::new("histogram").y("latency").bins(30),
        ),
    ]
}

pub fn boxplot() -> Vec<Example> {
    vec![ex(
        "Latency by service",
        "Outliers are the slow tail.",
        Feed::Ops,
        Spec::new("boxplot").x("service").y("latency"),
    )]
}

pub fn heatmap() -> Vec<Example> {
    vec![ex(
        "Revenue, customer × region",
        "Sum of amounts.",
        Feed::Sales,
        Spec::new("heatmap")
            .x("customer")
            .series("region")
            .y("amount")
            .format("$~s"),
    )]
}

pub fn timeheatmap() -> Vec<Example> {
    vec![ex(
        "Latency distribution",
        "12 bins per time bucket.",
        Feed::Ops,
        Spec::new("timeheatmap").x("at").y("latency").bins(12),
    )]
}

pub fn scatter() -> Vec<Example> {
    vec![ex(
        "Seats against amount",
        "Bubble size is seats, color is product.",
        Feed::Sales,
        Spec::new("scatter")
            .x("seats")
            .y("amount")
            .size("seats")
            .series("product")
            .limit(400),
    )]
}

pub fn kpi() -> Vec<Example> {
    vec![
        ex(
            "Revenue",
            "Sum, trend per minute.",
            Feed::Sales,
            Spec::new("kpi")
                .x("at")
                .y("amount")
                .interval("1m")
                .format("$,.0f"),
        ),
        ex(
            "Average latency",
            "Colored by threshold rules.",
            Feed::Ops,
            Spec::new("kpi")
                .y("latency")
                .aggregate(Agg::Avg)
                .thresholds(latency())
                .format(",.0f"),
        ),
    ]
}

pub fn gauge() -> Vec<Example> {
    vec![ex(
        "Average latency",
        "0 to 800 ms, threshold ticks.",
        Feed::Ops,
        Spec::new("gauge")
            .y("latency")
            .aggregate(Agg::Avg)
            .min(0.0)
            .max(800.0)
            .thresholds(latency())
            .format(",.0f"),
    )]
}

pub fn slo() -> Vec<Example> {
    vec![ex(
        "Latency under 500 ms",
        "Target 95%.",
        Feed::Ops,
        Spec::new("slo").y("latency").objective("<=", 500.0, 95.0),
    )]
}

pub fn hostmap() -> Vec<Example> {
    let mut thresholds = latency();
    thresholds.push(Threshold::new(">=", 0.0, Level::Ok));
    vec![ex(
        "Average latency per host",
        "Grouped by service.",
        Feed::Ops,
        Spec::new("hostmap")
            .x("host")
            .y("latency")
            .aggregate(Agg::Avg)
            .series("service")
            .thresholds(thresholds),
    )]
}

pub fn status() -> Vec<Example> {
    vec![ex(
        "Host checks",
        "From the `check` field of each request.",
        Feed::Ops,
        Spec::new("status").x("host").y("check").series("at"),
    )]
}

pub fn stream() -> Vec<Example> {
    vec![ex(
        "Request log",
        "Host as a tag.",
        Feed::Ops,
        Spec::new("stream")
            .x("at")
            .y("message")
            .series("level")
            .columns(vec![Column::new("host")])
            .limit(60),
    )]
}

pub fn note() -> Vec<Example> {
    vec![ex(
        "About this dashboard",
        "Blank lines split paragraphs.",
        Feed::Ops,
        Spec::new("note")
            .text("Request logs from 24 hosts.\n\nWarning above 250 ms, critical above 500 ms."),
    )]
}

// ---- Rendering

/// Rows per example on a chart page, and per thumbnail, as in d3set.
const EXAMPLE_ROWS: usize = 600;
const THUMB_ROWS: usize = 400;

/// The last `limit` rows of a feed.
pub fn rows(feed: Feed, limit: usize) -> &'static [Row] {
    let all = match feed {
        Feed::Ops => &FEEDS.0,
        Feed::Sales => &FEEDS.1,
    };
    &all[all.len().saturating_sub(limit)..]
}

/// The rows a chart page draws.
pub fn example_rows(feed: Feed) -> &'static [Row] {
    rows(feed, EXAMPLE_ROWS)
}

/// One card of the overview grid.
pub struct Thumb {
    pub kind: &'static str,
    pub name: &'static str,
    pub summary: &'static str,
    pub html: String,
}

/// Every group, with a small chart per kind: the first example of each.
pub fn overview() -> Vec<(&'static str, Vec<Thumb>)> {
    GROUPS
        .iter()
        .map(|group| {
            let thumbs = group
                .kinds
                .iter()
                .filter_map(|kind| entry(kind))
                .map(|e| Thumb {
                    html: thumbnail(&e.examples[0]),
                    kind: e.kind,
                    name: e.name,
                    summary: e.summary,
                })
                .collect();
            (group.name, thumbs)
        })
        .collect()
}

/// A small chart, without title, at 300 px. The colours are CSS variables
/// (`var(--d3s-series-0)`): the page's theme gives them their values.
fn thumbnail(example: &Example) -> String {
    let mut spec = example.spec.clone();
    spec.title = None;
    spec.height = Some(if matches!(spec.kind.as_str(), "kpi" | "slo") {
        72
    } else {
        150
    });
    if spec.kind == "table" {
        spec.limit = Some(6);
    }
    match render(&spec, rows(example.feed, THUMB_ROWS), &LIGHT, 300.0).and_then(|c| c.html()) {
        Ok(html) => html,
        Err(error) => format!("<p role=\"alert\">Chart error: {error}</p>"),
    }
}

/// Text with `code` spans: backticks become <code>. The input is our own
/// catalog text.
pub fn inline_code(text: &str) -> String {
    let mut out = String::new();
    for (i, part) in text.split('`').enumerate() {
        let escaped = part
            .replace('&', "&amp;")
            .replace('<', "&lt;")
            .replace('>', "&gt;");
        if i % 2 == 1 {
            out.push_str("<code class=\"g-code\">");
            out.push_str(&escaped);
            out.push_str("</code>");
        } else {
            out.push_str(&escaped);
        }
    }
    out
}

/// The same text without the backticks, for a plain-text slot.
pub fn plain(text: &str) -> String {
    text.replace('`', "")
}

// ---- Sample data: d3set's generator, run once at a fixed clock.

/// The end of the history: the static d3set gallery's clock.
const NOW: &str = "2026-10-01T00:00:00Z";
const OPS_HISTORY: f64 = 15.0 * 60_000.0;
const SALES_HISTORY: f64 = 30.0 * 60_000.0;

static FEEDS: LazyLock<(Vec<Row>, Vec<Row>)> = LazyLock::new(|| {
    let t = d3set_ssr::time::parse_iso(NOW).expect("gallery: NOW is an ISO date");
    let (requests, sales) = Generator::new().history(t);
    (
        requests.iter().map(Request::row).collect(),
        sales.iter().map(Sale::row).collect(),
    )
});

/// SplitMix64: small, fast, and seedable.
struct Rng(u64);

impl Rng {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E37_79B9_7F4A_7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58_476D_1CE4_E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D0_49BB_1331_11EB);
        z ^ (z >> 31)
    }
    /// Uniform in [0, 1).
    fn f(&mut self) -> f64 {
        (self.next() >> 11) as f64 / (1u64 << 53) as f64
    }
    fn pick<'a, T>(&mut self, items: &'a [T]) -> &'a T {
        &items[(self.next() % items.len() as u64) as usize]
    }
}

const SERVICES: [&str; 4] = ["api", "billing", "web", "worker"];
const REGIONS: [&str; 4] = ["APAC", "EU", "LATAM", "US"];
const PRODUCTS: [&str; 3] = ["Starter", "Pro", "Enterprise"];
const CUSTOMERS: [&str; 8] = [
    "Acme", "Globex", "Hooli", "Initech", "Stark", "Umbrella", "Wayne", "Wonka",
];
const PATHS: [&str; 4] = ["invoices", "customers", "events", "plans"];

struct Host {
    name: String,
    service: &'static str,
    region: &'static str,
    slow: f64,
}

/// One request log line.
struct Request {
    id: u64,
    at: f64,
    host: Arc<str>,
    service: &'static str,
    region: &'static str,
    latency: u32,
    status: u16,
    errors: u8,
    level: &'static str,
    check: &'static str,
    message: String,
}

/// One order.
struct Sale {
    id: u64,
    at: f64,
    region: &'static str,
    product: &'static str,
    customer: &'static str,
    amount: u32,
    seats: u32,
    stage: &'static str,
}

impl Request {
    fn row(&self) -> Row {
        Row::new()
            .with("id", self.id as i64)
            .with("at", iso(self.at))
            .with("host", &*self.host)
            .with("service", self.service)
            .with("region", self.region)
            .with("latency", self.latency)
            .with("status", u32::from(self.status))
            .with("errors", u32::from(self.errors))
            .with("level", self.level)
            .with("check", self.check)
            .with("message", self.message.as_str())
    }
}

impl Sale {
    fn row(&self) -> Row {
        Row::new()
            .with("id", self.id as i64)
            .with("at", iso(self.at))
            .with("region", self.region)
            .with("product", self.product)
            .with("customer", self.customer)
            .with("amount", self.amount)
            .with("seats", self.seats)
            .with("stage", self.stage)
    }
}

struct Generator {
    rng: Rng,
    hosts: Vec<Host>,
    next_request: u64,
    next_sale: u64,
}

impl Generator {
    fn new() -> Self {
        let mut rng = Rng(0x0d3_5e7);
        let hosts = (0..24)
            .map(|i| Host {
                name: format!("host-{:02}", i + 1),
                service: SERVICES[i % 4],
                region: REGIONS[i % 3 + usize::from(i % 7 == 0)],
                slow: 1.0 + rng.f() * 1.6,
            })
            .collect();
        Self {
            rng,
            hosts,
            next_request: 0,
            next_sale: 0,
        }
    }

    fn request(&mut self, at: f64) -> Request {
        let r = &mut self.rng;
        let host = &self.hosts[(r.next() % self.hosts.len() as u64) as usize];
        // Log-normal latency, a slow tail, and hosts that are slower than others.
        let spike = if r.f() < 0.04 { 1.4 } else { 0.0 };
        let latency = ((4.2 + r.f() * 0.9 + spike).exp() * host.slow).round() as u32;
        let error = r.f() < 0.02 + if latency > 600 { 0.25 } else { 0.0 };
        self.next_request += 1;
        let (method, path) = (*r.pick(&["GET", "GET", "POST", "PUT"]), *r.pick(&PATHS));
        Request {
            id: self.next_request,
            at,
            host: host.name.as_str().into(),
            service: host.service,
            region: host.region,
            latency,
            status: if error { 500 } else { 200 },
            errors: u8::from(error),
            level: if error {
                "error"
            } else if latency > 400 {
                "warn"
            } else {
                "info"
            },
            check: if error {
                "critical"
            } else if latency > 400 {
                "warning"
            } else {
                "ok"
            },
            message: format!(
                "{method} /{}/{path} {} {latency}ms",
                host.service,
                if error { 500 } else { 200 }
            ),
        }
    }

    fn sale(&mut self, at: f64) -> Sale {
        let r = &mut self.rng;
        self.next_sale += 1;
        let product = *r.pick(&PRODUCTS);
        let base = match product {
            "Starter" => 40.0,
            "Pro" => 180.0,
            _ => 420.0,
        };
        Sale {
            id: self.next_sale,
            at,
            region: r.pick(&REGIONS),
            product,
            customer: r.pick(&CUSTOMERS),
            amount: (base * (0.6 + r.f() * 0.9)).round() as u32,
            seats: 1 + (r.f().powi(2) * 48.0) as u32,
            stage: r.pick(&[
                "Visited",
                "Visited",
                "Visited",
                "Visited",
                "Signed up",
                "Signed up",
                "Signed up",
                "Trial",
                "Trial",
                "Paid",
            ]),
        }
    }

    /// The rows before `t`: 15 minutes of requests and 30 of sales.
    fn history(&mut self, t: f64) -> (Vec<Request>, Vec<Sale>) {
        let mut at = t - OPS_HISTORY;
        let mut requests = Vec::new();
        while at < t {
            requests.push(self.request(at));
            // About 2 requests a second.
            at += 250.0 + self.rng.f() * 500.0;
        }
        let mut at = t - SALES_HISTORY;
        let mut sales = Vec::new();
        while at < t {
            sales.push(self.sale(at));
            at += 500.0 + self.rng.f() * 3000.0;
        }
        (requests, sales)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn every_kind_has_an_entry_and_its_examples_render() {
        for kind in kinds() {
            let e = entry(kind).unwrap_or_else(|| panic!("no entry for {kind}"));
            assert!(!e.examples.is_empty(), "{kind} has no example");
            for example in &e.examples {
                render(&example.spec, example_rows(example.feed), &LIGHT, 600.0)
                    .and_then(|c| c.html())
                    .unwrap_or_else(|err| panic!("{kind}: {err}"));
            }
        }
        assert!(entry("sparkle").is_none());
    }

    #[test]
    fn the_sample_data_is_the_same_every_time() {
        let a = Generator::new().history(1_790_812_800_000.0);
        let b = Generator::new().history(1_790_812_800_000.0);
        assert_eq!(a.0.len(), b.0.len());
        assert_eq!(a.0.last().unwrap().message, b.0.last().unwrap().message);
        assert!(rows(Feed::Ops, EXAMPLE_ROWS).len() == EXAMPLE_ROWS);
    }
}
