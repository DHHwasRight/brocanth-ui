//! Aspect ratio box. No JavaScript: CSS `aspect-ratio`.

/// `ratio` is a CSS ratio: `"16 / 9"`, `"1"`, `"4 / 3"`.
pub fn AspectRatio(ratio: &str, children: Element) -> Element {
    <div class="relative w-full overflow-hidden [&>img]:size-full [&>img]:object-cover" style={format!("aspect-ratio: {ratio}")}>
        {children}
    </div>
}
