[CmdletBinding()]
param([ValidateRange(1,3650)][int]$StaleDays=90)
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory
$domain = Get-ADDomain
if ($domain.DNSRoot -ne 'identitylab.local') { throw 'This script is restricted to identitylab.local.' }
$base = "OU=IDENTITYLAB,$($domain.DistinguishedName)"
$cutoff = (Get-Date).AddDays(-$StaleDays)
$privileged = @{}
$groupIds = @('GG-Privileged-Admins', "$($domain.DomainSID.Value)-512")
foreach ($groupId in $groupIds) {
    $group = Get-ADGroup -Identity $groupId
    foreach ($member in (Get-ADGroupMember -Identity $group -Recursive | Where-Object objectClass -eq 'user')) {
        $privileged[$member.DistinguishedName] = $true
    }
}
Get-ADUser -SearchBase $base -Filter * -Properties LastLogonDate,whenCreated,Enabled,PasswordLastSet |
    Select-Object SamAccountName,Enabled,whenCreated,LastLogonDate,PasswordLastSet,
        @{Name='StaleLogonCandidate';Expression={ [bool]($_.LastLogonDate -and $_.LastLogonDate -lt $cutoff) }},
        @{Name='NeverUsedOldCandidate';Expression={ [bool](-not $_.LastLogonDate -and $_.whenCreated -lt $cutoff) }},
        @{Name='SelectedPrivilegedGroupMember';Expression={ $privileged.ContainsKey($_.DistinguishedName) }}
