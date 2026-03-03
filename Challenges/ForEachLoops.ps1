# Task 1 =======================================================================================================
$num = (1,2,3,4,5,6)

foreach ($n in $num) {
    write-host $n
}

foreach ($n in $num) {
    $multiplied = $n * 6
    write-host $multiplied
}

# Task 2 ========================================================================================================
$files = get-childitem E:\Mod07\Labfiles

foreach ($file in $files) {
    $file | select name

}

# Task 3 ========================================================================================================
New-ADOrganizationalUnit "Test"
###### Test
Get-ADOrganizationalUnit -Filter "Name -like '*Disabled*'"

# Task 4 =============================================================================
# Get-ADUser -filter * | select -Property *
# Get-ADUser -Identity Elise -Properties distinguishedname | select distingushedname
# (Get-ADUser -Identity Elise).dis

$mrktUsers = Get-ADUser -SearchBase "OU=Marketing,DC=adatum,DC=com" -Filter "Name -like 'A*'"

foreach ($user in $mrktUsers) {
    Disable-ADAccount $user
}

# Test
Get-aduser -Identity Annie -Properties *

Set-ADUser -Identity Annie -Department "IT"
# Worked

# Task 5
$disabledUsers = Get-ADUser -SearchBase "OU=Marketing,DC=adatum,DC=com" -filter "enabled -EQ '$false' -and Department -EQ 'marketing'"

foreach ($user in $disabledUsers) {
    Get-ADUser -Identity $user | Select name
}

# Task 6 ================================================================================================================================================
$disabledUsers = Get-ADUser -SearchBase "OU=Marketing,DC=adatum,DC=com" -filter "enabled -EQ '$false' -and Department -EQ 'marketing'"

# Rest my lab and lost all the Department editing I did -fix
foreach ($user in $disabledUsers) {
    Set-ADUser $user -Department Marketing
}

$csvCont = foreach ($user in $disabledUsers) {
     Get-ADUser -Identity $user -Properties * | Select name,department
}

$csvCont | Export-Csv -NoTypeInformation C:\DisabledMarketingUsers.csv

# Help #
# Out-File C:\DisabledMarketingUsers.csv
# help notypeinformation

# Task 7 ==========================================================================================================================================================
$disabledUsers = Get-ADUser -SearchBase "OU=Marketing,DC=adatum,DC=com" -filter "enabled -EQ '$false' -and Department -EQ 'marketing'"

foreach ($user in $disabledUsers) {
    Move-ADObject $user -TargetPath "OU=Disabled Users,DC=adatum,DC=com"
}

# Check OU #
Get-ADUser -Identity ada -Properties * | Select name,department,distinguishedname


# Test #
$disabledUsers = Get-ADUser -SearchBase "OU=Disabled Users,DC=adatum,DC=com" -filter "enabled -EQ '$false' -and Department -EQ 'marketing'"
$csvCont = foreach ($user in $disabledUsers) {
     Get-ADUser -Identity $user -Properties * | Select name,department,distinguishedname
}

$csvCont | Export-Csv -NoTypeInformation C:\DisabledMarketingUsers2.csv

# Task 8 ===========================================================================================================================================================
$disabledUsers = Get-ADUser -Filter "enabled -EQ '$false' -and Department -EQ 'marketing'"
$OU = read-host "Marketing"

foreach ($user in $disabledUsers) {
    Move-ADObject $user -TargetPath "OU=Marketing,DC=adatum,DC=com"
    Write-Host "$($user.name) has been moved to the $OU OU."
}

# Test #
Get-aduser -Identity ada -Properties * | select name,department,distinguishedname | fl