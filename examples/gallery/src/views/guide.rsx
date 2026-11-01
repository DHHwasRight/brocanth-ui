//! Configuration: the Utilities tab's first page, in place of Tailwind's
//! Installation. It shows what brocanth-ui passes to the Tailwind CLI to
//! get its design, with the files themselves in each Code accordion.

use std::collections::HashMap;

use crate::code::Tab;
use brocanth_ui::components::accordion::{Accordion, AccordionItem};
use brocanth_ui::components::badge::Badge;
use brocanth_ui::components::button::Button;
use brocanth_ui::components::popover::{PopoverContent, PopoverTrigger};
use brocanth_ui::{BadgeVariant, ButtonSize, ButtonVariant};
use super::reference::{title, ReferenceSide};
use super::shell::{CodePanel, PageTitle, Shell, LAYER_2};

pub fn GuidePage(base: &str, css: &str, code: &HashMap<&str, Vec<Tab>>) -> Element {
    <Shell title={&title("Configuration")} base={base} css={css} tab="utilities">
        <ReferenceSide current="index" oob={false} />
        <main class="g-main" id="top" dp-layout="/utilities">{! LAYER_2.0 }
            <PageTitle title={&title("Configuration")} />
            <article class="g-page g-doc" data-ui-theme="original">
                <div class="g-eyebrow">Getting started</div>
                <h1 class="g-h1">Configuration</h1>
                <p class="g-lead">
                    brocanth-ui uses Tailwind CSS v4 with no <code class="g-code">tailwind.config.js</code>: the configuration is CSS that the
                    Tailwind CLI reads. Seven changes turn Tailwind's defaults into this design. Every utility page in this tab shows the CSS
                    they produce.
                </p>
                <ol class="g-steps">
                    <li><a href="#sources">Scan only our sources</a></li>
                    <li><a href="#theme">Map theme variables to tokens</a></li>
                    <li><a href="#themes">Give the tokens values, per theme</a></li>
                    <li><a href="#base">Set the base styles</a></li>
                    <li><a href="#motion">Add the motion classes</a></li>
                    <li><a href="#rsx">Write the classes in rsx</a></li>
                    <li><a href="#build">Build with the Tailwind CLI</a></li>
                </ol>

                <section id="sources" class="g-doc-section">
                    <h2 class="g-doc-h2">1. Scan only our sources</h2>
                    <p>
                        <code class="g-code">@import "tailwindcss" source(none)</code> stops Tailwind from scanning the working directory. Each
                        <code class="g-code">@source</code> line then names a folder whose files hold class names: the rsx components and the
                        glue. The output holds only the classes the components use. An app that runs its own Tailwind imports our theme
                        files and adds our folders to its own sources.
                    </p>
                    <CodePanel slug="guide-sources" tabs={&code["sources"]} />
                </section>

                <section id="theme" class="g-doc-section">
                    <h2 class="g-doc-h2">2. Map theme variables to tokens</h2>
                    <p>
                        <code class="g-code">@theme inline</code> defines the utilities. Each name reads a <code class="g-code">--ui-*</code>
                        variable, so <code class="g-code">bg-primary</code> compiles to <code class="g-code">background-color: var(--ui-primary)</code>.
                        The colour names are shadcn's; the extra names (<code class="g-code">h-control</code>, <code class="g-code">shadow-control</code>,
                        <code class="g-code">font-control</code>, <code class="g-code">rounded-badge</code>) carry what differs between the themes
                        beyond colour.
                    </p>
                    <div class="g-pane"><div class="g-pane-body"><GuideTokens /></div></div>
                    <CodePanel slug="guide-theme" tabs={&code["theme"]} />
                </section>

                <section id="themes" class="g-doc-section">
                    <h2 class="g-doc-h2">3. Give the tokens values, per theme</h2>
                    <p>
                        A theme file sets every <code class="g-code">--ui-*</code> variable under <code class="g-code">[data-ui-theme]</code>.
                        Each colour is a <code class="g-code">light-dark()</code> pair, so one file covers light and dark, and the system or
                        <code class="g-code">color-scheme</code> picks the side. This page uses the original theme.
                    </p>
                    <CodePanel slug="guide-themes" tabs={&code["themes"]} />
                </section>

                <section id="base" class="g-doc-section">
                    <h2 class="g-doc-h2">4. Set the base styles</h2>
                    <p>
                        The base layer sets the default border colour, the light/dark switch, the page colours of a themed subtree, the
                        backdrop of native dialogs, the fallback for anchored popovers, and the chart colours.
                    </p>
                    <CodePanel slug="guide-base" tabs={&code["base"]} />
                </section>

                <section id="motion" class="g-doc-section">
                    <h2 class="g-doc-h2">5. Add the motion classes</h2>
                    <p>
                        Five classes give overlays shadcn's motion in CSS: fade, zoom from 95% and a short slide. Exit states stay on screen
                        while they animate, through <code class="g-code">allow-discrete</code> transitions.
                    </p>
                    <div class="g-pane"><div class="g-pane-body"><GuideMotion /></div></div>
                    <CodePanel slug="guide-motion" tabs={&code["motion"]} />
                </section>

                <section id="rsx" class="g-doc-section">
                    <h2 class="g-doc-h2">6. Write the classes in rsx</h2>
                    <p>
                        Components write whole class names, in rsx or in a plain Rust function. Tailwind finds a class by scanning the source,
                        so it never sees one built with <code class="g-code">format!</code> from pieces.
                    </p>
                    <div class="g-pane"><div class="g-pane-body"><GuideRsx /></div></div>
                    <CodePanel slug="guide-rsx" tabs={&code["rsx"]} />
                </section>

                <section id="build" class="g-doc-section">
                    <h2 class="g-doc-h2">7. Build with the Tailwind CLI</h2>
                    <p>
                        mise pins the standalone Tailwind CLI. With the <code class="g-code">rebuild-assets</code> feature, build.rs runs it,
                        then brocanth-bundle (rolldown) bundles the glue. The outputs are committed, so an app needs neither Node nor the CLI.
                    </p>
                    <CodePanel slug="guide-build" tabs={&code["build"]} />
                </section>
            </article>
        {! LAYER_2.1 }</main>
    </Shell>
}

pub fn GuideTokens() -> Element {
    <div class="grid gap-4">
        <div class="grid grid-cols-3 gap-2 sm:grid-cols-6">
            <div class="grid gap-1"><div class="h-10 rounded-md bg-primary"></div><code class="text-xs text-muted-foreground">bg-primary</code></div>
            <div class="grid gap-1"><div class="h-10 rounded-md border bg-secondary"></div><code class="text-xs text-muted-foreground">bg-secondary</code></div>
            <div class="grid gap-1"><div class="h-10 rounded-md bg-muted"></div><code class="text-xs text-muted-foreground">bg-muted</code></div>
            <div class="grid gap-1"><div class="h-10 rounded-md bg-success"></div><code class="text-xs text-muted-foreground">bg-success</code></div>
            <div class="grid gap-1"><div class="h-10 rounded-md bg-warning"></div><code class="text-xs text-muted-foreground">bg-warning</code></div>
            <div class="grid gap-1"><div class="h-10 rounded-md bg-destructive"></div><code class="text-xs text-muted-foreground">bg-destructive</code></div>
        </div>
        <div class="flex flex-wrap items-center gap-3">
            <div class="flex h-control items-center rounded-md border bg-card px-3 text-sm font-control text-heading shadow-control">h-control · shadow-control · font-control</div>
            <Badge variant={BadgeVariant::Default}>rounded-badge</Badge>
            <div class="rounded-lg border bg-popover px-3 py-2 text-sm shadow-overlay">shadow-overlay</div>
        </div>
    </div>
}

pub fn GuideMotion() -> Element {
    <div class="grid gap-4 sm:grid-cols-2">
        <div>
            <PopoverTrigger target="guide-popover" variant={ButtonVariant::Outline}>Open a popover</PopoverTrigger>
            <PopoverContent id="guide-popover" label="Motion">
                <p class="text-sm">This panel uses <code>ui-pop</code>: fade, zoom from 95% and a 0.5rem slide.</p>
            </PopoverContent>
        </div>
        <Accordion>
            <AccordionItem name="guide-motion" title="ui-collapse" open={false}>The content grows to its height.</AccordionItem>
        </Accordion>
    </div>
}

pub fn GuideRsx() -> Element {
    <div class="flex flex-wrap items-center gap-2">
        <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[]}>Primary</Button>
        <Button variant={ButtonVariant::Secondary} size={ButtonSize::Md} attrs={&[]}>Secondary</Button>
        <button type="button" class="inline-flex h-control items-center rounded-md border border-input bg-background px-4 text-sm font-control text-heading shadow-control hover:bg-accent">Plain rsx, same classes</button>
    </div>
}
