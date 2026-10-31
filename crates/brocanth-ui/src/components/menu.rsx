//! Dropdown menu, context menu and menubar. Zag `@zag-js/menu` (menu.ts)
//! adds the keyboard (arrows, typeahead, Escape), focus return, outside
//! click, and placement. The content moves to the portal layer when the
//! glue mounts, so no ancestor clips it.
//!
//! ```text
//! <DropdownMenu id="account">
//!     <MenuTrigger variant={ButtonVariant::Outline}>Account</MenuTrigger>
//!     <MenuContent>
//!         <MenuLabel>My account</MenuLabel>
//!         <MenuLink value="profile" href="/profile" shortcut="⇧⌘P">Profile</MenuLink>
//!         <MenuSeparator />
//!         <MenuItem value="logout" shortcut="">Log out</MenuItem>
//!     </MenuContent>
//! </DropdownMenu>
//! ```

use crate::{class, ButtonSize, ButtonVariant};

/// `id` must be unique on the page.
pub fn DropdownMenu(id: &str, children: Element) -> Element {
    <div id={id} data-ui="menu" class="contents">{children}</div>
}

/// A right-click (or long-press) menu over an area.
pub fn ContextMenu(id: &str, children: Element) -> Element {
    <div id={id} data-ui="menu" data-placement="right-start" class="contents">{children}</div>
}

/// The area a right-click opens the context menu in.
pub fn ContextMenuArea(children: Element) -> Element {
    <div data-part="context-trigger" class="flex h-36 w-full items-center justify-center rounded-md border border-dashed text-sm text-muted-foreground select-none">{children}</div>
}

pub fn MenuTrigger(variant: ButtonVariant, children: Element) -> Element {
    <button type="button" data-part="trigger" aria-haspopup="menu" aria-expanded="false" class={class::button(variant, ButtonSize::Md)}>{children}</button>
}

pub fn MenuContent(children: Element) -> Element {
    <div data-part="positioner" class="z-50">
        <div data-part="content" role="menu" hidden class="ui-pop max-h-[var(--available-height)] min-w-[12rem] overflow-y-auto rounded-md border bg-popover p-1 text-popover-foreground shadow-overlay outline-none">
            {children}
        </div>
    </div>
}

/// An action. The glue emits `ui:select` with its value on the menu root.
pub fn MenuItem(value: &str, shortcut: &str, children: Element) -> Element {
    <div data-part="item" data-value={value} role="menuitem" class={item_class()}>
        {children}
        <Shortcut text={shortcut} />
    </div>
}

/// A link: Enter or a click navigates (with dp-boost, as a partial navigation).
pub fn MenuLink(value: &str, href: &str, shortcut: &str, children: Element) -> Element {
    <a data-part="item" data-value={value} href={href} role="menuitem" class={item_class()}>
        {children}
        <Shortcut text={shortcut} />
    </a>
}

pub fn MenuCheckboxItem(value: &str, checked: bool, children: Element) -> Element {
    <div data-part="option-item" data-type="checkbox" data-value={value} role="menuitemcheckbox" aria-checked={checked} class={format!("{} pl-8", item_class())} { ...[("data-checked", checked)] }>
        <span data-part="item-indicator" hidden?={!checked} class="absolute left-2 flex size-4 items-center justify-center [&_svg]:size-4">{! crate::icons::CHECK }</span>
        {children}
    </div>
}

/// `group` names the radio set: one item per group is checked.
pub fn MenuRadioItem(group: &str, value: &str, checked: bool, children: Element) -> Element {
    <div data-part="option-item" data-type="radio" data-group={group} data-value={value} role="menuitemradio" aria-checked={checked} class={format!("{} pl-8", item_class())} { ...[("data-checked", checked)] }>
        <span data-part="item-indicator" hidden?={!checked} class="absolute left-2 flex size-4 items-center justify-center"><span class="size-2 rounded-full bg-current"></span></span>
        {children}
    </div>
}

pub fn MenuLabel(children: Element) -> Element {
    <div class="px-2 py-1.5 text-xs font-control text-muted-foreground">{children}</div>
}

pub fn MenuSeparator() -> Element {
    <div data-part="separator" role="separator" class="-mx-1 my-1 h-px bg-border"></div>
}

fn Shortcut(text: &str) -> Element {
    if !text.is_empty() {
        <span class="ml-auto pl-4 text-xs tracking-widest text-muted-foreground">{text}</span>
    }
}

fn item_class() -> &'static str {
    "relative flex cursor-pointer items-center gap-2 rounded-sm px-2 py-1.5 text-sm text-popover-foreground outline-none select-none data-[disabled]:pointer-events-none data-[disabled]:opacity-50 data-[highlighted]:bg-accent data-[highlighted]:text-accent-foreground [&_svg]:size-4 [&_svg]:text-muted-foreground"
}

/// A row of menus, as in a desktop app. Each child is a `DropdownMenu`
/// with a `MenubarTrigger`.
pub fn Menubar(label: &str, children: Element) -> Element {
    <div role="menubar" aria-label={label} class="flex h-9 w-fit items-center gap-1 rounded-md border bg-background p-1 shadow-control">{children}</div>
}

pub fn MenubarTrigger(children: Element) -> Element {
    <button type="button" data-part="trigger" aria-haspopup="menu" aria-expanded="false" class="flex cursor-pointer items-center rounded-sm px-2 py-1 text-sm font-control text-foreground outline-none select-none hover:bg-accent focus-visible:bg-accent data-[state=open]:bg-accent data-[state=open]:text-accent-foreground">{children}</button>
}
