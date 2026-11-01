//! The code under each example: the demo's rsx, the component's rsx, and
//! the glue it loads, read from the sources at export time and
//! highlighted. The gallery shows the files as they are in the repo.

use std::collections::HashMap;
use std::path::{Path, PathBuf};

use crate::catalog::{Entry, Js, GROUPS};
use crate::charts_data::kinds;
use crate::highlight;
use crate::reference::CATEGORIES;

/// One tab of the code panel.
pub struct Tab {
    pub label: &'static str,
    /// Path from the repository root.
    pub path: String,
    pub html: String,
}

/// The grammar for a file, by extension.
fn lang(path: &str) -> &'static str {
    match path.rsplit('.').next() {
        Some("rsx") => "rsx",
        Some("rs") => "rust",
        Some("ts") => "typescript",
        Some("css") => "css",
        Some("toml") => "toml",
        Some("json") => "json",
        _ => "text",
    }
}

/// A tab with a whole file.
fn file(label: &'static str, path: &str) -> Tab {
    let text = read(path);
    Tab {
        label,
        html: highlight::html(&text, lang(path)),
        path: path.to_string(),
    }
}

/// A tab with the part of a file from `start` up to and including `end`.
fn part(label: &'static str, path: &str, start: &str, end: &str) -> Tab {
    let text = read(path);
    let from = text
        .find(start)
        .unwrap_or_else(|| panic!("gallery: `{start}` not in {path}"));
    let to = text[from..]
        .find(end)
        .map_or(text.len(), |at| from + at + end.len());
    Tab {
        label,
        html: highlight::html(&text[from..to], lang(path)),
        path: path.to_string(),
    }
}

/// The Example tab of each utility page, by slug: the `<Slug>Example`
/// function from the category's rsx file.
pub fn utilities() -> HashMap<String, Vec<Tab>> {
    let mut out = HashMap::new();
    for category in CATEGORIES.iter() {
        let module = format!(
            "u_{}",
            category
                .name
                .to_lowercase()
                .split(|c: char| !c.is_ascii_alphanumeric())
                .filter(|w| !w.is_empty())
                .collect::<Vec<_>>()
                .join("_")
        );
        let path = format!("examples/gallery/src/views/{module}.rsx");
        let text = read(&path);
        for page in &category.pages {
            let name = format!("{}Example", pascal(&page.slug));
            let tabs = extract_fn(&text, &name)
                .map(|source| {
                    vec![Tab {
                        label: "Example",
                        path: path.clone(),
                        html: highlight::html(&source, "rsx"),
                    }]
                })
                .unwrap_or_default();
            out.insert(page.slug.clone(), tabs);
        }
    }
    out
}

/// The Code accordions of the Configuration guide, by section.
pub fn guide() -> HashMap<&'static str, Vec<Tab>> {
    let theme = "crates/brocanth-ui/styles/theme.css";
    let guide = "examples/gallery/src/views/guide.rsx";
    let demo = |label, name: &str| {
        let text = read(guide);
        let source =
            extract_fn(&text, name).unwrap_or_else(|| panic!("gallery: no {name} in {guide}"));
        Tab {
            label,
            path: guide.to_string(),
            html: highlight::html(&source, "rsx"),
        }
    };
    HashMap::from([
        (
            "sources",
            vec![
                file("ui.css", "crates/brocanth-ui/styles/ui.css"),
                file(
                    "An app's own Tailwind",
                    "examples/gallery/styles/gallery.css",
                ),
            ],
        ),
        (
            "theme",
            vec![
                part("theme.css", theme, "@theme inline {", "\n}\n"),
                demo("Example", "GuideTokens"),
            ],
        ),
        (
            "themes",
            vec![
                file(
                    "original.css",
                    "crates/brocanth-ui/styles/themes/original.css",
                ),
                file("shadcn.css", "crates/brocanth-ui/styles/themes/shadcn.css"),
            ],
        ),
        (
            "base",
            vec![part("theme.css", theme, "@layer base {", "\n}\n")],
        ),
        (
            "motion",
            vec![
                part("theme.css", theme, "/*\n * Motion", "\n}\n"),
                demo("Example", "GuideMotion"),
            ],
        ),
        (
            "rsx",
            vec![
                demo("Example", "GuideRsx"),
                file("button.rsx", "crates/brocanth-ui/src/components/button.rsx"),
                part(
                    "variants.rs",
                    "crates/brocanth-ui/src/variants.rs",
                    "const BUTTON_BASE",
                    "\n}\n\npub fn input",
                ),
            ],
        ),
        (
            "build",
            vec![
                file("build.rs", "crates/brocanth-ui/build.rs"),
                file("mise.toml", "mise.toml"),
            ],
        ),
    ])
}

/// The Code panel of each chart page, by kind: the function that builds
/// the kind's examples, the rsx that renders them with brocanth-ui's Chart,
/// and the d3set-ssr template that draws the chart.
pub fn charts() -> HashMap<&'static str, Vec<Tab>> {
    let data = "examples/gallery/src/charts_data.rs";
    let view = "examples/gallery/src/views/charts.rsx";
    let (data_text, view_text) = (read(data), read(view));
    let page = extract_fn(&view_text, "ChartExamples")
        .unwrap_or_else(|| panic!("gallery: no ChartExamples in {view}"));
    kinds()
        .map(|kind| {
            let spec = extract_fn(&data_text, kind)
                .unwrap_or_else(|| panic!("gallery: no fn {kind} in {data}"));
            let mut tabs = vec![
                Tab {
                    label: "Spec",
                    path: data.to_string(),
                    html: highlight::html(&spec, "rust"),
                },
                Tab {
                    label: "Page",
                    path: view.to_string(),
                    html: highlight::html(&page, "rsx"),
                },
            ];
            if let Some(template) = d3set_ssr::sources::view(kind) {
                tabs.push(Tab {
                    label: "Template",
                    path: format!("d3set-ssr/src/views/{}.rsx", template_file(kind)),
                    html: highlight::html(template, "rsx"),
                });
            }
            (kind, tabs)
        })
        .collect()
}

/// The d3set-ssr template file of a kind (`d3set_ssr::sources::view`).
fn template_file(kind: &str) -> &str {
    match kind {
        "line" | "area" | "timeseries" => "xy",
        "donut" => "pie",
        other => other,
    }
}

fn repo() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR")).join("../..")
}

fn read(path: &str) -> String {
    std::fs::read_to_string(repo().join(path))
        .unwrap_or_else(|e| panic!("gallery: cannot read {path}: {e}"))
}

/// Every entry's tabs, by slug.
pub fn all() -> HashMap<&'static str, Vec<Tab>> {
    let demos = demo_sources();
    GROUPS
        .iter()
        .flat_map(|group| group.entries)
        .map(|entry| (entry.slug, tabs(entry, &demos)))
        .collect()
}

fn tabs(entry: &Entry, demos: &[(String, String)]) -> Vec<Tab> {
    let mut tabs = Vec::new();
    let name = format!("{}Demo", pascal(entry.slug));
    if let Some((path, source)) = demos
        .iter()
        .find_map(|(path, text)| extract_fn(text, &name).map(|f| (path, f)))
    {
        tabs.push(Tab {
            label: "Usage",
            path: path.clone(),
            html: highlight::html(&source, "rsx"),
        });
    }
    let component = component_path(entry.slug);
    tabs.push(Tab {
        label: "Component",
        html: highlight::html(&read(&component), "rsx"),
        path: component,
    });
    if let Some(glue) = glue_path(entry.js) {
        tabs.push(Tab {
            label: "Glue",
            html: highlight::html(&read(&glue), "typescript"),
            path: glue,
        });
    }
    tabs
}

fn demo_sources() -> Vec<(String, String)> {
    ["actions", "forms", "overlays", "data", "layout"]
        .iter()
        .map(|file| {
            let path = format!("examples/gallery/src/views/{file}.rsx");
            let text = read(&path);
            (path, text)
        })
        .collect()
}

/// `pub fn <name>(...) ... }`: from the signature to the first `}` at the
/// start of a line, which closes a top-level function in these files.
fn extract_fn(text: &str, name: &str) -> Option<String> {
    let start = text.find(&format!("pub fn {name}("))?;
    let end = text[start..].find("\n}\n")? + start + 2;
    Some(text[start..end].to_string())
}

fn pascal(slug: &str) -> String {
    slug.split('-')
        .map(|word| word[..1].to_uppercase() + &word[1..])
        .collect()
}

/// The rsx file that defines the component.
fn component_path(slug: &str) -> String {
    let file = match slug {
        "alert-dialog" | "sheet" | "drawer" => "dialog",
        "dropdown-menu" | "context-menu" | "menubar" => "menu",
        "date-picker" => "calendar",
        "toast" => "toast",
        "chart" => return "crates/brocanth-ui/src/charts/chart.rsx".to_string(),
        other => {
            return format!(
                "crates/brocanth-ui/src/components/{}.rsx",
                other.replace('-', "_")
            )
        }
    };
    format!("crates/brocanth-ui/src/components/{file}.rsx")
}

/// The TypeScript glue the component loads, if any.
fn glue_path(js: Js) -> Option<String> {
    let file = match js {
        Js::None(_) => return None,
        Js::Glue(file) => file.trim_end_matches(".ts"),
        Js::Zag("listbox") => "command",
        Js::Zag("toast") => "toaster",
        Js::Zag("splitter") => "resizable",
        Js::Zag(package) => package,
    };
    Some(format!(
        "crates/brocanth-ui/assets/brocanth-ui/_glue/{file}.ts"
    ))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn every_utility_page_has_an_example_and_its_source() {
        let examples = utilities();
        assert_eq!(examples.len(), 184);
        let missing: Vec<_> = examples
            .iter()
            .filter(|(_, tabs)| tabs.is_empty())
            .map(|(slug, _)| slug.as_str())
            .collect();
        assert!(
            missing.is_empty(),
            "no <Slug>Example function for {missing:?}"
        );
    }

    #[test]
    fn every_entry_has_its_usage_and_component_source() {
        let demos = demo_sources();
        for entry in GROUPS.iter().flat_map(|group| group.entries) {
            let name = format!("{}Demo", pascal(entry.slug));
            assert!(
                demos
                    .iter()
                    .any(|(_, text)| extract_fn(text, &name).is_some()),
                "no {name}"
            );
            assert!(
                repo().join(component_path(entry.slug)).exists(),
                "no component file for {}",
                entry.slug
            );
            if let Some(glue) = glue_path(entry.js) {
                assert!(repo().join(&glue).exists(), "no glue {glue}");
            }
        }
    }
}
