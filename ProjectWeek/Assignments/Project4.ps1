# Objective: Build a script that gathers the same basic administrative data from multiple systems and combines the results into one report. 

# Primary outcome: Which servers are reachable?

$systems = Import-Csv "C:\GitHubRepositories\PowerShell\ProjectWeek\Assignments\Resorces\Systems.csv"

$report = foreach ($sys in $systems) {

    $name = $sys.SystemName
    $reachable = Test-Connection -ComputerName $name -Count 1 -Quiet

    # Default values if unreachable
    $lastBoot = $null
    $uptime = $null
    $os = $null
    $cpu = $null
    $memory = $null
    $disk = $null
    $sessions = $null

    if ($reachable) {
        try {
            $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $name
            $cpuInfo = Get-CimInstance -ClassName Win32_Processor -ComputerName $name
            $memInfo = Get-CimInstance -ClassName Win32_OperatingSystem -ComputerName $name
            $diskInfo = Get-CimInstance -ClassName Win32_LogicalDisk -ComputerName $name -Filter "DeviceID='C:'"

            $lastBoot = $osInfo.LastBootUpTime
            $uptime = (Get-Date) - $lastBoot
            $os = $osInfo.Caption
            $cpu = "$($cpuInfo.LoadPercentage)%"
            $memory = "{0:N2}%" -f (($memInfo.FreePhysicalMemory / $memInfo.TotalVisibleMemorySize) * 100)
            $disk = "{0:N2}%" -f (($diskInfo.FreeSpace / $diskInfo.Size) * 100)

            # Logged-in users
            $raw = quser /server:$name 2>$null
            if ($raw) {
                $sessions = ($raw | Select-Object -Skip 1).Count
            }
        }
        catch {
            # leaves defult values null if WMI fails
        }
    }

    [PSCustomObject]@{
        SystemName = $name
        Reachable  = if ($reachable) { "Yes" } else { "No" }
        OS         = $os
        LastBoot   = $lastBoot
        Uptime     = if ($uptime) { $uptime.Days.ToString() + " days" } else { $null }
        CPULoad    = $cpu
        MemoryFree = $memory
        DiskFree   = $disk
        LoggedInUsers = $sessions
        Timestamp  = Get-Date
    }
}

$report | Format-Table -AutoSize
$report | Export-Csv "ExpandedServerAudit.csv" -NoTypeInformation