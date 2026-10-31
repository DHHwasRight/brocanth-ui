//! The code under each example: the demo's rsx, the component's rsx, and
//! the glue it loads, read from the sources at export time and
//! highlighted. The gallery shows the files as they are in the repo.

use std::collections::HashMap;
use std::path::{Path, PathBuf};

use crate::catalog::{Entry, Js, GROUPS};
use crate::highlight;

/// One tab of the code panel.
pub struct Tab {
    pub label: &'static str,
    /// Path from the repository root.
    pub path: String,
    pub html: String,
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
