//! Tooltip. No JavaScript: shows on hover and on keyboard focus of the
//! trigger, placed with anchor positioning.
//!
//! The trigger must name the tooltip: pass `("aria-describedby", id)` in
//! its attrs. Escape does not hide a CSS tooltip (WCAG 1.4.13); boot.js
//! adds that in about 10 lines.

pub fn Tooltip(id: &str, text: &str, children: Element) -> Element {
    <span class="group/tt relative inline-flex" style={format!("anchor-name: --{id}")}>
        {children}
        <span role="tooltip" id={id} class="pointer-events-none invisible fixed z-50 mb-1.5 w-max max-w-xs rounded-md bg-tooltip px-3 py-1.5 text-xs text-tooltip-foreground ui-float scale-95 opacity-0 [position-area:block-start] [position-try-fallbacks:flip-block] group-hover/tt:visible group-hover/tt:scale-100 group-hover/tt:opacity-100 group-hover/tt:delay-300 group-has-[:focus-visible]/tt:visible group-has-[:focus-visible]/tt:scale-100 group-has-[:focus-visible]/tt:opacity-100 group-data-[tooltip-dismissed]/tt:invisible! group-data-[tooltip-dismissed]/tt:opacity-0!" style={format!("position-anchor: --{id}")}>
            {text}
        </span>
    </span>
}
