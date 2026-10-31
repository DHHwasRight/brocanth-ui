use brocanth_ui::components::calendar::{Calendar, DatePicker};
use brocanth_ui::components::button::Button;
use brocanth_ui::components::checkbox::Checkbox;
use brocanth_ui::components::combobox::Combobox;
use brocanth_ui::components::field::{FieldDescription, FieldError, FieldSet};
use brocanth_ui::components::input::{Field, Input};
use brocanth_ui::components::input_group::InputGroup;
use brocanth_ui::components::input_otp::InputOtp;
use brocanth_ui::components::native_select::NativeSelect;
use brocanth_ui::components::radio_group::RadioGroup;
use brocanth_ui::components::select::Select;
use brocanth_ui::components::slider::Slider;
use brocanth_ui::components::switch::Switch;
use brocanth_ui::components::textarea::Textarea;
use brocanth_ui::icons::SEARCH;
use brocanth_ui::{class, ButtonSize, ButtonVariant};

const COUNTRIES: [(&str, &str); 8] = [
    ("us", "United States"), ("fr", "France"), ("de", "Germany"), ("jp", "Japan"),
    ("br", "Brazil"), ("ca", "Canada"), ("in", "India"), ("au", "Australia"),
];

const CURRENCIES: [(&str, &str); 4] = [("usd", "USD — US dollar"), ("eur", "EUR — Euro"), ("gbp", "GBP — Pound sterling"), ("jpy", "JPY — Yen")];

pub fn InputDemo(p: &str) -> Element {
    <div class="grid max-w-sm gap-4">
        <Field id={&format!("{p}-email")} label="Email" hint="Receipts go to this address.">
            <Input id={&format!("{p}-email")} kind="email" attrs={&[("placeholder", "jenny@example.com")]} />
        </Field>
        <Field id={&format!("{p}-key")} label="Secret key" hint="">
            <Input id={&format!("{p}-key")} kind="text" attrs={&[("value", "sk_test_51PqA…"), ("readonly", "")]} />
        </Field>
    </div>
}

pub fn InputGroupDemo(p: &str) -> Element {
    <div class="grid max-w-sm gap-3">
        <InputGroup prefix={SEARCH} suffix="">
            <input class={class::input_bare()} placeholder="Search payments" aria-label="Search payments" id={format!("{p}-search")}>
        </InputGroup>
        <InputGroup prefix="$" suffix="USD">
            <input class={class::input_bare()} inputmode="decimal" value="49.00" aria-label="Amount" id={format!("{p}-amount")}>
        </InputGroup>
    </div>
}

pub fn InputOtpDemo(p: &str) -> Element {
    <div class="grid gap-2">
        <InputOtp id={&format!("{p}-otp")} name="code" length={6} label="Verification code" />
        <p class="text-sm text-muted-foreground">Enter the 6-digit code we sent to your phone.</p>
    </div>
}

pub fn TextareaDemo(p: &str) -> Element {
    <div class="grid max-w-sm gap-2">
        <label for={format!("{p}-memo")} class="text-sm font-control text-heading">Invoice memo</label>
        <Textarea id={&format!("{p}-memo")} name="memo" value="" attrs={&[("placeholder", "Thanks for your business!")]} />
    </div>
}

pub fn CheckboxDemo(p: &str) -> Element {
    <div class="grid gap-3">
        <Checkbox id={&format!("{p}-terms")} name="terms" label="Accept the terms of service" checked={true} attrs={&[]} />
        <Checkbox id={&format!("{p}-news")} name="news" label="Email me product updates" checked={false} attrs={&[]} />
        <Checkbox id={&format!("{p}-locked")} name="locked" label="Locked by your admin" checked={false} attrs={&[("disabled", "")]} />
    </div>
}

pub fn RadioGroupDemo(p: &str) -> Element {
    <RadioGroup name={&format!("{p}-plan")} legend="Plan" options={&[("starter", "Starter — $0"), ("growth", "Growth — $49/mo"), ("scale", "Scale — $199/mo")]} selected="growth" />
}

pub fn SwitchDemo(p: &str) -> Element {
    <div class="grid gap-3">
        <Switch id={&format!("{p}-live")} name="live" label="Live mode" checked={true} />
        <Switch id={&format!("{p}-radar")} name="radar" label="Block risky payments" checked={false} />
    </div>
}

pub fn SliderDemo(p: &str) -> Element {
    <div class="grid max-w-sm gap-2">
        <label for={format!("{p}-retries")} class="text-sm font-control text-heading">Retry attempts</label>
        <Slider id={&format!("{p}-retries")} name="retries" label="Retry attempts" min={0} max={8} step={1} value={4} />
    </div>
}

pub fn NativeSelectDemo(p: &str) -> Element {
    <div class="grid max-w-sm gap-2">
        <label for={format!("{p}-currency")} class="text-sm font-control text-heading">Currency</label>
        <NativeSelect id={&format!("{p}-currency")} name="currency" options={&CURRENCIES} selected="eur" attrs={&[]} />
    </div>
}

pub fn SelectDemo(p: &str) -> Element {
    <div class="max-w-sm">
        <Select id={&format!("{p}-select")} name="currency" label="Currency" value="" placeholder="Select a currency" options={&CURRENCIES} />
    </div>
}

pub fn ComboboxDemo(p: &str) -> Element {
    <div class="max-w-sm">
        <Combobox id={&format!("{p}-combobox")} name="country" label="Country" value="fr" placeholder="Search countries" options={&COUNTRIES} />
    </div>
}

pub fn FieldDemo(p: &str) -> Element {
    <form class="max-w-sm" action="#field">
        <FieldSet legend="Business details" description="Shown on receipts and invoices.">
            <Field id={&format!("{p}-business")} label="Business name" hint="">
                <Input id={&format!("{p}-business")} kind="text" attrs={&[("value", "Acme")]} />
            </Field>
            <div class="grid gap-2">
                <label for={format!("{p}-website")} class="text-sm font-control text-heading">Website</label>
                <Input id={&format!("{p}-website")} kind="url" attrs={&[("value", "acme"), ("aria-invalid", "true"), ("aria-describedby", format!("{p}-website-error").as_str())]} />
                <FieldError id={&format!("{p}-website-error")} message="Enter a full URL, such as https://acme.com." />
                <FieldDescription>The server checked this field and sent the error back.</FieldDescription>
            </div>
            <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[("type", "submit")]}>Save</Button>
        </FieldSet>
    </form>
}

pub fn CalendarDemo(p: &str) -> Element {
    <Calendar id={&format!("{p}-calendar")} name="day" month="2026-10" selected="2026-10-14" today="2026-10-31" nav_base="?" />
}

pub fn DatePickerDemo(p: &str) -> Element {
    <DatePicker id={&format!("{p}-due")} name="due" month="2026-11" selected="" today="2026-10-31" nav_base="?" placeholder="Pick a due date" />
}
