//! Navigation menu: site links, some with a flyout. No JavaScript: each
//! flyout is a native popover opened by an invoker button and anchored to it.

pub fn NavigationMenu(label: &str, children: Element) -> Element {
    <nav aria-label={label} class="relative flex max-w-max flex-1 items-center">
        <ul class="flex flex-1 list-none items-center gap-1">{children}</ul>
    </nav>
}

pub fn NavigationMenuLink(href: &str, current: bool, children: Element) -> Element {
    <li>
        if current {
            <a href={href} aria-current="page" class={link_class()}>{children}</a>
        } else {
            <a href={href} class={link_class()}>{children}</a>
        }
    </li>
}

/// A trigger and its flyout. `id` must be a CSS identifier.
pub fn NavigationMenuItem(id: &str, label: &str, children: Element) -> Element {
    <li>
        <button type="button" commandfor={id} command="toggle-popover" class={format!("{} group/nav", link_class())} style={format!("anchor-name: --{id}")}>
            {label}
            <span class="[&_svg]:size-3 [&_svg]:transition-transform">{! crate::icons::CHEVRON_DOWN }</span>
        </button>
        <div id={id} popover data-anchored class="ui-pop inset-auto m-0 mt-1.5 w-[min(32rem,calc(100vw-2rem))] rounded-md border bg-popover p-2 text-popover-foreground shadow-overlay [position-area:block-end_span-inline-end] [position-try-fallbacks:flip-inline]" style={format!("position-anchor: --{id}")}>
            <ul class="grid gap-1 sm:grid-cols-2">{children}</ul>
        </div>
    </li>
}

/// A link inside a flyout.
pub fn NavigationMenuCard(href: &str, title: &str, description: &str) -> Element {
    <li>
        <a href={href} class="block rounded-md p-3 text-sm outline-none transition-colors hover:bg-accent focus-visible:ring-[3px] focus-visible:ring-ring/50">
            <div class="font-control leading-none text-heading">{title}</div>
            <p class="mt-1.5 line-clamp-2 leading-snug text-muted-foreground">{description}</p>
        </a>
    </li>
}

fn link_class() -> &'static str {
    "inline-flex h-control w-max cursor-pointer items-center justify-center gap-1 rounded-md px-4 py-2 text-sm font-control text-foreground outline-none transition-colors hover:bg-accent hover:text-accent-foreground focus-visible:ring-[3px] focus-visible:ring-ring/50 aria-[current=page]:bg-accent aria-[current=page]:text-accent-foreground"
}
