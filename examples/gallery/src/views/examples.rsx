//! Dispatches a utility page to its category's examples.

use super::u_layout;
use super::u_flexbox_grid;
use super::u_spacing;
use super::u_sizing;
use super::u_typography;
use super::u_backgrounds;
use super::u_borders;
use super::u_effects;
use super::u_filters;
use super::u_tables;
use super::u_transitions_animation;
use super::u_transforms;
use super::u_interactivity;
use super::u_svg;
use super::u_accessibility;

pub fn UtilityExample(category: &str, slug: &str) -> Element {
    match category {
        "Layout" => <u_layout::Examples slug={slug} />,
        "Flexbox & Grid" => <u_flexbox_grid::Examples slug={slug} />,
        "Spacing" => <u_spacing::Examples slug={slug} />,
        "Sizing" => <u_sizing::Examples slug={slug} />,
        "Typography" => <u_typography::Examples slug={slug} />,
        "Backgrounds" => <u_backgrounds::Examples slug={slug} />,
        "Borders" => <u_borders::Examples slug={slug} />,
        "Effects" => <u_effects::Examples slug={slug} />,
        "Filters" => <u_filters::Examples slug={slug} />,
        "Tables" => <u_tables::Examples slug={slug} />,
        "Transitions & Animation" => <u_transitions_animation::Examples slug={slug} />,
        "Transforms" => <u_transforms::Examples slug={slug} />,
        "Interactivity" => <u_interactivity::Examples slug={slug} />,
        "SVG" => <u_svg::Examples slug={slug} />,
        "Accessibility" => <u_accessibility::Examples slug={slug} />,
        _ => <super::reference::NoExample />,
    }
}
