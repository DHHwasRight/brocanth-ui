// Tabs glue (Zag `@zag-js/tabs`). Markup: src/components/tabs.rsx.
// Server attributes on the root: data-value (the open tab),
// data-orientation="vertical", data-activation="manual".
// Events: `ui:value-change` with `{ value }`.

import * as tabs from "@zag-js/tabs";
import { defineComponent, emit, normalizeProps } from "./zag";

export default defineComponent({
  machine: tabs.machine,
  connect: (service) => tabs.connect(service, normalizeProps),
  props: (root) => ({
    defaultValue: root.dataset.value,
    orientation: root.dataset.orientation === "vertical" ? ("vertical" as const) : ("horizontal" as const),
    activationMode: root.dataset.activation === "manual" ? ("manual" as const) : ("automatic" as const),
    onValueChange: (details) => emit(root, "value-change", details),
  }),
  parts: {
    root: (api) => api.getRootProps(),
    list: (api) => api.getListProps(),
    trigger: (api, el) => api.getTriggerProps({ value: el.dataset.value! }),
    content: (api, el) => api.getContentProps({ value: el.dataset.value! }),
    indicator: (api) => api.getIndicatorProps(),
  },
});
