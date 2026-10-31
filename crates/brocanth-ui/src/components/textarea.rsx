//! Textarea. No JavaScript: `field-sizing: content` grows it with its text
//! where the engine supports it.

pub fn Textarea(id: &str, name: &str, value: &str, attrs: &[(&str, &str)]) -> Element {
    <textarea id={id} name={name} class="flex field-sizing-content min-h-16 w-full rounded-md border border-input bg-background px-3 py-2 text-sm text-foreground shadow-control outline-none transition-[color,box-shadow] placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive" { ...attrs.iter().copied() }>{value}</textarea>
}
