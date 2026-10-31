//! Progress bar. No JavaScript. The server renders the value; a live value
//! comes from a dp-swap of the bar.

/// `value` is a percentage, 0 to 100.
pub fn Progress(value: u8, label: &str) -> Element {
    <div role="progressbar" aria-label={label} aria-valuemin="0" aria-valuemax="100" aria-valuenow={value} class="relative h-2 w-full overflow-hidden rounded-full bg-primary/20">
        <div class="h-full bg-primary transition-[width]" style={format!("width: {}%", value.min(100))}></div>
    </div>
}
