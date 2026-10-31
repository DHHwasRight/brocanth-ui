//! Item: a row with media, a title, a description and actions. No JavaScript.

pub fn ItemGroup(children: Element) -> Element {
    <div role="list" class="flex flex-col divide-y rounded-lg border">{children}</div>
}

/// `media` is raw HTML (an icon or an avatar) and may be empty.
/// `children` holds the actions.
pub fn Item(media: &str, title: &str, description: &str, children: Element) -> Element {
    <div role="listitem" class="flex flex-wrap items-center gap-4 p-4 text-sm">
        if !media.is_empty() {
            <div class="flex size-9 shrink-0 items-center justify-center rounded-md border bg-muted text-heading [&_svg]:size-4">{! media }</div>
        }
        <div class="flex min-w-0 flex-1 flex-col gap-1">
            <div class="font-control leading-snug text-heading">{title}</div>
            <p class="line-clamp-2 text-muted-foreground">{description}</p>
        </div>
        <div class="flex items-center gap-2">{children}</div>
    </div>
}
