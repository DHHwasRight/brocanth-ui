// Drives the gallery in headless Chromium and checks the dialog glue:
// open, focus trap, Escape, focus return, alert-dialog rules, outside
// click, and unmount/remount around a dp-swap.
//
// mise run browser-test   (serves target/gallery on :4100 first)
// Env: CHROME (headless shell path), GALLERY_URL, SHOTS (screenshot dir).
import { chromium } from "playwright-core";
const exe = process.env.CHROME ?? (process.env.HOME + "/Library/Caches/ms-playwright/chromium_headless_shell-1248/chrome-headless-shell-mac-arm64/chrome-headless-shell");
const browser = await chromium.launch({ executablePath: exe });
const page = await browser.newPage({ viewport: { width: 1400, height: 1000 } });
const errors = [];
page.on("console", (m) => m.type() === "error" && errors.push(m.text()));
page.on("pageerror", (e) => errors.push(String(e)));
page.on("requestfailed", (r) => errors.push("failed " + r.url()));
await page.goto(process.env.GALLERY_URL ?? "http://localhost:4100/");
await page.waitForFunction(() => document.getElementById("ui-portal")?.children.length === 8, null, { timeout: 5000 }).catch(() => errors.push("portal not filled"));
await page.screenshot({ path: `${process.env.SHOTS ?? "target"}/closed.png`, fullPage: true });
const r = {};
const trig = page.locator('#shadcn-invite [data-part="trigger"]');
await trig.click();
const content = page.locator('#dialog\\:shadcn-invite\\:content');
r.openVisible = await content.isVisible();
r.ariaExpanded = await trig.getAttribute("aria-expanded");
r.inPortal = await content.evaluate((el) => !!el.closest("#ui-portal"));
r.portalTheme = await content.evaluate((el) => el.closest("[data-ui-portaled]")?.dataset.theme);
r.focusInside = await page.evaluate(() => !!document.activeElement.closest('[data-part="content"]'));
r.labelledby = await content.getAttribute("aria-labelledby");
await page.screenshot({ path: `${process.env.SHOTS ?? "target"}/open-shadcn.png` });
await page.keyboard.press("Escape");
await page.waitForTimeout(150);
r.closedAfterEsc = !(await content.isVisible());
r.focusBackOnTrigger = await page.evaluate(() => document.activeElement.closest("#shadcn-invite") !== null);
await page.locator('#stripe-delete [data-part="trigger"]').click();
const alert = page.locator('#dialog\\:stripe-delete\\:content');
r.alertRole = await alert.getAttribute("role");
await page.waitForTimeout(100);
r.alertFocus = await page.evaluate(() => document.activeElement.textContent.trim());
await page.screenshot({ path: `${process.env.SHOTS ?? "target"}/open-stripe-alert.png` });
await page.mouse.click(10, 10);
await page.waitForTimeout(150);
r.alertStaysOnOutsideClick = await alert.isVisible();
await page.locator('#dialog\\:stripe-delete\\:content [data-close-primary]').click();
await page.waitForTimeout(150);
r.alertClosedByCancel = !(await alert.isVisible());
// Stripe invite, outside click closes a normal dialog
await page.locator('#stripe-invite [data-part="trigger"]').click();
await page.waitForTimeout(100);
await page.screenshot({ path: `${process.env.SHOTS ?? "target"}/open-stripe.png` });
await page.mouse.click(10, 10);
await page.waitForTimeout(150);
r.normalClosesOnOutside = !(await page.locator('#dialog\\:stripe-invite\\:content').isVisible());
// dp-swap: replace the stripe column the way dp-swap does (innerHTML).
await page.evaluate(() => {
  const col = document.querySelector('[data-theme="stripe"]');
  const before = new CustomEvent("dp:beforeSwap", { bubbles: true, cancelable: true, detail: { spec: { swap: { style: "innerHTML" } } } });
  col.dispatchEvent(before);
  const html = col.innerHTML; // overlays are back in place now
  col.innerHTML = html.replace(/stripe-invite/g, "stripe-invite2");
  col.dispatchEvent(new CustomEvent("dp:afterSwap", { bubbles: true, detail: {} }));
});
await page.waitForTimeout(300);
r.portalAfterSwap = await page.evaluate(() => [...document.querySelectorAll("#ui-portal > *")].map((n) => n.querySelector("[data-part=content]")?.id ?? n.id));
await page.locator('#stripe-invite2 [data-part="trigger"]').click();
await page.waitForTimeout(150);
r.swappedDialogOpens = await page.locator('#dialog\\:stripe-invite2\\:content').isVisible();
console.log(JSON.stringify(r, null, 1));
await browser.close();
const failed = Object.entries(r).filter(([, v]) => v === false).map(([k]) => k);
if (r.alertFocus !== "Cancel") failed.push("alertFocus");
if (r.portalTheme !== "shadcn") failed.push("portalTheme");
if (errors.length || failed.length) {
  console.error("FAILED:", failed, "errors:", errors);
  process.exit(1);
}
console.log("ok: all dialog checks passed");
