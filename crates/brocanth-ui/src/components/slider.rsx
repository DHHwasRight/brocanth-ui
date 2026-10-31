//! Slider. No JavaScript: a native range input. `accent-color` fills the
//! track in the theme colour in every engine; the form posts the value.
//! A two-thumb range needs Zag's slider (see docs/punch-list.md).

pub fn Slider(id: &str, name: &str, label: &str, min: i64, max: i64, step: i64, value: i64) -> Element {
    <input type="range" id={id} name={name} aria-label={label} min={min} max={max} step={step} value={value} class="h-2 w-full cursor-pointer accent-[var(--ui-primary)] focus-visible:outline-none focus-visible:[&::-webkit-slider-thumb]:ring-[3px] disabled:opacity-50">
}
