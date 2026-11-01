//! Compiles the gallery's stylesheets with the Tailwind CLI from mise:
//!
//! 1. `gallery.css`: the page's own stylesheet (minified).
//! 2. `reference.css`: every class the Utilities tab documents, compiled
//!    through brocanth-ui's configuration (not minified). The gallery reads
//!    it to show, next to each class, the CSS our configuration produces.

use std::{env, fs, path::Path, path::PathBuf, process::Command};

fn main() {
    for watched in [
        "build.rs",
        "styles",
        "src",
        "data/utilities.json",
        "../../crates/brocanth-ui/src",
        "../../crates/brocanth-ui/styles",
    ] {
        println!("cargo:rerun-if-changed={watched}");
    }
    println!("cargo:rerun-if-env-changed=TAILWINDCSS");
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
    let manifest = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());

    tailwind(
        Path::new("styles/gallery.css"),
        &out_dir.join("gallery.css"),
        true,
    );

    // Every concrete class of the index, fed to Tailwind with `@source inline`.
    let index = fs::read_to_string("data/utilities.json").unwrap();
    let mut classes = Vec::new();
    for chunk in index.split("\"name\": \"").skip(1) {
        let name = &chunk[..chunk.find('"').unwrap()];
        if !name.contains('<') {
            classes.push(name.replace('\\', ""));
        }
    }
    let styles = manifest.join("../../crates/brocanth-ui/styles");
    let input = out_dir.join("reference.input.css");
    let mut css = format!(
        "@import \"tailwindcss\" source(none);\n@import \"{0}/theme.css\";\n@import \"{0}/themes/shadcn.css\";\n@import \"{0}/themes/original.css\";\n",
        styles.display()
    );
    for batch in classes.chunks(200) {
        css.push_str(&format!("@source inline(\"{}\");\n", batch.join(" ")));
    }
    fs::write(&input, css).unwrap();
    tailwind(&input, &out_dir.join("reference.css"), false);
}

fn tailwind(input: &Path, output: &Path, minify: bool) {
    let cli = env::var("TAILWINDCSS").unwrap_or_else(|_| "tailwindcss".to_string());
    let mut command = Command::new(&cli);
    command
        .arg("--input")
        .arg(input)
        .arg("--output")
        .arg(output);
    if minify {
        command.arg("--minify");
    }
    let status = command.status().unwrap_or_else(|error| {
        panic!(
            "gallery: cannot run `{cli}`: {error}\nhelp: build through mise (`mise run gallery`)"
        )
    });
    assert!(
        status.success(),
        "gallery: `{cli}` failed on {}\nhelp: run `{cli} --input {}` to see the error",
        input.display(),
        input.display()
    );
}
