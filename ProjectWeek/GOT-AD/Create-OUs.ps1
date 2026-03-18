# Create top level OUs for each Great House

Import-Module ActiveDirectory

# Import configuration file
. "C:\Scripts\GOT-AD-Scripts\Config.ps1"

$domainDN = "DC=$($DomainName.Split('.')[0]),DC=$($DomainName.Split('.')[1])"

Write-Host "=== Creating House OUs in $DomainName ==="

foreach ($house in $Houses) { 
    $ouPath = "OU=$house,$domainDN"

    if (-not (Get-ADOrganizationalUnit -LDAPFilter "(ou=$house)" -SearchBase $domainDN -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $house -Path $domainDN -ProtectedFromAccidentalDeletion $true
        Write-Host "Created OU: $house"
    }
    else {
        Write-Host "OU already exists: $house"
    }
}

Write-Host "OU creation complete."