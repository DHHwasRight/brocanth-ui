//! Hover card: a preview that shows on hover or keyboard focus. No
//! JavaScript: CSS `:hover` and `:focus-within`, anchor positioning, and a
//! transition delay so a passing pointer does not open it.
//!
//! Keep the content a preview: a touch screen has no hover, so the trigger
//! must also work as a plain link.

/// `trigger` is raw HTML (usually a link).
pub fn HoverCard(id: &str, trigger: &str, children: Element) -> Element {
    <span class="group/hc relative inline-block" style={format!("anchor-name: --{id}")}>
        {! trigger }
        <span id={id} class="invisible fixed z-50 mt-2 w-64 rounded-md border bg-popover p-4 text-sm text-popover-foreground ui-float scale-95 opacity-0 shadow-overlay delay-100 [position-area:block-end_span-inline-end] [position-try-fallbacks:flip-block] group-hover/hc:visible group-hover/hc:scale-100 group-hover/hc:opacity-100 group-hover/hc:delay-500 group-focus-within/hc:visible group-focus-within/hc:scale-100 group-focus-within/hc:opacity-100" style={format!("position-anchor: --{id}")}>
            {children}
        </span>
    </span>
}
