# Phase 3 — Identity security exercises

## Privileged separation

Use Alex only for normal cloud application tests. Jamie.ADAdmin remains AD-only and outside synchronization scope. Delegate a narrow task on the lab workforce OU using AD's Delegation of Control wizard and document its effective permissions. Keep forest administration separate; do not grant Domain Admin merely to demonstrate privilege.

Create a separate cloud-only named Entra administrator. Assign a limited role needed for a specific task; use PIM eligibility/time-bound activation only if licensed. Record both the assigned role and the effective scope. Build two cloud-only emergency access accounts using Microsoft's current guidance, phishing-resistant authentication, secure credential storage, sign-in monitoring and a tested recovery procedure. Review exclusions from Conditional Access before enforcement.

## Joiner–Mover–Leaver test matrix

| Test | AD action | Expected cloud observation | Evidence |
|---|---|---|---|
| Joiner | Create Casey.Joiner in Employees; add Employees and Cloud-App groups; complete initial AD password change | New synchronized account and expected memberships | AD view, provisioning event, cloud account, fresh sign-in |
| Mover | Move Taylor to Employees; remove Contractors group; add Employees group; update department | Updated attributes/memberships; old access removed | Before/after membership and app authorization test |
| Leaver | Disable Alex; remove application groups; move to in-scope Disabled Users | Retained synchronized cloud object with accountEnabled false and removed memberships | AD state, provisioning event, cloud state, fresh sign-in denied |

For the application test, configure an actual test enterprise application that supports group assignment and require assignment where supported. License appropriately. Group membership alone does not prove application entitlement enforcement.

Record timestamps for action, provisioning completion, cloud state and sign-in test. Do not assert instantaneous propagation. Disablement does not guarantee every existing application session ends immediately: revoke Entra sign-in sessions as a separate authorized lab step, then observe existing and fresh sessions; app-local sessions can need app-specific termination. Record the limitation.

## Stale and privileged-account review

Run `scripts/Get-LabIdentityReview.ps1` on LAB-DC01. It reports last-logon candidates, never-used candidates and recursive membership in the lab privileged group and Domain Admins. LastLogonDate is replicated and approximate, so it is a review signal, not an automatic deletion decision. Review service identities with an owner and purpose rather than treating lack of interactive logon as proof of inactivity. Newly created accounts cannot honestly demonstrate 90 days of staleness; document candidate logic or use an explicitly synthetic sample.

Also inspect built-in Administrators, Enterprise Admins and delegated OU permissions manually, and cloud role assignments/PIM eligibility separately. The script is not a complete effective-privilege audit. Record owner, business reason, review date, recommendation and approval in a sanitized findings table. Do not remediate automatically.

## Conditional Access and controls

If licensed, create pilot-only policies in report-only mode: require MFA for the test workforce and block legacy authentication. Examine policy evaluation and sign-in logs, verify emergency access, then enforce on pilot users and repeat fresh sign-ins. Add phishing-resistant strength for named cloud administrators only after enrollment and recovery validation. Report-only evidence is not proof of enforcement. If unlicensed, record these as proposed controls and accurately describe the tenant's available protections.

Test agent outage: stop the agent service only in the isolated lab, modify a harmless workforce attribute, observe pending synchronization, restore service and verify recovery. With password hash sync, previously synchronized cloud credentials can still authenticate; record what you actually observe. Track agent health, provisioning failures/quarantine, unexpected privileged membership, emergency-account sign-ins and lifecycle propagation delays.

## Recovery and cleanup

Use a new disposable identity to test out-of-scope deletion separately, after reviewing the accidental deletion threshold. Never move the primary leaver outside scope casually. Record restore behavior rather than assuming re-scope restores the same object.

Before retiring the lab, export sanitized evidence, revoke/remove test app access, inspect planned sync deletions, and follow current Microsoft configuration/agent removal guidance. Cancel any paid subscriptions separately. Hypervisor checkpoints are convenience tools, not a tested AD backup strategy; use supported system-state recovery practices for recovery exercises.
