//! Native select. No JavaScript. Use it unless the options need rich content.

/// `options` are `(value, label)`.
pub fn NativeSelect(id: &str, name: &str, options: &[(&str, &str)], selected: &str, attrs: &[(&str, &str)]) -> Element {
    <div class="relative w-full">
        <select id={id} name={name} class={crate::class::select()} { ...attrs.iter().copied() }>
            for (value, label) in options {
                <option value={value} selected?={*value == selected}>{label}</option>
            }
        </select>
        <span class="pointer-events-none absolute top-1/2 right-2.5 -translate-y-1/2 text-muted-foreground [&_svg]:size-4">{! crate::icons::CHEVRON_DOWN }</span>
    </div>
}
