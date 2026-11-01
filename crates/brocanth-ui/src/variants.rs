//! Variants and their class lists.
//!
//! Class strings must appear whole in the source: Tailwind finds classes by
//! scanning these files, so it cannot see a class built with `format!`.
//! Every token-backed name (`bg-primary`, `h-control`, `shadow-control`,
//! `font-control`) is defined in `styles/theme.css`.

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum ButtonVariant {
    #[default]
    Primary,
    Secondary,
    Outline,
    Ghost,
    Destructive,
    Link,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum ButtonSize {
    Sm,
    #[default]
    Md,
    Lg,
    Icon,
}

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum BadgeVariant {
    #[default]
    Default,
    Secondary,
    Success,
    Destructive,
    Outline,
}

const BUTTON_BASE: &str = "inline-flex shrink-0 cursor-pointer items-center justify-center gap-2 whitespace-nowrap rounded-md text-sm font-control transition-colors outline-none focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:pointer-events-none disabled:opacity-50 [&_svg]:size-4 [&_svg]:shrink-0";

pub fn button(variant: ButtonVariant, size: ButtonSize) -> String {
    let variant = match variant {
        ButtonVariant::Primary => "bg-primary text-primary-foreground shadow-control hover:bg-primary-hover",
        ButtonVariant::Secondary => {
            "border border-secondary-border bg-secondary text-secondary-foreground shadow-control hover:bg-accent"
        }
        ButtonVariant::Outline => {
            "border border-input bg-background shadow-control hover:bg-accent hover:text-accent-foreground"
        }
        ButtonVariant::Ghost => "hover:bg-accent hover:text-accent-foreground",
        ButtonVariant::Destructive => {
            "bg-destructive text-destructive-foreground shadow-control hover:bg-destructive/90 focus-visible:ring-destructive/30"
        }
        ButtonVariant::Link => "text-link underline-offset-4 hover:underline",
    };
    let size = match size {
        ButtonSize::Sm => "h-control-sm gap-1.5 px-3",
        ButtonSize::Md => "h-control px-4 py-2",
        ButtonSize::Lg => "h-control-lg px-6",
        ButtonSize::Icon => "size-control",
    };
    format!("{BUTTON_BASE} {variant} {size}")
}

pub fn input() -> &'static str {
    "flex h-control w-full min-w-0 rounded-md border border-input bg-background px-3 py-1 text-sm text-foreground shadow-control outline-none transition-[color,box-shadow] placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-destructive/20"
}

/// A native `<select>`. It has no arrow of its own (`appearance-none`):
/// `NativeSelect` draws a chevron over its right padding.
pub fn select() -> &'static str {
    "h-control w-full min-w-0 cursor-pointer appearance-none rounded-md border border-input bg-background py-1 pr-8 pl-3 text-sm text-foreground shadow-control outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive"
}

/// The look of a card: corners, border, surface and shadow, without its
/// layout, for an element that has its own padding (a chart card).
pub fn card_surface() -> &'static str {
    "rounded-xl border bg-card text-card-foreground shadow-control"
}

/// An input inside an `InputGroup`: the group draws the border and the ring.
pub fn input_bare() -> &'static str {
    "h-full w-full min-w-0 flex-1 bg-transparent px-3 text-sm text-foreground outline-none placeholder:text-muted-foreground disabled:cursor-not-allowed"
}

pub fn badge(variant: BadgeVariant) -> String {
    let variant = match variant {
        BadgeVariant::Default => "border-transparent bg-primary text-primary-foreground",
        BadgeVariant::Secondary => "border-transparent bg-muted text-muted-foreground",
        BadgeVariant::Success => {
            "border-transparent bg-badge-success text-badge-success-foreground"
        }
        BadgeVariant::Destructive => {
            "border-transparent bg-destructive text-destructive-foreground"
        }
        BadgeVariant::Outline => "text-foreground",
    };
    format!("inline-flex w-fit shrink-0 items-center gap-1 whitespace-nowrap rounded-badge border px-2 py-0.5 text-xs font-control {variant}")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn every_button_class_list_starts_with_the_shared_base() {
        for variant in [ButtonVariant::Primary, ButtonVariant::Link] {
            for size in [ButtonSize::Sm, ButtonSize::Icon] {
                assert!(button(variant, size).starts_with(BUTTON_BASE));
            }
        }
    }
}
