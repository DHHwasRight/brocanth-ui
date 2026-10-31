//! Radio group. No JavaScript: native radios, so arrow keys move the
//! selection and the form posts the value.

/// `options` are `(value, label)`.
pub fn RadioGroup(name: &str, legend: &str, options: &[(&str, &str)], selected: &str) -> Element {
    <fieldset class="grid gap-3">
        <legend class="mb-3 text-sm font-control text-heading">{legend}</legend>
        for (value, label) in options {
            <label class="flex cursor-pointer items-center gap-2 text-sm text-foreground">
                <input type="radio" name={name} value={value} checked?={*value == selected} class="size-4 shrink-0 cursor-pointer appearance-none rounded-full border border-input bg-background shadow-control outline-none transition-[box-shadow,border-color] checked:border-primary checked:[box-shadow:inset_0_0_0_3px_var(--ui-background),inset_0_0_0_8px_var(--ui-primary)] focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:opacity-50">
                {label}
            </label>
        }
    </fieldset>
}
