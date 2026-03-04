
# Logging #
$logPath = "C:\Users\camil\OneDrive\Desktop\WorkdayLogs\WorkdayLog.txt"
$timeStamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
Add-Content -PassThru $logPath -Value "[$timeStamp]: Workday startup script triggered"

# Function to Launch Applications Safely #
function Start-App {
    param (
        [string]$processName,
        [string]$executablePath
    )

    if (Get-Process -Name $processName -ErrorAction SilentlyContinue) {
        Add-Content -Path $logPath -Value "[$timeStamp]: Already running. Skipped."
    }
    else {
        Start-Process $executablePath
        Add-Content -Path $logPath -Value "[$timeStamp]: Started $processName"
    }
}

# Launch Apps #
Start-App -processName "Notion Ai" -executablePath "C:\Users\camil\AppData\Local\Programs\Notion\Notion.exe"
Start-App -processName "Notepad" -executablePath "C:\Windows\system32\notepad.exe"
Start-App -processName "Teams" -executablePath "C:\Program Files\WindowsApps\MSTeams_26032.208.4399.5_x64__8wekyb3d8bbwe\ms-teams.exe"

# Launch Websites #
Start-Process "https://m365.cloud.microsoft/launch/onenote?auth=2"
Start-Process "https://copilot.microsoft.com/"
Start-Process "https://lms.learnondemand.net/User/Login?ReturnUrl=%2F"
Start-Process "https://github.com/"

# Start-Process "$skillAble"


