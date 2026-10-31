// Menu glue (Zag `@zag-js/menu`): dropdown menu, context menu, and each
// menu of a menubar. Markup: src/components/menu.rsx.
//
// Items are `<button data-part="item" data-value>` or `<a data-part="item"
// href>`; a link item navigates (dp-boost turns it into a partial
// navigation). Checkbox and radio items are `data-part="option-item"` with
// data-type, data-value, data-group and data-checked.
// Events: `ui:select` with `{ value }`, `ui:checked-change` with
// `{ value, checked }`.

import * as menu from "@zag-js/menu";
import { type Base, defineComponent, emit, flag, ownerOf, normalizeProps } from "./zag";

interface Ctx extends Base {
  /** The checked state of option items: from the server, then the user's. */
  checked: Map<string, boolean>;
}

export default defineComponent({
  machine: menu.machine,
  connect: (service) => menu.connect(service, normalizeProps),
  setup: (root): Omit<Ctx, keyof Base> => {
    const checked = new Map<string, boolean>();
    for (const el of root.querySelectorAll<HTMLElement>("[data-type][data-value]")) {
      checked.set(el.dataset.value!, el.hasAttribute("data-checked"));
    }
    return { checked };
  },
  props: (root) => ({
    positioning: { placement: (root.dataset.placement ?? "bottom-start") as NonNullable<menu.PositioningOptions["placement"]>, gutter: 4 },
    closeOnSelect: flag(root, "closeOnSelect", true),
    onSelect: ({ value }) => {
      const item = [...document.querySelectorAll<HTMLElement>('[data-part="item"]')].find(
        (el) => el.dataset.value === value && ownerOf(el) === root,
      );
      if (item instanceof HTMLAnchorElement) item.click();
      emit(root, "select", { value });
    },
  }),
  parts: {
    trigger: (api) => api.getTriggerProps(),
    "context-trigger": (api) => api.getContextTriggerProps(),
    positioner: (api) => api.getPositionerProps(),
    content: (api) => api.getContentProps(),
    item: (api, el) => api.getItemProps({ value: el.dataset.value!, disabled: el.hasAttribute("data-disabled") }),
    "option-item": (api, el, ctx) => api.getOptionItemProps(option(el, ctx)),
    "item-indicator": (api, el, ctx) =>
      // Zag renames the option item's data-part to "item"; data-type stays.
      api.getItemIndicatorProps(option(el.closest<HTMLElement>("[data-type]")!, ctx)),
    "item-group-label": (api, el) => api.getItemGroupLabelProps({ htmlFor: el.dataset.group! }),
    "item-group": (api, el) => api.getItemGroupProps({ id: el.dataset.group! }),
    separator: (api) => api.getSeparatorProps(),
  },
  portal: ["positioner"],
});

function option(el: HTMLElement, ctx: Ctx): menu.OptionItemProps {
  const value = el.dataset.value!;
  const type = el.dataset.type === "radio" ? "radio" : "checkbox";
  return {
    type,
    value,
    checked: ctx.checked.get(value) ?? false,
    closeOnSelect: false,
    onCheckedChange(checked) {
      const root = ctx.instance!.root;
      if (type === "radio") {
        // One radio per group: clear the others in the same data-group.
        for (const other of document.querySelectorAll<HTMLElement>(`[data-type="radio"][data-group="${el.dataset.group}"]`)) {
          if (ownerOf(other) === root) ctx.checked.set(other.dataset.value!, false);
        }
      }
      ctx.checked.set(value, checked);
      emit(root, "checked-change", { value, checked });
      ctx.instance!.refresh();
    },
  };
}
