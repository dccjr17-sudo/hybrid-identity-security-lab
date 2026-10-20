# Portfolio narrative

Built an isolated two-server Active Directory and Microsoft Entra hybrid identity lab with scoped Cloud Sync and password hash synchronization. Validated joiner, mover and leaver changes, MFA policy evaluation, OU-scoped password-reset delegation and group-based SAML application assignment enforcement.

## Resume bullets

- Built and documented an AD-to-Entra identity lab with workforce-only OU scoping, separate administrative identities and tested password hash authentication.
- Validated identity lifecycle and access removal using provisioning/sign-in evidence, including disabled-account error 50057 and application-assignment denial 50105.
- Tested delegated password resets across OU boundaries and agent outage recovery; documented scope-deletion semantics, session limitations and setup-role removal.

## Interview discussion

Explain why AD owns synchronized workforce attributes, why Disabled Users remains in scope, and why group removal can deny a fresh app sign-in without disabling the identity. Contrast registered authentication methods with enforcement evidence. Discuss the residual app-local login, single-key emergency dependency, single-agent availability and unmeasured propagation times.

Do not claim production deployment, full Zero Trust implementation, automated certification, exhaustive privilege analysis, immediate session termination or tested alert delivery.
