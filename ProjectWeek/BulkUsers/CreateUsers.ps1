$ouName = "NewGOTEmployees"
$ouPath = "OU=$ouName,DC=adatum,DC=com"

# Check if the OU exists
$existingOU = Get-ADOrganizationalUnit -LDAPFilter "(ou=$ouName)" -ErrorAction SilentlyContinue

# Create it only if it doesn't exist
if (-not $existingOU) {
    New-ADOrganizationalUnit -Name $ouName -Path "DC=adatum,DC=com"
    Write-Host "OU '$ouName' created."
}
else {
    Write-Host "OU '$ouName' already exists — skipping creation."
}

# Prompt the user for the CSV file path
$csvPath = Read-Host "Enter the full path to the CSV file containing new user information"

# Import the CSV
$users = Import-Csv -Path $csvPath

# Loop through each row and create a new AD user
foreach ($user in $users) {

        New-ADUser `
                -Name "$($user.FirstName) $($user.LastName)" `
                -GivenName $user.FirstName `
                -Surname $user.LastName `
                -SamAccountName $user.SamAccountName `
                -UserPrincipalName "$($user.SamAccountName)@adatum.com" `
                -Path $user.OU `
                -Department $user.Department `
                -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
                -Enabled $true
                   
                Write-Host "Created user: $($user.SamAccountName)"
}