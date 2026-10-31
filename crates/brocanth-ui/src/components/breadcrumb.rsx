//! Breadcrumb. No JavaScript.

/// `items` are `(label, href)`. The last item is the current page; its href
/// is not used.
pub fn Breadcrumb(items: &[(&str, &str)]) -> Element {
    <nav aria-label="Breadcrumb">
        <ol class="flex flex-wrap items-center gap-1.5 text-sm break-words text-muted-foreground sm:gap-2.5">
            for (i, (label, href)) in items.iter().enumerate() {
                if i + 1 == items.len() {
                    <li class="inline-flex items-center"><span aria-current="page" class="font-normal text-heading">{label}</span></li>
                } else {
                    <li class="inline-flex items-center gap-1.5"><a href={href} class="transition-colors hover:text-heading">{label}</a></li>
                    <li role="presentation" aria-hidden="true" class="[&_svg]:size-3.5">{! crate::icons::CHEVRON_RIGHT }</li>
                }
            }
        </ol>
    </nav>
}
