//! Table. No JavaScript.
//!
//! The header row reads three component tokens, so each theme can set it:
//! shadcn keeps sentence case; the original theme uses small caps.

pub fn Table(children: Element) -> Element {
    <div class="relative w-full overflow-x-auto">
        <table class="w-full caption-bottom text-sm">{children}</table>
    </div>
}

pub fn TableHeader(children: Element) -> Element {
    <thead class="[&_tr]:border-b">{children}</thead>
}

pub fn TableBody(children: Element) -> Element {
    <tbody class="[&_tr:last-child]:border-0">{children}</tbody>
}

pub fn TableRow(children: Element) -> Element {
    <tr class="border-b transition-colors hover:bg-muted/50">{children}</tr>
}

pub fn TableHead(children: Element) -> Element {
    <th class={head_class()}>
        {children}
    </th>
}

pub fn TableCell(children: Element) -> Element {
    <td class="whitespace-nowrap p-2 align-middle">{children}</td>
}

pub fn TableCaption(children: Element) -> Element {
    <caption class="mt-4 text-sm text-muted-foreground">{children}</caption>
}

pub(crate) fn head_class() -> &'static str {
    "h-10 whitespace-nowrap px-2 text-left align-middle font-control text-(length:--ui-table-head-size) tracking-(--ui-table-head-tracking) text-(--ui-table-head-color) [text-transform:var(--ui-table-head-case)]"
}
