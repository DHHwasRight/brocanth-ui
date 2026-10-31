//! Avatar. No JavaScript: the image sits on top of the fallback initials.
//! A broken image with `alt=""` draws nothing, so the initials show through.

/// `src` may be empty: then only the fallback shows. `alt` names the person.
pub fn Avatar(src: &str, alt: &str, fallback: &str) -> Element {
    <span class="relative inline-flex size-8 shrink-0 overflow-hidden rounded-full bg-muted" role="img" aria-label={alt}>
        <span class="flex size-full items-center justify-center text-xs font-control text-muted-foreground" aria-hidden="true">{fallback}</span>
        if !src.is_empty() {
            <img src={src} alt="" class="absolute inset-0 size-full object-cover">
        }
    </span>
}

/// Overlapping avatars.
pub fn AvatarGroup(children: Element) -> Element {
    <div class="flex -space-x-2 [&>*]:ring-2 [&>*]:ring-background">{children}</div>
}
