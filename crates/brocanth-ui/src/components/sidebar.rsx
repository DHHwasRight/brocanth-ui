//! Sidebar layout. No JavaScript: `SidebarTrigger` is a checkbox drawn as an
//! icon button, and the layout reads it with `:has()`.
//!
//! - Wide screens: the sidebar shows; the trigger collapses it.
//! - Narrow screens: the sidebar hides; the trigger opens it over the page.
//!
//! A server that wants the choice to persist renders `collapsed` from a
//! cookie or a user setting.

pub fn SidebarProvider(children: Element) -> Element {
    <div class="group/sidebar relative flex min-h-[28rem] w-full overflow-hidden rounded-lg border bg-background">{children}</div>
}

pub fn Sidebar(label: &str, children: Element) -> Element {
    <aside aria-label={label} class="flex w-60 shrink-0 flex-col gap-4 overflow-y-auto border-r bg-muted/50 p-3 transition-[width,padding] group-has-[[data-sidebar-toggle]:checked]/sidebar:w-0 group-has-[[data-sidebar-toggle]:checked]/sidebar:border-0 group-has-[[data-sidebar-toggle]:checked]/sidebar:p-0 max-md:absolute max-md:inset-y-0 max-md:left-0 max-md:z-20 max-md:w-0 max-md:border-0 max-md:p-0 max-md:shadow-overlay max-md:group-has-[[data-sidebar-toggle]:checked]/sidebar:w-60 max-md:group-has-[[data-sidebar-toggle]:checked]/sidebar:border-r max-md:group-has-[[data-sidebar-toggle]:checked]/sidebar:bg-background max-md:group-has-[[data-sidebar-toggle]:checked]/sidebar:p-3">
        {children}
    </aside>
}

pub fn SidebarGroup(label: &str, children: Element) -> Element {
    <div class="grid min-w-52 gap-1">
        <div class="px-2 py-1 text-xs font-control text-muted-foreground">{label}</div>
        <ul class="grid gap-0.5">{children}</ul>
    </div>
}

/// `icon` is raw HTML and may be empty.
pub fn SidebarItem(href: &str, icon: &str, label: &str, current: bool) -> Element {
    <li>
        if current {
            <a href={href} aria-current="page" class={item_class()}>{! icon }<span>{label}</span></a>
        } else {
            <a href={href} class={item_class()}>{! icon }<span>{label}</span></a>
        }
    </li>
}

fn item_class() -> &'static str {
    "flex h-8 items-center gap-2 rounded-md px-2 text-sm text-foreground outline-none hover:bg-accent hover:text-accent-foreground focus-visible:ring-[3px] focus-visible:ring-ring/50 aria-[current=page]:bg-accent aria-[current=page]:font-control aria-[current=page]:text-heading [&_svg]:size-4 [&_svg]:shrink-0"
}

pub fn SidebarInset(children: Element) -> Element {
    <div class="flex min-w-0 flex-1 flex-col">{children}</div>
}

/// The checkbox that collapses (wide) or opens (narrow) the sidebar.
pub fn SidebarTrigger(collapsed: bool) -> Element {
    <span class="relative inline-flex size-7 items-center justify-center rounded-md text-foreground hover:bg-accent has-[:focus-visible]:ring-[3px] has-[:focus-visible]:ring-ring/50 [&_svg]:size-4">
        <input type="checkbox" data-sidebar-toggle aria-label="Toggle sidebar" checked?={collapsed} class="absolute inset-0 cursor-pointer appearance-none rounded-md outline-none">
        {! crate::icons::PANEL_LEFT }
    </span>
}
