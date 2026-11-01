//! Alert. No JavaScript.

#[derive(Clone, Copy, Debug, Default, PartialEq, Eq)]
pub enum AlertVariant {
    #[default]
    Default,
    Info,
    Success,
    Warning,
    Destructive,
}

fn alert_class(variant: AlertVariant) -> &'static str {
    match variant {
        AlertVariant::Default => "relative grid w-full grid-cols-[1rem_1fr] items-start gap-x-3 gap-y-0.5 rounded-lg border bg-card px-4 py-3 text-sm text-card-foreground [&_svg]:size-4 [&_svg]:translate-y-0.5",
        AlertVariant::Info => "relative grid w-full grid-cols-[1rem_1fr] items-start gap-x-3 gap-y-0.5 rounded-lg border bg-muted px-4 py-3 text-sm text-foreground [&_svg]:size-4 [&_svg]:translate-y-0.5 [&_svg]:text-link",
        AlertVariant::Success => "ui-alert-status relative grid w-full grid-cols-[1rem_1fr] items-start gap-x-3 gap-y-0.5 rounded-lg border border-success/30 bg-alert-success px-4 py-3 text-sm text-alert-success-foreground [&_svg]:size-4 [&_svg]:translate-y-0.5",
        AlertVariant::Warning => "ui-alert-status relative grid w-full grid-cols-[1rem_1fr] items-start gap-x-3 gap-y-0.5 rounded-lg border border-warning/30 bg-alert-warning px-4 py-3 text-sm text-alert-warning-foreground [&_svg]:size-4 [&_svg]:translate-y-0.5",
        AlertVariant::Destructive => "ui-alert-status relative grid w-full grid-cols-[1rem_1fr] items-start gap-x-3 gap-y-0.5 rounded-lg border border-destructive/30 bg-alert-destructive px-4 py-3 text-sm text-alert-destructive-foreground [&_svg]:size-4 [&_svg]:translate-y-0.5",
    }
}

fn alert_icon(variant: AlertVariant) -> &'static str {
    match variant {
        AlertVariant::Default | AlertVariant::Info => crate::icons::INFO,
        AlertVariant::Success => crate::icons::CHECK_CIRCLE,
        AlertVariant::Warning => crate::icons::ALERT_TRIANGLE,
        AlertVariant::Destructive => crate::icons::ALERT_CIRCLE,
    }
}

/// `children` is the description. `role="alert"` only for the urgent kinds,
/// so a screen reader does not interrupt for a plain notice.
pub fn Alert(variant: AlertVariant, title: &str, children: Element) -> Element {
    <div role={alert_role(variant)} class={alert_class(variant)}>
        {! alert_icon(variant) }
        <div class="col-start-2 font-control leading-5 text-heading [.ui-alert-status_&]:text-current">{title}</div>
        <div class="col-start-2 grid gap-1 leading-relaxed opacity-90">{children}</div>
    </div>
}

fn alert_role(variant: AlertVariant) -> &'static str {
    match variant {
        AlertVariant::Warning | AlertVariant::Destructive => "alert",
        _ => "status",
    }
}
