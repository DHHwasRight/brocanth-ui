//! Input with add-ons (text or icons) inside the same border. No JavaScript:
//! the group draws the focus ring with `has-[:focus-visible]`.

/// `prefix` and `suffix` may be empty. `children` is the `<input>`; give it
/// `class::input_bare()`.
pub fn InputGroup(prefix: &str, suffix: &str, children: Element) -> Element {
    <div class="flex h-control w-full min-w-0 items-center rounded-md border border-input bg-background text-sm shadow-control transition-[color,box-shadow] has-[:focus-visible]:border-ring has-[:focus-visible]:ring-[3px] has-[:focus-visible]:ring-ring/50 has-[[aria-invalid=true]]:border-destructive">
        if !prefix.is_empty() {
            <span class="flex items-center pl-3 text-muted-foreground [&_svg]:size-4">{! prefix }</span>
        }
        {children}
        if !suffix.is_empty() {
            <span class="flex items-center pr-3 text-muted-foreground [&_svg]:size-4">{! suffix }</span>
        }
    </div>
}
