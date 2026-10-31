// The one glue pattern that every Zag-backed component uses.
//
// rsx renders the markup on the server. Each component root has
// `data-ui="<kind>"` and an `id`. Each node that Zag drives has
// `data-part="<part>"`. At mount, the glue:
//   1. runs `setup(root)` once: per-instance context, such as a collection
//      read from the item nodes,
//   2. starts the Zag machine with props from `props(root, ctx)`,
//   3. subscribes to it, and on every change calls connect() and spreads
//      each part's props (attributes and event handlers) onto its nodes.
//
// The glue never creates nodes; the server markup is the structure. The
// one exception is a portal: see `portal` below.

import type { Machine, MachineSchema, Service } from "@zag-js/core";
import { type Attrs, VanillaMachine, normalizeProps, spreadProps } from "@zag-js/vanilla";

export { normalizeProps };
import { type Instance, type Kind, instanceOf, setInstance } from "./instance";

/** The context every kind gets: `instance` is set once the machine runs. */
export interface Base {
  instance?: ZagInstance;
}

export interface ZagInstance extends Instance {
  readonly api: unknown;
  /** Reads the props again (after a dp-swap changed the items). */
  refresh(): void;
}

type Props<S extends MachineSchema> = Partial<S["props"]>;
type Part<Api, Ctx> = (api: Api, el: HTMLElement, ctx: Ctx) => Attrs;

export interface Spec<S extends MachineSchema, Api, C extends object> {
  machine: Machine<S>;
  /** `(service) => x.connect(service, normalizeProps)`: Zag's connect is generic, so each kind names it. */
  connect: (service: Service<S>) => Api;
  /** Runs once before the machine starts. Its result, plus `instance`, is `ctx`. */
  setup?: (root: HTMLElement) => C;
  /** Machine props from the server markup. `id` comes from `root.id`. */
  props: (root: HTMLElement, ctx: C & Base) => Props<S>;
  /** For each `data-part` name, the props to spread on each node with it. */
  parts: Record<string, Part<Api, C & Base>>;
  /**
   * Parts that move to `#ui-portal` at the end of <body>, for floating
   * content that a parent's `overflow` or `transform` would clip. They
   * take the theme with them and go back on unmount.
   */
  portal?: string[];
}

const portalOwner = new WeakMap<Element, HTMLElement>(); // portaled node -> root

// The glue part of a node, read from the server's `data-part` the first
// time the glue sees it. Zag's props write their own `data-part` (an
// option item becomes "item"), so a later read would get Zag's name.
const partOf = new WeakMap<Element, string>();

/** The glue part of a node: the server's `data-part`, as first seen. */
export function gluePart(el: HTMLElement): string | undefined {
  let part = partOf.get(el);
  if (part === undefined && el.dataset.part) {
    part = el.dataset.part;
    partOf.set(el, part);
  }
  return part;
}

/**
 * The root that owns a part: the nearest component root, or the root that
 * a portaled ancestor came from. This keeps a nested component's parts out
 * of its parent's lookup.
 */
export function ownerOf(el: Element): Element | null {
  const host = el.closest("[data-ui], [data-ui-portaled]");
  return host && (portalOwner.get(host) ?? host);
}

function portalLayer(): HTMLElement {
  let layer = document.getElementById("ui-portal");
  if (!layer) {
    layer = document.createElement("div");
    layer.id = "ui-portal";
    document.body.append(layer);
  }
  return layer;
}

export function defineComponent<S extends MachineSchema, Api, C extends object = object>(spec: Spec<S, Api, C>): Kind {
  return {
    mount(root) {
      const existing = instanceOf(root);
      if (existing) return existing;
      if (!root.id) throw new Error(`[brocanth-ui] <${root.tagName.toLowerCase()} data-ui="${root.dataset.ui}"> has no id`);

      const ctx = (spec.setup?.(root) ?? {}) as C & Base;
      // `ids.root` keeps the server's id on the root: Zag's getRootProps
      // would replace it with `<kind>:<id>`, and the app looks it up by id.
      const read = () => {
        const own = spec.props(root, ctx) as Props<S> & { ids?: object };
        return { id: root.id, ...own, ids: { root: root.id, ...own.ids } } as Props<S>;
      };
      let props = read();
      const service = new VanillaMachine(spec.machine, () => props);
      const cleanups = new Map<HTMLElement, () => void>(); // node -> cleanup of its last spread
      const moved: { node: HTMLElement; parent: ParentNode; next: ChildNode | null }[] = [];

      const partNodes = (): HTMLElement[] => {
        const found: HTMLElement[] = [];
        for (const scope of [root, ...moved.map((m) => m.node)]) {
          for (const el of [scope, ...scope.querySelectorAll<HTMLElement>("[data-part]")]) {
            const part = gluePart(el);
            if (part && part in spec.parts && ownerOf(el) === root) found.push(el);
          }
        }
        return found;
      };

      for (const part of spec.portal ?? []) {
        for (const node of partNodes().filter((el) => gluePart(el) === part)) {
          moved.push({ node, parent: node.parentNode!, next: node.nextSibling });
          portalOwner.set(node, root);
          node.setAttribute("data-ui-portaled", "");
          // The node leaves its themed subtree: take the theme and the
          // light/dark scheme with it.
          const themed = root.closest<HTMLElement>("[data-ui-theme]");
          if (themed?.dataset.uiTheme) node.setAttribute("data-ui-theme", themed.dataset.uiTheme);
          // Only a scheme that differs from the page's is pinned: the page's
          // own scheme reaches the portal layer anyway, and stays live.
          const scheme = getComputedStyle(root.parentElement ?? root).colorScheme;
          if (scheme !== getComputedStyle(document.body).colorScheme) node.style.colorScheme = scheme;
          portalLayer().append(node);
        }
      }

      const render = (): void => {
        const api = spec.connect(service.service);
        for (const el of partNodes()) {
          cleanups.set(el, spreadProps(el, spec.parts[gluePart(el)!](api, el, ctx)));
        }
      };

      service.start();
      const unsubscribe = service.subscribe(render);
      render();

      const instance: ZagInstance = {
        root,
        get api() {
          return spec.connect(service.service);
        },
        refresh() {
          props = read();
          service.updateProps(props);
          render();
        },
        unmount() {
          unsubscribe();
          service.stop();
          for (const cleanup of cleanups.values()) cleanup();
          // Reverse order: a node's recorded next sibling may itself have
          // been portaled, so it must be back in place first.
          for (const { node, parent, next } of moved.reverse()) {
            node.removeAttribute("data-ui-portaled");
            portalOwner.delete(node);
            // A dp-swap may have removed the root; then the node goes too.
            if (root.isConnected) parent.insertBefore(node, next?.parentNode === parent ? next : null);
            else node.remove();
          }
          setInstance(root, undefined);
        },
      };
      setInstance(root, instance);
      ctx.instance = instance;
      return instance;
    },
  };
}

/** Reads a boolean data attribute: absent gives `fallback`. */
export function flag(root: HTMLElement, name: string, fallback: boolean): boolean {
  const value = root.dataset[name];
  return value === undefined ? fallback : value !== "false";
}

/** Dispatches a bubbling `ui:<name>` event on the root. */
export function emit(root: HTMLElement, name: string, detail: unknown): void {
  root.dispatchEvent(new CustomEvent(`ui:${name}`, { detail, bubbles: true }));
}

/** One option of a list component, read from its node. */
export interface Item {
  value: string;
  label: string;
  disabled: boolean;
}

function ownedParts(root: Element, part: string): HTMLElement[] {
  return [...document.querySelectorAll<HTMLElement>(`[data-part="${part}"]`)].filter((el) => ownerOf(el) === root);
}

/**
 * The items of a list component, read from its `[data-part="item"]` nodes.
 * `label` is `data-label`, else the text.
 */
export function readItems(root: Element): Item[] {
  return ownedParts(root, "item").map((el) => ({
    value: el.dataset.value ?? "",
    label: el.dataset.label ?? el.textContent?.trim() ?? "",
    disabled: el.hasAttribute("data-disabled"),
  }));
}

/** The item for a node: the node itself or its `[data-part="item"]` ancestor. */
export function itemOf(items: Item[], el: Element): Item {
  const node = el.closest<HTMLElement>('[data-part="item"]');
  const item = items.find((candidate) => candidate.value === node?.dataset.value);
  if (!item) throw new Error(`[brocanth-ui] no item for ${el.outerHTML.slice(0, 80)}`);
  return item;
}

/**
 * Hides the item nodes whose label does not contain `query` (case and
 * accents ignored), and returns the items that stay visible.
 */
export function filterItems(root: Element, items: Item[], query: string): Item[] {
  const fold = (text: string) => text.normalize("NFD").replace(/\p{M}/gu, "").toLowerCase();
  const wanted = fold(query.trim());
  const visible = new Set(items.filter((item) => fold(item.label).includes(wanted)).map((item) => item.value));
  for (const el of ownedParts(root, "item")) el.hidden = !visible.has(el.dataset.value ?? "");
  for (const group of ownedParts(root, "item-group")) {
    group.hidden = !group.querySelector('[data-part="item"]:not([hidden])');
  }
  const empty = ownedParts(root, "empty")[0];
  if (empty) empty.hidden = visible.size > 0;
  return items.filter((item) => visible.has(item.value));
}

/** Calls `ours` after the handler Zag put under the same name, if any. */
export function also<P extends Attrs>(props: P, name: string, ours: (event: Event) => void): P {
  const theirs = props[name] as ((event: Event) => void) | undefined;
  return {
    ...props,
    [name]: (event: Event) => {
      theirs?.(event);
      ours(event);
    },
  };
}
