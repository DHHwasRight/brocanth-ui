# Components

All 56 shadcn/ui components, with what each one costs in the browser.
Sizes are gzip. A Zag "total" includes the shared Zag core (machine,
DOM helpers, dismiss layer, popper), which the browser downloads once per
page. Measured on 2026-10-31, Zag 1.47.0.

| Tier | Count | What runs in the browser |
|---|---|---|
| **No JS** | 45 | HTML, CSS and platform features. Nothing to download. |
| **Glue** | 2 | A small TypeScript file, no Zag: carousel 0.5 KB, date picker 0.4 KB. |
| **Zag** | 9 | A Zag machine, loaded the first time a page renders that kind. |

Every page loads `boot.js` (1.1 KB) and `ui.css` (11.1 KB).

## No JS: the platform does it

| Component | How |
|---|---|
| Dialog, Alert dialog, Sheet, Drawer | `<dialog>` opened by `commandfor` + `command="show-modal"` (invoker commands, Baseline Dec 2025). Top layer, focus trap, Escape, `inert` page, focus return. `closedby="any"` closes on an outside click; alert dialogs use `closedby="closerequest"`. boot.ts adds `closedby` where an engine lacks it. |
| Popover, Navigation menu | `popover` attribute + `command="toggle-popover"`, placed with CSS anchor positioning (Baseline Jan 2026); `position-try-fallbacks` flips it at the viewport edge. Without anchor positioning it centres on the screen. |
| Tooltip, Hover card | CSS `:hover` / `:focus-within` + anchor positioning, with a delay. boot.ts hides a tooltip on Escape (WCAG 1.4.13). |
| Accordion, Collapsible | `<details>` / `<summary>`; `name` makes items exclusive. Find-in-page opens the matching item. |
| Toggle, Toggle group, Switch, Checkbox, Radio group | Native checkboxes and radios, drawn with `appearance: none` and `:has()`. The state posts with the form. |
| Sidebar | A checkbox drawn as the trigger; the layout reads it with `:has()`. |
| Calendar | Server-rendered month. Days are radios; previous and next are links that dp-swap the calendar (`dp-select`). |
| Data table, Pagination | Sort, filter and page are links and forms the server answers. |
| Input OTP | One input drawn as slots: paste and `autocomplete="one-time-code"` work. |
| Slider | `<input type="range">`; `accent-color` fills the track. |
| Chart | d3set-ssr renders SVG on the server (feature `charts`). |
| Everything else | Plain HTML and Tailwind classes. |

## Glue (TypeScript, no Zag)

| Component | Size | Why it needs code |
|---|---|---|
| Carousel | 0.5 KB | Scroll-snap works alone; the buttons need `scrollBy`. Without JS the buttons stay hidden. |
| Date picker | 0.4 KB | Writes the chosen date into the trigger and closes the popover. Without JS the calendar still works in the popover. |

## Zag

| Kind | Components | Own | Total | Why the platform is not enough |
|---|---|---|---|---|
| `tabs` | Tabs | 3.2 KB | 15.2 KB | Roving focus and arrow keys between tabs. |
| `menu` | Dropdown menu, Context menu, Menubar | 8.6 KB | 37.6 KB | Arrow keys, typeahead, checkbox and radio items, context trigger. |
| `select` | Select | 6.4 KB | 37.4 KB | A styled list with typeahead. `appearance: base-select` would replace it once it is Baseline. |
| `combobox` | Combobox | 8.2 KB | 38.6 KB | Filtering with keyboard navigation over the filtered list. |
| `command` | Command | 5.3 KB | 21.3 KB | `@zag-js/listbox` with its filter input. |
| `resizable` | Resizable | 8.2 KB | 20.5 KB | Pointer drag and keyboard resize. |
| `toaster` | Toast | 8.1 KB | 24.5 KB | Toasts exist only at run time: stacking, timers, pause on hover. |

## Where Zag expects DOM that rsx does not render

| Zag expects | Kinds | What the glue does |
|---|---|---|
| Floating content in a portal at the end of `<body>` | menu, select, combobox | `portal: ["positioner"]` moves the node at mount, copies `data-ui-theme` (and the colour scheme, if it differs from the page's), and puts it back on unmount. A dp-swap that removes the root removes the node too. |
| Its own `id` and `data-part` on every node | all | `ids.root` keeps the server's root id. The glue records each node's part at mount, because Zag renames some (an option item becomes `item`). |
| Items as a JS collection | select, combobox, command | `readItems()` builds the collection from the `[data-part="item"]` nodes. Filtering hides nodes and shrinks the collection. After a dp-swap of the items, call `instanceOf(root).refresh()`. |
| Nodes created at run time | toaster | The layout renders a `<template>`; the glue clones it per toast. The server raises a toast with `<Toast>` markup, a `ui:toast` event, or dpmutate's `DP-Trigger` header. |
| Text rendered by the framework | select (value text), toaster | The glue writes the text, and only when it changes: Zag's toast measures with a MutationObserver, so a rewrite would loop. |

## Known gaps

- **Drawer drag-to-dismiss.** The handle is drawn only. Escape, the backdrop and the buttons close it.
- **Two-thumb slider.** The native range has one thumb. `@zag-js/slider` covers a range.
- **Submenus.** A nested menu needs a second machine linked with `setParent`/`setChild`. The glue has one machine per root.
- **Menubar arrow keys between menus.** Each menu works with the keyboard; Left/Right does not move to the next menu.
- **Sidebar state across reloads.** The server must render `collapsed` from a cookie or a setting.
- **Exit animation of native overlays in Firefox.** `transition-behavior: allow-discrete` on `overlay` is Chromium and Safari only; Firefox closes at once.
