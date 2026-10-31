// Instance bookkeeping shared by Zag and plain glue. No dependency, so a
// plain kind (carousel, date picker) does not pull Zag into its chunk.

/** What _boot.ts needs from a mounted component. */
export interface Instance {
  root: HTMLElement;
  unmount(): void;
}

/** A kind's glue module: its default export. */
export interface Kind {
  mount(root: HTMLElement): Instance;
}

// The instance lives on its root under a well-known symbol, so _boot.ts
// can find it without importing any glue (see _boot.ts).
const KEY = Symbol.for("brocanth-ui.instance");

export function instanceOf<T extends Instance = Instance>(root: Element): T | undefined {
  return (root as unknown as Record<symbol, T | undefined>)[KEY];
}

export function setInstance(root: HTMLElement, instance: Instance | undefined): void {
  (root as unknown as Record<symbol, Instance | undefined>)[KEY] = instance;
}

/** Marks a plain (non-Zag) instance, so _boot.ts can find and unmount it. */
export function register<Extra extends object>(root: HTMLElement, unmount: () => void, extra?: Extra): Instance & Extra {
  const instance = {
    ...(extra as Extra),
    root,
    unmount() {
      unmount();
      setInstance(root, undefined);
    },
  };
  setInstance(root, instance);
  return instance;
}
