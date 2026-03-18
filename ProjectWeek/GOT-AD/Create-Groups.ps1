Import-Module ActiveDirectory

# Import master config
. "C:\Scripts\GOT-AD-Scripts"

$domainDN = "DC=$($DomainName.Split('.')[0]),DC=$($DomainName.Split('.')[1])"
$groupsOU = "OU=Groups,$domainDN"

# Ensure OU=Groups exists
if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=Groups)" -SearchBase $domainDN -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name "Groups" -Path $domainDN -ProtectedFromAccidentalDeletion $true
    Write-Host "Created OU: Groups"
}
else {
    Write-Host "OU already exists: Groups"
}

function New-GOTGroup {
    param([string]$Name)

    if (-not (Get-ADGroup -Filter "Name -eq '$Name'" -SearchBase $groupsOU -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $Name `
                    -SamAccountName $Name `
                    -GroupScope Global `
                    -GroupCategory Security `
                    -Path $groupsOU
        Write-Host "Created group: $Name"
    }
    else {
        Write-Host "Group already exists: $Name"
    }
}

Write-Host "Creating Alliance groups..."
foreach ($ally in $Alliances) { New-GOTGroup -Name $ally }

Write-Host "Creating Army groups..."
foreach ($army in $Armies) { New-GOTGroup -Name $army }

Write-Host "Group creation complete."