Set-ExecutionPolicy RemoteSigned
Enable-PSremoting -SkipNetworkProfileCheck

Enter-PSSession -ComputerName LON-DC1
# Now in session
Install-WindowsFeature NLB
# Installed it
# Now disconnect
Exit-pssession

# Testing Multihopremoting
Enter-PSSession -ComputerName LON-DC1
Enter-PSSession -ComputerName LON-CL1
# Does not work because you can multi-hop

# Remoting limitations
Enter-PSSession -ComputerName localhost
notepad
# Does not work well because it has no way to display the GUI

# One-to-many remoting
help *adapter*
help Get-NetAdapter
Invoke-Command -ComputerName LON-CL1,LON-DC1 -ScriptBlock { Get-NetAdapter -Physical}

# Comparing outputs of local and remote machines
Get-Process | gm
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Get-Process} | gm
# Looks very simular but returend different information

# Implicit remoting
$dc = New-PSSession -ComputerName LON-DC1

# Import and use a module from a server
# Displays a list of modules on the domain controller
Get-Module -ListAvailable -PSSession $dc
# Looks for the module that works with SMB
Get-Module -ListAvailable -PSSession $dc | where { $_.Name -like '*share*' }
# Imports that module from the dc to my local computer
Import-Module -PSSession $dc -Name SMBShare -Prefix DC
# Display the shares that exist on the DC
Get-DCSmbShare
# Display the shares that exist on the local computer
Get-DCSmbShare


# Close all open remoting connections
Get-PSSession | Remove-PSSession
# Verify
Get-PSSession

# Managing multiple computers
$computers = New-PSSession -ComputerName LON-CL1,LON-DC1
$computers
# Two connections are displayed

# A report that can display Windows Firewall rules from both computers
# Finding the net security module
Get-Module *Security* -ListAvailable
# Imports the module
Invoke-Command -Session $computers -ScriptBlock { Import-Module NetSecurity }
# Find the cmdlt you need
Get-Command -Module netsecurity
# Learn about Get-netFirewallRule Cmdlt
help Get-NetFirewallRule -ShowWindow
# List the enabled firwall rules for CL1 and DC1
Invoke-Command -Session $computers -ScriptBlock { Get-NetFirewallRule -Enabled True } | select Name,PSComputerName

# Unload a module
Invoke-Command -Session $computers -ScriptBlock { Remove-Module NetSecurity }

# Display a HTML report that displays local disk information from both computers
# For a local machine
Get-WmiObject -Class win32_logicaldisk -Filter "Drivetype=3"
# For the remote computers
Invoke-Command -Session $computers -ScriptBlock { Get-WmiObject -Class win32_logicaldisk -Filter "Drivetype=3" }
# Turn it into an HTML report
Invoke-Command -Session $computers -ScriptBlock { Get-WmiObject -Class win32_logicaldisk -Filter "Drivetype=3" } | ConvertTo-Html -Property pscomputername,deviceid,freespace,size

# Close all sessions before you leave
Get-PSSession | Remove-PSSession