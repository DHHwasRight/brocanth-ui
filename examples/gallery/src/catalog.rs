//! Every component the gallery shows, in sidebar order, with the
//! JavaScript it costs.

/// What a component needs in the browser.
#[derive(Clone, Copy)]
pub enum Js {
    /// Nothing: HTML and CSS, or a platform feature.
    None(&'static str),
    /// A small glue file, no Zag.
    Glue(&'static str),
    /// A Zag machine.
    Zag(&'static str),
}

impl Js {
    pub fn class(self) -> &'static str {
        match self {
            Js::None(_) => "js-none",
            Js::Glue(_) => "js-glue",
            Js::Zag(_) => "js-zag",
        }
    }

    pub fn label(self) -> String {
        match self {
            Js::None(how) => format!("No JS · {how}"),
            Js::Glue(file) => format!("Glue · {file}"),
            Js::Zag(package) => format!("Zag · @zag-js/{package}"),
        }
    }
}

pub struct Entry {
    pub slug: &'static str,
    pub name: &'static str,
    pub js: Js,
    pub blurb: &'static str,
}

pub struct Group {
    pub name: &'static str,
    pub entries: &'static [Entry],
}

const fn e(slug: &'static str, name: &'static str, js: Js, blurb: &'static str) -> Entry {
    Entry {
        slug,
        name,
        js,
        blurb,
    }
}

pub const GROUPS: &[Group] = &[
    Group { name: "Actions", entries: &[
        e("button", "Button", Js::None("HTML"), "Six variants, four sizes. type=\"button\" by default, so it never submits a form by accident."),
        e("button-group", "Button group", Js::None("CSS"), "Joins buttons edge to edge."),
        e("toggle", "Toggle", Js::None("checkbox"), "A checkbox drawn as a button: the pressed state posts with the form."),
        e("toggle-group", "Toggle group", Js::None("radios"), "Radios or checkboxes drawn as joined toggles. Arrow keys come from the native radio group."),
    ]},
    Group { name: "Forms", entries: &[
        e("input", "Input", Js::None("HTML"), "Text input with label and hint."),
        e("input-group", "Input group", Js::None(":has()"), "Add-ons inside one border; the group draws the focus ring."),
        e("input-otp", "Input OTP", Js::None("one input"), "One native input drawn as slots. Paste and one-time-code autofill work as usual."),
        e("textarea", "Textarea", Js::None("field-sizing"), "Grows with its content where the engine supports field-sizing."),
        e("checkbox", "Checkbox", Js::None("HTML"), "A native checkbox with appearance: none."),
        e("radio-group", "Radio group", Js::None("HTML"), "Native radios in a fieldset."),
        e("switch", "Switch", Js::None("role=switch"), "A checkbox with role=switch, drawn as a track and a thumb."),
        e("slider", "Slider", Js::None("range"), "A native range input; accent-color fills the track."),
        e("native-select", "Native select", Js::None("HTML"), "The platform select, styled. The default choice for forms."),
        e("select", "Select", Js::Zag("select"), "A styled list with typeahead. A hidden native select posts the value."),
        e("combobox", "Combobox", Js::Zag("combobox"), "Type to filter. A hidden input posts the value."),
        e("field", "Field", Js::None("HTML"), "Field sets, descriptions and server-side errors."),
        e("calendar", "Calendar", Js::None("radios + links"), "Server-rendered month. Days are radios; month links swap the calendar with dp-swap."),
        e("date-picker", "Date picker", Js::Glue("date-picker.ts"), "The calendar in a popover. 0.4 KB of glue writes the date into the trigger."),
    ]},
    Group { name: "Overlays", entries: &[
        e("dialog", "Dialog", Js::None("<dialog> + commandfor"), "Native modal: top layer, focus trap, Escape, inert page. closedby=\"any\" closes on an outside click."),
        e("alert-dialog", "Alert dialog", Js::None("<dialog>"), "No outside dismiss; the safe action takes the focus."),
        e("sheet", "Sheet", Js::None("<dialog>"), "A dialog that slides in from an edge."),
        e("drawer", "Drawer", Js::None("<dialog>"), "A bottom sheet with a grab handle."),
        e("popover", "Popover", Js::None("popover + anchor"), "Native popover with light dismiss, placed with CSS anchor positioning."),
        e("hover-card", "Hover card", Js::None("CSS"), "Opens on hover or focus after a delay."),
        e("tooltip", "Tooltip", Js::None("CSS + anchor"), "Hover and focus, anchored. A 10-line shim in boot hides it on Escape."),
        e("dropdown-menu", "Dropdown menu", Js::Zag("menu"), "Arrow keys, typeahead, checkbox and radio items."),
        e("context-menu", "Context menu", Js::Zag("menu"), "Right-click or long-press inside the area."),
        e("menubar", "Menubar", Js::Zag("menu"), "A row of menus."),
        e("command", "Command", Js::Zag("listbox"), "Type to filter; arrows and Enter from the input."),
        e("toast", "Toast", Js::Zag("toast"), "Stacked, timed, paused on hover. The server raises one with markup or a response header."),
    ]},
    Group { name: "Navigation", entries: &[
        e("breadcrumb", "Breadcrumb", Js::None("HTML"), "A trail of links."),
        e("navigation-menu", "Navigation menu", Js::None("popover"), "Site links; flyouts are native popovers."),
        e("pagination", "Pagination", Js::None("links"), "Links, so dp-boost turns them into partial navigations."),
        e("tabs", "Tabs", Js::Zag("tabs"), "Roving focus and arrow keys. shadcn draws a pill, the original theme an underline: tokens only."),
        e("sidebar", "Sidebar", Js::None("checkbox + :has()"), "Collapses on wide screens, slides over on narrow ones."),
    ]},
    Group { name: "Data display", entries: &[
        e("table", "Table", Js::None("HTML"), "The header case, size and colour are theme tokens."),
        e("data-table", "Data table", Js::None("links"), "Sorting and paging are links the server answers, for any size of data."),
        e("chart", "Chart", Js::None("d3set-ssr SVG"), "Rendered on the server by d3set-ssr. Series colours are the theme's chart tokens."),
        e("card", "Card", Js::None("HTML"), "Header, content, footer."),
        e("badge", "Badge", Js::None("HTML"), "Five variants."),
        e("avatar", "Avatar", Js::None("HTML"), "The image covers the initials; a broken image shows them."),
        e("item", "Item", Js::None("HTML"), "A row with media, text and actions."),
        e("kbd", "Kbd", Js::None("HTML"), "Keyboard keys."),
        e("typography", "Typography", Js::None("CSS"), "Styles for prose from Markdown or a CMS."),
        e("carousel", "Carousel", Js::Glue("carousel.ts"), "Scroll-snap without JS; 0.6 KB of glue adds the buttons."),
    ]},
    Group { name: "Feedback", entries: &[
        e("alert", "Alert", Js::None("HTML"), "Five variants; only the urgent ones use role=alert."),
        e("progress", "Progress", Js::None("HTML"), "A server-rendered bar; dp-swap it for live progress."),
        e("skeleton", "Skeleton", Js::None("CSS"), "Placeholder blocks."),
        e("spinner", "Spinner", Js::None("CSS"), "With role=status."),
        e("empty", "Empty", Js::None("HTML"), "An empty state with actions."),
    ]},
    Group { name: "Layout", entries: &[
        e("accordion", "Accordion", Js::None("<details name>"), "One open at a time, enforced by the browser. Find-in-page opens the matching item."),
        e("collapsible", "Collapsible", Js::None("<details>"), "One section that opens and closes."),
        e("aspect-ratio", "Aspect ratio", Js::None("CSS"), "aspect-ratio."),
        e("separator", "Separator", Js::None("HTML"), "Horizontal or vertical."),
        e("scroll-area", "Scroll area", Js::None("CSS"), "A thin, themed scrollbar."),
        e("resizable", "Resizable", Js::Zag("splitter"), "Drag or arrow keys on the handle."),
    ]},
];

pub fn count() -> usize {
    GROUPS.iter().map(|group| group.entries.len()).sum()
}

pub fn count_without_js() -> usize {
    GROUPS
        .iter()
        .flat_map(|group| group.entries)
        .filter(|entry| matches!(entry.js, Js::None(_)))
        .count()
}
