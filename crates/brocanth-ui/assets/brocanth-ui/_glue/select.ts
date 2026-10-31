// Select glue (Zag `@zag-js/select`). Markup: src/components/select.rsx.
// The items come from the `[data-part="item"]` nodes; a hidden native
// <select> (rendered by the server, with its options) posts the value.
// Server attributes on the root: data-value, data-name.
// Events: `ui:value-change` with `{ value: string[] }`.

import * as select from "@zag-js/select";
import { type Item, defineComponent, emit, itemOf, readItems, normalizeProps } from "./zag";

export default defineComponent({
  machine: select.machine,
  connect: (service) => select.connect(service, normalizeProps),
  setup: (root) => {
    const items = readItems(root);
    const collection = select.collection<Item>({
      items,
      itemToValue: (item) => item.value,
      itemToString: (item) => item.label,
      isItemDisabled: (item) => item.disabled,
    });
    return { items, collection };
  },
  props: (root, ctx) => ({
    collection: ctx.collection,
    defaultValue: root.dataset.value ? [root.dataset.value] : [],
    name: root.dataset.name,
    positioning: { sameWidth: true, gutter: 4 },
    onValueChange: ({ value }) => emit(root, "value-change", { value }),
  }),
  parts: {
    root: (api) => api.getRootProps(),
    label: (api) => api.getLabelProps(),
    control: (api) => api.getControlProps(),
    trigger: (api) => api.getTriggerProps(),
    // Zag gives the attributes; the text is ours: the label, else the placeholder.
    "value-text": (api, el) => {
      const text = api.valueAsString || el.dataset.placeholder || "";
      if (el.textContent !== text) el.textContent = text;
      return api.getValueTextProps();
    },
    indicator: (api) => api.getIndicatorProps(),
    positioner: (api) => api.getPositionerProps(),
    content: (api) => api.getContentProps(),
    item: (api, el, ctx) => api.getItemProps({ item: itemOf(ctx.items, el) }),
    "item-text": (api, el, ctx) => api.getItemTextProps({ item: itemOf(ctx.items, el) }),
    "item-indicator": (api, el, ctx) => api.getItemIndicatorProps({ item: itemOf(ctx.items, el) }),
    "hidden-select": (api) => api.getHiddenSelectProps(),
  },
  portal: ["positioner"],
});
