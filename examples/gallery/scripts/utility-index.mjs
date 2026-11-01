// Writes data/utilities.json: the Tailwind utility pages from "Layout"
// onwards, with the class names each page documents.
//
// Only names are taken (which classes exist), not prose or examples. The
// gallery compiles the names through our own Tailwind configuration, so
// the CSS it shows is ours. A placeholder row (`p-<number>`) keeps its
// pattern, since there is no single class to compile.
//
// Colours: Tailwind lists its 22-colour palette for every colour utility
// (3,500 rows for border-color). We list our theme tokens instead, once
// per utility, plus one sample for each extra prefix (border-t-, ring-).
// Our own utilities (shadow-control, h-control, font-control, ...) are
// added to the pages they belong to, marked `ours`.
//
// Usage: node scripts/utility-index.mjs            (fetch, then shape)
//        node scripts/utility-index.mjs --offline  (shape the saved file again)

import { readFileSync, writeFileSync } from "node:fs";

const OUT = new URL("../data/utilities.json", import.meta.url);
const PALETTE = /^(.*)-(slate|gray|zinc|neutral|stone|mauve|olive|mist|taupe|red|orange|amber|yellow|lime|green|emerald|teal|cyan|sky|blue|indigo|violet|purple|fuchsia|pink|rose)-(50|[1-9]00|950)$/;
const TOKENS = ["background", "foreground", "heading", "card", "popover", "primary", "primary-foreground", "secondary", "muted", "muted-foreground", "accent", "accent-foreground", "destructive", "success", "warning", "link", "border", "input", "ring", "overlay", "tooltip", "chart-1", "chart-2", "chart-3", "chart-4", "chart-5"];
const OURS = {
  "border-radius": ["rounded-badge"],
  "box-shadow": ["shadow-control", "shadow-overlay"],
  "font-weight": ["font-control", "font-heading"],
  "width": ["w-control"],
  "height": ["h-control", "h-control-sm", "h-control-lg"],
  "min-width": ["min-w-control"],
  "animation": ["animate-overlay-in", "animate-content-in"],
};

function shape(categories) {
  for (const category of categories) {
    for (const page of category.pages) {
      const seen = new Set();
      const out = [];
      for (const row of page.classes) {
        if (row.ours) continue;
        const match = row.name.match(PALETTE);
        if (!match) { out.push(row); continue; }
        const prefix = match[1];
        if (seen.has(prefix)) continue;
        // The first prefix of the page gets every token; the others one sample.
        const tokens = seen.size === 0 ? TOKENS : ["primary"];
        seen.add(prefix);
        for (const token of tokens) out.push({ name: `${prefix}-${token}`, ours: true });
      }
      for (const name of OURS[page.slug] ?? []) out.push({ name, ours: true });
      page.classes = out;
    }
  }
  return categories;
}

if (process.argv.includes("--offline")) {
  writeFileSync(OUT, JSON.stringify(shape(JSON.parse(readFileSync(OUT, "utf8"))), null, 1) + "\n");
  process.exit(0);
}

const BASE = "https://tailwindcss.com/docs/";
const FIRST = "Layout";
const LAST = "Accessibility";

const strip = (html) => html.replace(/<[^>]+>/g, "").replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&amp;/g, "&").replace(/&quot;/g, '"').replace(/&#x27;/g, "'").trim();

async function get(path) {
  const response = await fetch(BASE + path, { headers: { "user-agent": "brocanth-ui utility index" } });
  if (!response.ok) throw new Error(`${path}: ${response.status}`);
  return response.text();
}

// The sidebar: <h3>Category</h3> then links, in order.
const first = await get("aspect-ratio");
const nav = first.slice(first.indexOf("Getting started") - 200);
const parts = nav.split(/<h3[^>]*>(.*?)<\/h3>/s);
const categories = [];
let collecting = false;
for (let i = 1; i < parts.length; i += 2) {
  const name = strip(parts[i]);
  if (name === FIRST) collecting = true;
  if (!collecting) continue;
  const pages = [...parts[i + 1].matchAll(/href="\/docs\/([a-z0-9-]+)"[^>]*>(.*?)<\/a>/gs)].map((m) => ({ slug: m[1], title: strip(m[2]) }));
  categories.push({ name, pages });
  if (name === LAST) break;
}

for (const category of categories) {
  for (const page of category.pages) {
    const html = await get(page.slug);
    const table = html.slice(html.indexOf("<table"), html.indexOf("</table>"));
    page.classes = [...table.matchAll(/<tr[^>]*>\s*<td[^>]*><code>(.*?)<\/code><\/td>\s*<td[^>]*>(.*?)<\/td>/gs)].map((m) => {
      const name = strip(m[1]);
      // Placeholders keep their CSS pattern; concrete classes are compiled by the gallery.
      return name.includes("<") ? { name, pattern: strip(m[2].replace(/<\/code><code>/g, "\n")) } : { name };
    });
    console.log(`${category.name} / ${page.title}: ${page.classes.length}`);
  }
}

writeFileSync(OUT, JSON.stringify(shape(categories), null, 1) + "\n");
