# brocanth-ui

Every shadcn/ui component for brocanth apps, with as little JavaScript as
possible. Two themes ship: **shadcn/ui** (default) and **original**.
The markup is the same for both; only CSS variables differ.

- **Markup:** rsx components, rendered on the server. There is no client VDOM.
- **Style:** Tailwind v4 classes that read theme variables. Every colour is a
  `light-dark()` pair, so dark mode follows the system or `color-scheme`.
- **Behaviour, in this order of preference:**
  1. HTML and CSS: `<dialog>`, `popover`, invoker commands, anchor
     positioning, `<details name>`, `:has()`. 45 of 56 components.
  2. A small TypeScript glue file, under 1 KB: carousel, date picker.
  3. A Zag.js machine, loaded the first time a page renders that kind:
     menus, select, combobox, command, tabs, toast, resizable panels.

Live gallery: **https://dhhwasright.github.io/brocanth-ui/**, built and
checked by `.github/workflows/gallery.yml` on every push to `main`. It has
two tabs:

- **Components**: every component under both themes, with its code.
- **Utilities**: Tailwind's utility pages from Layout onwards (184), each
  with a quick reference compiled through our configuration, a live example
  under the original theme, and its rsx. Its first page, Configuration,
  walks through what we pass to the Tailwind CLI.
- **Charts**: the d3set chart gallery, Rust version (d3set-ssr): 24 chart
  kinds rendered on the server as SVG and HTML, in our theme's colours, each
  with its spec and template.

brocanth-static exports every page as a document and as partials; with
JavaScript, dp-swap loads only the part of the page that changes.

```
mise run setup          # npm packages: Zag for the bundle, TypeScript, Playwright
mise run gallery        # the three tabs, http://localhost:4100
mise run browser-test   # 47 checks in headless Chromium and WebKit
```

See [docs/components.md](docs/components.md) for each component's JS cost,
and where Zag's DOM expectations needed a workaround.

## Layout

```
Cargo.toml                    workspace: the crate + the gallery
mise.toml                     Rust 1.98, Tailwind 4.3.3, Node; tasks
crates/brocanth-ui/
  build.rs                    feature `rebuild-assets`: Tailwind CLI + brocanth-bundle (rolldown)
  package.json, tsconfig.json Zag 1.47.0 and TypeScript 7, for the bundle and `mise run typecheck`
  styles/
    ui.css                    Tailwind entry for the shipped stylesheet
    theme.css                 @theme: utility names -> --ui-* variables; native overlay and chart rules
    themes/shadcn.css         --ui-* values, light-dark() pairs
    themes/original.css       --ui-* values: purple brand, cool greys (light), d3set gallery navy (dark)
  src/
    components/*.rsx          56 components, one file per shadcn component (or family)
    charts/chart.rsx          Chart (feature `charts`, d3set-ssr)
    variants.rs, icons.rs     button/badge/input classes; inline Lucide icons
    date.rs                   civil dates for the calendar, no dependency
    assets.rs                 brocanth_assets::assets!("assets", "public")
  assets/brocanth-ui/
    _boot.ts                  entry: mounts [data-ui] kinds, dp-swap hooks, two platform shims
    _glue/zag.ts              the one Zag pattern: defineComponent()
    _glue/<kind>.ts           tabs, menu, select, combobox, command, resizable, toaster;
                              carousel and date-picker (no Zag)
    boot.js, ui.css           build outputs, committed
  public/brocanth-ui/chunks/  one chunk per kind + shared Zag chunks, committed
examples/gallery/             the static site: Components and Utilities tabs, d3set gallery layout,
                              code highlighted by giallo
  data/utilities.json         the utility pages and their class names (scripts/utility-index.mjs)
  src/reference.rs            reads each class's compiled CSS back from build.rs's reference.css
  src/views/u_*.rsx           one example per utility page, by category
tests/browser.mjs             47 checks in headless Chromium and WebKit
docs/components.md            JS cost per component, Zag workarounds, known gaps
```

## Use it in a brocanth app

1. Add the dependency, with the same `rsx` source as the app:

   ```toml
   brocanth-ui = { git = "https://github.com/DHHwasRight/brocanth-ui.git", branch = "main" }
   # features = ["charts"] for the Chart component (brings d3set-ssr and jt)
   ```

2. Serve the crate's files next to the app's own, in `serve_asset`:

   ```rust
   if let Some(asset) = brocanth_ui::assets::lookup(&request.path) {
       return Some(/* the same 200/304 response as for crate::assets */);
   }
   ```

   Every path starts with `/brocanth-ui/`. For a static export, also pass
   `brocanth_ui::assets::ASSETS` to `Export::assets`.

3. Put `<UiHead />` in the layout's `<head>`: one stylesheet, one
   `<script type="module">`, no inline script (the default CSP holds).
   With a toast, add `<Toaster id="toaster" placement="bottom-end" />` to
   the layout.

4. Call the components:

   ```rust
   use brocanth_ui::components::dialog::{Dialog, DialogClose, DialogFooter, DialogTrigger};
   use brocanth_ui::components::button::Button;
   use brocanth_ui::{ButtonSize, ButtonVariant};

   <DialogTrigger target="invite" variant={ButtonVariant::Primary}>Invite</DialogTrigger>
   <Dialog id="invite" title="Invite a teammate" description="They get an email.">
       <form dp-post="/invites" class="grid gap-4">
           <DialogFooter>
               <DialogClose target="invite" variant={ButtonVariant::Outline}>Cancel</DialogClose>
               <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[("type", "submit")]}>Send</Button>
           </DialogFooter>
       </form>
   </Dialog>
   ```

   rsx rules: every parameter is required (`attrs={&[]}` when you have
   none), and a cross-crate component that takes children needs a children
   block. Ids that name an anchor (popover, tooltip, hover card, menus)
   must be CSS identifiers: letters, digits, `-`, `_`.

5. Pick the theme with `data-ui-theme="original"` on `<html>` or any subtree.
   Dark mode follows the system; `class="dark"` or `data-theme="dark"` on
   any ancestor forces it.

### Two ways to get the CSS

| Mode | When | How |
|---|---|---|
| Shipped `ui.css` | The app does not run Tailwind, or uses brocanth-ui as a git dependency | `<UiHead />` |
| The app's own Tailwind | The app runs Tailwind and uses brocanth-ui as a **path** dependency | Import `styles/theme.css` and `styles/themes/*.css`, `@source` the crate's `src/` and `assets/brocanth-ui/_glue/`, use `<UiScripts />`. See `examples/gallery/styles/gallery.css`. |

## Theming

Theming is Tailwind config and CSS variables only. `theme.css` maps every
utility to a `--ui-*` variable; a theme file sets the variables; components
never name a colour, radius or size. Every colour is a `light-dark()` pair,
so one theme file covers light and dark.

| Token | shadcn | original |
|---|---|---|
| `--ui-primary` | near black / near white | `#625afa` / `#9d97ff` |
| `--ui-background` (dark) | `oklch(0.145 0 0)` | `#0a1929` (d3set navy) |
| `--ui-secondary` + `-border` | grey fill, no border | white fill, `#d5dbe1` border |
| `--ui-shadow-control` | `0 1px 2px rgb(0 0 0/.05)` | `0 1px 1px rgb(0 0 0/.12), 0 2px 5px rgb(60 66 87/.08)` |
| `--ui-control-h` | 36px | 32px |
| `--ui-weight-control` | 500 | 600 |
| `--ui-radius-*` | 6 / 8 / 10 / 14px | 4 / 6 / 8 / 10px |
| `--ui-tabs-*` | a pill on a muted track | an underline on a divider |
| `--ui-table-head-*` | 14px, sentence case | 12px, uppercase, tracked, muted |
| `--ui-tooltip` | the primary colour | near black, in both schemes |
| `--ui-chart-1..5` | shadcn's chart palette | purple, blue, lavender, orange, green |

Charts follow the theme too: `theme.css` maps d3set's `--d3s-series-N` to
`--ui-chart-N`.

## Motion

The animations match shadcn's (tw-animate-css), in CSS only. Five classes
in `theme.css` carry them:

| Class | Components | Motion |
|---|---|---|
| `ui-modal` | Dialog, Alert dialog | fade + zoom from 95%, 200ms; backdrop fades |
| `ui-sheet` + `data-side` | Sheet, Drawer | slide from the edge, 500ms in, 300ms out |
| `ui-pop` | Popover, Navigation menu, Date picker, Dropdown/Context menu, Menubar, Select, Combobox | fade + zoom from 95% + 0.5rem slide from the anchor side, 150ms |
| `ui-float` | Tooltip, Hover card | fade + zoom, 150ms |
| `ui-collapse` | Accordion, Collapsible | height grows to the content, 200ms |

Enter states come from `@starting-style`. Exit states stay on screen while
they animate, because `display` and `overlay` transition with
`allow-discrete`: this works for native overlays and for Zag content (its
`hidden` attribute), so Zag needs no presence machine. The accordion
animates a `grid-template-rows` change (0fr to 1fr) on `::details-content`,
which works in Chromium, Safari and Firefox. `prefers-reduced-motion` turns every transition off.

## The glue pattern (TypeScript)

The server owns the structure; Zag adds state and behaviour.

1. **rsx markup:** the root has `data-ui="<kind>"` and a unique `id`; each
   node Zag drives has `data-part`. The server renders the initial state, so
   the page is right before the glue loads.
2. **`_boot.ts`** (1.1 KB): mounts each `[data-ui]` root, importing
   `_glue/<kind>.ts` on first use; unmounts before a dp-swap that removes
   nodes, mounts after. It has no static import, so no chunk imports the
   entry back. It also holds two platform shims (`closedby`, tooltip
   Escape).
3. **`_glue/zag.ts`**: `defineComponent({ machine, connect, setup, props,
   parts, portal })`, typed against Zag's own types. `setup` builds
   per-instance context (a collection read from the item nodes); `parts`
   maps each `data-part` to `(api, el, ctx) => attrs`.
4. **One file per kind**, 25 to 60 lines. To add one: add the package to
   `crates/brocanth-ui/package.json`, write `_glue/<kind>.ts`, add a line
   to `kinds` in `_boot.ts`, write the rsx, run `mise run assets`.

## Build

The built files are committed, so an app needs neither Node nor the
Tailwind CLI, and does not compile rolldown. `mise run assets`:

1. type-checks the glue (`tsc --noEmit`, TypeScript 7),
2. runs the Tailwind CLI on `styles/ui.css`,
3. runs `brocanth_bundle::build()`: rolldown compiles `_boot.ts` and the
   glue, with Zag from `node_modules`, into `boot.js` and the chunks.

## Decisions

- **The platform first, Zag last.** A component uses Zag only where HTML
  and CSS have no answer. Invoker commands (Baseline Dec 2025) and anchor
  positioning (Baseline Jan 2026) took dialog, sheet, popover, tooltip and
  hover card off Zag; `<details name>` took the accordion.
- **Native overlays need no portal.** `<dialog>` and `popover` render in
  the top layer, so no ancestor clips them, and they keep their DOM place,
  so they inherit the theme.
- **`data-ui-theme`, not `data-theme`.** d3set and the artifact viewer put
  `data-theme="light|dark"` on `<html>`; the design-system theme must not
  collide with it.
- **Zag owns ids and parts, the server keeps them.** The glue passes
  `ids.root` and records each node's part at mount.
- **Committed build outputs, behind a feature.** As brocanth-admin does.

See [docs/components.md](docs/components.md) for the known gaps.
