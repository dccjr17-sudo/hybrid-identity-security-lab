# Phase 2 — Synchronize workforce identities

1. Confirm a personal test tenant, a valid UPN suffix, and current Cloud Sync prerequisites from the README references. Avoid an existing tenant with valuable identities or overlapping synchronization configurations.

   The earlier Entra project used Alex.Employee, Taylor.Contractor and Jamie.Admin. This project uses Alex.Hybrid, Taylor.Hybrid and Jamie.ADAdmin to avoid collisions. Check existing UPNs before reproducing; never casually soft-match or overwrite prior lab accounts. Keep the earlier cloud-only Jamie.Admin distinct from the AD-only Jamie.ADAdmin.
2. Create separate cloud-only setup and emergency identities. Use the least-privileged appropriate role required by each setup step; Microsoft's prerequisites specify a cloud-only Hybrid Identity Administrator for agent setup and AD administrative credentials for gMSA creation. Do not reuse daily accounts.
3. Create LAB-SYNC01 as a Windows Server 2022 member server. Set DNS to LAB-DC01, join `identitylab.local`, restart, patch, and verify domain/network health. Microsoft supports agent installation on a DC, but this lab uses a separate server to make the trust boundary visible.
4. Follow the current prerequisite page for TLS 1.2, outbound endpoints, agent permissions and gMSA configuration. Do not embed credentials, manually weaken transport security, or publish gMSA secrets.
5. From Entra admin center's Cloud Sync area, obtain the Microsoft provisioning agent and install/register it on LAB-SYNC01. Confirm healthy agent status.
6. Create an **AD to Entra** configuration and enable password hash synchronization. Scope Employees, Contractors, Groups, and Disabled Users explicitly. Exclude Admins and Service Accounts. Review group membership scope and provisioning previews before enabling.
7. Preserve accidental deletion protection; choose and record a deliberately small lab threshold appropriate to the tiny object count. Record scope, attribute mappings and threshold. Do not disable protection to bypass unexplained deletions.
8. Provision Alex on demand where supported, then enable the configuration after reviewing the result. Validate Alex and Taylor's UPNs, source of authority, group memberships, and provisioning logs. Ensure no Jamie/Jordan user objects were provisioned.
9. After a successful AD password change for Alex, test a fresh cloud sign-in in a private browser window. A pending “change password at next logon” can prevent the temporary password hash being provisioned; use Microsoft's FAQ when troubleshooting.

Keep Disabled Users in scope: the leaver exercise disables a retained identity. Moving a user out of synchronization scope can lead to deletion and is a separate experiment, not equivalent to disabling.

## Authentication rationale

Password hash synchronization supports cloud authentication without requiring the domain controller to answer each cloud sign-in. Document the credential-derived material and agent privilege trust boundary. Pass-through authentication instead introduces on-premises authentication agent availability into sign-in; do not claim Cloud Sync implements PTA for this lab.

## Completion gate

Capture a healthy agent, successful provisioning event, workforce source-of-authority fields, expected group memberships and a successful fresh sign-in. Record actual timestamps and errors. Never infer success merely from agent health.
