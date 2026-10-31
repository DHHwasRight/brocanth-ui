use brocanth_ui::components::head::UiScripts;
use super::showcase::Showcase;

pub fn Page() -> Element {
    <!DOCTYPE html>
    <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>brocanth-ui themes</title>
            <link rel="stylesheet" href="gallery.css">
            <UiScripts />
            <script>{! DARK_TOGGLE }</script>
        </head>
        <body class="min-h-screen bg-[#f3f4f6] text-[#111827] [&.dark]:bg-[#0b0c10] [&.dark]:text-[#e5e7eb]">
            <header class="mx-auto flex max-w-[1400px] flex-wrap items-end justify-between gap-4 px-4 pb-4 pt-8 sm:px-6">
                <div>
                    <h1 class="text-2xl font-semibold tracking-tight">brocanth-ui: one markup, two themes</h1>
                    <p class="mt-1 max-w-2xl text-sm opacity-70">
                        Each column renders the same rsx calls. Only <code class="font-mono">data-theme</code> differs.
                        The left column uses the shadcn/ui tokens. The right column uses the docs.stripe.com tokens.
                        The dialogs are Zag.js machines. rolldown (brocanth-bundle) bundles them at build time,
                        and the page loads them only when it renders a dialog.
                    </p>
                </div>
                <button type="button" id="dark-toggle" class="rounded-md border border-current/20 px-3 py-1.5 text-sm">Toggle dark</button>
            </header>
            <main class="mx-auto grid max-w-[1400px] gap-4 px-4 pb-12 sm:px-6 lg:grid-cols-2">
                <Showcase theme="shadcn" label="shadcn/ui" />
                <Showcase theme="stripe" label="docs.stripe.com" />
            </main>
        </body>
    </html>
}

const DARK_TOGGLE: &str = r#"
document.addEventListener("click", (e) => {
  if (e.target.id !== "dark-toggle") return;
  document.body.classList.toggle("dark");
  document.querySelectorAll("[data-theme], [data-ui-portaled]").forEach((el) => el.classList.toggle("dark", document.body.classList.contains("dark")));
});
"#;
