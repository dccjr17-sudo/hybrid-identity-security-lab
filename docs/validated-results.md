# Verified results — October 13–20, 2026

Evidence basis: screenshots supplied in this chat plus explicitly identified user-reported outcomes. Selected supplied screenshots are included in the evidence folder. Do not claim independent execution of the VM tests by Codex.

## Implemented environment

Hyper-V on Windows 11 Pro, 32 GB host RAM. Two Windows Server 2022 Desktop Experience VMs were built using 4 GB RAM, two virtual processors and 60 GB virtual disks per the guided procedure. LAB-DC01 provides AD DS/DNS at 192.168.50.10; LAB-SYNC01 is a domain member at 192.168.50.20. Internal switch plus NAT gateway 192.168.50.1 provides outbound connectivity. Both guests' HTTPS connectivity was verified. AD forest/domain is identitylab.local, NetBIOS IDENTITYLAB. AD DNS diagnostics passed.

Cloud-only HybridSync.Admin received an active, time-limited Hybrid Identity Administrator assignment (guided end date October 26) and Authenticator registration. Assignment success and registration were reported by the user. Entra P2 trial expiration was reported as October 27, 2026. This is distinct from the earlier lab's October 20 PIM eligibility end date.

Cloud Sync agent registered as Active; configuration enabled/Healthy with password hash synchronization. Scope: Employees, Contractors, Groups and Disabled Users OUs beneath IDENTITYLAB. Admins and Service Accounts excluded. Accidental deletion protection threshold 1; notification recipient kept private. Observed object provisioning interval: **20 minutes**. Do not substitute the introductory portal text's two-minute timing for the observed configuration.

## Results

| Test | Observed result | Basis/limit |
|---|---|---|
| Initial provisioning | Alex.Hybrid provisioned on demand; Taylor.Hybrid appeared through scheduled synchronization | Screenshots; user confirmed workforce memberships and Jamie.ADAdmin/Jordan.Service exclusions |
| Password hash sync | Alex signed into My Account using AD password; authentication detail explicitly says Password Hash Sync, succeeded, correct password | Screenshot |
| MFA pilot | Alex added to existing cloud-only Identity-Security-Lab-Users group; LAB-CA01 policy result Success | Screenshot shows Previously satisfied MFA claim; fresh Authenticator challenge reported by user, not displayed in that event |
| Mover | Taylor moved to Employees; GG-Employees present, GG-Contractors absent; department Operations | Screenshots; cloud last sync shown at 10:01 AM |
| Leaver | Alex disabled and moved to in-scope Disabled Users; AD group memberships removed; cloud object retained and disabled | Screenshots; cloud pilot membership removed and sessions revoked per walkthrough/user reports |
| Denied sign-in | Alex fresh sign-in failed at 11:09:48 AM, code 50057, user account disabled | Screenshot; does not prove immediate termination of all prior application sessions |
| Joiner | Casey.Joiner automatically created enabled with expected memberships; AD-password cloud sign-in succeeded | Create screenshot; membership checks and sign-in reported by user |
| Delegation | GG-Privileged-Admins delegated reset/change-at-next-logon task on Employees; Jamie reset disabled disposable Delegation.Test inside Employees and was denied after move to Service Accounts | Allowed operation returned without error per user; denial screenshot. Selected group review showed only Administrator in Domain Admins |
| Out-of-scope deletion | Delegation.Test first provisioned disabled, then moved out of scope; soft-deleted at 12:21 PM; Delete action at 12:21:45 PM with successful EntryExportDelete | Screenshots; unlike in-scope disablement, cloud object moved to Deleted users |
| Agent recovery | Agent stopped, Taylor changed in AD to Operations-RecoveryTest, cloud remained Operations; user restarted agent at 1:20 PM; new value successfully imported/exported, cloud last sync 1:21 PM | Screenshots and user restart time; exact outage duration and exact recovery latency not measured |
| Recovery cleanup | User confirmed Taylor's cloud department restored to Operations and Cloud Sync Healthy | User-reported verification after cleanup |
| Built-in privileged groups | Enterprise Admins and Schema Admins each contained Administrator; built-in Administrators contained Domain Admins, Enterprise Admins and Administrator | Screenshot; selected group review, not exhaustive effective-access analysis |
| Cloud setup role | HybridSync.Admin active direct Hybrid Identity Administrator assignment with October 27 end date | Screenshot; corrects planned October 26 date; exact end time cropped |
| Emergency access | Two enabled cloud-only onmicrosoft.com emergency accounts with permanent active Global Administrator and exclusions from four existing CA policies | Configuration checks reported by user |
| Emergency authentication | Successful device-bound passkey registration audit events for both accounts; user reported successful YubiKey sign-in | Portal events at 3:29:07/3:29:26 PM confirm access but show no new authentication/previously satisfied claims; these events do not independently establish FIDO2 use. One physical key shared by both accounts is a recovery dependency |

## Identity review findings

- Alex.Hybrid: disabled leaver retained for the lifecycle test; remove cloud-owned entitlements separately and review retention.
- Taylor.Hybrid and Casey.Joiner: enabled workforce identities; recently created, not stale.
- Jamie.ADAdmin: separate AD administrative identity outside sync scope; selected group memberships and a scoped password-reset boundary tested. Broader effective-privilege review still pending.
- Jordan.Service: disabled inventory example, no application integration or stored application secret; not evidence of a functioning service account.
- Delegation.Test: disabled AD test object in Service Accounts, cloud object soft-deleted after scope removal. No restoration or permanent deletion performed.
- All initial inventory LastLogonDate values blank; AD dates do not describe cloud sign-in activity. Recently created users are not 90-day stale candidates.

## Application assignment test — October 15–19, 2026

Hybrid-Lab-SAML-App was created from the Microsoft Entra SAML Toolkit gallery application, with assignment required and GG-Cloud-App-Users assigned. The user configured the Toolkit-side SAML trust and app-specific sign-on/ACS URLs using the downloaded public signing certificate. A separate app-local Toolkit account was registered for Casey; no local password or SAML assertion is stored here.

- Allowed baseline: Toolkit displayed Casey signed in. Entra interactive logs show Casey's Hybrid-Lab-SAML-App sign-in Success at October 15, 23:21:08 UTC (4:21:08 PM Pacific).
- Removal: user reported removing Casey from GG-Cloud-App-Users in AD at 4:40 PM during the October 16 walkthrough. Subsequent Entra membership screenshot shows only GG-Employees. Exact propagation latency is not established.
- Denial: fresh SP-initiated SAML attempt at October 19, 21:17:19 UTC (2:17:19 PM Pacific) failed. Browser and matching Entra sign-in details show error 50105, Casey Joiner and Hybrid-Lab-SAML-App, with failure reason explicitly describing lack of direct/group application assignment.
- Conclusion: AD-managed group membership controlled access to a fresh Entra SAML sign-in. This does not establish immediate termination of preexisting Toolkit sessions or removal of the separate Toolkit-local password/login. No SCIM deprovisioning was implemented. Casey was left without the app-access group; no restoration requested.

Evidence naming: E22 Toolkit allowed access; E23 successful Entra app sign-in; E24 redacted browser assignment denial; E25 matching 50105 sign-in detail. The initial browser denial image exposed the tenant username in its lower Message; use the corrected redacted version only.

## Remaining work and honest limits

Scripts use actual lab names and the bootstrap refuses existing lab identities. Syntax parsing passed; packaged scripts were not executed against live AD. Guided hands-on commands were run by the user. HybridSync.Admin role removal was reported October 19. On October 20, configuration quarantined with HybridIdentityServiceNoActiveAgents; services were Running, sign-in endpoint DNS/TCP checks passed and portal agent was Active. After Restart provisioning, screenshot showed Healthy with Users/Groups cycle completed at 2:26:35 PM Pacific. Root cause unconfirmed; no role restoration performed. PHS cycle completion after this incident was not separately captured.

Emergency-account alerting and independent backup-key recovery remain untested. Application assignment enforcement was tested; app-local access and existing-session termination remain outside that claim. Single DC/agent architecture is not high availability. Deletion threshold was configured but bulk-deletion protection not tested. Risk-based controls and legacy-auth blocking were not demonstrated. Selected group/task review is not an exhaustive effective-permission audit.
