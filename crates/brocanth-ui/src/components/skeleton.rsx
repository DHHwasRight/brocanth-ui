//! Skeleton placeholder. No JavaScript.

/// `size` holds the size classes: `"h-4 w-48"`. They must be complete
/// class names in the app's source, so Tailwind finds them.
pub fn Skeleton(size: &str) -> Element {
    <div aria-hidden="true" class={format!("animate-pulse rounded-md bg-muted {size}")}></div>
}
