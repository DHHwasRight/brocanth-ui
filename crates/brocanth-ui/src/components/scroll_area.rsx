//! Scroll area. No JavaScript: a scroll container with a thin, themed
//! scrollbar (`scrollbar-width`, `scrollbar-color`).

/// `max_height` is a CSS length: `"18rem"`.
pub fn ScrollArea(max_height: &str, label: &str, children: Element) -> Element {
    <div role="region" aria-label={label} tabindex="0" class="relative overflow-auto rounded-md border [scrollbar-color:var(--ui-border)_transparent] [scrollbar-width:thin] focus-visible:ring-[3px] focus-visible:ring-ring/50 outline-none" style={format!("max-height: {max_height}")}>
        {children}
    </div>
}
