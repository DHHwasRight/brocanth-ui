use brocanth_ui::components::button::{Button, ButtonLink};
use brocanth_ui::components::button_group::ButtonGroup;
use brocanth_ui::components::toggle::Toggle;
use brocanth_ui::components::toggle_group::ToggleGroup;
use brocanth_ui::icons::{BOLD, CHEVRON_DOWN, ITALIC, UNDERLINE};
use brocanth_ui::{ButtonSize, ButtonVariant};

pub fn ButtonDemo() -> Element {
    <div class="grid gap-3">
        <div class="flex flex-wrap items-center gap-2">
            <Button variant={ButtonVariant::Primary} size={ButtonSize::Md} attrs={&[]}>Primary</Button>
            <Button variant={ButtonVariant::Secondary} size={ButtonSize::Md} attrs={&[]}>Secondary</Button>
            <Button variant={ButtonVariant::Outline} size={ButtonSize::Md} attrs={&[]}>Outline</Button>
            <Button variant={ButtonVariant::Ghost} size={ButtonSize::Md} attrs={&[]}>Ghost</Button>
            <Button variant={ButtonVariant::Destructive} size={ButtonSize::Md} attrs={&[]}>Delete</Button>
            <ButtonLink href="#button" variant={ButtonVariant::Link} size={ButtonSize::Md}>Link</ButtonLink>
        </div>
        <div class="flex flex-wrap items-center gap-2">
            <Button variant={ButtonVariant::Primary} size={ButtonSize::Sm} attrs={&[]}>Small</Button>
            <Button variant={ButtonVariant::Primary} size={ButtonSize::Lg} attrs={&[]}>Large</Button>
            <Button variant={ButtonVariant::Outline} size={ButtonSize::Icon} attrs={&[("aria-label", "More")]}>{! CHEVRON_DOWN }</Button>
            <Button variant={ButtonVariant::Outline} size={ButtonSize::Md} attrs={&[("disabled", "")]}>Disabled</Button>
        </div>
    </div>
}

pub fn ButtonGroupDemo() -> Element {
    <ButtonGroup label="Invoice actions">
        <Button variant={ButtonVariant::Outline} size={ButtonSize::Md} attrs={&[]}>Preview</Button>
        <Button variant={ButtonVariant::Outline} size={ButtonSize::Md} attrs={&[]}>Download PDF</Button>
        <Button variant={ButtonVariant::Outline} size={ButtonSize::Icon} attrs={&[("aria-label", "More actions")]}>{! CHEVRON_DOWN }</Button>
    </ButtonGroup>
}

pub fn ToggleDemo(p: &str) -> Element {
    <div class="flex gap-2">
        <Toggle id={&format!("{p}-bold")} name="bold" label="Bold" pressed={true} content={BOLD} />
        <Toggle id={&format!("{p}-italic")} name="italic" label="Italic" pressed={false} content={ITALIC} />
    </div>
}

pub fn ToggleGroupDemo(p: &str) -> Element {
    <div class="grid gap-3">
        <ToggleGroup name={&format!("{p}-format")} label="Text format" multiple={true} items={&[("bold", "Bold", BOLD), ("italic", "Italic", ITALIC), ("underline", "Underline", UNDERLINE)]} selected={&["bold"]} />
        <ToggleGroup name={&format!("{p}-interval")} label="Billing interval" multiple={false} items={&[("month", "Monthly", "Monthly"), ("year", "Yearly", "Yearly")]} selected={&["month"]} />
    </div>
}
