use brocanth_ui::charts::{Chart, Row, Spec};
use brocanth_ui::components::avatar::{Avatar, AvatarGroup};
use brocanth_ui::components::badge::Badge;
use brocanth_ui::components::button::Button;
use brocanth_ui::components::card::{Card, CardContent, CardFooter, CardHeader};
use brocanth_ui::components::carousel::{Carousel, CarouselItem};
use brocanth_ui::components::data_table::{DataTableToolbar, Sort, SortableHead};
use brocanth_ui::components::input::{Field, Input};
use brocanth_ui::components::item::{Item, ItemGroup};
use brocanth_ui::components::kbd::{Kbd, KbdGroup};
use brocanth_ui::components::pagination::Pagination;
use brocanth_ui::components::table::{Table, TableBody, TableCaption, TableCell, TableHead, TableHeader, TableRow};
use brocanth_ui::components::typography::Prose;
use brocanth_ui::icons::{CALENDAR, INBOX};
use brocanth_ui::{class, BadgeVariant, ButtonSize, ButtonVariant};

pub struct Payment {
    pub id: &'static str,
    pub customer: &'static str,
    pub status: BadgeVariant,
    pub label: &'static str,
    pub amount: &'static str,
}

pub const PAYMENTS: [Payment; 4] = [
    Payment { id: "py_3PqA", customer: "Acme Corp", status: BadgeVariant::Success, label: "Succeeded", amount: "$1,250.00" },
    Payment { id: "py_3PqB", customer: "Globex", status: BadgeVariant::Secondary, label: "Pending", amount: "$480.00" },
    Payment { id: "py_3PqC", customer: "Initech", status: BadgeVariant::Outline, label: "Refunded", amount: "$3,100.00" },
    Payment { id: "py_3PqD", customer: "Umbrella", status: BadgeVariant::Destructive, label: "Failed", amount: "$90.00" },
];

pub fn TableDemo() -> Element {
    <Table>
        <TableCaption>Recent payments</TableCaption>
        <TableHeader>
            <TableRow>
                <TableHead>Payment</TableHead>
                <TableHead>Customer</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Amount</TableHead>
            </TableRow>
        </TableHeader>
        <TableBody>
            for payment in &PAYMENTS {
                <TableRow>
                    <TableCell><span class="font-mono text-xs">{payment.id}</span></TableCell>
                    <TableCell>{payment.customer}</TableCell>
                    <TableCell><Badge variant={payment.status}>{payment.label}</Badge></TableCell>
                    <TableCell><span class="tabular-nums">{payment.amount}</span></TableCell>
                </TableRow>
            }
        </TableBody>
    </Table>
}

pub fn DataTableDemo() -> Element {
    <DataTableToolbar>
        <form class="flex-1" action="#data-table"><input name="q" placeholder="Filter customers…" aria-label="Filter customers" class={format!("{} max-w-xs", class::input())}></form>
        <Button variant={ButtonVariant::Outline} size={ButtonSize::Md} attrs={&[]}>Columns</Button>
    </DataTableToolbar>
    <Table>
        <TableHeader>
            <TableRow>
                <SortableHead label="Customer" href="?sort=customer" sort={Sort::Ascending} />
                <SortableHead label="Status" href="?sort=status" sort={Sort::None} />
                <SortableHead label="Amount" href="?sort=-amount" sort={Sort::None} />
            </TableRow>
        </TableHeader>
        <TableBody>
            for payment in &PAYMENTS {
                <TableRow>
                    <TableCell>{payment.customer}</TableCell>
                    <TableCell><Badge variant={payment.status}>{payment.label}</Badge></TableCell>
                    <TableCell><span class="tabular-nums">{payment.amount}</span></TableCell>
                </TableRow>
            }
        </TableBody>
    </Table>
    <div class="pt-4"><Pagination current={2} total={9} href_base="?" /></div>
}

fn mrr_rows() -> Vec<Row> {
    let mut rows = Vec::new();
    let pro = [1200.0, 1350.0, 1310.0, 1480.0, 1620.0, 1590.0, 1750.0];
    let team = [400.0, 520.0, 610.0, 590.0, 700.0, 820.0, 880.0];
    for day in 0..7 {
        let date = format!("2026-10-{:02}T00:00:00Z", 1 + day * 4);
        rows.push(Row::new().with("day", date.as_str()).with("mrr", pro[day]).with("plan", "Pro"));
        rows.push(Row::new().with("day", date.as_str()).with("mrr", team[day]).with("plan", "Team"));
    }
    rows
}

fn line_spec() -> Spec {
    Spec::new("area").x("day").y("mrr").series("plan").format("$,.0f").height(200)
}

fn bar_spec() -> Spec {
    Spec::new("bar").x("plan").y("mrr").aggregate(brocanth_ui::charts::Agg::Sum).format("$,.0f").height(200)
}

pub fn ChartDemo() -> Element {
    <div class="grid gap-4">
        <Chart title="Monthly recurring revenue" description="October 2026, by plan" spec={&line_spec()} rows={&mrr_rows()} width={520.0} />
        <Chart title="Revenue by plan" description="Sum for October" spec={&bar_spec()} rows={&mrr_rows()} width={520.0} />
    </div>
}

pub fn CardDemo(p: &str) -> Element {
    <div class="max-w-sm">
        <Card>
            <CardHeader title="Create an API key" description="Restricted keys limit what a key can do." />
            <CardContent>
                <Field id={&format!("{p}-key-name")} label="Name" hint="Shown in the Dashboard.">
                    <Input id={&format!("{p}-key-name")} kind="text" attrs={&[("placeholder", "Billing worker")]} />
                </Field>
            </CardContent>
            <CardFooter>
                <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[]}>Create key</Button>
                <Button variant={ButtonVariant::Ghost} size={ButtonSize::Md} attrs={&[]}>Cancel</Button>
            </CardFooter>
        </Card>
    </div>
}

pub fn BadgeDemo() -> Element {
    <div class="flex flex-wrap gap-2">
        <Badge variant={BadgeVariant::Default}>Default</Badge>
        <Badge variant={BadgeVariant::Secondary}>Pending</Badge>
        <Badge variant={BadgeVariant::Success}>Succeeded</Badge>
        <Badge variant={BadgeVariant::Destructive}>Failed</Badge>
        <Badge variant={BadgeVariant::Outline}>Refunded</Badge>
    </div>
}

pub fn AvatarDemo() -> Element {
    <div class="flex items-center gap-6">
        <Avatar src="" alt="Jenny Rosen" fallback="JR" />
        <Avatar src="missing.png" alt="Broken image" fallback="BI" />
        <AvatarGroup>
            <Avatar src="" alt="Ada" fallback="AL" />
            <Avatar src="" alt="Grace" fallback="GH" />
            <Avatar src="" alt="Linus" fallback="LT" />
        </AvatarGroup>
    </div>
}

pub fn ItemDemo() -> Element {
    <ItemGroup>
        <Item media={INBOX} title="Payouts" description="Weekly, every Friday, to your bank ending in 6789.">
            <Button variant={ButtonVariant::Outline} size={ButtonSize::Sm} attrs={&[]}>Edit</Button>
        </Item>
        <Item media={CALENDAR} title="Billing cycle" description="Invoices go out on the 1st of each month.">
            <Button variant={ButtonVariant::Outline} size={ButtonSize::Sm} attrs={&[]}>Edit</Button>
        </Item>
    </ItemGroup>
}

pub fn KbdDemo() -> Element {
    <div class="flex flex-wrap items-center gap-4 text-sm">
        <KbdGroup><Kbd>⌘</Kbd><Kbd>K</Kbd></KbdGroup>
        <span>Search with <Kbd>/</Kbd></span>
    </div>
}

pub fn TypographyDemo() -> Element {
    <Prose>
        <h2>Accept a payment</h2>
        <p>Create a <code>PaymentIntent</code> on the server, then confirm it in the browser. Read the <a href="#typography">integration guide</a> first.</p>
        <ul>
            <li>Collect the card details.</li>
            <li>Handle 3D Secure.</li>
        </ul>
        <blockquote>Test mode never moves money.</blockquote>
    </Prose>
}

pub fn CarouselDemo(p: &str) -> Element {
    <div class="px-4">
        <Carousel id={&format!("{p}-carousel")} label="Plans">
            <CarouselItem label="1 of 3"><Slide name="Starter" price="$0" /></CarouselItem>
            <CarouselItem label="2 of 3"><Slide name="Growth" price="$49" /></CarouselItem>
            <CarouselItem label="3 of 3"><Slide name="Scale" price="$199" /></CarouselItem>
        </Carousel>
    </div>
}

fn Slide(name: &str, price: &str) -> Element {
    <div class="flex aspect-[2/1] flex-col items-center justify-center gap-1 rounded-lg border bg-muted">
        <div class="text-sm text-muted-foreground">{name}</div>
        <div class="text-3xl font-heading text-heading">{price}<span class="text-sm font-normal text-muted-foreground">/mo</span></div>
    </div>
}
