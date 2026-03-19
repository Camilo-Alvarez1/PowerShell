
$systems = @(
    "Server1",
    "Client1"
)

# Ask for local admin credentials (the credentials INSIDE the VMs)
$localCred = Get-Credential -Message "Enter the local Administrator credentials for the VMs"

$report = foreach ($vm in $systems) {

    try {
        # Attempt to run inside the VM using PowerShell Direct
        $result = Invoke-Command -VMName $vm -Credential $localCred -ScriptBlock {

            # Collect system info
            $osInfo   = Get-CimInstance Win32_OperatingSystem
            $cpuInfo  = Get-CimInstance Win32_Processor
            $memInfo  = Get-CimInstance Win32_OperatingSystem
            $diskInfo = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

            # Logged-in users
            $raw = quser 2>$null
            $sessions = if ($raw) { ($raw | Select-Object -Skip 1).Count } else { 0 }

            # Return object
            [PSCustomObject]@{
                OS            = $osInfo.Caption
                LastBoot      = $osInfo.LastBootUpTime
                UptimeDays    = ((Get-Date) - $osInfo.LastBootUpTime).Days
                CPULoad       = "$($cpuInfo.LoadPercentage)%"
                MemoryFree    = "{0:N2}%" -f (($memInfo.FreePhysicalMemory / $memInfo.TotalVisibleMemorySize) * 100)
                DiskFree      = "{0:N2}%" -f (($diskInfo.FreeSpace / $diskInfo.Size) * 100)
                LoggedInUsers = $sessions
            }
        }

        # If Invoke-Command succeeded
        [PSCustomObject]@{
            SystemName    = $vm
            Reachable     = "Yes"
            OS            = $result.OS
            LastBoot      = $result.LastBoot
            Uptime        = "$($result.UptimeDays) days"
            CPULoad       = $result.CPULoad
            MemoryFree    = $result.MemoryFree
            DiskFree      = $result.DiskFree
            LoggedInUsers = $result.LoggedInUsers
            Timestamp     = Get-Date
        }
    }
    catch {
        # VM unreachable or credentials wrong
        [PSCustomObject]@{
            SystemName    = $vm
            Reachable     = "No"
            OS            = $null
            LastBoot      = $null
            Uptime        = $null
            CPULoad       = $null
            MemoryFree    = $null
            DiskFree      = $null
            LoggedInUsers = $null
            Timestamp     = Get-Date
        }
    }
}

# Output and export
$report | Format-Table -AutoSize
$report | Export-Csv -path "C:\GitHubRepositories\PowerShell\ProjectWeek\Assignments\OutComes\VM_Audit_Report.csv" -NoTypeInformation

# Spent 2 hours trying to figure out why the domain admins credentials where not working on either VM
# Solution: I was using the wrong username. Found this by using "Whoami" on the server and found lab\Administrator
# I have been using GOT\Administrator
