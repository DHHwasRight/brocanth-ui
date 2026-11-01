// Drives the gallery in headless Chromium and checks every component that
// has behaviour: the native overlays (0 JS), the glue kinds, the Zag kinds,
// and unmount/remount around a dp-swap. Both theme panes render the same
// markup, so the checks run in the shadcn pane and one theme check runs in
// the original pane.
//
// mise run browser-test   (exports and serves target/gallery on :4100)
// Env: CHROME (headless shell path), GALLERY_URL, SHOTS (screenshot dir).

import { chromium, webkit } from "playwright-core";

import { existsSync } from "node:fs";

// $CHROME, else the macOS headless shell if present, else the browser that
// `playwright-core install chromium-headless-shell` put in its cache (CI).
const macShell = `${process.env.HOME}/Library/Caches/ms-playwright/chromium_headless_shell-1248/chrome-headless-shell-mac-arm64/chrome-headless-shell`;
const exe = process.env.CHROME ?? (existsSync(macShell) ? macShell : undefined);
const url = process.env.GALLERY_URL ?? "http://localhost:4100/";
const shots = process.env.SHOTS ?? "target";

const browser = await chromium.launch({ executablePath: exe });
const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
page.setDefaultTimeout(4000);
// The examples default to the Original view; most checks need both panes.
await page.addInitScript(() => {
  if (!sessionStorage.getItem("view-set")) {
    localStorage.setItem("brocanth-ui-view", "both");
    sessionStorage.setItem("view-set", "1");
  }
});
const errors = [];
// The avatar demo shows a broken image on purpose.
page.on("console", (m) => m.type() === "error" && !m.text().includes("404") && errors.push(m.text()));
page.on("pageerror", (e) => errors.push(String(e)));
// A request the browser cancels because the test moved to another page is
// not a site error; any other failed request is.
page.on("requestfailed", (r) => r.failure()?.errorText !== "net::ERR_ABORTED" && errors.push(`failed ${r.url()}: ${r.failure()?.errorText}`));
page.on("response", (r) => r.status() >= 400 && !r.url().endsWith("missing.png") && errors.push(`${r.status()} ${r.url()}`));

const results = [];
async function check(name, fn) {
  try {
    const value = await fn();
    results.push([name, value === true ? "ok" : `FAIL (${JSON.stringify(value)})`]);
  } catch (error) {
    results.push([name, `FAIL (${String(error).split("\n")[0]})`]);
  }
}
const $ = (selector) => page.locator(selector).first();
const visible = (selector) => $(selector).isVisible();
const settle = (ms = 250) => page.waitForTimeout(ms);
const focusedText = () => page.evaluate(() => document.activeElement?.textContent?.trim());

await page.goto(url);
await page.waitForFunction(() => document.querySelectorAll('[data-ui="tabs"]').length === 2);
await settle(800);

// ---- native overlays: no JavaScript of ours
await check("dialog opens from its invoker", async () => {
  await $('#dialog [commandfor="shadcn-dialog"]').click();
  await settle();
  return page.evaluate(() => document.getElementById("shadcn-dialog").matches(":modal"));
});
await check("dialog traps the focus inside", () => page.evaluate(() => !!document.activeElement.closest("#shadcn-dialog")));
await check("Escape closes the dialog and the focus returns", async () => {
  await page.keyboard.press("Escape");
  await settle();
  return page.evaluate(() => !document.getElementById("shadcn-dialog").open && document.activeElement.getAttribute("commandfor") === "shadcn-dialog");
});
await check("dialog closes on a backdrop click (closedby=any)", async () => {
  await $('#dialog [commandfor="shadcn-dialog"]').click();
  await settle();
  await page.mouse.click(8, 500);
  await settle();
  return page.evaluate(() => !document.getElementById("shadcn-dialog").open);
});
await check("alert dialog focuses Cancel and ignores the backdrop", async () => {
  await $('#alert-dialog [commandfor="shadcn-alert"]').click();
  await settle();
  const focus = await focusedText();
  await page.mouse.click(8, 500);
  await settle();
  const open = await page.evaluate(() => document.getElementById("shadcn-alert").open);
  await page.keyboard.press("Escape");
  await settle();
  const closed = await page.evaluate(() => !document.getElementById("shadcn-alert").open);
  return (focus === "Cancel" && open && closed) || { focus, open, closed };
});
await check("sheet slides in from the right edge", async () => {
  await $('#sheet [commandfor="shadcn-sheet"]').click();
  await settle(700); // the sheet slides in for 500ms
  const box = await $("#shadcn-sheet").boundingBox();
  await page.keyboard.press("Escape");
  return Math.round(box.x + box.width) === 1440;
});
await check("popover opens below its trigger (anchor positioning)", async () => {
  await page.evaluate(() => document.querySelector('[commandfor="shadcn-popover"]').scrollIntoView({ block: "center" }));
  await $('#popover [commandfor="shadcn-popover"]').click();
  await settle();
  const trigger = await $('#popover [commandfor="shadcn-popover"]').boundingBox();
  const panel = await $("#shadcn-popover").boundingBox();
  const open = await page.evaluate(() => document.getElementById("shadcn-popover").matches(":popover-open"));
  await page.keyboard.press("Escape");
  // Below the trigger, or above it when the viewport has no room (flip-block).
  const below = panel.y >= trigger.y + trigger.height;
  const above = panel.y + panel.height <= trigger.y;
  return (open && (below || above) && Math.abs(panel.x - trigger.x) < 2) || { open, trigger, panel };
});
await check("tooltip shows on hover and hides on Escape", async () => {
  await $('#tooltip button[aria-describedby="shadcn-tip"]').hover();
  await settle(600);
  const shown = await visible("#shadcn-tip");
  await page.keyboard.press("Escape");
  await settle(500);
  const hidden = !(await visible("#shadcn-tip"));
  await page.mouse.move(0, 0);
  return (shown && hidden) || { shown, hidden };
});
await check("accordion keeps one item open (details name)", async () => {
  await $("#accordion details:nth-of-type(2) summary").click();
  return page.evaluate(() => [...document.querySelectorAll('#accordion [data-ui-theme="shadcn"] details')].map((d) => d.open).join() === "false,true,false");
});

// ---- motion, as shadcn has it, with no JavaScript
const styleOf = (selector, props) =>
  page.evaluate(([selector, props]) => {
    const cs = getComputedStyle(document.querySelector(selector));
    return Object.fromEntries(props.map((p) => [p, cs[p]]));
  }, [selector, props]);
await check("dialog fades and zooms in, and out", async () => {
  await $('#dialog [commandfor="shadcn-dialog"]').click();
  await settle(60);
  const opening = await styleOf("#shadcn-dialog", ["opacity", "scale"]);
  await settle(300);
  await page.keyboard.press("Escape");
  await settle(60);
  const closing = await styleOf("#shadcn-dialog", ["opacity", "display"]);
  await settle(300);
  const opacityIn = Number(opening.opacity);
  const ok = opacityIn > 0 && opacityIn < 1 && opening.scale !== "none" && Number(closing.opacity) < 1 && closing.display !== "none";
  return ok || { opening, closing };
});
await check("accordion content grows to its height", async () => {
  await page.evaluate(() => document.getElementById("accordion").scrollIntoView({ block: "center" }));
  const item = '#accordion [data-ui-theme="original"] details:nth-of-type(3)';
  const closed = (await $(item).boundingBox()).height;
  await $(`${item} summary`).click();
  await settle(80);
  const mid = (await $(item).boundingBox()).height;
  await settle(300);
  const open = (await $(item).boundingBox()).height;
  return (closed < mid && mid < open) || { closed, mid, open };
});

await check("the accordion animates in WebKit (Safari's engine) too", async () => {
  const engine = await webkit.launch();
  const safari = await engine.newPage({ viewport: { width: 1280, height: 900 } });
  await safari.goto(new URL("#accordion", url).href);
  await safari.waitForTimeout(500);
  const item = '#accordion [data-ui-theme="original"] details:nth-of-type(3)';
  const height = () => safari.evaluate((s) => document.querySelector(s).getBoundingClientRect().height, item);
  const closed = await height();
  await safari.click(`${item} summary`);
  await safari.waitForTimeout(80);
  const mid = await height();
  await safari.waitForTimeout(400);
  const open = await height();
  await engine.close();
  return (closed < mid && mid < open) || { closed, mid, open };
});

// ---- glue kinds (no Zag)
await check("carousel shows its buttons and scrolls one slide", async () => {
  const next = $('#shadcn-carousel [data-part="next"]');
  await next.click();
  await settle(700);
  return page.evaluate(() => {
    const track = document.querySelector('#shadcn-carousel [data-part="track"]');
    const second = track.children[1];
    return Math.abs(track.scrollLeft - (second.offsetLeft - track.children[0].offsetLeft)) < 2 && !document.querySelector('#shadcn-carousel [data-part="prev"]').disabled;
  });
});
await check("date picker writes the chosen date into the trigger", async () => {
  await $('#shadcn-due button[commandfor="shadcn-due-popover"]').click();
  await settle();
  await $('#shadcn-due-calendar label[aria-label="Nov 20, 2026"]').click();
  await settle();
  const text = await $('#shadcn-due [data-part="value"]').textContent();
  const open = await page.evaluate(() => document.getElementById("shadcn-due-popover").matches(":popover-open"));
  return text === "Nov 20, 2026" && !open;
});

// ---- Zag kinds
await check("tabs: arrow key moves to the next tab", async () => {
  await $('#shadcn-tabs [data-part="trigger"][data-value="curl"]').focus();
  await page.keyboard.press("ArrowRight");
  await settle();
  return page.evaluate(() => {
    const panel = document.querySelector('#shadcn-tabs [data-part="content"][data-value="ruby"]');
    return !panel.hidden && document.activeElement.dataset.value === "ruby";
  });
});
await check("dropdown menu: opens, arrow keys, Enter selects", async () => {
  const selected = page.evaluate(
    () => new Promise((resolve) => { document.getElementById("shadcn-menu").addEventListener("ui:select", (e) => resolve(e.detail.value), { once: true }); setTimeout(() => resolve("no ui:select"), 2000); }),
  ).catch((error) => `evaluate failed: ${String(error).split("\n")[0]} at ${page.url()}`);
  await $('#shadcn-menu [data-part="trigger"]').click();
  await settle();
  const portaled = await page.evaluate(() => !!document.querySelector('#ui-portal [data-ui-theme="shadcn"] [data-part="content"]:not([hidden])'));
  await page.keyboard.press("ArrowDown");
  await page.keyboard.press("ArrowDown");
  await page.keyboard.press("Enter");
  const value = await selected;
  return (portaled && value === "billing") || { portaled, value };
});
await check("menu content stays on screen while it fades out", async () => {
  await $('#shadcn-menu [data-part="trigger"]').click();
  await settle(250);
  await page.keyboard.press("Escape");
  await settle(30);
  const leaving = await page.evaluate(() =>
    [...document.querySelectorAll('#ui-portal [data-ui-theme="shadcn"] [role="menu"]')].some((el) => el.hidden && getComputedStyle(el).display !== "none"),
  );
  await settle(300);
  return leaving;
});
await check("menu checkbox item toggles", async () => {
  await $('#shadcn-menu [data-part="trigger"]').click();
  await settle();
  const item = page.locator('#ui-portal [data-type="checkbox"][data-value="archived"]').first();
  await item.click();
  await settle();
  const checked = await item.getAttribute("aria-checked");
  await page.keyboard.press("Escape");
  return checked === "true";
});
await check("context menu opens on right-click", async () => {
  await $('#shadcn-context [data-part="context-trigger"]').click({ button: "right" });
  await settle();
  const open = await page.evaluate(() =>
    [...document.querySelectorAll('#ui-portal [data-part="content"]')].some((el) => !el.hidden && el.textContent.includes("Reload")),
  );
  await page.keyboard.press("Escape");
  return open;
});
await check("select: choose an option, the hidden select follows", async () => {
  await $('#shadcn-select [data-part="trigger"]').click();
  await settle();
  await page.locator('#ui-portal [data-part="item"][data-value="gbp"]').first().click();
  await settle();
  const text = await $('#shadcn-select [data-part="value-text"]').textContent();
  const posted = await page.evaluate(() => document.querySelector('#shadcn-select select').value);
  return (text.includes("GBP") && posted === "gbp") || { text, posted };
});
await check("combobox: typing filters, Enter picks", async () => {
  const input = $('#shadcn-combobox [data-part="input"]');
  await input.fill("");
  await input.pressSequentially("ja");
  await settle();
  const shown = await page.evaluate(() =>
    [...document.querySelectorAll('[data-part="item"]')].filter((el) => el.closest('[data-ui-theme="shadcn"]') && el.closest("#ui-portal") && !el.hidden && el.closest('[data-part="content"]:not([hidden])')).map((el) => el.dataset.value),
  );
  await page.keyboard.press("ArrowDown");
  await page.keyboard.press("Enter");
  await settle();
  const value = await page.evaluate(() => document.querySelector('#shadcn-combobox [data-part="value-input"]').value);
  return JSON.stringify(shown) === '["jp"]' && value === "jp";
});
await check("command: filter, Enter runs the item", async () => {
  const selected = page.evaluate(
    () => new Promise((resolve) => { document.getElementById("shadcn-command").addEventListener("ui:select", (e) => resolve(e.detail.value), { once: true }); setTimeout(() => resolve("no ui:select"), 2000); }),
  ).catch((error) => `evaluate failed: ${String(error).split("\n")[0]} at ${page.url()}`);
  const input = $('#shadcn-command [data-part="input"]');
  await input.click();
  await input.pressSequentially("refund");
  await settle();
  const visibleItems = await page.evaluate(() => [...document.querySelectorAll('#shadcn-command [data-part="item"]')].filter((el) => !el.hidden).map((el) => el.dataset.value));
  await page.keyboard.press("Enter");
  const value = await selected;
  return (JSON.stringify(visibleItems) === '["refund"]' && value === "refund") || { visibleItems, value };
});
await check("toast: a button raises a toast in its own toaster", async () => {
  await $('#toast [data-ui-theme="shadcn"] [data-toast-trigger][data-type="success"]').click();
  await settle(600);
  return page.evaluate(() => {
    const mine = document.querySelectorAll('#shadcn-toaster [data-part="root"]').length;
    const other = document.querySelectorAll('#original-toaster [data-part="root"]').length;
    const title = document.querySelector('#shadcn-toaster [data-part="title"]')?.textContent;
    return mine === 1 && other === 0 && title === "Payment captured";
  });
});
await check("resizable: arrow key on the handle resizes", async () => {
  const before = await $('#shadcn-resizable [data-part="panel"][data-id="list"]').boundingBox();
  await $('#shadcn-resizable [data-part="resize-trigger"]').focus();
  await page.keyboard.press("ArrowRight");
  await page.keyboard.press("ArrowRight");
  await settle();
  const after = await $('#shadcn-resizable [data-part="panel"][data-id="list"]').boundingBox();
  return after.width > before.width;
});

// ---- themes
await check("the two panes paint different primary colours", () =>
  page.evaluate(() => {
    const color = (theme) => getComputedStyle(document.querySelector(`#button [data-ui-theme="${theme}"] button`)).backgroundColor;
    return color("shadcn") !== color("original") && color("original") === "rgb(157, 151, 255)";
  }),
);
await check("the original menu keeps the original theme in the portal", async () => {
  await $('#original-menu [data-part="trigger"]').click();
  await settle();
  const ok = await page.evaluate(() => {
    const content = [...document.querySelectorAll('#ui-portal [data-ui-theme="original"] [data-part="content"]')].find((el) => !el.hidden);
    return !!content && getComputedStyle(content).borderTopLeftRadius === "6px";
  });
  await page.keyboard.press("Escape");
  return ok;
});
await check("dark mode switches every token (light-dark)", async () => {
  await $("#theme-switch").click();
  await settle();
  const dark = await page.evaluate(() => getComputedStyle(document.querySelector('#card [data-ui-theme="original"] .g-pane-body > div > div')).backgroundColor);
  await $("#theme-switch").click();
  return dark === "rgb(13, 30, 49)";
});

// ---- the gallery's view switch
await check("one style hides the other pane and takes the whole width", async () => {
  await page.evaluate(() => document.getElementById("button").scrollIntoView({ block: "start" }));
  const pair = await $("#button .g-pair").boundingBox();
  await page.locator('.g-view label:has(input[value="shadcn"])').click();
  await settle();
  const shadcn = await $('#button .g-pane[data-ui-theme="shadcn"]').boundingBox();
  const originalHidden = !(await $('#button .g-pane[data-ui-theme="original"]').isVisible());
  await page.locator('.g-view label:has(input[value="original"])').click();
  await settle();
  const original = await $('#button .g-pane[data-ui-theme="original"]').boundingBox();
  const shadcnHidden = !(await $('#button .g-pane[data-ui-theme="shadcn"]').isVisible());
  await page.locator('.g-view label:has(input[value="both"])').click();
  await settle();
  const both = await page.locator("#button .g-pane").evaluateAll((panes) => panes.filter((p) => p.offsetParent).length);
  const full = (box) => Math.abs(box.width - pair.width) < 2;
  return (full(shadcn) && full(original) && originalHidden && shadcnHidden && both === 2) || { pair, shadcn, original, both };
});

await check("a first visit shows Original, with no jump, and keeps it across tabs", async () => {
  const fresh = await browser.newPage({ viewport: { width: 1440, height: 900 } });
  // The view must be set while the document is parsed, before any paint.
  await fresh.addInitScript(() => {
    document.addEventListener("DOMContentLoaded", () => {
      window.viewAtParse = document.documentElement.dataset.view;
      window.shadcnShownAtParse = [...document.querySelectorAll('.g-pane[data-ui-theme="shadcn"]')].some((p) => getComputedStyle(p).display !== "none");
    });
  });
  await fresh.goto(url);
  const first = await fresh.evaluate(() => ({ view: window.viewAtParse, shadcnShown: window.shadcnShownAtParse }));
  await fresh.locator('.g-top-nav a:has-text("Utilities")').click();
  await fresh.waitForFunction(() => document.querySelector("h1")?.textContent === "Configuration");
  await fresh.locator('.g-top-nav a:has-text("Components")').click();
  await fresh.waitForFunction(() => document.querySelector("h1")?.textContent === "One markup, two themes");
  const back = await fresh.evaluate(() => ({ view: document.documentElement.dataset.view, checked: document.querySelector(".g-view input:checked")?.value }));
  await fresh.close();
  return (first.view === "original" && !first.shadcnShown && back.view === "original" && back.checked === "original") || { first, back };
});

// ---- dp-swap: unmount before, mount after
await check("a dp-swap unmounts and remounts the Zag kinds", async () => {
  await page.evaluate(() => {
    const pane = document.querySelector('#tabs [data-ui-theme="shadcn"] .g-pane-body');
    pane.dispatchEvent(new CustomEvent("dp:beforeSwap", { bubbles: true, detail: { spec: { swap: { style: "innerHTML" } } } }));
    pane.innerHTML = pane.innerHTML.replaceAll("shadcn-tabs", "shadcn-tabs2");
    pane.dispatchEvent(new CustomEvent("dp:afterSwap", { bubbles: true }));
  });
  await settle(400);
  await $('#shadcn-tabs2 [data-part="trigger"][data-value="node"]').click();
  await settle();
  return page.evaluate(() => !document.querySelector('#shadcn-tabs2 [data-part="content"][data-value="node"]').hidden);
});

// ---- the Utilities tab
const base = new URL(url);
await check("the Utilities tab opens the Configuration guide", async () => {
  await page.goto(base.href);
  await page.locator('.g-top-nav a:has-text("Utilities")').click();
  await page.waitForFunction(() => document.querySelector("h1")?.textContent === "Configuration").catch(() => {});
  const title = await page.locator("h1").textContent();
  const steps = await page.locator(".g-steps li").count();
  return (title === "Configuration" && steps === 7) || { title, steps };
});
await check("a guide section shows the CSS we pass to Tailwind", async () => {
  await page.locator("#theme .g-src > summary").click();
  await settle(300);
  const code = await page.locator("#theme .g-src-panel").first().textContent();
  return code.includes("--color-primary: var(--ui-primary)") || code.slice(0, 120);
});
await check("a utility page shows the CSS our configuration compiles", async () => {
  await page.goto(new URL("utilities/border-radius/", base).href);
  const row = page.locator('.g-ref tr:has(code:text-is("rounded-md"))');
  const css = await row.locator(".g-ref-css").textContent();
  const ours = await row.locator(".g-ref-ours").count();
  return (css.trim() === "border-radius: var(--ui-radius-md);" && ours === 1) || { css, ours };
});
await check("a utility page has a live example and its rsx", async () => {
  await page.goto(new URL("utilities/z-index/", base).href);
  const example = await page.locator(".g-doc .g-pane-body .z-30").count();
  await page.locator(".g-src > summary").click();
  await settle(300);
  const code = await page.locator(".g-src-panel").first().textContent();
  return (example === 1 && code.includes("pub fn ZIndexExample()")) || { example, code: code.slice(0, 80) };
});
await check("the pager walks to the next utility", async () => {
  await page.goto(new URL("utilities/aspect-ratio/", base).href);
  await page.locator(".g-pager-next").click();
  await page.waitForFunction(() => document.querySelector("h1")?.textContent === "columns").catch(() => {});
  return (await page.locator("h1").textContent()) === "columns";
});
await check("the Components tab links back", async () => {
  await page.locator('.g-top-nav a:has-text("Components")').click();
  await page.waitForFunction(() => document.querySelector("h1")?.textContent === "One markup, two themes").catch(() => {});
  return (await page.locator("h1").textContent()) === "One markup, two themes";
});

await check("a link is a partial navigation: no reload, new title, tab and sidebar follow", async () => {
  await page.goto(base.href);
  await page.waitForFunction(() => window.dpswap);
  await page.evaluate(() => { window.sameDocument = true; });
  const requests = [];
  const listen = (r) => requests.push(new URL(r.url()).pathname);
  page.on("request", listen);
  await page.locator('.g-top-nav a:has-text("Utilities")').click();
  await page.waitForFunction(() => document.querySelector("h1")?.textContent === "Configuration");
  await page.locator('.g-side-link:text-is("z-index")').click();
  await page.waitForFunction(() => document.querySelector("h1")?.textContent === "z-index");
  page.off("request", listen);
  const state = await page.evaluate(() => ({
    same: window.sameDocument === true,
    title: document.title,
    path: location.pathname,
    tab: document.querySelector(".g-top-nav .is-current")?.textContent,
    side: document.querySelector(".g-side-link.is-current")?.textContent,
  }));
  const partials = requests.filter((p) => p.includes("/partials/"));
  const ok = state.same && state.title.startsWith("z-index") && state.path.endsWith("/utilities/z-index/") && state.tab === "Utilities" && state.side === "z-index"
    && partials.some((p) => p.includes("/partials/1/utilities")) && partials.some((p) => p.includes("/partials/2/utilities/z-index"));
  return ok || { state, partials };
});
await check("Back after a partial navigation shows the previous page", async () => {
  await page.goBack();
  await page.waitForFunction(() => document.querySelector("h1")?.textContent === "Configuration");
  return page.evaluate(() => window.sameDocument === true);
});

await check("every utility page loads with no error", async () => {
  await page.goto(new URL("utilities/", base).href);
  const links = await page.locator(".g-side-link").evaluateAll((as) => as.map((a) => a.href));
  const before = errors.length;
  const broken = [];
  for (const link of links) {
    const response = await page.goto(link, { waitUntil: "load" });
    if (!response.ok() || (await page.locator(".g-doc .g-pane-body").count()) === 0) broken.push(link);
  }
  return (links.length === 185 && broken.length === 0 && errors.length === before) || { pages: links.length, broken, errors: errors.slice(before) };
});
await check("without JavaScript, every link is a full page", async () => {
  const context = await browser.newContext({ javaScriptEnabled: false });
  const plain = await context.newPage();
  await plain.goto(new URL("utilities/", base).href);
  await plain.locator('.g-side-link:text-is("gap")').click();
  await plain.waitForLoadState();
  const h1 = await plain.locator("h1").textContent();
  const tab = await plain.locator(".g-top-nav .is-current").textContent();
  await context.close();
  return (h1 === "gap" && tab === "Utilities") || { h1, tab };
});

// ---- the Charts tab: d3set-ssr charts, server-rendered SVG
await check("the Charts tab opens the overview", async () => {
  await page.goto(base.href);
  await page.locator('.g-top-nav a:has-text("Charts")').click();
  await page.waitForFunction(() => document.querySelector("h1")?.textContent === "Charts rendered on the server").catch(() => {});
  const state = await page.evaluate(() => ({
    h1: document.querySelector("h1")?.textContent,
    tab: document.querySelector(".g-top-nav .is-current")?.textContent,
    thumbs: document.querySelectorAll(".g-thumb").length,
    svgs: document.querySelectorAll(".g-thumb svg").length,
  }));
  return (state.h1 === "Charts rendered on the server" && state.tab === "Charts" && state.thumbs === 24 && state.svgs > 10) || state;
});
await check("a chart page draws SVG marks in the theme's series colour", async () => {
  await page.goto(new URL("charts/bar/", base).href);
  return page.evaluate(() => {
    const marks = [...document.querySelectorAll(".g-pane .d3s-chart svg [style], .g-pane .d3s-chart svg [fill]")].filter((el) => `${el.getAttribute("style")} ${el.getAttribute("fill")}`.includes("var(--d3s-series-0)"));
    const painted = marks.length ? getComputedStyle(marks[0]).fill : "";
    const code = document.querySelector(".g-src-panel")?.textContent ?? "";
    // The variable resolves to a colour of the original theme, not to nothing.
    return (marks.length > 0 && painted.startsWith("rgb") && code.includes("pub fn bar()")) || { marks: marks.length, painted, code: code.slice(0, 60) };
  });
});
await check("a Charts sidebar link is a partial navigation and the sidebar follows", async () => {
  await page.goto(new URL("charts/", base).href);
  await page.waitForFunction(() => window.dpswap);
  await page.evaluate(() => { window.sameDocument = true; });
  const requests = [];
  const listen = (r) => requests.push(new URL(r.url()).pathname);
  page.on("request", listen);
  await page.locator('#charts-side .g-side-link:text-is("Heatmap")').click();
  await page.waitForFunction(() => document.querySelector("h1")?.textContent === "Heatmap");
  page.off("request", listen);
  const state = await page.evaluate(() => ({
    same: window.sameDocument === true,
    title: document.title,
    side: document.querySelector("#charts-side .g-side-link.is-current")?.textContent,
    tab: document.querySelector(".g-top-nav .is-current")?.textContent,
  }));
  const partial = requests.some((p) => p.includes("/partials/2/charts/heatmap"));
  return (state.same && state.title.startsWith("Heatmap") && state.side === "Heatmap" && state.tab === "Charts" && partial) || { state, requests };
});
await check("every Charts sidebar link loads with no error", async () => {
  await page.goto(new URL("charts/", base).href);
  const links = await page.locator("#charts-side .g-side-link").evaluateAll((as) => as.map((a) => a.href));
  const before = errors.length;
  const broken = [];
  for (const link of links) {
    const response = await page.goto(link, { waitUntil: "load" });
    const charts = await page.locator(".g-pane .d3s-chart, .g-pane .d3s-note, .g-thumb").count();
    const failed = await page.locator('[role="alert"]').count();
    if (!response.ok() || charts === 0 || failed > 0) broken.push(link);
  }
  return (links.length === 25 && broken.length === 0 && errors.length === before) || { pages: links.length, broken, errors: errors.slice(before) };
});

await page.screenshot({ path: `${shots}/gallery-top.png` }).catch(() => {});
await browser.close().catch(() => {});

const width = Math.max(...results.map(([name]) => name.length));
for (const [name, status] of results) console.log(`${name.padEnd(width)}  ${status}`);
const failed = results.filter(([, status]) => status !== "ok");
if (errors.length) console.error("console errors:", errors);
if (failed.length || errors.length) {
  console.error(`FAILED: ${failed.length} of ${results.length} checks, ${errors.length} console errors`);
  process.exit(1);
}
console.log(`ok: ${results.length} checks passed`);
