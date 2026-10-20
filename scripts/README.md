# Lab scripts

Run using Windows PowerShell on LAB-DC01 after reviewing the code. AD RSAT/module and appropriate delegated permissions are required.

```powershell
# Substitute your actual tenant suffix; inspect the preview first.
.\New-LabDirectory.ps1 -UpnSuffix 'YOUR-TENANT.onmicrosoft.com' -WhatIf
.\New-LabDirectory.ps1 -UpnSuffix 'YOUR-TENANT.onmicrosoft.com'

# Read-only review; console output by default.
.\Get-LabIdentityReview.ps1 -StaleDays 90 | Format-Table
```

The seed script is for a fresh lab only. It refuses to proceed if any known lab user exists, and is not a lifecycle replay tool. Names match this walkthrough; administrative/service UPNs use identitylab.local, while workforce UPNs use the supplied tenant suffix. It does not promote the DC, create Casey, grant administrative privileges or repair an existing deployment. Do not run against the completed lab. Partial failures require inspection before retry.

The review script evaluates users beneath the lab OU only and selected privileged groups. It omits many effective-permission paths; follow the manual review guide. Export only synthetic lab output to a private location and redact it before publication.

Validation in this workspace: PowerShell syntax parsing only. AD execution, permissions and deployment behavior require lab validation.
