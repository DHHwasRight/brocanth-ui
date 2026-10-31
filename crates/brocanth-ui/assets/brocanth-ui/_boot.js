// Entry of the glue bundle: brocanth-bundle (rolldown) builds it into
// assets/brocanth-ui/boot.js, and each `import()` below into a chunk of
// its own in public/brocanth-ui/chunks/. A page downloads a kind's glue,
// and the Zag code it needs, only when it renders that kind.
//
// It mounts every `[data-ui]` component once on load, and again for each
// part of the page that dp-swap replaces.

// No static import: anything the entry shares with a chunk would make the
// chunk import the entry back, which brocanth-bundle refuses. The entry
// finds a mounted instance through a well-known symbol on its root.
const INSTANCE = Symbol.for("brocanth-ui.instance");
const instanceOf = (root) => root[INSTANCE];

function rootsWithin(scope) {
  const roots = scope.matches?.("[data-ui]") ? [scope] : [];
  roots.push(...scope.querySelectorAll("[data-ui]"));
  return roots;
}

function unmountWithin(scope) {
  for (const root of rootsWithin(scope)) instanceOf(root)?.unmount();
}

// One line per Zag-backed kind. The import paths must be literal strings,
// so that the bundler can split them.
const kinds = {
  dialog: () => import("./_glue/dialog.js"),
};

const loaded = new Map(); // kind -> Promise<module>

function load(kind) {
  if (!(kind in kinds)) return Promise.reject(new Error(`unknown kind; add it to \`kinds\` in _boot.js`));
  if (!loaded.has(kind)) loaded.set(kind, kinds[kind]());
  return loaded.get(kind);
}

export async function mountWithin(scope) {
  await Promise.all(
    rootsWithin(scope)
      .filter((root) => !instanceOf(root))
      .map(async (root) => {
        try {
          (await load(root.dataset.ui)).default.mount(root);
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
document.addEventListener("dp:beforeSwap", (event) => {
  if (REMOVING.has(event.detail?.spec?.swap?.style ?? "innerHTML")) unmountWithin(event.target);
});
document.addEventListener("dp:afterSwap", (event) => mountWithin(event.target));

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", () => mountWithin(document), { once: true });
} else {
  mountWithin(document);
}
