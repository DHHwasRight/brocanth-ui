use brocanth_ui::components::badge::Badge;
use brocanth_ui::components::button::Button;
use brocanth_ui::components::card::{Card, CardContent, CardFooter, CardHeader};
use brocanth_ui::components::dialog::{Dialog, DialogClose, DialogContent, DialogFooter, DialogTrigger};
use brocanth_ui::components::input::{Field, Input};
use brocanth_ui::components::table::{Table, TableBody, TableCaption, TableCell, TableHead, TableHeader, TableRow};
use brocanth_ui::{BadgeVariant, ButtonSize, ButtonVariant};

pub struct Invoice {
    pub number: &'static str,
    pub customer: &'static str,
    pub status: BadgeVariant,
    pub label: &'static str,
    pub amount: &'static str,
}

pub const INVOICES: [Invoice; 4] = [
    Invoice { number: "in_1PqA", customer: "Acme Corp", status: BadgeVariant::Success, label: "Paid", amount: "$1,250.00" },
    Invoice { number: "in_1PqB", customer: "Globex", status: BadgeVariant::Secondary, label: "Draft", amount: "$480.00" },
    Invoice { number: "in_1PqC", customer: "Initech", status: BadgeVariant::Outline, label: "Open", amount: "$3,100.00" },
    Invoice { number: "in_1PqD", customer: "Umbrella", status: BadgeVariant::Destructive, label: "Failed", amount: "$90.00" },
];

pub const SWATCHES: [(&str, &str); 6] = [
    ("primary", "bg-primary"),
    ("secondary", "bg-secondary"),
    ("muted", "bg-muted"),
    ("accent", "bg-accent"),
    ("destructive", "bg-destructive"),
    ("border", "bg-border"),
];

fn swatch_class(fill: &str) -> String {
    format!("h-8 w-full rounded-md border {fill}")
}

pub fn Showcase(theme: &str, label: &str) -> Element {
    let invite_id = format!("{theme}-invite");
    let delete_id = format!("{theme}-delete");
    let email_id = format!("{theme}-email");
    let role_id = format!("{theme}-role");
    <section data-theme={theme} class="flex min-w-0 flex-col gap-6 rounded-xl border bg-background p-4 sm:p-6">
        <div class="flex items-center justify-between gap-2">
            <h2 class="text-xl font-heading text-heading">{label}</h2>
            <code class="rounded-sm bg-muted px-1.5 py-0.5 font-mono text-xs text-muted-foreground">data-theme="{theme}"</code>
        </div>

        <Section title="Tokens">
            <div class="grid grid-cols-3 gap-2 sm:grid-cols-6">
                for (name, fill) in SWATCHES {
                    <div class="grid gap-1">
                        <div class={swatch_class(fill)}></div>
                        <span class="font-mono text-[11px] text-muted-foreground">{name}</span>
                    </div>
                }
            </div>
        </Section>

        <Section title="Button">
            <div class="flex flex-wrap items-center gap-2">
                <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[]}>Primary</Button>
                <Button variant={ButtonVariant::Secondary} size={ButtonSize::Md} attrs={&[]}>Secondary</Button>
                <Button variant={ButtonVariant::Outline} size={ButtonSize::Md} attrs={&[]}>Outline</Button>
                <Button variant={ButtonVariant::Ghost} size={ButtonSize::Md} attrs={&[]}>Ghost</Button>
                <Button variant={ButtonVariant::Destructive} size={ButtonSize::Md} attrs={&[]}>Delete</Button>
                <Button variant={ButtonVariant::Link} size={ButtonSize::Md} attrs={&[]}>Link</Button>
            </div>
            <div class="flex flex-wrap items-center gap-2">
                <Button variant={ButtonVariant::Primary} size={ButtonSize::Sm} attrs={&[]}>Small</Button>
                <Button variant={ButtonVariant::Primary} size={ButtonSize::Lg} attrs={&[]}>Large</Button>
                <Button variant={ButtonVariant::Outline} size={ButtonSize::Md} attrs={&[("disabled", "")]}>Disabled</Button>
            </div>
        </Section>

        <Section title="Badge">
            <div class="flex flex-wrap gap-2">
                <Badge variant={BadgeVariant::Default}>Default</Badge>
                <Badge variant={BadgeVariant::Secondary}>Draft</Badge>
                <Badge variant={BadgeVariant::Success}>Succeeded</Badge>
                <Badge variant={BadgeVariant::Destructive}>Failed</Badge>
                <Badge variant={BadgeVariant::Outline}>Outline</Badge>
            </div>
        </Section>

        <Section title="Card + Input">
            <Card>
                <CardHeader title="API key" description="Restricted keys limit what a key can do." />
                <CardContent>
                    <div class="grid gap-4">
                        <Field id={&email_id} label="Name" hint="Shown in the Dashboard.">
                            <Input id={&email_id} kind="text" attrs={&[("placeholder", "Billing worker")]} />
                        </Field>
                        <Field id={&role_id} label="Key" hint="">
                            <Input id={&role_id} kind="text" attrs={&[("value", "rk_test_51PqA…"), ("readonly", "")]} />
                        </Field>
                    </div>
                </CardContent>
                <CardFooter>
                    <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[]}>Create key</Button>
                    <Button variant={ButtonVariant::Ghost} size={ButtonSize::Md} attrs={&[]}>Cancel</Button>
                </CardFooter>
            </Card>
        </Section>

        <Section title="Table">
            <Table>
                <TableCaption>Recent invoices</TableCaption>
                <TableHeader>
                    <TableRow>
                        <TableHead>Invoice</TableHead>
                        <TableHead>Customer</TableHead>
                        <TableHead>Status</TableHead>
                        <TableHead>Amount</TableHead>
                    </TableRow>
                </TableHeader>
                <TableBody>
                    for invoice in &INVOICES {
                        <TableRow>
                            <TableCell><span class="font-mono text-xs">{invoice.number}</span></TableCell>
                            <TableCell>{invoice.customer}</TableCell>
                            <TableCell><Badge variant={invoice.status}>{invoice.label}</Badge></TableCell>
                            <TableCell>{invoice.amount}</TableCell>
                        </TableRow>
                    }
                </TableBody>
            </Table>
        </Section>

        <Section title="Dialog (Zag.js)">
            <div class="flex flex-wrap gap-2">
                <Dialog id={&invite_id} role="dialog">
                    <DialogTrigger variant={ButtonVariant::Primary}>Invite teammate</DialogTrigger>
                    <DialogContent title="Invite a teammate" description="They get an email with a link to join this account.">
                        <Field id={&format!("{invite_id}-email")} label="Email" hint="">
                            <Input id={&format!("{invite_id}-email")} kind="email" attrs={&[("placeholder", "jenny@example.com")]} />
                        </Field>
                        <DialogFooter>
                            <DialogClose variant={ButtonVariant::Outline}>Cancel</DialogClose>
                            <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[]}>Send invite</Button>
                        </DialogFooter>
                    </DialogContent>
                </Dialog>
                <Dialog id={&delete_id} role="alertdialog">
                    <DialogTrigger variant={ButtonVariant::Destructive}>Delete product</DialogTrigger>
                    <DialogContent title="Delete this product?" description="Prices and payment links that use it stop working. You cannot undo this.">
                        <DialogFooter>
                            <DialogClose variant={ButtonVariant::Outline}>Cancel</DialogClose>
                            <Button variant={ButtonVariant::Destructive} size={ButtonSize::Md} attrs={&[]}>Delete</Button>
                        </DialogFooter>
                    </DialogContent>
                </Dialog>
            </div>
        </Section>
    </section>
}

fn Section(title: &str, children: Element) -> Element {
    <div class="grid gap-3">
        <h3 class="text-xs font-control uppercase tracking-wide text-muted-foreground">{title}</h3>
        {children}
    </div>
}
