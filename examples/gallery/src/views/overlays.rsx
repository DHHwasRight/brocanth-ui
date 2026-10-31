use brocanth_ui::components::button::Button;
use brocanth_ui::components::command::{Command, CommandGroup, CommandItem, CommandSeparator};
use brocanth_ui::components::dialog::{AlertDialog, AlertDialogCancel, Dialog, DialogClose, DialogFooter, DialogTrigger, Drawer, Sheet, SheetSide};
use brocanth_ui::components::hover_card::HoverCard;
use brocanth_ui::components::input::{Field, Input};
use brocanth_ui::components::kbd::Kbd;
use brocanth_ui::components::menu::{ContextMenu, ContextMenuArea, DropdownMenu, MenuCheckboxItem, MenuContent, MenuItem, MenuLabel, MenuLink, MenuRadioItem, MenuSeparator, MenuTrigger, Menubar, MenubarTrigger};
use brocanth_ui::components::popover::{PopoverContent, PopoverTrigger};
use brocanth_ui::components::toast::{ToastButton, Toaster};
use brocanth_ui::components::tooltip::Tooltip;
use brocanth_ui::icons::{CALENDAR, CHEVRON_DOWN, INFO, SEARCH};
use brocanth_ui::{ButtonSize, ButtonVariant};

pub fn DialogDemo(p: &str) -> Element {
    let id = format!("{p}-dialog");
    <DialogTrigger target={&id} variant={ButtonVariant::Outline}>Edit customer</DialogTrigger>
    <Dialog id={&id} title="Edit customer" description="Changes apply to future invoices.">
        <form method="dialog" class="grid gap-4">
            <Field id={&format!("{id}-name")} label="Name" hint="">
                <Input id={&format!("{id}-name")} kind="text" attrs={&[("value", "Jenny Rosen")]} />
            </Field>
            <Field id={&format!("{id}-email")} label="Email" hint="">
                <Input id={&format!("{id}-email")} kind="email" attrs={&[("value", "jenny@example.com")]} />
            </Field>
            <DialogFooter>
                <DialogClose target={&id} variant={ButtonVariant::Outline}>Cancel</DialogClose>
                <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[("type", "submit")]}>Save changes</Button>
            </DialogFooter>
        </form>
    </Dialog>
}

pub fn AlertDialogDemo(p: &str) -> Element {
    let id = format!("{p}-alert");
    <DialogTrigger target={&id} variant={ButtonVariant::Destructive}>Delete product</DialogTrigger>
    <AlertDialog id={&id} title="Delete this product?" description="Prices and payment links that use it stop working. You cannot undo this.">
        <DialogFooter>
            <AlertDialogCancel target={&id}>Cancel</AlertDialogCancel>
            <Button variant={ButtonVariant::Destructive} size={ButtonSize::Md} attrs={&[("commandfor", id.as_str()), ("command", "close")]}>Delete</Button>
        </DialogFooter>
    </AlertDialog>
}

pub fn SheetDemo(p: &str) -> Element {
    let id = format!("{p}-sheet");
    <DialogTrigger target={&id} variant={ButtonVariant::Outline}>Open filters</DialogTrigger>
    <Sheet id={&id} side={SheetSide::Right} title="Filters" description="Narrow the payment list.">
        <div class="grid gap-4">
            <Field id={&format!("{id}-min")} label="Minimum amount" hint="">
                <Input id={&format!("{id}-min")} kind="number" attrs={&[("value", "100")]} />
            </Field>
            <DialogClose target={&id} variant={ButtonVariant::Primary}>Apply</DialogClose>
        </div>
    </Sheet>
}

pub fn DrawerDemo(p: &str) -> Element {
    let id = format!("{p}-drawer");
    <DialogTrigger target={&id} variant={ButtonVariant::Outline}>Set a goal</DialogTrigger>
    <Drawer id={&id} title="Monthly revenue goal" description="Shown on your dashboard.">
        <div class="text-center text-5xl font-heading tracking-tight text-heading">$12,500</div>
        <DialogClose target={&id} variant={ButtonVariant::Primary}>Save goal</DialogClose>
    </Drawer>
}

pub fn PopoverDemo(p: &str) -> Element {
    let id = format!("{p}-popover");
    <PopoverTrigger target={&id} variant={ButtonVariant::Outline}>Dimensions</PopoverTrigger>
    <PopoverContent id={&id} label="Dimensions">
        <div class="grid gap-3">
            <div class="grid gap-1">
                <div class="font-heading leading-none text-heading">Dimensions</div>
                <p class="text-sm text-muted-foreground">Set the size of the receipt logo.</p>
            </div>
            <Field id={&format!("{id}-w")} label="Width" hint="">
                <Input id={&format!("{id}-w")} kind="text" attrs={&[("value", "128px")]} />
            </Field>
        </div>
    </PopoverContent>
}

pub fn HoverCardDemo(p: &str) -> Element {
    <p class="text-sm">
        Built with
        <HoverCard id={&format!("{p}-hc")} trigger={r#"<a href="https://github.com/DHHwasRight/brocanth" class="font-control text-link underline-offset-4 hover:underline">@brocanth</a>"#}>
            <div class="grid gap-1">
                <div class="font-heading text-heading">brocanth</div>
                <p class="text-muted-foreground">A server framework for HTML-first applications in Rust.</p>
                <p class="text-xs text-muted-foreground">33 crates · MIT</p>
            </div>
        </HoverCard>
        and rsx.
    </p>
}

pub fn TooltipDemo(p: &str) -> Element {
    let id = format!("{p}-tip");
    <Tooltip id={&id} text="Fees are 2.9% + 30¢ per card payment">
        <Button variant={ButtonVariant::Outline} size={ButtonSize::Md} attrs={&[("aria-describedby", id.as_str())]}>{! INFO } Pricing</Button>
    </Tooltip>
}

pub fn DropdownMenuDemo(p: &str) -> Element {
    <DropdownMenu id={&format!("{p}-menu")}>
        <MenuTrigger variant={ButtonVariant::Outline}>Account {! CHEVRON_DOWN }</MenuTrigger>
        <MenuContent>
            <MenuLabel>Jenny Rosen</MenuLabel>
            <MenuLink value="profile" href="#dropdown-menu" shortcut="⇧⌘P">Profile</MenuLink>
            <MenuItem value="billing" shortcut="⌘B">Billing</MenuItem>
            <MenuItem value="team" shortcut="">Team</MenuItem>
            <MenuSeparator />
            <MenuLabel>Show</MenuLabel>
            <MenuCheckboxItem value="test-data" checked={true}>Test data</MenuCheckboxItem>
            <MenuCheckboxItem value="archived" checked={false}>Archived</MenuCheckboxItem>
            <MenuSeparator />
            <MenuRadioItem group="density" value="compact" checked={false}>Compact</MenuRadioItem>
            <MenuRadioItem group="density" value="comfortable" checked={true}>Comfortable</MenuRadioItem>
            <MenuSeparator />
            <MenuItem value="logout" shortcut="⇧⌘Q">Log out</MenuItem>
        </MenuContent>
    </DropdownMenu>
}

pub fn ContextMenuDemo(p: &str) -> Element {
    <ContextMenu id={&format!("{p}-context")}>
        <ContextMenuArea>Right-click here</ContextMenuArea>
        <MenuContent>
            <MenuItem value="back" shortcut="⌘[">Back</MenuItem>
            <MenuItem value="reload" shortcut="⌘R">Reload</MenuItem>
            <MenuSeparator />
            <MenuItem value="inspect" shortcut="">Copy payment ID</MenuItem>
        </MenuContent>
    </ContextMenu>
}

pub fn MenubarDemo(p: &str) -> Element {
    <Menubar label="Editor">
        <DropdownMenu id={&format!("{p}-mb-file")}>
            <MenubarTrigger>File</MenubarTrigger>
            <MenuContent>
                <MenuItem value="new" shortcut="⌘N">New invoice</MenuItem>
                <MenuItem value="dup" shortcut="⌘D">Duplicate</MenuItem>
                <MenuSeparator />
                <MenuItem value="export" shortcut="">Export CSV</MenuItem>
            </MenuContent>
        </DropdownMenu>
        <DropdownMenu id={&format!("{p}-mb-edit")}>
            <MenubarTrigger>Edit</MenubarTrigger>
            <MenuContent>
                <MenuItem value="undo" shortcut="⌘Z">Undo</MenuItem>
                <MenuItem value="redo" shortcut="⇧⌘Z">Redo</MenuItem>
            </MenuContent>
        </DropdownMenu>
        <DropdownMenu id={&format!("{p}-mb-view")}>
            <MenubarTrigger>View</MenubarTrigger>
            <MenuContent>
                <MenuCheckboxItem value="sidebar" checked={true}>Sidebar</MenuCheckboxItem>
                <MenuCheckboxItem value="grid" checked={false}>Grid lines</MenuCheckboxItem>
            </MenuContent>
        </DropdownMenu>
    </Menubar>
}

pub fn CommandDemo(p: &str) -> Element {
    <div class="max-w-md">
        <Command id={&format!("{p}-command")} placeholder="Type a command or search…">
            <CommandGroup id={&format!("{p}-cmd-go")} heading="Go to">
                <CommandItem value="payments" href="#table" icon={SEARCH} shortcut="G P">Payments</CommandItem>
                <CommandItem value="customers" href="#data-table" icon={SEARCH} shortcut="G C">Customers</CommandItem>
                <CommandItem value="calendar" href="#calendar" icon={CALENDAR} shortcut="">Calendar</CommandItem>
            </CommandGroup>
            <CommandSeparator />
            <CommandGroup id={&format!("{p}-cmd-create")} heading="Create">
                <CommandItem value="invoice" href="" icon="" shortcut="⌘I">New invoice</CommandItem>
                <CommandItem value="refund" href="" icon="" shortcut="">Refund a payment</CommandItem>
            </CommandGroup>
        </Command>
    </div>
}

pub fn ToastDemo(p: &str) -> Element {
    let toaster = format!("{p}-toaster");
    <div class="flex flex-wrap gap-2">
        <ToastButton toaster={&toaster} variant={ButtonVariant::Outline} kind="success" title="Payment captured" description="$49.00 from jenny@example.com">Success</ToastButton>
        <ToastButton toaster={&toaster} variant={ButtonVariant::Outline} kind="error" title="Card declined" description="The bank refused the charge.">Error</ToastButton>
        <ToastButton toaster={&toaster} variant={ButtonVariant::Outline} kind="info" title="Export started" description="">Info</ToastButton>
    </div>
    <p class="mt-3 text-sm text-muted-foreground">Toasts stack at the bottom of the screen. Press <Kbd>Alt</Kbd> <Kbd>T</Kbd> to focus them.</p>
    <Toaster id={&toaster} placement={toast_corner(p)} />
}

/// One toaster per pane, in its own corner, so the two themes do not overlap.
fn toast_corner(p: &str) -> &'static str {
    if p == "shadcn" { "bottom-start" } else { "bottom-end" }
}
