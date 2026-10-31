//! Button group: joins buttons edge to edge. No JavaScript.

pub fn ButtonGroup(label: &str, children: Element) -> Element {
    <div role="group" aria-label={label} class="inline-flex w-fit items-stretch [&>*]:rounded-none [&>*]:shadow-none [&>*:first-child]:rounded-l-md [&>*:last-child]:rounded-r-md [&>*+*]:-ml-px [&>*:focus-visible]:z-10 shadow-control rounded-md">
        {children}
    </div>
}
