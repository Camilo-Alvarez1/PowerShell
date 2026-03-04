## Help ##
# help *OrganizationalUnit*
# help Set-ADOrganizationalUnit -ShowWindow
# help New-ADGroup -ShowWindow
# help *Move*

## Testing ##
# Get-ADOrganizationalUnit -Filter "name -eq 'London'" -Verbose
# Get-ADOrganizationalUnit "cn=Users,dc=Adatum,dc=com"
# Remove-ADOrganizationalUnit -Identity "OU=London,DC=Adatum,DC=com"
# Get-ADUser -Filter * -Properties * | gm
# $LondonUsers  | select name | measure
# Get-ADUser -SearchBase "OU=Sales,DC=Adatum,DC=com" -filter "City -eq 'London'" -Properties * | select name | measure

## Variables ##
$OUName = "London" 
$DomainDN = "DC=Adatum,DC=com" 
$OUPath = "$DomainDN" 

# Part 1 - Creates an Organizational Unit (OU) named "London" if it does not exist. If it does exist 
# Write a message to the console stating that it already exists. 
$ou = Get-ADOrganizationalUnit -Filter "name -eq '$OUName'" -ErrorAction SilentlyContinue

if ($ou) {"The following OU already exists: $($ou.distinguishedname)"}
    else {
        "OU does NOT exist. Creating now!"
        New-ADOrganizationalUnit -Name "London" -Path "$OUPath"
    }

# Part 2 - Inside the new “London” OU create a global security group named “London Users” #
New-ADGroup -Name "London Users" -GroupCategory Security -GroupScope Global -Path "ou=london,dc=adatum,dc=com"

# Part 3 - Locate all users int the Sales OU that have an address in the city of London and move them into the London OU. #
$LondonUsers = Get-ADUser -SearchBase "OU=Sales,DC=Adatum,DC=com" -filter "City -eq 'London'" -Properties * | select -ExpandProperty distinguishedname
foreach ($user in $LondonUsers) {
    Move-ADObject -Identity $user -TargetPath "OU=London,DC=Adatum,DC=com"
}

# Part 4 - Add the London OU users into the “London Users” security group. #
$LONUsers = Get-ADUser -SearchBase "OU=London,DC=Adatum,DC=com" -filter * -Properties * | Select-Object -ExpandProperty distinguishedname
foreach ($user in $LONUsers) {
    Add-ADGroupMember -Identity "London Users" -Members $user 
}

## Test ##
# Move-ADObject -Identity $LondonUsers -TargetPath "OU=London,DC=Adatum,DC=com"
# Get-ADUser -SearchBase "OU=London,DC=Adatum,DC=com" -filter * | measure
# same number 47
# $LondonUsers = Get-ADUser -SearchBase "OU=london,DC=Adatum,DC=com" -filter * -Properties * | select -ExpandProperty distinguishedname
