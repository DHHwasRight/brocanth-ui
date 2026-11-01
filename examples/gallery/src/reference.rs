//! The Utilities tab: Tailwind's utility pages, from Layout onwards, with
//! the CSS that brocanth-ui's configuration produces for each class.
//!
//! `data/utilities.json` names the classes (scripts/utility-index.mjs).
//! build.rs compiles them all through our theme into `reference.css`, and
//! this module reads each class's rules back out of it.

use std::collections::HashMap;
use std::sync::LazyLock;

use serde::Deserialize;

#[derive(Deserialize)]
pub struct Category {
    pub name: String,
    pub pages: Vec<Page>,
}

#[derive(Deserialize)]
pub struct Page {
    pub slug: String,
    pub title: String,
    pub classes: Vec<Row>,
}

#[derive(Deserialize)]
pub struct Row {
    pub name: String,
    /// A placeholder row (`p-<number>`): its CSS pattern, not compiled.
    #[serde(default)]
    pub pattern: Option<String>,
    /// A class our configuration adds or replaces (tokens, `h-control`).
    #[serde(default)]
    pub ours: bool,
}

pub static CATEGORIES: LazyLock<Vec<Category>> = LazyLock::new(|| {
    serde_json::from_str(include_str!("../data/utilities.json"))
        .expect("data/utilities.json is valid")
});

static COMPILED: LazyLock<Vec<Rule>> =
    LazyLock::new(|| parse(include_str!(concat!(env!("OUT_DIR"), "/reference.css"))));
static BY_CLASS: LazyLock<HashMap<String, Vec<usize>>> = LazyLock::new(|| {
    let mut index: HashMap<String, Vec<usize>> = HashMap::new();
    for (i, rule) in COMPILED.iter().enumerate() {
        for class in classes_in(&rule.selector) {
            index.entry(class).or_default().push(i);
        }
    }
    index
});

/// One short sentence for the page, from its CSS property.
pub fn lead(page: &Page) -> String {
    format!(
        "Utilities that set {} with brocanth-ui's configuration.",
        page.title.replace(" / ", ", ")
    )
}

/// The CSS for a row: the compiled rules, or the pattern of a placeholder.
pub fn styles(row: &Row) -> String {
    if let Some(pattern) = &row.pattern {
        return pattern.clone();
    }
    let Some(indices) = BY_CLASS.get(&row.name) else {
        return String::from("/* not in this Tailwind version */");
    };
    let escaped = escape(&row.name);
    let rules: Vec<&Rule> = indices.iter().map(|&i| &COMPILED[i]).collect();
    if let [rule] = rules.as_slice() {
        if rule.selector == format!(".{escaped}") {
            return rule.declarations.join("\n");
        }
    }
    rules
        .iter()
        .map(|rule| {
            format!(
                "{} {{\n  {}\n}}",
                rule.selector,
                rule.declarations.join("\n  ")
            )
        })
        .collect::<Vec<_>>()
        .join("\n")
}

/// A class name as it appears in a CSS selector: `w-1/2` → `w-1\/2`.
pub fn escape(name: &str) -> String {
    let mut out = String::new();
    for c in name.chars() {
        if c.is_ascii_alphanumeric() || c == '-' || c == '_' {
            out.push(c);
        } else {
            out.push('\\');
            out.push(c);
        }
    }
    out
}

/// The class names a selector uses (unescaped).
fn classes_in(selector: &str) -> Vec<String> {
    let mut out = Vec::new();
    let mut chars = selector.chars().peekable();
    while let Some(c) = chars.next() {
        if c != '.' {
            continue;
        }
        let mut name = String::new();
        while let Some(&next) = chars.peek() {
            if next == '\\' {
                chars.next();
                if let Some(escaped) = chars.next() {
                    name.push(escaped);
                }
            } else if next.is_ascii_alphanumeric() || next == '-' || next == '_' {
                name.push(next);
                chars.next();
            } else {
                break;
            }
        }
        if !name.is_empty() {
            out.push(name);
        }
    }
    out
}

struct Rule {
    selector: String,
    declarations: Vec<String>,
}

/// A small CSS reader for Tailwind's own output: rules, declarations, and
/// nesting through @layer, @media, @supports. @property and @keyframes are
/// skipped.
fn parse(css: &str) -> Vec<Rule> {
    let mut rules = Vec::new();
    parse_block(css, "", &mut rules);
    rules
}

fn parse_block(text: &str, parent: &str, rules: &mut Vec<Rule>) {
    let bytes = text.as_bytes();
    let mut i = 0;
    let mut start = 0;
    let mut declarations = Vec::new();
    while i < bytes.len() {
        match bytes[i] {
            b'/' if bytes.get(i + 1) == Some(&b'*') => {
                let end = text[i + 2..]
                    .find("*/")
                    .map_or(bytes.len(), |e| i + 2 + e + 2);
                i = end;
                start = i;
                continue;
            }
            b';' => {
                let declaration = text[start..i].trim();
                if !declaration.is_empty() {
                    declarations.push(format!("{declaration};"));
                }
                start = i + 1;
            }
            b'{' => {
                let prelude = text[start..i].trim().to_string();
                let close = matching(bytes, i);
                let inner = &text[i + 1..close];
                if prelude.starts_with("@property")
                    || prelude.starts_with("@keyframes")
                    || prelude.starts_with("@font-face")
                {
                    // Not a utility rule.
                } else if prelude.starts_with('@') {
                    parse_block(inner, parent, rules);
                } else {
                    let selector = if parent.is_empty() {
                        prelude
                    } else {
                        prelude.replace('&', parent)
                    };
                    parse_block(inner, &selector, rules);
                }
                i = close + 1;
                start = i;
                continue;
            }
            _ => {}
        }
        i += 1;
    }
    if !parent.is_empty() && !declarations.is_empty() {
        rules.push(Rule {
            selector: parent.to_string(),
            declarations,
        });
    }
}

fn matching(bytes: &[u8], open: usize) -> usize {
    let mut depth = 0;
    for (offset, byte) in bytes[open..].iter().enumerate() {
        match byte {
            b'{' => depth += 1,
            b'}' => {
                depth -= 1;
                if depth == 0 {
                    return open + offset;
                }
            }
            _ => {}
        }
    }
    bytes.len()
}

#[cfg(test)]
mod tests {
    use super::*;

    fn row(name: &str) -> Row {
        Row {
            name: name.into(),
            pattern: None,
            ours: false,
        }
    }

    #[test]
    fn a_class_shows_the_css_our_configuration_produces() {
        assert_eq!(
            styles(&row("rounded-md")),
            "border-radius: var(--ui-radius-md);"
        );
        assert_eq!(
            styles(&row("bg-primary")),
            "background-color: var(--ui-primary);"
        );
        assert!(
            styles(&row("h-control")).contains("--ui-control-h")
                || styles(&row("h-control")).contains("--spacing-control")
        );
    }

    #[test]
    fn selectors_are_escaped_and_read_back() {
        assert_eq!(escape("w-1/2"), "w-1\\/2");
        assert_eq!(classes_in(".w-1\\/2:hover"), vec!["w-1/2".to_string()]);
        assert!(styles(&row("w-full")).contains("width: 100%"));
    }

    #[test]
    fn every_page_has_classes() {
        assert_eq!(CATEGORIES.iter().map(|c| c.pages.len()).sum::<usize>(), 184);
        for category in CATEGORIES.iter() {
            for page in &category.pages {
                assert!(!page.classes.is_empty(), "{} has no classes", page.slug);
            }
        }
    }
}
