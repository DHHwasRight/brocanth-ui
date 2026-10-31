// Command palette glue (Zag `@zag-js/listbox` with its filter input).
// Markup: src/components/command.rsx. Typing filters the items; the arrow
// keys move the highlight from the input; Enter runs the item: a link item
// navigates, any item emits `ui:select` with `{ value }`.
// Put it in a Dialog for a ⌘K palette.

import * as listbox from "@zag-js/listbox";
import { type Item, also, defineComponent, emit, filterItems, itemOf, ownerOf, readItems, normalizeProps } from "./zag";

export default defineComponent({
  machine: listbox.machine,
  connect: (service) => listbox.connect(service, normalizeProps),
  setup: (root) => {
    const items = readItems(root);
    return { items, visible: items };
  },
  props: (root, ctx) => ({
    collection: listbox.collection<Item>({
      items: ctx.visible,
      itemToValue: (item) => item.value,
      itemToString: (item) => item.label,
      isItemDisabled: (item) => item.disabled,
    }),
    selectionMode: "single" as const,
    loopFocus: true,
    onSelect: ({ value }) => {
      const node = [...document.querySelectorAll<HTMLElement>('[data-part="item"]')].find(
        (el) => el.dataset.value === value && ownerOf(el) === root,
      );
      const link = node?.closest("a") ?? node?.querySelector("a");
      link?.click();
      emit(root, "select", { value });
    },
  }),
  parts: {
    root: (api) => api.getRootProps(),
    input: (api, el, ctx) =>
      also(api.getInputProps({ autoHighlight: true }), "onInput", () => {
        ctx.visible = filterItems(ctx.instance!.root, ctx.items, (el as HTMLInputElement).value);
        queueMicrotask(() => ctx.instance!.refresh());
      }),
    content: (api) => api.getContentProps(),
    item: (api, el, ctx) => api.getItemProps({ item: itemOf(ctx.items, el), highlightOnHover: true }),
    "item-group": (api, el) => api.getItemGroupProps({ id: el.dataset.group! }),
    "item-group-label": (api, el) => api.getItemGroupLabelProps({ htmlFor: el.dataset.group! }),
  },
});
