# Operations and troubleshooting

## Final state

LAB-DC01 and LAB-SYNC01 retained; provisioning configuration retained. Taylor restored to Operations. Alex disabled and retained in scope. Casey enabled in Employees without GG-Cloud-App-Users. Delegation.Test remains disabled in AD outside scope and soft-deleted in Entra. HybridSync.Admin setup role removed. Emergency accounts and existing methods preserved.

## October 20 quarantine

Observed HybridIdentityServiceNoActiveAgents and quarantined configuration. Both local agent services were Running; login.microsoftonline.com DNS and TCP/443 checks passed; portal agent showed Active. These checks alone did not establish complete agent connectivity. User restarted provisioning; screenshot then showed Healthy and Users/Groups cycle completion October 20 at 2:26:35 PM Pacific. Root cause remains unconfirmed. Do not attribute the incident to setup-role removal, or claim that the connectivity check diagnosed every required endpoint.

## Guided build issues

- Enhanced VM connection failed during updates; basic session exposed shutdown progress. Once reboot completed, enhanced mode was restored for clipboard use.
- Restarting rdpclip inside the guest restored clipboard in the observed session. This was not an AD/sync repair.
- Windows Update stayed at 100%; changing CBS log timestamps showed continued servicing. Waited for completion and performed normal restarts rather than interrupting servicing.
- Portal displayed a fixed 20-minute object provisioning interval. Use actual cycle timestamps; do not promise two-minute propagation.

## Routine checks

Confirm domain DNS and secure channel, local agent/updater services, portal agent state, configuration state, recent cycle completion and provisioning events. For recurring failures, collect sanitized agent/event logs and check all current Microsoft prerequisite endpoints before reinstalling or changing credentials. Preserve deletion protection and scope while diagnosing.

Shut down member server before DC when stopping the lab; start DC/DNS before member server when resuming. A powered-off single-agent lab cannot provision. Recheck health after startup. Retiring the tenant/configuration or subscriptions is a separate deliberate cleanup; do not delete sync scope casually to stop the lab. Hypervisor checkpoints do not substitute for a supported AD backup/recovery procedure.
