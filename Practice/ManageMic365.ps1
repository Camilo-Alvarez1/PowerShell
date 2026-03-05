# Managing users and groups in Microsoft Entra ID #

# Connect to Microsoft Entra ID

# Set execution Policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install the correct modules
Install-Module Microsoft.Graph -Scope CurrentUser

# Verify Install
Get-InstalledModule Microsoft.Graph

# Connect to Microsoft Graph using interactive authentication for users, groups, teamsettings, RoleManagement.
Connect-MgGraph -Scopes "User.ReadWrite.All", "Application.ReadWrite.All", "Sites.ReadWrite.All", "Directory.ReadWrite.All", "Group.ReadWrite.All", "RoleManagement.ReadWrite.Directory"

# Sign in with the global Administrator role

# Review the list of Microsoft Entra ID users
Get-MgUser

# Create a new Administrative user
# Get the organizations verified domain
$verifiedDomain = (Get-MgOrganization).VerifiedDomains[0].Name
# Set the password variable
$PasswordProfile = @{  
"Password"="<password>";  
"ForceChangePasswordNextSignIn"=$true  
}  

# Create a new Microsoft Entra ID User
New-MgUser -DisplayName "Noreen Riggs" -UserPrincipalName "Noreen@$verifiedDomain" -AccountEnabled -PasswordProfile $PasswordProfile -MailNickName "Noreen"

# Store a reference to the new user in a variable
$user = Get-MgUser -UserId "Noreen@$verifiedDomain"

#  Store a reference to the Global Administrator role in a variable
$role = Get-MgDirectoryRole | Where {$_.displayName -eq 'Global Administrator'}

# Assign the Global Administrator role to Noreen's user account
$OdataId = "https://graph.microsoft.com/v1.0/directoryObjects/" + $user.id  
New-MgDirectoryRoleMemberByRef -DirectoryRoleId $role.id -OdataId $OdataId

# Verify that the role was assigned
Get-MgDirectoryRoleMember -DirectoryRoleId $role.id

# Create another user
New-MgUser -DisplayName "Allan Yoo" -UserPrincipalName Allan@$verifiedDomain -AccountEnabled -PasswordProfile $PasswordProfile -MailNickName "Allan"

# Set the Allan's Usage Location to U.S.
Update-MgUser -UserId Allan@$verifiedDomain -UsageLocation US

# Review available licenses
Get-MgSubscribedSku | FL

# Get the SKU ID from the correct license
$SkuId = (Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -eq "Office_365_E5_(no_Teams)" }).SkuId

# Give the license to Allan using the SKU
Set-MgUserLicense -UserId Allan@$verifiedDomain -AddLicenses @{SkuId = $SkuId} -RemoveLicenses @()

# Review existing groups then create a new one
Get-MgGroup
New-MgGroup -DisplayName "Sales Security Group" -MailEnabled:$False  -MailNickName "SalesSecurityGroup" -SecurityEnabled

# Store the new group in a variable
$group = Get-MgGroup -ConsistencyLevel eventual -Count groupCount -Search '"DisplayName:Sales Security"'

# Store Allan's account in a variable
$user = Get-MgUser -UserId Allan@$verifiedDomain

# Add Allan to the Sales Security Group
New-MgGroupMember -GroupId $group.id -DirectoryObjectId $user.id

# Verify that Allan got added to the group
Get-MgGroupMember -GroupId $group.id

# Manage Exchange online
# Install the module
Install-Module ExchangeOnlineManagement -force

# Connect to Exchange online
Connect-ExchangeOnline

# Sign into your account

# List the mailboxes in Exchange online
Get-EXOMailbox

# Create a room Mailbox
New-Mailbox -Room -Name BoardRoom

# Configure the new room to accespt meeting requests
Set-CalendarProcessing BoardRoom -AutomateProcessing AutoAccept

# Test your work by siging into Allans account on Outlook and creating a New Event and sending it to the board room
# Verify that the New Event shows up in Allan's inbox

# Manage SharePoint online
Install-Module -Name Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser

# Connect to SharePoint online
$verifiedDomainShort = LODSA593293
Connect-SPOService -Url "https://$verifiedDomainShort-admin.sharepoint.com"

# Create a new site
New-SPOSite -Url https://$verifiedDomainShort.sharepoint.com/sites/Sales -Owner noreen@$verifiedDomain -StorageQuota 256 -Template EHS#1 -NoWait

# Disconnect from SPO service
Disconnect-SPOService

# Managing Microsoft Teams
Install-Module -Name MicrosoftTeams -Force -AllowClobber

# Connect to Teams
Connect-MicrosoftTeams

# Verify that there are no existing teans
Get-Team

# Create new team
New-Team -DisplayName "Sales Team" -MailNickName "SalesTeam"

# Place the team into a variable
$team = Get-Team -DisplayName "Sales Team"

# Review the teams information
$team | Fl

# Get the organizations verified domain name
$verifiedDomain = (Get-MgOrganization).VerifiedDomains[0].Name

# Add a user
Add-TeamUser -GroupId $team.GroupId -User Allan@$verifiedDomain -Role Member

# Review the teams member information
Get-TeamUser -GroupId $team.GroupId