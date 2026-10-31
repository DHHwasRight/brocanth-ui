use brocanth_ui::components::accordion::{Accordion, AccordionItem};
use brocanth_ui::components::alert::{Alert, AlertVariant};
use brocanth_ui::components::aspect_ratio::AspectRatio;
use brocanth_ui::components::breadcrumb::Breadcrumb;
use brocanth_ui::components::button::Button;
use brocanth_ui::components::collapsible::Collapsible;
use brocanth_ui::components::empty::Empty;
use brocanth_ui::components::navigation_menu::{NavigationMenu, NavigationMenuCard, NavigationMenuItem, NavigationMenuLink};
use brocanth_ui::components::pagination::Pagination;
use brocanth_ui::components::progress::Progress;
use brocanth_ui::components::resizable::{Resizable, ResizableHandle, ResizablePanel};
use brocanth_ui::components::scroll_area::ScrollArea;
use brocanth_ui::components::separator::Separator;
use brocanth_ui::components::sidebar::{Sidebar, SidebarGroup, SidebarInset, SidebarItem, SidebarProvider, SidebarTrigger};
use brocanth_ui::components::skeleton::Skeleton;
use brocanth_ui::components::spinner::Spinner;
use brocanth_ui::components::tabs::{Tabs, TabsContent, TabsList, TabsTrigger};
use brocanth_ui::icons::{CALENDAR, INBOX, SEARCH};
use brocanth_ui::{ButtonSize, ButtonVariant};

pub fn BreadcrumbDemo() -> Element {
    <Breadcrumb items={&[("Dashboard", "#breadcrumb"), ("Customers", "#breadcrumb"), ("Jenny Rosen", "")]} />
}

pub fn NavigationMenuDemo(p: &str) -> Element {
    <NavigationMenu label="Docs">
        <NavigationMenuItem id={&format!("{p}-nav-payments")} label="Payments">
            <NavigationMenuCard href="#navigation-menu" title="Checkout" description="A prebuilt, hosted payment page." />
            <NavigationMenuCard href="#navigation-menu" title="Elements" description="UI components for your own checkout." />
            <NavigationMenuCard href="#navigation-menu" title="Payment Links" description="Sell with a link, no code." />
            <NavigationMenuCard href="#navigation-menu" title="Terminal" description="In-person payments." />
        </NavigationMenuItem>
        <NavigationMenuLink href="#navigation-menu" current={true}>Billing</NavigationMenuLink>
        <NavigationMenuLink href="#navigation-menu" current={false}>Connect</NavigationMenuLink>
    </NavigationMenu>
}

pub fn PaginationDemo() -> Element {
    <Pagination current={5} total={12} href_base="?" />
}

pub fn TabsDemo(p: &str) -> Element {
    <Tabs id={&format!("{p}-tabs")} value="curl">
        <TabsList label="Language">
            <TabsTrigger value="curl" selected={true}>cURL</TabsTrigger>
            <TabsTrigger value="ruby" selected={false}>Ruby</TabsTrigger>
            <TabsTrigger value="node" selected={false}>Node.js</TabsTrigger>
        </TabsList>
        <TabsContent value="curl" selected={true}><Code text="curl https://api.stripe.com/v1/charges -u sk_test_…" /></TabsContent>
        <TabsContent value="ruby" selected={false}><Code text="Stripe::Charge.list(limit: 3)" /></TabsContent>
        <TabsContent value="node" selected={false}><Code text="await stripe.charges.list({ limit: 3 });" /></TabsContent>
    </Tabs>
}

fn Code(text: &str) -> Element {
    <pre class="overflow-x-auto rounded-md border bg-muted p-3 font-mono text-[13px] text-heading"><code>{text}</code></pre>
}

pub fn SidebarDemo() -> Element {
    <SidebarProvider>
        <Sidebar label="Dashboard">
            <SidebarGroup label="Payments">
                <SidebarItem href="#sidebar" icon={INBOX} label="All payments" current={true} />
                <SidebarItem href="#sidebar" icon={CALENDAR} label="Subscriptions" current={false} />
                <SidebarItem href="#sidebar" icon={SEARCH} label="Disputes" current={false} />
            </SidebarGroup>
        </Sidebar>
        <SidebarInset>
            <div class="flex h-12 items-center gap-2 border-b px-3">
                <SidebarTrigger collapsed={false} />
                <span class="text-sm font-control text-heading">All payments</span>
            </div>
            <div class="grid gap-3 p-4">
                <Skeleton size="h-4 w-3/4" />
                <Skeleton size="h-4 w-1/2" />
                <Skeleton size="h-24 w-full" />
            </div>
        </SidebarInset>
    </SidebarProvider>
}

pub fn AlertDemo() -> Element {
    <div class="grid gap-3">
        <Alert variant={AlertVariant::Info} title="Test mode">You are viewing test data. Live payments are not shown.</Alert>
        <Alert variant={AlertVariant::Success} title="Payout sent">$4,210.55 is on its way to your bank.</Alert>
        <Alert variant={AlertVariant::Warning} title="Verification needed">Upload an ID by Nov 15 to keep payouts running.</Alert>
        <Alert variant={AlertVariant::Destructive} title="Webhook failing">Your endpoint returned 500 for the last 12 events.</Alert>
    </div>
}

pub fn ProgressDemo() -> Element {
    <div class="grid max-w-sm gap-2">
        <div class="flex justify-between text-sm"><span class="text-heading">Import customers</span><span class="text-muted-foreground tabular-nums">62%</span></div>
        <Progress value={62} label="Import customers" />
    </div>
}

pub fn SkeletonDemo() -> Element {
    <div class="flex items-center gap-4">
        <Skeleton size="size-12 rounded-full" />
        <div class="grid gap-2">
            <Skeleton size="h-4 w-56" />
            <Skeleton size="h-4 w-40" />
        </div>
    </div>
}

pub fn SpinnerDemo() -> Element {
    <div class="flex items-center gap-3 text-sm text-muted-foreground"><Spinner label="Loading" /> Refreshing balance…</div>
}

pub fn EmptyDemo() -> Element {
    <Empty title="No disputes" description="When a customer disputes a payment, it shows here.">
        <Button variant={ButtonVariant::Outline} size={ButtonSize::Md} attrs={&[]}>Read about disputes</Button>
    </Empty>
}

pub fn AccordionDemo(p: &str) -> Element {
    <Accordion>
        <AccordionItem name={&format!("{p}-faq")} title="When do I get paid?" open={true}>Payouts arrive 2 business days after a payment in most countries.</AccordionItem>
        <AccordionItem name={&format!("{p}-faq")} title="Which cards do you accept?" open={false}>Visa, Mastercard, American Express, Discover, JCB and UnionPay.</AccordionItem>
        <AccordionItem name={&format!("{p}-faq")} title="Can I refund a payment?" open={false}>Yes, in full or in part, for up to 180 days.</AccordionItem>
    </Accordion>
}

pub fn CollapsibleDemo() -> Element {
    <div class="max-w-sm">
        <Collapsible title="3 more line items" open={false}>
            <div class="rounded-md border px-4 py-2 font-mono text-sm">Seat license × 3</div>
            <div class="rounded-md border px-4 py-2 font-mono text-sm">Support plan</div>
            <div class="rounded-md border px-4 py-2 font-mono text-sm">Setup fee</div>
        </Collapsible>
    </div>
}

pub fn AspectRatioDemo() -> Element {
    <div class="max-w-sm">
        <AspectRatio ratio="16 / 9">
            <div class="flex size-full items-center justify-center rounded-md bg-[linear-gradient(135deg,var(--ui-chart-1),var(--ui-chart-2))] text-sm font-control text-white">16 / 9</div>
        </AspectRatio>
    </div>
}

pub fn SeparatorDemo() -> Element {
    <div class="grid max-w-sm gap-3">
        <div>
            <div class="text-sm font-control text-heading">Balances</div>
            <p class="text-sm text-muted-foreground">Funds on their way to your bank.</p>
        </div>
        <Separator vertical={false} />
        <div class="flex h-5 items-center gap-4 text-sm">
            <span>Payments</span>
            <Separator vertical={true} />
            <span>Payouts</span>
            <Separator vertical={true} />
            <span>Fees</span>
        </div>
    </div>
}

pub fn ScrollAreaDemo() -> Element {
    <div class="max-w-xs">
        <ScrollArea max_height="12rem" label="Events">
            <div class="grid p-4">
                for n in 1..=20 {
                    <div class="border-b py-2 font-mono text-xs last:border-0">{format!("evt_1Pq{n:02} · charge.succeeded")}</div>
                }
            </div>
        </ScrollArea>
    </div>
}

pub fn ResizableDemo(p: &str) -> Element {
    <div class="h-48 overflow-hidden rounded-lg border">
        <Resizable id={&format!("{p}-resizable")} vertical={false}>
            <ResizablePanel id="list" size={40} min={20}><div class="flex h-full items-center justify-center text-sm text-muted-foreground">Payments</div></ResizablePanel>
            <ResizableHandle before="list" after="detail" />
            <ResizablePanel id="detail" size={60} min={30}><div class="flex h-full items-center justify-center text-sm text-muted-foreground">Details</div></ResizablePanel>
        </Resizable>
    </div>
}
