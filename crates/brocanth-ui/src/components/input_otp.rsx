//! One-time code input. No JavaScript: one native input, drawn as separate
//! slots with a repeating background. Paste, autofill
//! (`autocomplete="one-time-code"`) and screen readers work as for any input.

pub fn InputOtp(id: &str, name: &str, length: usize, label: &str) -> Element {
    <input id={id} name={name} aria-label={label} inputmode="numeric" autocomplete="one-time-code" pattern={format!("[0-9]{{{length}}}")} maxlength={length} required class="h-control-lg border-0 bg-[repeating-linear-gradient(90deg,var(--ui-background)_0_2.25rem,transparent_2.25rem_2.75rem)] pl-[0.95rem] font-mono text-lg tracking-[1.83rem] text-heading caret-primary outline-none [background-clip:content-box] [box-shadow:inset_0_0_0_1px_var(--ui-input)] focus-visible:[box-shadow:inset_0_0_0_2px_var(--ui-ring)] rounded-md" style={otp_style(length)}>
}

/// Each slot is 2.25rem plus a 0.5rem gap; the mask cuts the gaps out of the border.
fn otp_style(length: usize) -> String {
    let width = length as f32 * 2.75 - 0.5;
    format!("width: {width}rem; -webkit-mask: repeating-linear-gradient(90deg, #000 0 2.25rem, transparent 2.25rem 2.75rem); mask: repeating-linear-gradient(90deg, #000 0 2.25rem, transparent 2.25rem 2.75rem);")
}
