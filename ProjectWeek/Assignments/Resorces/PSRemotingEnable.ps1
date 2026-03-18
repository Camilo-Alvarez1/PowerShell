Enable-PSRemoting -Force
Set-Item WSMan:\localhost\Service\Auth\Basic $true
Restart-Service WinRM

# Adjust firewall rule if needed
Enable-NetFirewallRule -DisplayGroup "Windows Remote Management"
Enable-NetFirewallRule -DisplayGroup "Windows Management Instrumentation (WMI)"
Enable-NetFirewallRule -DisplayGroup "Remote Event Log Management"
