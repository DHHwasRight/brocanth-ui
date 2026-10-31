//! Separator. No JavaScript.

pub fn Separator(vertical: bool) -> Element {
    if vertical {
        <div role="separator" aria-orientation="vertical" class="h-full w-px shrink-0 self-stretch bg-border"></div>
    } else {
        <div role="separator" aria-orientation="horizontal" class="h-px w-full shrink-0 bg-border"></div>
    }
}
