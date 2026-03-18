Import-Module ActiveDirectory

# Path to your CSV
$csvPath = "C:\Scripts\GOT-AD-Scripts\GOT-Users.csv"

# Import CSV
$users = Import-Csv $csvPath

Write-Host "Creating users from CSV..." -ForegroundColor Cyan

foreach ($u in $users) {

    $first  = $u.FirstName
    $last   = $u.LastName
    $sam    = $u.SamAccountName
    $house  = $u.House
    $ou     = $u.OU
    $password    = $u.Password
    $upn    = "$sam@got.lab"

    # Check if user already exists
    if (Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue) {
        Write-Host "User already exists: $sam" -ForegroundColor Yellow
        continue
    }

    try {
        New-ADUser `
            -Name "$first $last" `
            -GivenName $first `
            -Surname $last `
            -SamAccountName $sam `
            -UserPrincipalName $upn `
            -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
            -Enabled $true `
            -Path $ou `
            -ChangePasswordAtLogon $false `
            -PasswordNeverExpires $true

        Write-Host "Created user: $sam" -ForegroundColor Green
    }
    catch {
        Write-Warning "Failed to create user $sam : $_"
    }
}

Write-Host "`nUser creation complete." -ForegroundColor Cyan

# Ran into an obsticle when running the create users script.
# I got an error for each user saying "Failed to create user, No superior refernce has been configured"

# Trouble Shooting #
# Verified that the OUs existed using Get-ADOrganizationalUnit -Filter * | Select name, distinguishedname
# OUs where their so the users should have been created in them

# Fix #
# Reviewed the CSV.file with all the user information in it.
# Noticed that the OU field did not have double quotes making it unreadable due to the commas in a OU path