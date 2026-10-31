//! Data table pieces: sortable headers and a toolbar. No JavaScript: sort,
//! filter and paging are links and forms that the server answers, so the
//! table works on any size of data. With dp-swap, a sort or a page swaps
//! only the table (`dp-boost` on an ancestor, or `dp-get` on the links).
//! Compose with `Table`, `TableRow`, `TableCell` and `Pagination`.

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum Sort {
    #[default]
    None,
    Ascending,
    Descending,
}

/// `href` is the URL that sorts by this column (the server toggles the
/// direction).
pub fn SortableHead(label: &str, href: &str, sort: Sort) -> Element {
    <th aria-sort={aria_sort(sort)} class={super::table::head_class()}>
        <a href={href} class="-ml-2 inline-flex h-8 items-center gap-1.5 rounded-md px-2 hover:bg-accent hover:text-accent-foreground [&_svg]:size-3.5">
            {label}
            {! sort_icon(sort) }
        </a>
    </th>
}

fn aria_sort(sort: Sort) -> &'static str {
    match sort {
        Sort::None => "none",
        Sort::Ascending => "ascending",
        Sort::Descending => "descending",
    }
}

fn sort_icon(sort: Sort) -> &'static str {
    match sort {
        Sort::None => crate::icons::ARROW_UP_DOWN,
        Sort::Ascending => crate::icons::ARROW_UP,
        Sort::Descending => crate::icons::ARROW_DOWN,
    }
}

/// The row above a table: a filter form, column toggles, actions.
pub fn DataTableToolbar(children: Element) -> Element {
    <div class="flex flex-wrap items-center gap-2 py-4">{children}</div>
}
