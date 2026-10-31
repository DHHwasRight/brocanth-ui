// Combobox glue (Zag `@zag-js/combobox`). Markup: src/components/combobox.rsx.
//
// The items come from the `[data-part="item"]` nodes. Typing filters them
// on the client: a node that does not match gets `hidden`, and the
// collection shrinks to the visible items, so the arrow keys skip the
// others. For a list too long to send, filter on the server instead:
// dp-swap the item list and call `instanceOf(root).refresh()`.
// A hidden input (`data-part="value-input"`) posts the value.
// Events: `ui:value-change` with `{ value: string[] }`.

import * as combobox from "@zag-js/combobox";
import { type Item, defineComponent, emit, filterItems, itemOf, readItems, normalizeProps } from "./zag";

export default defineComponent({
  machine: combobox.machine,
  connect: (service) => combobox.connect(service, normalizeProps),
  setup: (root) => {
    const items = readItems(root);
    return { items, visible: items };
  },
  props: (root, ctx) => ({
    collection: combobox.collection<Item>({
      items: ctx.visible,
      itemToValue: (item) => item.value,
      itemToString: (item) => item.label,
      isItemDisabled: (item) => item.disabled,
    }),
    defaultValue: root.dataset.value ? [root.dataset.value] : [],
    defaultInputValue: ctx.items.find((item) => item.value === root.dataset.value)?.label ?? "",
    placeholder: root.dataset.placeholder,
    openOnClick: true,
    positioning: { sameWidth: true, gutter: 4 },
    onInputValueChange: ({ inputValue }) => {
      ctx.visible = filterItems(root, ctx.items, inputValue);
      queueMicrotask(() => ctx.instance?.refresh());
    },
    onOpenChange: ({ open }) => {
      // Reopening shows every item again.
      if (open && ctx.visible.length !== ctx.items.length) {
        ctx.visible = filterItems(root, ctx.items, "");
        queueMicrotask(() => ctx.instance?.refresh());
      }
    },
    onValueChange: ({ value }) => {
      const input = root.querySelector<HTMLInputElement>('[data-part="value-input"]');
      if (input) input.value = value[0] ?? "";
      emit(root, "value-change", { value });
    },
  }),
  parts: {
    root: (api) => api.getRootProps(),
    label: (api) => api.getLabelProps(),
    control: (api) => api.getControlProps(),
    input: (api) => api.getInputProps(),
    trigger: (api) => api.getTriggerProps(),
    positioner: (api) => api.getPositionerProps(),
    content: (api) => api.getContentProps(),
    item: (api, el, ctx) => api.getItemProps({ item: itemOf(ctx.items, el) }),
    "item-text": (api, el, ctx) => api.getItemTextProps({ item: itemOf(ctx.items, el) }),
    "item-indicator": (api, el, ctx) => api.getItemIndicatorProps({ item: itemOf(ctx.items, el) }),
  },
  portal: ["positioner"],
});
