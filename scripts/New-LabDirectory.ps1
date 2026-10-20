# Run only on the isolated lab DC using Windows PowerShell with the AD module.
# Prompts for credentials; never writes passwords to disk.
[CmdletBinding(SupportsShouldProcess)]
param([Parameter(Mandatory)][ValidatePattern('^[a-zA-Z0-9][a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')][string]$UpnSuffix)
$ErrorActionPreference = 'Stop'
Import-Module ActiveDirectory
$domain = Get-ADDomain
if ($domain.DNSRoot -ne 'identitylab.local') { throw 'This script is restricted to identitylab.local.' }
$forest = Get-ADForest
if ($UpnSuffix -ne $domain.DNSRoot -and $UpnSuffix -notin $forest.UPNSuffixes) {
    throw 'Add the actual tenant UPN suffix in Active Directory Domains and Trusts first.'
}
$base = "OU=IDENTITYLAB,$($domain.DistinguishedName)"
if (Get-ADUser -Filter * -SearchBase $domain.DistinguishedName | Where-Object { $_.SamAccountName -in @('Alex.Hybrid','Taylor.Hybrid','Jamie.ADAdmin','Jordan.Service','Casey.Joiner') }) {
    throw 'Seed accounts already exist. This bootstrap is for a fresh lab only; it must not restore memberships after lifecycle tests.'
}
$ous = @(
    @{Name='IDENTITYLAB';Path=$domain.DistinguishedName},
    @{Name='Users';Path=$base}, @{Name='Groups';Path=$base},
    @{Name='Admins';Path=$base}, @{Name='Disabled Users';Path=$base},
    @{Name='Employees';Path="OU=Users,$base"},
    @{Name='Contractors';Path="OU=Users,$base"},
    @{Name='Service Accounts';Path="OU=Users,$base"}
)
foreach ($ou in $ous) {
    $dn = "OU=$($ou.Name),$($ou.Path)"
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$dn'")) {
        if ($PSCmdlet.ShouldProcess($dn,'Create lab OU')) {
            New-ADOrganizationalUnit -Name $ou.Name -Path $ou.Path -ProtectedFromAccidentalDeletion $true
        }
    }
}
foreach ($name in @('GG-Employees','GG-Privileged-Admins','GG-Contractors','GG-Cloud-App-Users')) {
    $existing = Get-ADGroup -Filter "SamAccountName -eq '$name'"
    if ($existing -and $existing.DistinguishedName -ne "CN=$name,OU=Groups,$base") { throw "Group collision: $name" }
    if (-not $existing -and $PSCmdlet.ShouldProcess($name,'Create global security group')) {
        New-ADGroup -Name $name -SamAccountName $name -GroupScope Global -GroupCategory Security -Path "OU=Groups,$base"
    }
}
$users = @(
    @{Name='Alex.Hybrid';Path="OU=Employees,OU=Users,$base";Groups=@('GG-Employees','GG-Cloud-App-Users');Enabled=$true},
    @{Name='Taylor.Hybrid';Path="OU=Contractors,OU=Users,$base";Groups=@('GG-Contractors');Enabled=$true},
    @{Name='Jamie.ADAdmin';Path="OU=Admins,$base";Groups=@('GG-Privileged-Admins');Enabled=$true},
    @{Name='Jordan.Service';Path="OU=Service Accounts,OU=Users,$base";Groups=@();Enabled=$false}
)
foreach ($user in $users) {
    $name = $user.Name
    $existing = Get-ADUser -Filter "SamAccountName -eq '$name'"
    if ($existing -and $existing.DistinguishedName -ne "CN=$name,$($user.Path)") { throw "User collision or moved identity: $name; review manually." }
    if (-not $existing -and $PSCmdlet.ShouldProcess($name,'Create synthetic user')) {
        $password = Read-Host "Unique temporary password for $name" -AsSecureString
        $suffix = if ($name -in @('Jamie.ADAdmin','Jordan.Service')) { $domain.DNSRoot } else { $UpnSuffix }
        $changeAtLogon = $name -eq 'Jamie.ADAdmin'
        New-ADUser -Name $name -SamAccountName $name -UserPrincipalName "$name@$suffix" -Path $user.Path -AccountPassword $password -Enabled $user.Enabled -ChangePasswordAtLogon $changeAtLogon
        $password.Dispose()
    }
    foreach ($group in $user.Groups) {
        if ($PSCmdlet.ShouldProcess("$name -> $group",'Add lab membership')) {
            Add-ADGroupMember -Identity $group -Members $name
        }
    }
}
Write-Output 'Review directory state and complete initial AD password changes before testing PHS.'
