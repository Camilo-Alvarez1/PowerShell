# Scheduled Task #
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File `"`"C:\GitHubRepositories\PowerShell\My_Challenges\WorkDayAutomation\Start_Workday.ps1`"`""

# Sets trigger from every day except Friday
$trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday,Tuesday,Wednesday,Thursday -At 7:50AM

Register-ScheduledTask -TaskName "Start Workday Apps1" -Action $action -Trigger $trigger -Description "Opens all work applications at 7:50 AM on weekdays exept Friday"

# View Scheduled Task #
# Get-ScheduledTask -TaskName "Start Workday Apps1"

# Diabale Scheduled Task #
# Disable-ScheduledTask -TaskName "Start Workday Apps1"

# Delete Scheduled Task #
# Unregister-ScheduledTask -TaskName "Start Workday Apps1" -Confirm:$false
