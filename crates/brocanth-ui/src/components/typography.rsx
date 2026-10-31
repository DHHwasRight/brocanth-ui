//! Typography: styles for prose rendered from Markdown or a CMS. No JavaScript.

pub fn Prose(children: Element) -> Element {
    <div class="max-w-prose text-foreground [&_a]:font-control [&_a]:text-link [&_a]:underline-offset-4 hover:[&_a]:underline [&_blockquote]:mt-6 [&_blockquote]:border-l-2 [&_blockquote]:pl-6 [&_blockquote]:italic [&_code]:rounded-sm [&_code]:bg-muted [&_code]:px-[0.3rem] [&_code]:py-[0.2rem] [&_code]:font-mono [&_code]:text-sm [&_h1]:scroll-m-20 [&_h1]:text-4xl [&_h1]:font-heading [&_h1]:tracking-tight [&_h1]:text-balance [&_h1]:text-heading [&_h2]:mt-10 [&_h2]:scroll-m-20 [&_h2]:border-b [&_h2]:pb-2 [&_h2]:text-2xl [&_h2]:font-heading [&_h2]:tracking-tight [&_h2]:text-heading [&_h3]:mt-8 [&_h3]:text-xl [&_h3]:font-heading [&_h3]:text-heading [&_li]:mt-2 [&_p]:leading-7 [&_p:not(:first-child)]:mt-6 [&_ul]:my-6 [&_ul]:ml-6 [&_ul]:list-disc">
        {children}
    </div>
}
