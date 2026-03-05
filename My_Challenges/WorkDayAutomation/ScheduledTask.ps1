# Scheduled Task #
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -File `"`"C:\GitHubRepositories\PowerShell\My_Challenges\WorkDayAutomation\Start_Workday.ps1`"`""
# Sets trigger to 7:50 AM
$trigger = New-ScheduledTaskTrigger -Daily -At 7:50AM
# Changes the trigger from every day (7 Days a week) to Mon-Thur using an aray of days @()
$trigger.daysofweek = @("Monday","Tuesday","Wednesday","Thursday")

Register-ScheduledTask -TaskName "Start Workday Apps1" -Action $action -Trigger $trigger -Description "Opens all work applications at 7:50 AM on weekdays exept Friday"

# View Scheduled Task #
# Get-ScheduledTask -TaskName "Start Workday Apps"

# Diabale Scheduled Task #
# Disable-ScheduledTask -TaskName "Start Workday Apps"