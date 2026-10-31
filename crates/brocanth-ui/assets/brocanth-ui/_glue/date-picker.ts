// Date picker glue (no Zag). Markup: DatePicker in src/components/calendar.rsx.
// The calendar works without it; this writes the chosen date into the
// trigger and closes the popover. It listens on the root, so a calendar
// that dp-swap replaces (month navigation) keeps working.

import { type Instance, register } from "./instance";

export default {
  mount(root: HTMLElement): Instance {
    const onChange = (event: Event) => {
      const input = event.target;
      if (!(input instanceof HTMLInputElement) || input.type !== "radio") return;
      const value = root.querySelector<HTMLElement>('[data-part="value"]')!;
      value.textContent = input.dataset.human ?? input.value;
      value.removeAttribute("data-empty");
      root.querySelector<HTMLElement>("[popover]")?.hidePopover();
    };
    root.addEventListener("change", onChange);
    return register(root, () => root.removeEventListener("change", onChange));
  },
};
