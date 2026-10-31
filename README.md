# brocanth-ui

Design-system components for brocanth apps. The inventory is shadcn/ui's.
Two themes ship: **shadcn/ui** (default) and **docs.stripe.com**. The
markup is the same for both; only CSS variables differ.

- **Markup:** rsx components, rendered on the server. There is no client VDOM.
- **Style:** Tailwind v4 classes that read theme variables.
- **Behaviour:** static components ship no JavaScript. Stateful components
  use a Zag.js machine through one small glue pattern. rolldown
  (`brocanth-bundle`) bundles the glue at build time.

```
mise run gallery        # both themes side by side, http://localhost:4100
mise run browser-test   # drives the dialogs in headless Chromium
```

## Status

| Component | State | JS |
|---|---|---|
| Button, ButtonLink | done | none |
| Input, Label, Field | done | none |
| Badge | done | none |
| Card | done | none |
| Table | done | none |
| **Dialog** (+ alert dialog) | **done, end to end** | Zag `dialog`, 20 KB gzip, loaded on first use |
| everything else | see [docs/punch-list.md](docs/punch-list.md) | |

## Layout

```
Cargo.toml                       workspace: the crate + the gallery
mise.toml                        toolchain (Rust 1.98, Tailwind 4.3.3, Node) and tasks
crates/brocanth-ui/
  build.rs                       feature `rebuild-assets`: Tailwind CLI + brocanth-bundle
  package.json                   Zag.js versions (sources for the bundle)
  styles/
    ui.css                       Tailwind entry for the shipped stylesheet
    theme.css                    Tailwind @theme: utility names -> --ui-* variables
    themes/shadcn.css            --ui-* values, shadcn (light + dark)
    themes/stripe.css            --ui-* values, Stripe docs (light + derived dark)
  src/
    lib.rs                       components module, variants, class helpers
    variants.rs                  ButtonVariant, ButtonSize, BadgeVariant -> class lists
    assets.rs                    brocanth_assets::assets!("assets", "public")
    components/*.rsx             button, input, badge, card, table, dialog, head
  assets/brocanth-ui/
    _boot.js                     glue entry (bundled to boot.js)
    _glue/zag.js                 the one glue pattern: defineComponent()
    _glue/dialog.js              dialog: machine + part map
    boot.js, ui.css              build outputs, committed
  public/brocanth-ui/chunks/     one chunk per kind, committed
examples/gallery/                static export: both themes side by side
tests/browser.mjs                headless Chromium checks for the glue
docs/punch-list.md               the remaining components, difficulty, Zag flags
```

## Use it in a brocanth app

1. Add the dependency. Use the same `rsx` source as the app, or rsx makes
   two `Template` traits.

   ```toml
   brocanth-ui = { git = "https://github.com/DHHwasRight/brocanth-ui.git", branch = "main" }
   ```

2. Serve the crate's files next to the app's own. Put this in `serve_asset`
   in `src/app.rs`:

   ```rust
   if let Some(asset) = brocanth_ui::assets::lookup(&request.path) {
       return Some(/* the same 200/304 response as for crate::assets */);
   }
   ```

   Every path starts with `/brocanth-ui/`, so it cannot collide with the
   app's own files. For a static export, also pass
   `brocanth_ui::assets::ASSETS` to `Export::assets`.

3. Put `<UiHead />` in the layout's `<head>`. It writes the stylesheet link
   and one `<script type="module">`. There is no inline script, so the
   default CSP needs no change.

4. Call the components:

   ```rust
   use brocanth_ui::components::button::Button;
   use brocanth_ui::components::dialog::{Dialog, DialogClose, DialogContent, DialogFooter, DialogTrigger};
   use brocanth_ui::{ButtonSize, ButtonVariant};

   pub fn Invite() -> Element {
       <Dialog id="invite" role="dialog">
           <DialogTrigger variant={ButtonVariant::Primary}>Invite</DialogTrigger>
           <DialogContent title="Invite a teammate" description="They get an email.">
               <DialogFooter>
                   <DialogClose variant={ButtonVariant::Outline}>Cancel</DialogClose>
                   <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[("dp-post", "/invites")]}>Send</Button>
               </DialogFooter>
           </DialogContent>
       </Dialog>
   }
   ```

   rsx rules that apply here:
   - Every parameter is required.
   - `attrs` takes `&[]` when you have none.
   - A cross-crate component that takes children needs a children block.

5. Pick the theme with `data-theme="stripe"` on `<html>` or on any subtree.
   Add `class="dark"` for dark mode.

### Two ways to get the CSS

| Mode | When | How |
|---|---|---|
| Shipped `ui.css` | The app does not run Tailwind, or uses brocanth-ui as a git dependency | `<UiHead />` |
| The app's own Tailwind | The app runs Tailwind and uses brocanth-ui as a **path** dependency | Import `styles/theme.css` and `styles/themes/*.css`, add `@source` for the crate's `src/` and `assets/brocanth-ui/_glue/`, then use `<UiScripts />` (see `examples/gallery/styles/gallery.css`) |

Do not point `@source` into `~/.cargo`, because the path changes with each
version. brocanth-admin has the same rule.

## Theming

Theming is only Tailwind config and CSS variables:

- `theme.css` maps every utility name to a `--ui-*` variable.
- A theme file sets those variables.
- Components never name a colour, radius or size directly.

The colour names are shadcn's, so a shadcn class list ports unchanged. The
Stripe look differs from shadcn in more than colour, so the token set adds
some names:

| Token (utility) | shadcn | docs.stripe.com |
|---|---|---|
| `--ui-primary` (`bg-primary`) | `oklch(0.205 0 0)`, near black | `#625afa`, blurple |
| `--ui-foreground` / `--ui-heading` | near black / near black | `#414552` / `#1a1b25` |
| `--ui-secondary` + `--ui-secondary-border` | grey fill, no border | white fill, `#d5dbe1` border |
| `--ui-shadow-control` (`shadow-control`) | `0 1px 2px rgb(0 0 0/.05)` | `0 1px 1px rgb(0 0 0/.12), 0 2px 5px rgb(60 66 87/.08)` |
| `--ui-shadow-overlay` (`shadow-overlay`) | Tailwind `shadow-lg` | `0 15px 35px rgb(60 66 87/.12), 0 5px 15px rgb(0 0 0/.12)` |
| `--ui-control-h` (`h-control`) | 36px | 32px |
| `--ui-weight-control` (`font-control`) | 500 | 600 |
| `--ui-radius-*` | 6 / 8 / 10 / 14px (from `--radius: .625rem`) | 4 / 6 / 8 / 10px |
| `--ui-radius-badge` (`rounded-badge`) | 8px | 4px |
| `--ui-table-head-*` | 14px, sentence case | 12px, uppercase, `0.04em`, `#687385` |
| `--ui-font-mono` | system mono | `Source Code Pro` |

Sources:
- The Stripe values are the Sail tokens that docs.stripe.com ships as CSS
  variables (read 2026-10-31).
- Stripe's text face, Sohne, needs a licence. The theme uses the system
  stack that the docs fall back to.
- The Stripe dark theme is derived from the same grey scale. Stripe did
  not publish it.

## The glue pattern

The server owns the structure, and Zag adds state and behaviour.

1. **The rsx markup:**
   - The root has `data-ui="<kind>"` and a unique `id`.
   - Each node that Zag drives has `data-part="<part>"`.
   - The server renders the closed state (`hidden`, `data-state="closed"`),
     so the page is correct before the JS loads.
2. **`_boot.js`** (about 1 KB once built):
   - On load, it finds every `[data-ui]` and imports `./_glue/<kind>.js`.
     Each import is its own chunk, loaded on first use.
   - It mounts on `dp:afterSwap`.
   - It unmounts on `dp:beforeSwap`, but only for the swap styles that
     remove nodes.
3. **`_glue/zag.js`** has `defineComponent({ machine, connect, props, parts, portal })`. On mount, it:
   - starts a `VanillaMachine` with props from the root's `data-*` attributes,
   - subscribes to it,
   - on each change, calls `connect()` and runs `spreadProps()` on every
     `[data-part]` node that the root owns.

   A part function takes `(api, el)`, so per-item props come from
   `el.dataset` (tabs, menu items).
4. **One file per kind.** `_glue/dialog.js` is 46 lines: the machine, the
   props, a part map, and `portal: ["backdrop", "positioner"]`.

To add a kind:
1. Add the package to `crates/brocanth-ui/package.json`.
2. Write `_glue/<kind>.js`.
3. Add one line to `kinds` in `_boot.js`.
4. Write the rsx file.
5. Run `mise run assets`.

## Build

The built files are **committed**: `ui.css`, `boot.js` and the chunks. An
app that depends on the crate does not need Node or the Tailwind CLI, and it
does not compile rolldown.

`mise run assets` builds with `--features rebuild-assets`:

1. The Tailwind CLI compiles `styles/ui.css`. Only the paths that the
   `@source` lines name are scanned.
2. `brocanth_bundle::build()` runs rolldown on `_boot.js`, using Zag from
   `node_modules`. rolldown replaces `process.env.NODE_ENV` for the browser
   platform.
3. `assets!` embeds both folders. `boot.js` gets a fingerprint. The chunks
   keep rolldown's hashed names, because the entry imports them by
   relative URL.

`mise run setup` installs the npm packages once.

## Decisions

- **Committed build outputs, behind a feature.** brocanth-admin commits its
  CSS for the same reason. An app's build must not need Node, and it must
  not compile rolldown for files that never change in the app.
- **No static import in `_boot.js`.** A module that the entry shares with a
  chunk makes the chunk import the entry back. The entry's name is
  fingerprinted, so `brocanth-bundle` refuses that. The entry finds
  instances through `Symbol.for("brocanth-ui.instance")` on the root.
- **Overlays are portaled by the glue.** rsx renders an overlay next to its
  trigger. Any ancestor with `transform`, `filter` or `overflow: hidden`
  would clip or misplace a `position: fixed` overlay. The glue moves the
  listed parts to `#ui-portal` and copies `data-theme` and `.dark` onto
  them. On unmount, it puts them back, or removes them if a swap removed
  the root.
- **The close-trigger id goes to one node.** Zag gives every close trigger
  the same id, and an alert dialog focuses that id on open. The footer
  `DialogClose` (`data-close-primary`) keeps the id, because it is the safe
  action.
- **`Button` defaults to `type="button"`.** A button in a form then does not
  submit it by accident. `attrs={&[("type", "submit")]}` overrides it.

## Known gaps

- **Exit animations.** Zag sets `hidden` as soon as an overlay closes, so
  only the enter animation runs. The fix is `@zag-js/presence` per overlay
  part, in `defineComponent`.
- **Serving files from more than one crate.** brocanth has no seam for
  this, so each app chains `lookup` by hand. Widen `serve_asset` in the
  brocanth CLI template to take several asset tables.
