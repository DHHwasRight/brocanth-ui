//! Inline SVG icons (Lucide shapes, MIT). Components write them with
//! `{! crate::icons::NAME }`. Each takes `currentColor` and the size of its
//! container (`[&_svg]:size-4` and similar).

macro_rules! icon {
    ($name:ident, $body:literal) => {
        pub const $name: &str = concat!(
            r#"<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">"#,
            $body,
            "</svg>"
        );
    };
}

icon!(CHECK, r#"<path d="M20 6 9 17l-5-5"/>"#);
icon!(X, r#"<path d="M18 6 6 18"/><path d="m6 6 12 12"/>"#);
icon!(CHEVRON_DOWN, r#"<path d="m6 9 6 6 6-6"/>"#);
icon!(CHEVRON_UP, r#"<path d="m18 15-6-6-6 6"/>"#);
icon!(CHEVRON_LEFT, r#"<path d="m15 18-6-6 6-6"/>"#);
icon!(CHEVRON_RIGHT, r#"<path d="m9 18 6-6-6-6"/>"#);
icon!(
    CHEVRONS_UP_DOWN,
    r#"<path d="m7 15 5 5 5-5"/><path d="m7 9 5-5 5 5"/>"#
);
icon!(
    MORE_HORIZONTAL,
    r#"<circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/><circle cx="5" cy="12" r="1"/>"#
);
icon!(
    INFO,
    r#"<circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/>"#
);
icon!(
    ALERT_CIRCLE,
    r#"<circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/>"#
);
icon!(
    ALERT_TRIANGLE,
    r#"<path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3"/><path d="M12 9v4"/><path d="M12 17h.01"/>"#
);
icon!(
    CHECK_CIRCLE,
    r#"<circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>"#
);
icon!(
    SEARCH,
    r#"<circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>"#
);
icon!(LOADER, r#"<path d="M21 12a9 9 0 1 1-6.219-8.56"/>"#);
icon!(
    INBOX,
    r#"<polyline points="22 12 16 12 14 15 10 15 8 12 2 12"/><path d="M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/>"#
);
icon!(
    PANEL_LEFT,
    r#"<rect width="18" height="18" x="3" y="3" rx="2"/><path d="M9 3v18"/>"#
);
icon!(
    ARROW_UP_DOWN,
    r#"<path d="m21 16-4 4-4-4"/><path d="M17 20V4"/><path d="m3 8 4-4 4 4"/><path d="M7 4v16"/>"#
);
icon!(ARROW_UP, r#"<path d="m5 12 7-7 7 7"/><path d="M12 19V5"/>"#);
icon!(
    ARROW_DOWN,
    r#"<path d="M12 5v14"/><path d="m19 12-7 7-7-7"/>"#
);
icon!(
    GRIP_VERTICAL,
    r#"<circle cx="9" cy="12" r="1"/><circle cx="9" cy="5" r="1"/><circle cx="9" cy="19" r="1"/><circle cx="15" cy="12" r="1"/><circle cx="15" cy="5" r="1"/><circle cx="15" cy="19" r="1"/>"#
);
icon!(
    CALENDAR,
    r#"<path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/>"#
);
icon!(
    BOLD,
    r#"<path d="M6 12h9a4 4 0 0 1 0 8H7a1 1 0 0 1-1-1V5a1 1 0 0 1 1-1h7a4 4 0 0 1 0 8"/>"#
);
icon!(
    ITALIC,
    r#"<line x1="19" x2="10" y1="4" y2="4"/><line x1="14" x2="5" y1="20" y2="20"/><line x1="15" x2="9" y1="4" y2="20"/>"#
);
icon!(
    UNDERLINE,
    r#"<path d="M6 4v6a6 6 0 0 0 12 0V4"/><line x1="4" x2="20" y1="20" y2="20"/>"#
);
