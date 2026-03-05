# Start a remote job that retrives physical network adapters from DC1 and SVR1
Invoke-Command -ScriptBlock { Get-NetAdapter -Physical } -ComputerName LON-DC1,LON-SVR1 -AsJob -JobName RemoteNetAdapt

# Start a remote job that retrives SMB Shares from DC1 and SVR1
Invoke-Command -ScriptBlock { Get-SmbShare } -ComputerName LON-DC1,LON-SVR1 -AsJob -JobName RemoteNetAdapt

# Start a remote job that retrives all instances of the Win32_Volume class from all computers in AD DS
Enable-PSRemoting –SkipNetworkProfileCheck –Force
Invoke-Command –ScriptBlock { Get-CimInstance –ClassName Win32_Volume } –ComputerName (Get-ADComputer –Filter * | Select –Expand Name) –AsJob –JobName RemoteDisks

# Start a local job that retrieves all entries from the Security event log
Start-Job –ScriptBlock { Get-EventLog –LogName Security } –Name LocalSecurity

#  Start a local job that produces 100 directory listings
Start-Job –ScriptBlock { 1..100 | ForEach-Object { Dir C:\ -Recurse } } –Name LocalDir

# Display running jobs
Get-Job

# Display running jobs whos name start with remote
Get-Job -Name Remote*

# Stop a job (LocalDir)
Stop-Job -Name LocalDir

# To get the result of a remote jobs
Receive-Job –Name RemoteNetAdapt

# Receive the results of the RemoteDisks job
Get-Job –Name RemoteDisks –IncludeChildJob | Receive-Job

# Create a scheduled job
$option = New-ScheduledJobOption –WakeToRun -RunElevated

# Create a job trigger
$trigger1 = New-JobTrigger –Once –At (Get-Date).AddMinutes(5)

# Create a scheduled job and retrieve results
Register-ScheduledJob –ScheduledJobOption $option `
–Trigger $trigger1 `
–ScriptBlock { Get-EventLog –LogName Security } `
–Name LocalSecurityLog

#  Display a list of job triggers
Get-ScheduledJob –Name LocalSecurityLog | 
Select –Expand JobTriggers 