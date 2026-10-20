# Evidence and portfolio publication

Save reviewed evidence under `evidence/`. Keep originals privately. Crop or redact tenant identifiers, real domains/emails, billing information, IPs that identify real infrastructure, tokens, passwords, QR codes, recovery material and unrelated browser content. Never include employer systems or production exports.

| Evidence ID | Capture | What it proves |
|---|---|---|
| E01 | AD domain/forest and DNS health | Working directory foundation |
| E02 | OU tree and synthetic group memberships | Segmentation and directory model |
| E03 | Agent status, scope and PHS setting | Intended sync design |
| E04 | Successful provisioning event and cloud user source | Actual object synchronization |
| E05 | AD-only admin and cloud-only role assignment | Administrative separation |
| E06 | Joiner before/after and app sign-in | Provisioning plus authorization |
| E07 | Mover membership/app before/after | Access change and removal |
| E08 | Leaver cloud disabled state and denied fresh sign-in | Disable propagation |
| E09 | Review CSV and disposition table | Evidence-based identity review |
| E10 | CA evaluation plus enforced test, if licensed | Policy behavior |
| E11 | Agent outage and recovery timeline | Operational resilience |

Each evidence entry needs date, synthetic identity, test steps, expected result, actual result, redaction notes and a limitation. Screenshots complement logs; neither alone proves all controls.

## GitHub readiness gate

- Replace all “pending” results with observed outcomes or explicit incomplete labels.
- Review every image and file; search for secrets and personal/employer data.
- Do not commit raw exports or local config. Check the staged diff before publishing.
- Document licensing gaps, single-agent lab availability limits, session behavior and privilege-review coverage.
- Keep evidence captions readable and link each claim to a test.

## Career narrative — complete after validation

“Built an isolated AD-to-Entra hybrid identity lab with scoped workforce provisioning and separate administrative identities. Tested joiner, mover and leaver propagation, documented session revocation limitations, and produced identity review findings and recovery evidence.”

Use only after those tests pass. Add measured propagation times and concrete review findings; never invent metrics. Interview discussion: source of authority, scope vs disable semantics, AD/Entra privilege boundaries, authentication availability, and operational monitoring.
