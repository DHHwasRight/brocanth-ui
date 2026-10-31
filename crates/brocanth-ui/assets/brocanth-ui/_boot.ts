// Entry of the glue bundle: brocanth-bundle (rolldown) compiles it into
// assets/brocanth-ui/boot.js, and each `import()` below into a chunk of
// its own in public/brocanth-ui/chunks/. A page downloads a kind's glue,
// and the Zag code it needs, only when it renders that kind.
//
// It mounts every `[data-ui]` component once on load, and again for each
// part of the page that dp-swap replaces.

// No static import: anything the entry shares with a chunk would make the
// chunk import the entry back, which brocanth-bundle refuses. The entry
// finds a mounted instance through a well-known symbol on its root.
interface Instance {
  unmount(): void;
}
interface Kind {
  mount(root: HTMLElement): Instance;
}

const INSTANCE = Symbol.for("brocanth-ui.instance");
const instanceOf = (root: Element): Instance | undefined => (root as unknown as Record<symbol, Instance | undefined>)[INSTANCE];

function rootsWithin(scope: Element | Document): HTMLElement[] {
  const roots: HTMLElement[] = scope instanceof HTMLElement && scope.matches("[data-ui]") ? [scope] : [];
  roots.push(...scope.querySelectorAll<HTMLElement>("[data-ui]"));
  return roots;
}

function unmountWithin(scope: Element): void {
  for (const root of rootsWithin(scope)) instanceOf(root)?.unmount();
}

// One line per Zag-backed kind. The import paths must be literal strings,
// so that the bundler can split them. No extension: rolldown resolves
// the `.ts` file.
const kinds: Record<string, () => Promise<{ default: Kind }>> = {
  carousel: () => import("./_glue/carousel"),
  combobox: () => import("./_glue/combobox"),
  command: () => import("./_glue/command"),
  "date-picker": () => import("./_glue/date-picker"),
  menu: () => import("./_glue/menu"),
  resizable: () => import("./_glue/resizable"),
  select: () => import("./_glue/select"),
  tabs: () => import("./_glue/tabs"),
  toaster: () => import("./_glue/toaster"),
};

const loaded = new Map<string, Promise<{ default: Kind }>>();

function load(kind: string): Promise<{ default: Kind }> {
  if (!(kind in kinds)) return Promise.reject(new Error(`unknown kind; add it to \`kinds\` in _boot.js`));
  let module = loaded.get(kind);
  if (!module) {
    module = kinds[kind]();
    loaded.set(kind, module);
  }
  return module;
}

export async function mountWithin(scope: Element | Document): Promise<void> {
  await Promise.all(
    rootsWithin(scope)
      .filter((root) => !instanceOf(root))
      .map(async (root) => {
        try {
          (await load(root.dataset.ui!)).default.mount(root);
        } catch (error) {
          console.error(`[brocanth-ui] cannot mount data-ui="${root.dataset.ui}" #${root.id}:`, error);
        }
      }),
  );
}

// dp-swap: unmount before the old nodes leave, mount after the new ones land.
// Only these swap styles remove nodes; `beforeend` and the other positional
// styles keep the target's children, and their components keep their state.
const REMOVING = new Set(["innerHTML", "outerHTML", "delete"]);
interface SwapDetail {
  spec?: { swap?: { style?: string } };
}
document.addEventListener("dp:beforeSwap", (event) => {
  const style = (event as CustomEvent<SwapDetail>).detail?.spec?.swap?.style ?? "innerHTML";
  if (REMOVING.has(style)) unmountWithin(event.target as Element);
});
document.addEventListener("dp:afterSwap", (event) => mountWithin(event.target as Element));

// Platform shims. Each is a few lines and replaces a component's JS.
//
// 1. `closedby="any"` (light dismiss for <dialog>) where the engine lacks
//    it: a click on the backdrop lands on the dialog element itself.
if (!("closedBy" in HTMLDialogElement.prototype)) {
  document.addEventListener("click", (event) => {
    const dialog = event.target;
    if (!(dialog instanceof HTMLDialogElement) || !dialog.open || dialog.getAttribute("closedby") !== "any") return;
    const box = dialog.getBoundingClientRect();
    const inside = event.clientX >= box.left && event.clientX <= box.right && event.clientY >= box.top && event.clientY <= box.bottom;
    if (!inside) dialog.close();
  });
}

// 2. Escape hides the CSS tooltip that shows (WCAG 1.4.13) until the
//    pointer or the focus leaves its trigger.
document.addEventListener("keydown", (event) => {
  if (event.key !== "Escape") return;
  for (const tip of document.querySelectorAll('[role="tooltip"]')) {
    const group = tip.parentElement;
    if (group?.matches(":hover, :has(:focus-visible)")) group.setAttribute("data-tooltip-dismissed", "");
  }
});
const undismiss = (event: PointerEvent | FocusEvent) => {
  const group = event.target instanceof Element ? event.target.closest("[data-tooltip-dismissed]") : null;
  if (group && !group.contains(event.relatedTarget as Node | null)) group.removeAttribute("data-tooltip-dismissed");
};
document.addEventListener("pointerout", undismiss);
document.addEventListener("focusout", undismiss);

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => mountWithin(document), { once: true });
} else {
  mountWithin(document);
}
