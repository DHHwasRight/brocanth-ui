// The one glue pattern that every Zag-backed component uses.
//
// rsx renders the markup on the server. Each component root has
// `data-ui="<kind>"` and an `id`. Each node that Zag drives has
// `data-part="<part>"`. At mount, the glue:
//   1. starts the Zag machine with props read from the root's data-* attributes,
//   2. subscribes to it,
//   3. on every change, calls connect() and spreads each part's props
//      (attributes and event handlers) onto the matching nodes.
//
// The glue never creates or removes nodes. Server markup stays the source
// of structure, and Zag adds state and behaviour. The one exception is a
// portal: see `portal` below.

import { VanillaMachine, normalizeProps, spreadProps } from "@zag-js/vanilla";

// The instance lives on its root under a well-known symbol, so _boot.js
// can find it without importing this module (see _boot.js).
const INSTANCE = Symbol.for("brocanth-ui.instance");
const portalOwner = new WeakMap(); // node moved to the portal layer -> root

// The element that owns a part: the nearest component root, or the root
// that a portaled ancestor came from. This keeps a nested component's
// parts out of its parent's lookup.
function ownerOf(el) {
  const host = el.closest("[data-ui], [data-ui-portaled]");
  return host && (portalOwner.get(host) ?? host);
}

function portalLayer() {
  let layer = document.getElementById("ui-portal");
  if (!layer) {
    layer = document.createElement("div");
    layer.id = "ui-portal";
    document.body.append(layer);
  }
  return layer;
}

/**
 * Describes one component kind.
 *
 * @param {object} spec
 * @param {object} spec.machine   The Zag machine (`dialog.machine`).
 * @param {Function} spec.connect The Zag connect function (`dialog.connect`).
 * @param {(root: HTMLElement) => object} spec.props
 *        Machine props from the server markup. `id` is added from `root.id`.
 * @param {Record<string, (api: object, el: HTMLElement) => object>} spec.parts
 *        For each `data-part` name, the props to spread on each node with that
 *        name. `el` gives per-item props (tabs, menu items) from `el.dataset`.
 * @param {string[]} [spec.portal]
 *        Parts that the glue moves to `#ui-portal` at the end of <body>. Use it
 *        for overlays that must escape a parent's `overflow`, `transform` or
 *        stacking context. The nodes go back to the root on unmount.
 * @param {(root: HTMLElement, api: object) => void} [spec.onRender]
 *        Optional hook after each render (for example, exit animations).
 */
export function defineComponent(spec) {
  return {
    mount(root) {
      if (root[INSTANCE]) return root[INSTANCE];
      if (!root.id) throw new Error(`[brocanth-ui] <${root.tagName.toLowerCase()} data-ui="${root.dataset.ui}"> has no id`);

      const service = new VanillaMachine(spec.machine, () => ({ id: root.id, ...spec.props(root) }));
      const cleanups = new Map(); // node -> cleanup of its last spread
      const moved = [];

      // Find the parts before the portal moves any of them.
      const searchRoots = () => [root, ...moved.map((m) => m.node)];
      const partNodes = () => {
        const found = [];
        for (const scope of searchRoots()) {
          const candidates = [scope, ...scope.querySelectorAll("[data-part]")];
          for (const el of candidates) {
            if (el.dataset.part in spec.parts && ownerOf(el) === root) found.push(el);
          }
        }
        return found;
      };

      for (const part of spec.portal ?? []) {
        for (const node of partNodes().filter((el) => el.dataset.part === part)) {
          moved.push({ node, parent: node.parentNode, next: node.nextSibling });
          portalOwner.set(node, root);
          node.setAttribute("data-ui-portaled", "");
          // The portaled node leaves the themed subtree, so copy the theme.
          const themed = root.closest("[data-theme]");
          if (themed) node.setAttribute("data-theme", themed.dataset.theme);
          if (root.closest(".dark")) node.classList.add("dark");
          portalLayer().append(node);
        }
      }

      const render = () => {
        const api = spec.connect(service.service, normalizeProps);
        for (const el of partNodes()) {
          cleanups.set(el, spreadProps(el, spec.parts[el.dataset.part](api, el)));
        }
        spec.onRender?.(root, api);
        return api;
      };

      service.start();
      const unsubscribe = service.subscribe(render);
      render();

      const instance = {
        root,
        service,
        get api() {
          return spec.connect(service.service, normalizeProps);
        },
        unmount() {
          unsubscribe();
          service.stop();
          for (const cleanup of cleanups.values()) cleanup();
          // Reverse order: a node's recorded next sibling may itself have
          // been portaled (the backdrop's is the positioner), so it must be
          // back in place first.
          for (const { node, parent, next } of moved.reverse()) {
            node.removeAttribute("data-ui-portaled");
            portalOwner.delete(node);
            // A dp-swap may have removed the root; then the overlay goes too.
            if (root.isConnected) parent.insertBefore(node, next?.parentNode === parent ? next : null);
            else node.remove();
          }
          delete root[INSTANCE];
        },
      };
      root[INSTANCE] = instance;
      return instance;
    },
  };
}

/** The mounted instance for a root element, if any. */
export function instanceOf(root) {
  return root[INSTANCE];
}

/** Reads a boolean data attribute: absent gives `fallback`. */
export function flag(root, name, fallback) {
  const value = root.dataset[name];
  return value === undefined ? fallback : value !== "false";
}

/** Dispatches a bubbling `ui:<name>` event on the root. */
export function emit(root, name, detail) {
  root.dispatchEvent(new CustomEvent(`ui:${name}`, { detail, bubbles: true }));
}
