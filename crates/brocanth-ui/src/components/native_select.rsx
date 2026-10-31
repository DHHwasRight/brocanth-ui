//! Native select. No JavaScript. Use it unless the options need rich content.

/// `options` are `(value, label)`.
pub fn NativeSelect(id: &str, name: &str, options: &[(&str, &str)], selected: &str, attrs: &[(&str, &str)]) -> Element {
    <div class="relative w-full">
        <select id={id} name={name} class="h-control w-full min-w-0 cursor-pointer appearance-none rounded-md border border-input bg-background py-1 pr-8 pl-3 text-sm text-foreground shadow-control outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive" { ...attrs.iter().copied() }>
            for (value, label) in options {
                <option value={value} selected?={*value == selected}>{label}</option>
            }
        </select>
        <span class="pointer-events-none absolute top-1/2 right-2.5 -translate-y-1/2 text-muted-foreground [&_svg]:size-4">{! crate::icons::CHEVRON_DOWN }</span>
    </div>
}
