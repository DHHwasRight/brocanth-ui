//! Pagination: links, so it works with a full page load or with dp-swap
//! (`dp-boost` on an ancestor turns the links into partial navigations).
//! No JavaScript.

/// Pages are numbered from 1. `href_base` gets `page=<n>` appended, so pass
/// `"/invoices?"` or `"/invoices?status=open&"`.
pub fn Pagination(current: usize, total: usize, href_base: &str) -> Element {
    <nav aria-label="Pagination" class="mx-auto flex w-full justify-center">
        <ul class="flex flex-row items-center gap-1">
            <li>
                if current > 1 {
                    <a href={page_href(href_base, current - 1)} class={step_class()} aria-label="Previous page">{! crate::icons::CHEVRON_LEFT }<span class="hidden sm:block">Previous</span></a>
                } else {
                    <span class={step_class()} aria-disabled="true" data-disabled="">{! crate::icons::CHEVRON_LEFT }<span class="hidden sm:block">Previous</span></span>
                }
            </li>
            for slot in page_slots(current, total) {
                <li>
                    match slot {
                        Some(page) => {
                            if page == current {
                                <a href={page_href(href_base, page)} aria-current="page" class={page_class(true)}>{page}</a>
                            } else {
                                <a href={page_href(href_base, page)} class={page_class(false)}>{page}</a>
                            }
                        }
                        None => <span aria-hidden="true" class="flex size-control items-center justify-center text-muted-foreground [&_svg]:size-4">{! crate::icons::MORE_HORIZONTAL }</span>,
                    }
                </li>
            }
            <li>
                if current < total {
                    <a href={page_href(href_base, current + 1)} class={step_class()} aria-label="Next page"><span class="hidden sm:block">Next</span>{! crate::icons::CHEVRON_RIGHT }</a>
                } else {
                    <span class={step_class()} aria-disabled="true" data-disabled=""><span class="hidden sm:block">Next</span>{! crate::icons::CHEVRON_RIGHT }</span>
                }
            </li>
        </ul>
    </nav>
}

fn page_href(base: &str, page: usize) -> String {
    format!("{base}page={page}")
}

fn step_class() -> &'static str {
    "inline-flex h-control items-center gap-1 rounded-md px-2.5 text-sm font-control text-foreground hover:bg-accent hover:text-accent-foreground data-[disabled]:pointer-events-none data-[disabled]:opacity-50 [&_svg]:size-4"
}

fn page_class(current: bool) -> &'static str {
    if current {
        "inline-flex size-control items-center justify-center rounded-md border border-input bg-background text-sm font-control text-heading shadow-control"
    } else {
        "inline-flex size-control items-center justify-center rounded-md text-sm text-foreground hover:bg-accent hover:text-accent-foreground"
    }
}

/// First, last, and the pages around `current`; `None` is a gap.
pub fn page_slots(current: usize, total: usize) -> Vec<Option<usize>> {
    let mut slots = Vec::new();
    for page in 1..=total {
        let near = page + 1 >= current && page <= current + 1;
        if page == 1 || page == total || near {
            slots.push(Some(page));
        } else if slots.last() != Some(&None) {
            slots.push(None);
        }
    }
    slots
}
