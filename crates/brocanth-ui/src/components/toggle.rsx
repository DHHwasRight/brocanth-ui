//! Toggle button. No JavaScript: a checkbox inside a label drawn as a
//! button, so the pressed state posts with the form and survives a reload.

/// `content` is raw HTML (an icon, text, or both). `label` is the
/// accessible name.
pub fn Toggle(id: &str, name: &str, label: &str, pressed: bool, content: &str) -> Element {
    <label for={id} title={label} class={toggle_class()}>
        <input type="checkbox" id={id} name={name} aria-label={label} checked?={pressed} class="sr-only">
        {! content }
    </label>
}

pub(crate) fn toggle_class() -> &'static str {
    "inline-flex h-control min-w-control cursor-pointer items-center justify-center gap-2 rounded-md px-2 text-sm font-control text-foreground transition-colors select-none hover:bg-muted hover:text-muted-foreground has-[:checked]:bg-accent has-[:checked]:text-accent-foreground has-[:checked]:[box-shadow:inset_0_0_0_1px_var(--ui-border)] has-[:focus-visible]:ring-[3px] has-[:focus-visible]:ring-ring/50 has-[:disabled]:opacity-50 [&_svg]:size-4"
}
