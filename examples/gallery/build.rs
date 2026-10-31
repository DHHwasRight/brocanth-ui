//! Compiles the gallery's stylesheet with the Tailwind CLI from mise.

use std::{env, path::PathBuf, process::Command};

fn main() {
    for watched in [
        "build.rs",
        "styles",
        "src",
        "../../crates/brocanth-ui/src",
        "../../crates/brocanth-ui/styles",
    ] {
        println!("cargo:rerun-if-changed={watched}");
    }
    println!("cargo:rerun-if-env-changed=TAILWINDCSS");
    let out = PathBuf::from(env::var("OUT_DIR").unwrap()).join("gallery.css");
    let cli = env::var("TAILWINDCSS").unwrap_or_else(|_| "tailwindcss".to_string());
    let status = Command::new(&cli)
        .args(["--input", "styles/gallery.css", "--output"])
        .arg(&out)
        .arg("--minify")
        .status()
        .unwrap_or_else(|error| panic!("gallery: cannot run `{cli}`: {error}\nhelp: build through mise (`mise run gallery`)"));
    assert!(
        status.success(),
        "gallery: `{cli}` failed\nhelp: run `{cli} --input styles/gallery.css` to see the error"
    );
}
