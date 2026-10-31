//! Card. No JavaScript.

pub fn Card(children: Element) -> Element {
    <div class="flex flex-col gap-6 rounded-xl border bg-card py-6 text-card-foreground shadow-control">
        {children}
    </div>
}

/// `description` may be empty.
pub fn CardHeader(title: &str, description: &str) -> Element {
    <div class="grid gap-1.5 px-6">
        <h3 class="font-heading leading-none text-heading">{title}</h3>
        if !description.is_empty() {
            <p class="text-sm text-muted-foreground">{description}</p>
        }
    </div>
}

pub fn CardContent(children: Element) -> Element {
    <div class="px-6">{children}</div>
}

pub fn CardFooter(children: Element) -> Element {
    <div class="flex items-center gap-2 px-6">{children}</div>
}
