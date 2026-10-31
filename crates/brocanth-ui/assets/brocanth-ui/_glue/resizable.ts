// Resizable panels glue (Zag `@zag-js/splitter`). Markup:
// src/components/resizable.rsx. Panels carry data-id, data-size (percent)
// and data-min; a handle between panels a and b carries data-id="a:b".
// The server renders the sizes as flex-basis, so the layout does not move
// when the glue loads. Events: `ui:resize-end` with `{ size: number[] }`.

import * as splitter from "@zag-js/splitter";
import { defineComponent, emit, normalizeProps } from "./zag";

export default defineComponent({
  machine: splitter.machine,
  connect: (service) => splitter.connect(service, normalizeProps),
  setup: (root) => ({
    panels: [...root.querySelectorAll<HTMLElement>(':scope > [data-part="panel"]')],
  }),
  props: (root, ctx) => ({
    orientation: root.dataset.orientation === "vertical" ? ("vertical" as const) : ("horizontal" as const),
    panels: ctx.panels.map((el) => ({ id: el.dataset.id!, minSize: Number(el.dataset.min ?? 10) })),
    defaultSize: ctx.panels.map((el) => Number(el.dataset.size)),
    onResizeEnd: ({ size }) => emit(root, "resize-end", { size }),
  }),
  parts: {
    root: (api) => api.getRootProps(),
    panel: (api, el) => api.getPanelProps({ id: el.dataset.id! }),
    "resize-trigger": (api, el) => api.getResizeTriggerProps({ id: el.dataset.id! as `${string}:${string}` }),
  },
});
