//! Server-side code highlighting with giallo, as in the d3set gallery:
//! TextMate grammars and VS Code themes. rsx brings its own grammar
//! (`rsx::grammar`); Rust and TypeScript are built in.

use std::sync::LazyLock;

use giallo::{HighlightOptions, HtmlRenderer, Registry, RenderOptions, ThemeVariant};

/// The d3set gallery's code themes. giallo writes each colour as
/// `light-dark(light, dark)`, so the page's colour scheme picks one.
const THEME_DARK: &str = "night-owl";
const THEME_LIGHT: &str = "night-owl-light";

static REGISTRY: LazyLock<Registry> =
    LazyLock::new(|| build().unwrap_or_else(|e| panic!("gallery: code highlighting: {e}")));

fn build() -> Result<Registry, String> {
    let mut registry = Registry::builtin().map_err(|e| e.to_string())?;
    // giallo loads grammars from files: write rsx's where it can read it.
    let dir = std::env::temp_dir().join(format!("brocanth-ui-grammars-{}", std::process::id()));
    std::fs::create_dir_all(&dir).map_err(|e| e.to_string())?;
    let path = dir.join("rsx.tmLanguage.json");
    std::fs::write(&path, rsx::grammar::TEXTMATE).map_err(|e| e.to_string())?;
    registry
        .add_grammar_from_path(&path)
        .map_err(|e| format!("rsx grammar: {e}"))?;
    let _ = std::fs::remove_dir_all(&dir);
    registry.add_alias(giallo::PLAIN_GRAMMAR_NAME, "text");
    registry.link_grammars();
    Ok(registry)
}

/// `<pre><code>` with inline colours. `lang`: `rsx`, `rust`, `typescript`.
pub fn html(code: &str, lang: &str) -> String {
    let theme = ThemeVariant::Dual {
        light: THEME_LIGHT,
        dark: THEME_DARK,
    };
    let options = HighlightOptions::new(lang, theme).fallback_to_plain(true);
    match REGISTRY.highlight(code.trim_end(), &options) {
        Ok(highlighted) => HtmlRenderer::default().render(&highlighted, &RenderOptions::default()),
        Err(e) => {
            eprintln!("gallery: cannot highlight {lang}: {e}");
            format!(
                "<pre><code>{}</code></pre>",
                code.replace('&', "&amp;")
                    .replace('<', "&lt;")
                    .replace('>', "&gt;")
            )
        }
    }
}
