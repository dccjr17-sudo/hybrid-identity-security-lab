# Identity security review

| Finding | Evidence | Disposition |
|---|---|---|
| Daily/workforce and administrative identities require separation | AD admin excluded from sync; cloud-only setup admin; selected AD group review | Implemented for lab personas; original built-in Administrator retains forest-wide setup privilege |
| Delegated group needs a defined boundary | Jamie allowed password reset in Employees and denied in Service Accounts | Boundary demonstrated for tested operation; not exhaustive ACL audit |
| Stale-account signals can mislead | New accounts with blank AD LastLogonDate despite cloud sign-ins | No stale finding asserted; combine AD/cloud activity, creation age, owner and purpose before remediation |
| In-scope disable differs from out-of-scope deletion | Alex retained disabled; Delegation.Test soft-deleted | Disabled Users intentionally remains in scope |
| Cloud-managed group membership requires separate leaver cleanup | Alex retained cloud MFA group after AD group removal | Cloud group membership removed explicitly |
| App access requires assignment enforcement | Required-assignment SAML app; Casey allowed then denied after AD group removal | Fresh federated sign-in enforcement verified; app-local password/session remains a distinct path |
| Emergency methods should avoid shared dependencies | Two passkey registrations on one physical YubiKey | Lab validation only; independent backup hardware/storage and alerting remain future work |
| Setup privilege should not remain standing | HybridSync.Admin role removed; healthy completed cycle afterward | Removed; agent service identity retained |

Proposed monitoring: alert on emergency-account sign-ins, changes to privileged roles/groups and sync scope, no-active-agent/quarantine errors, provisioning failures and lifecycle delays. Alert rules, notification delivery and response escalation were not implemented in this lab.

Entra P2 trial expiration reported October 27, 2026. Preserve evidence before expiry and reassess licensing before continuing licensed CA/group-assignment controls. Do not represent trial-only controls as permanently available.
