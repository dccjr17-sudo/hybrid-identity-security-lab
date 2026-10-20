# Phase 1 — Build Active Directory

## 1. Prepare the environment

Use your own lab hardware and personal test tenant. Record hypervisor, host RAM, VM sizing, OS edition, network mode, and license/evaluation expiry in the lab journal. Download Windows Server media from Microsoft. Choose Desktop Experience for this guided build.

Create LAB-DC01 with 2 vCPU, 4 GB RAM, and approximately 60 GB disk. Use an isolated NAT/internal network. Choose an unused private subnet; record actual addresses instead of copying a subnet that may conflict with your home network or VPN.

## 2. Install and configure the server

1. Install Windows Server 2022 Desktop Experience; set a unique local Administrator password.
2. Rename the computer to LAB-DC01 and restart.
3. Install updates. Set a static IP appropriate to the lab subnet and its actual NAT gateway. Do not disable Windows Firewall.
4. Through Server Manager → Add roles and features, install **Active Directory Domain Services** and **DNS Server**, including management tools.
5. Select the promotion notification → Add a new forest → `identitylab.local`.
6. Enter a distinct Directory Services Restore Mode password and store it privately. Keep DNS and Global Catalog selected. Review prerequisite checks and install; restart.
7. Verify the DC uses its own lab IP for DNS. Configure a DNS forwarder if needed for external resolution. Clients and LAB-SYNC01 must use the DC for DNS, not a public resolver directly.

## 3. Validate the forest

Run in elevated Windows PowerShell on LAB-DC01:

```powershell
Get-ADDomain | Select-Object DNSRoot,NetBIOSName,DomainMode
Get-ADForest | Select-Object RootDomain,ForestMode
Get-Service NTDS,DNS,Netlogon
dcdiag /test:DNS
```

Resolve errors before proceeding. Save sanitized output and a screenshot of the forest/domain summary.

## 4. Create the directory structure and identities

Use Active Directory Users and Computers to create an **OU** named `IDENTITYLAB` beneath the domain. Inside it create:

```text
IDENTITYLAB
├── Users
│   ├── Employees
│   ├── Contractors
│   └── Service Accounts
├── Groups
├── Admins
└── Disabled Users
```

Add the tenant's actual sign-in suffix in Active Directory Domains and Trusts → root Properties → Alternative UPN suffixes. Do not enter a placeholder suffix literally. If the tenant is not ready, create the OUs now and defer user creation.

Create users with unique private passwords:

| Account | OU | Global security groups |
|---|---|---|
| Alex.Hybrid | Employees | GG-Employees, GG-Cloud-App-Users |
| Taylor.Hybrid | Contractors | GG-Contractors |
| Jamie.ADAdmin | Admins | GG-Privileged-Admins |
| Jordan.Service | Service Accounts | none; keep disabled initially |

Create all four groups in Groups. Jamie is an administrative test identity but receives no Domain Admin membership during initial seeding. Later delegate only a narrowly scoped lab task. Jordan is an inventory example, not an application credential.

The optional bootstrap creates the initial structure and four identities in a fresh lab. It prompts privately for passwords. To match the synthetic walkthrough, workforce accounts have no forced initial password change; Jamie initially requires one and Jordan is disabled. This is a lab convenience, not a production onboarding policy. The script refuses existing lab users and is not a lifecycle replay tool.

## Completion gate

- AD/DNS health checks pass.
- OUs, four users, groups and memberships match the table.
- No unnecessary privileged membership exists.
- Record outcomes in `docs/lab-journal.md`.

Do not install synchronization until this gate passes.
