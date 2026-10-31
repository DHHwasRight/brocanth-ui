# Punch list

These estimates are for one engineer who knows the stack. Each one includes
the rsx file, the glue file, the Stripe and shadcn tokens, a gallery entry,
and a check in `tests/browser.mjs`. Zag versions are pinned at 1.47.0.

**Fit** says how well the glue pattern from the README holds:
- ✅ The pattern holds as it is.
- ⚠️ It holds with a small extension to `defineComponent`.
- ❌ It breaks: Zag expects nodes that the server cannot render in advance.

## Done

| Component | Notes |
|---|---|
| Button, ButtonLink | Variants and sizes come from `variants.rs`. `attrs` passes `dp-*`, `type` and `disabled`. |
| Input, Label, Field | Field = label + control + hint. |
| Badge | Five variants. |
| Card | Header, content, footer. |
| Table | The header case, size and tracking are tokens. |
| Dialog, alert dialog | The full pipeline: rsx → Tailwind → rolldown → Zag glue → portal → dp-swap unmount and remount. Checked in Chromium. |

## To do

Ranked from easiest to hardest.

| # | Component | Zag package | Fit | Difficulty | Estimate | What it needs |
|---|---|---|---|---|---|---|
| 1 | Textarea, Checkbox, Switch, native Select | none | ✅ | Easy | 1–2 h total | Pure rsx + Tailwind. A styled native `<select>` covers most forms; see 8. |
| 2 | Tabs | `@zag-js/tabs` | ✅ | Easy | 2–3 h | Parts `list`, `trigger`, `content`, `indicator`. Per-item value: `(api, el) => api.getTriggerProps({ value: el.dataset.value })`. The server renders the default tab open and the others `hidden`. A tab that loads its panel from the server adds `dp-get` on the trigger. |
| 3 | Accordion | `@zag-js/accordion` | ✅ | Easy | 2–3 h | Parts `item`, `item-trigger`, `item-content`, `item-indicator`. The value comes from `el.closest('[data-part="item"]').dataset.value`. |
| 4 | Charts (line, bar, area, donut) | none: `d3set-ssr` | ✅ | Medium | 4–6 h | See "Charts" below. |
| 5 | Tooltip | `@zag-js/tooltip` | ⚠️ | Medium | 3–4 h | Positioning comes from `@zag-js/popper` (floating-ui), which writes the positioner's `style`. Portal the `positioner`. **Extension:** mount on the first `pointerenter`/`focusin` instead of on load, so a page with 200 tooltips does not start 200 machines. This is a boot change, ~20 lines. |
| 6 | Popover | `@zag-js/popover` | ✅ | Medium | 3–4 h | Same as Dialog, plus the popper. Portal the `positioner`. |
| 7 | Dropdown menu | `@zag-js/menu` | ⚠️ | Medium | 5–7 h | Items take `{ value }` from `data-value`. Checkbox and radio items take `{ type, value, checked }`, and the glue owns `checked` after mount. **Extension:** a submenu is a second machine linked with `api.setParent` / `setChild`, but the pattern assumes one machine per root. Add a `link(parent, child)` step for a nested `data-ui="menu"`. |
| 8 | Select (custom) | `@zag-js/select` | ⚠️ | Hard | 6–8 h | Zag needs a `collection` (`select.collection({ items })`) in JS, not only in the DOM. **Extension:** before `start()`, the glue reads `[data-part="item"]` nodes into the collection. For forms, rsx renders the hidden native `<select>` with its `<option>`s, and the glue spreads `getHiddenSelectProps()`. |
| 9 | Combobox | `@zag-js/combobox` | ❌ / ⚠️ | Hard | 1–1.5 days | Same collection rule as Select. Filtering has two modes: (a) on the client, filtering the collection read from the DOM; (b) **on the server with dp-swap**: `dp-get` on the input with `dp-trigger="input changed delay:200ms"` swaps the item list. **Break:** parts are collected at mount, so swapped items are unknown to the machine. **Workaround:** add `instance.refresh()` that re-reads the parts and calls `service.updateProps({ collection })`, and call it from `dp:afterSwap` when the swap target is inside a mounted root. |
| 10 | Toast | `@zag-js/toast` | ❌ | Hard | 1 day | **Break:** a toast does not exist until run time (`toaster.create()`), so no server markup holds it. Zag runs a group machine plus one machine per toast. **Workaround:** the layout renders the group region once, plus a `<template data-part="toast-template">`. The glue clones the template for each toast and spreads `getRootProps()` and the other parts. The server raises a toast with dpmutate's `DP-Trigger: {"ui:toast": {...}}` response header; the glue listens for `ui:toast`. |
| 11 | Calendar / date picker | `@zag-js/date-picker` (+ `@internationalized/date` peer) | ❌ | Hard | 1.5–2 days (Zag) or 4–6 h (server) | **Break:** the day grid comes from `api.weeks` and changes with each month change. The server cannot render every month. **Option A (recommended for display and booking calendars):** a pure rsx month grid. Prev and next are `dp-get="?month=2026-11"` links that swap the grid, so there is no Zag and no client state. **Option B (date-picker input):** the glue renders the grid from a `<template>` per cell. This breaks the "glue never creates nodes" rule, so keep it to this one component. |

Total for the rest: about 6–8 working days.

## Where Zag assumes DOM that rsx cannot produce

| Assumption | Components | Status |
|---|---|---|
| **Overlays render in a portal at the end of `<body>`.** React and Vue adapters wrap them in `<Portal>`, but rsx renders them next to the trigger. A parent's `transform` or `overflow` then clips them. | dialog, popover, tooltip, menu, select, combobox, date-picker | **Solved in general:** `portal: [...]` in `defineComponent` moves the parts at mount, copies `data-theme` and `.dark`, and puts them back on unmount (dp-swap safe). |
| **Items come from a JS collection.** Zag owns the list, but rsx renders it. | select, combobox, (listbox, tree-view) | Read the collection from `[data-part="item"]` before `start()`. A dp-swapped list needs `instance.refresh()` (to do, #9). |
| **Nodes are created at run time.** | toast, date-picker grid | Use a `<template>` that rsx renders, cloned by the glue (#10, #11). |
| **Linked machines.** | nested menu, (nested dialogs work as they are) | `link(parent, child)` (#7). |
| **Exit animations need Presence.** Zag sets `hidden` at once, and the adapters delay it through `@zag-js/presence`. | every overlay | To do: add a presence machine per overlay part in `defineComponent`, about 2 h once for all overlays. |
| **The same id on more than one node.** All close triggers get `dialog:<id>:close`. | dialog | Solved: only the `data-close-primary` node keeps the id. |

## Charts

Charts use **d3set-ssr**, a Rust crate inside the d3set repo. I read its
source, because it has no docs:

- `render(&Spec, &[Row], &Theme, width) -> Rendered`, then `.html()`. This
  gives SVG, rendered on the server, with no JS.
- `Spec::new("line" | "bar" | "area" | "donut").x("day").y("mrr").series("plan").format("$,.0f")`
- Every mark uses `fill`/`stroke: var(--d3s-series-N)`. Map the variables
  in `theme.css`, so the chart colours follow the theme:
  ```css
  [data-theme] { --d3s-series-0: var(--ui-chart-1); /* … 4 */ --d3s-text-muted: var(--ui-muted-foreground); --d3s-grid: var(--ui-border); }
  ```
- Use `render(..).html()`, not `static_figure`. `static_figure` writes the
  library's theme inline, and that beats the mapping above.
- Copy the axis rules (`.d3s-chart .tick text`, `.domain`) from
  `d3set/src/style.css` into `theme.css`.
- Wrap it as `Chart(spec, rows, width) -> Element` with `{! html }`.
- Hover tooltips and brush-to-zoom need d3set's TS `hydrate()` and d3 7.
  That is a separate lazy kind (`data-ui="chart"`), so pages without
  interactive charts pay nothing.
- **Dependency cost:** d3set-ssr pulls in `jt` from git. Its rsx must have
  the same git source as ours. Put it behind a `charts` feature.

## Follow-ups outside this repo

1. **brocanth:** `serve_asset` should take several asset tables. Today each
   app chains `brocanth_ui::assets::lookup` by hand. Record this as a gap in
   `docs/framework-gaps.md`.
2. **brocanth-cli:** add a `brocanth-ui` module (a `Module` behind a
   `scaffold` feature). It writes the dependency, the `serve_asset` line and
   `<UiHead />` into a new project.
3. **rsx:** components have no optional parameters, so every call writes
   `attrs={&[]}`. Defaults for `Option`/`Default` parameters would remove
   that noise.
