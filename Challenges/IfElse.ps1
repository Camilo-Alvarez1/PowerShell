## Help ##
# help *OrganizationalUnit*
# help Set-ADOrganizationalUnit -ShowWindow

## Testing ##
# Get-ADOrganizationalUnit -Filter "name -eq 'London'" -Verbose
# Get-ADOrganizationalUnit "cn=Users,dc=Adatum,dc=com"
# Remove-ADOrganizationalUnit -Identity "OU=London,DC=Adatum,DC=com"

## Variables ##
$OUName = "London" 

$DomainDN = "DC=Adatum,DC=com" 

$OUPath = "$DomainDN" 



$ou = Get-ADOrganizationalUnit -Filter "name -eq '$OUName'" -ErrorAction SilentlyContinue

if ($ou) {"The following OU already exists: $($ou.distinguishedname)"}
    else {
        "OU does NOT exist. Creating now!"
        New-ADOrganizationalUnit -Name "London" -Path "$OUPath"
    }