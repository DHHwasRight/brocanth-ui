//! Chart: a d3set-ssr chart, rendered on the server as SVG. No JavaScript.
//! Feature `charts`.
//!
//! The SVG paints every mark with `var(--d3s-series-N)`. theme.css maps
//! those variables to `--ui-chart-1..5`, so a chart takes the colours of
//! the theme around it, light or dark, with no second render.
//!
//! ```ignore
//! let spec = Spec::new("line").x("day").y("mrr").series("plan").format("$,.0f").height(220);
//! <Chart title="MRR" description="Last 30 days" spec={&spec} rows={&rows} width={640.0} />
//! ```

use d3set_ssr::{render, Row, Spec, LIGHT};

/// `width` is the drawing width in px: the server cannot measure the page.
/// The SVG scales to its container, so pass the width it usually gets.
pub fn Chart(title: &str, description: &str, spec: &Spec, rows: &[Row], width: f64) -> Element {
    <figure class="grid gap-4 rounded-xl border bg-card p-6 text-card-foreground shadow-control">
        <figcaption class="grid gap-1">
            <div class="font-heading leading-none text-heading">{title}</div>
            if !description.is_empty() {
                <div class="text-sm text-muted-foreground">{description}</div>
            }
        </figcaption>
        {! chart_html(spec, rows, width) }
    </figure>
}

/// The chart markup, or a visible note when the spec does not fit the rows.
fn chart_html(spec: &Spec, rows: &[Row], width: f64) -> String {
    match render(spec, rows, &LIGHT, width).and_then(|chart| chart.html()) {
        Ok(html) => html,
        Err(error) => format!(r#"<p role="alert" class="text-sm text-destructive">Chart error: {}</p>"#, rsx_escape(&error.to_string())),
    }
}

fn rsx_escape(text: &str) -> String {
    text.replace('&', "&amp;").replace('<', "&lt;").replace('>', "&gt;")
}
