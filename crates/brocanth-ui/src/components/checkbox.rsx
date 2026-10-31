//! Checkbox. No JavaScript: a native checkbox with `appearance: none`, and a
//! check icon that `peer-checked` shows.

pub fn Checkbox(id: &str, name: &str, label: &str, checked: bool, attrs: &[(&str, &str)]) -> Element {
    <div class="flex items-center gap-2">
        <span class="relative inline-grid size-4 shrink-0 place-items-center">
            <input type="checkbox" id={id} name={name} checked?={checked} class="peer size-4 cursor-pointer appearance-none rounded-sm border border-input bg-background shadow-control outline-none transition-colors checked:border-primary checked:bg-primary focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive" { ...attrs.iter().copied() }>
            <span class="pointer-events-none absolute scale-50 text-primary-foreground opacity-0 transition-[opacity,scale] duration-150 peer-checked:scale-100 peer-checked:opacity-100 [&_svg]:size-3.5">{! crate::icons::CHECK }</span>
        </span>
        <label for={id} class="cursor-pointer text-sm leading-none font-control text-heading peer-disabled:opacity-50">{label}</label>
    </div>
}
