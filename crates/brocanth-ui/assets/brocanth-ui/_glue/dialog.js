// Dialog glue. The markup comes from src/components/dialog.rsx.
//
// Server attributes on the root:
//   data-role="dialog|alertdialog"   data-modal="false"
//   data-default-open                data-close-on-outside="false"
// Events on the root: `ui:open-change` with `{ open }`.

import * as dialog from "@zag-js/dialog";
import { defineComponent, emit, flag } from "./zag.js";

// Zag gives every close trigger the same id, and an alert dialog focuses
// the node with that id on open. Only one node may hold it: the footer
// button (`data-close-primary`, the safe action) when there is one, else
// the corner button.
function closeTrigger(api, el) {
  const props = api.getCloseTriggerProps();
  const content = el.closest('[data-part="content"]');
  const hasPrimary = content?.querySelector("[data-close-primary]");
  if (hasPrimary && !el.hasAttribute("data-close-primary")) return { ...props, id: undefined };
  return props;
}

export default defineComponent({
  machine: dialog.machine,
  connect: dialog.connect,
  props: (root) => ({
    role: root.dataset.role === "alertdialog" ? "alertdialog" : "dialog",
    modal: flag(root, "modal", true),
    defaultOpen: flag(root, "defaultOpen", false),
    closeOnInteractOutside: flag(root, "closeOnOutside", true),
    onOpenChange: (details) => emit(root, "open-change", details),
  }),
  parts: {
    trigger: (api) => api.getTriggerProps(),
    backdrop: (api) => api.getBackdropProps(),
    positioner: (api) => api.getPositionerProps(),
    content: (api) => api.getContentProps(),
    title: (api) => api.getTitleProps(),
    description: (api) => api.getDescriptionProps(),
    "close-trigger": (api, el) => closeTrigger(api, el),
  },
  // rsx renders the overlay next to its trigger. A `transform` or
  // `overflow: hidden` on any ancestor would clip a `position: fixed`
  // overlay, so it moves to the end of <body>.
  portal: ["backdrop", "positioner"],
});
