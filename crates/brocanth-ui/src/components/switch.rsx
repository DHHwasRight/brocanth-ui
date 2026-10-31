//! Switch. No JavaScript: a native checkbox with `role="switch"`, drawn as
//! a track with a thumb.

pub fn Switch(id: &str, name: &str, label: &str, checked: bool) -> Element {
    <div class="flex items-center gap-2">
        <span class="relative inline-flex h-[1.15rem] w-8 shrink-0 items-center">
            <input type="checkbox" role="switch" id={id} name={name} checked?={checked} class="peer h-[1.15rem] w-8 cursor-pointer appearance-none rounded-full border border-transparent bg-input shadow-control outline-none transition-colors checked:bg-primary focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-50">
            <span class="pointer-events-none absolute left-px size-4 rounded-full bg-background shadow-sm transition-transform duration-200 peer-checked:translate-x-[calc(100%-2px)]"></span>
        </span>
        <label for={id} class="cursor-pointer text-sm leading-none font-control text-heading">{label}</label>
    </div>
}
