// Toaster glue (Zag `@zag-js/toast`). Markup: src/components/toast.rsx.
//
// Zag creates toasts at run time, so the server cannot render them. The
// layout renders one region with a <template> of a toast; the glue clones
// it for each toast and drives the clone with its own machine.
//
// Three ways to raise a toast:
// - Server markup: `<div data-toast data-title data-description data-type
//   hidden>` anywhere in a page or a dp-swap response (a flash message).
// - An event: `document.dispatchEvent(new CustomEvent("ui:toast",
//   { detail: { title, description, type } }))`. dpmutate's
//   `DP-Trigger: {"ui:toast": {...}}` response header does this.
// - A click on `[data-toast-trigger]` (ToastButton).
// - Code: `instanceOf<Toaster>(region).store.create({ ... })`.

import * as toast from "@zag-js/toast";
import { VanillaMachine, normalizeProps, spreadProps } from "@zag-js/vanilla";
import { type Instance, register } from "./instance";

export interface Toaster extends Instance {
  store: toast.Store;
}

interface Live {
  node: HTMLElement;
  data: toast.Options;
  machine: VanillaMachine<any>;
  props: Partial<toast.Props>;
  cleanups: Map<Element, () => void>;
}

export default {
  mount(root: HTMLElement): Toaster {
    const store = toast.createStore({
      placement: (root.dataset.placement ?? "bottom-end") as toast.Placement,
      overlap: true,
      max: 5,
    });
    const group = new VanillaMachine(toast.group.machine, { id: root.id, store });
    const region = root.querySelector<HTMLElement>('[data-part="group"]')!;
    const template = root.querySelector<HTMLTemplateElement>('template[data-part="template"]')!;
    const live = new Map<string, Live>();

    const renderToast = (entry: Live): void => {
      const api = toast.connect(entry.machine.service, normalizeProps);
      const spread = (part: string, props: object) => {
        for (const el of [entry.node, ...entry.node.querySelectorAll<HTMLElement>("[data-part]")]) {
          if (el.dataset.part === part) entry.cleanups.set(el, spreadProps(el, props));
        }
      };
      spread("root", api.getRootProps());
      spread("title", api.getTitleProps());
      spread("description", api.getDescriptionProps());
      spread("close-trigger", api.getCloseTriggerProps());
      // Write text only when it changes: Zag measures the toast with a
      // MutationObserver, and a rewrite would measure, render and rewrite
      // again, forever.
      setText(entry.node.querySelector('[data-part="title"]')!, String(api.title ?? ""));
      setText(entry.node.querySelector('[data-part="description"]')!, String(api.description ?? ""));
    };

    const sync = (): void => {
      const api = toast.group.connect(group.service, normalizeProps);
      spreadProps(region, api.getGroupProps());
      const toasts = api.getToasts();
      toasts.forEach((data, index) => {
        const props = { ...data, parent: group.service, index };
        let entry = live.get(data.id!);
        if (entry) {
          // Only on a real change: a toast writes its height back to the
          // group, so updating on every group change would loop.
          if (entry.data !== data || entry.props.index !== index) {
            entry.data = data;
            entry.props = props;
            entry.machine.updateProps(props);
          }
        } else {
          const node = template.content.firstElementChild!.cloneNode(true) as HTMLElement;
          region.append(node);
          const created: Live = { node, data, props, cleanups: new Map(), machine: undefined! };
          created.machine = new VanillaMachine(toast.machine, () => created.props);
          live.set(data.id!, created);
          created.machine.start();
          created.machine.subscribe(() => renderToast(created));
          entry = created;
        }
      });
      for (const [id, entry] of live) {
        if (!toasts.some((data) => data.id === id)) {
          entry.machine.stop();
          for (const cleanup of entry.cleanups.values()) cleanup();
          entry.node.remove();
          live.delete(id);
        }
      }
    };

    group.start();
    const unsubscribe = group.subscribe(sync);
    sync();

    const create = (detail: Partial<toast.Options>) => store.create({ type: "info", ...detail });
    // A toast that names a toaster goes only to that one.
    const mine = (target: string | undefined) => !target || target === root.id;
    const onEvent = (event: Event) => {
      const detail = (event as CustomEvent<Partial<toast.Options> & { toaster?: string }>).detail ?? {};
      if (mine(detail.toaster)) create(detail);
    };
    const consumeFlashes = (scope: ParentNode) => {
      for (const el of scope.querySelectorAll<HTMLElement>("[data-toast]")) {
        if (!mine(el.dataset.toaster)) continue;
        create({ title: el.dataset.title, description: el.dataset.description, type: el.dataset.type as toast.Type });
        el.remove();
      }
    };
    const onSwap = (event: Event) => consumeFlashes(event.target as Element);
    const onClick = (event: Event) => {
      const button = event.target instanceof Element ? event.target.closest<HTMLElement>("[data-toast-trigger]") : null;
      if (button && mine(button.dataset.toaster)) create({ title: button.dataset.title, description: button.dataset.description, type: button.dataset.type as toast.Type });
    };
    document.addEventListener("ui:toast", onEvent);
    document.addEventListener("click", onClick);
    document.addEventListener("dp:afterSwap", onSwap);
    consumeFlashes(document);

    return register(
      root,
      () => {
        document.removeEventListener("ui:toast", onEvent);
        document.removeEventListener("click", onClick);
        document.removeEventListener("dp:afterSwap", onSwap);
        unsubscribe();
        for (const entry of live.values()) entry.machine.stop();
        group.stop();
      },
      { store },
    );
  },
};

function setText(el: Element, text: string): void {
  if (el.textContent !== text) el.textContent = text;
}
