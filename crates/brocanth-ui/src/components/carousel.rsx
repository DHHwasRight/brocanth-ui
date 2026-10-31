//! Carousel. Without JavaScript it is a scroll-snap track: swipe, the
//! trackpad and the keyboard (it is focusable) all scroll it. The glue
//! (carousel.js, no Zag, under 1 KB) shows the previous/next buttons and
//! disables them at the ends.

pub fn Carousel(id: &str, label: &str, children: Element) -> Element {
    <section id={id} data-ui="carousel" aria-roledescription="carousel" aria-label={label} class="relative w-full">
        <div data-part="track" tabindex="0" class="flex snap-x snap-mandatory gap-4 overflow-x-auto scroll-smooth rounded-lg outline-none [scrollbar-width:none] focus-visible:ring-[3px] focus-visible:ring-ring/50 [&::-webkit-scrollbar]:hidden">
            {children}
        </div>
        <button type="button" data-part="prev" hidden aria-label="Previous slide" class={arrow_class("-left-4")}>{! crate::icons::CHEVRON_LEFT }</button>
        <button type="button" data-part="next" hidden aria-label="Next slide" class={arrow_class("-right-4")}>{! crate::icons::CHEVRON_RIGHT }</button>
    </section>
}

pub fn CarouselItem(label: &str, children: Element) -> Element {
    <div role="group" aria-roledescription="slide" aria-label={label} class="min-w-0 shrink-0 grow-0 basis-full snap-start">{children}</div>
}

fn arrow_class(side: &str) -> String {
    format!("absolute top-1/2 {side} inline-flex size-8 -translate-y-1/2 cursor-pointer items-center justify-center rounded-full border border-input bg-background text-foreground shadow-control hover:bg-accent disabled:cursor-default disabled:opacity-40 [&_svg]:size-4")
}
