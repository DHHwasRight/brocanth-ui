// Carousel glue (no Zag). Markup: src/components/carousel.rsx. The track
// scrolls on its own (scroll-snap); this shows the buttons, scrolls one
// slide per click, and disables a button at its end.

import { type Instance, register } from "./instance";

export default {
  mount(root: HTMLElement): Instance {
    const track = root.querySelector<HTMLElement>('[data-part="track"]')!;
    const prev = root.querySelector<HTMLButtonElement>('[data-part="prev"]')!;
    const next = root.querySelector<HTMLButtonElement>('[data-part="next"]')!;
    const update = () => {
      prev.disabled = track.scrollLeft <= 1;
      next.disabled = track.scrollLeft + track.clientWidth >= track.scrollWidth - 1;
    };
    // One slide: the distance between two slides, so the gap counts.
    const slide = () => {
      const [first, second] = track.children as HTMLCollectionOf<HTMLElement>;
      return second ? second.offsetLeft - first.offsetLeft : track.clientWidth;
    };
    const step = (direction: number) => () => track.scrollBy({ left: direction * slide(), behavior: "smooth" });
    const onPrev = step(-1);
    const onNext = step(1);
    prev.addEventListener("click", onPrev);
    next.addEventListener("click", onNext);
    track.addEventListener("scroll", update, { passive: true });
    prev.hidden = next.hidden = false;
    update();
    return register(root, () => {
      prev.removeEventListener("click", onPrev);
      next.removeEventListener("click", onNext);
      track.removeEventListener("scroll", update);
    });
  },
};
