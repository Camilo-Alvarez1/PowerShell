# Naming table
$VMName = "Server1"
$dcName = "Server1"
$domainName = "got.lab"
$netbiosName = "LAB"

# IP information
$dcIP = "192.168.10.10"
$prefixLength = 24
$gateway = "192.168.10.1"
$dnsIP = $dcIP

# Scope information
$scopeName = "LabScope"
$scopeStart = "192.168.10.50"
$scopeEnd = "192.168.10.100"
$scopeMask = "255.255.255.0"

# Credential handling
$localCred = Get-Credential -Message "=== Enter the local Administrator credentials for $VMName"

# Build the Domain credentials automatically
$domainCred = New-Object System.Management.Automation.PSCredential(
    "$netbiosName\Administrator",
    $localCred.Password
)

# Makes a dsrm password
$dsrmPasswordPlain = "Hun43edSh0ts!@"
$dsrmPassword = ConvertTo-SecureString $dsrmPasswordPlain -AsPlainText -Force

# Check if the VM is running
Write-Host "=== Checking VM '$VMName' exists and is running ==="
$vm = Get-VM -Name $VMName

# Start the VM if needed
if ($vm.state -ne 'Running') {
    Write-Host "=== VM is not running. Starting VM now ==="
    Start-VM -Name $VMName | Out-Null
    Start-Sleep -Seconds 20
}

# Configure computer name and base networking
Write-Host "=== Setting computer name and configuring base networking on $VMName via PowerShell Direct ==="
Invoke-Command -VMName $VMName -Credential $localCred -ScriptBlock {
    param(
        $dcName, $dcIP, $prefixLength, $gateway, $dnsIP
    )
    
    # Change computer name if needed
    Write-Host "=== Setting computer name to $dcName ==="
    if ($env:COMPUTERNAME -ne $dcName) {
        Rename-Computer -NewName $dcName -Force
        Write-Host "=== Computer renamed. Rebooting after IP configuration ==="
    }

    # Find and store the first network adapter that is running
    Write-Host "=== Configuring static IP and DNS ==="
    $nic = Get-NetAdapter | Where-Object { $_.Status -eq 'Up'} | Select-Object -First 1

    # Remove any existing IPs to avoid conflicts
    Get-NetIPAddress -InterfaceIndex $nic.ifIndex -ErrorAction SilentlyContinue |
        Where-Object { $_.AddressFamily -eq 'IPv4'} |
        Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue

    New-NetIPAddress -InterfaceIndex $nic.ifIndex -IPAddress $dcIP -PrefixLength $prefixLength -DefaultGateway $gateway
    Set-DnsClientServerAddress -InterfaceIndex $nic.ifIndex -ServerAddresses $dnsIP

    Write-Host "=== Base networking configuration complete ==="

} -ArgumentList $dcName, $dcIP, $prefixLength, $gateway, $dnsIP

# Reboot computer and apply changes
Write-Host "=== Rebooting VM to apply changes ==="
Invoke-Command -VMName $VMName -Credential $localCred -ScriptBlock { Restart-Computer -Force }

Start-Sleep -Seconds 15

# Install AD DS role
Invoke-Command -VMName $VMName -Credential $localCred -ScriptBlock {
    Write-Host "=== Installing AD-Domain-Services ==="
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
    Write-Host "=== AD DS role installed ==="

}

Write-Host "=== Promoting $VMName to Domain Controller for $domainName ==="

Invoke-Command -VMName $VMName -Credential $localCred -ScriptBlock {
    param($domainName, $netbiosName, $dsrmPassword)

    Write-Host "=== Running Install-ADDSForest ==="
    Install-ADDSForest `
        -DomainName $domainName `
        -DomainNetbiosName $netbiosName `
        -SafeModeAdministratorPassword $dsrmPassword `
        -InstallDNS `
        -Force
    
    Write-Host "=== Promotion initiated. Server will reboot automatically ==="

} -ArgumentList $domainName, $netbiosName, $dsrmPassword

Write-Host "=== Waiting for DC promotion reboot ==="
Start-Sleep -Seconds 120

Write-Host "=== Installing DHCP role on $VMName ==="

Invoke-Command -VMName $VMName -Credential $domainCred -ScriptBlock {
    Install-WindowsFeature DHCP -IncludeManagementTools
    Write-Host "=== DHCP installed ==="

}

Write-Host "=== Configuring DHCP authorization / scope on $VMName ==="

Invoke-Command -VMName $VMName -Credential $domainCred -ScriptBlock {
    param($dcName, $domainName, $dcIP, $scopeName, $scopeStart, $scopeEnd, $scopeMask, $gateway, $dnsIP)

    Import-Module DHCPServer

    $fqdn = "$dcName.$domainName"

    Write-Host "=== Authorizing DHCP server in AD as $fqdn ($dcIP)"
    Add-DhcpServerInDC -DnsName $fqdn -IPAddress $dcIP -ErrorAction SilentlyContinue

    Write-Host "=== Creating DHCP scope $scopeName ($scopeStart - $scopeEnd) ==="
    Add-DhcpServerv4Scope `
        -Name $scopeName `
        -StartRange $scopeStart `
        -EndRange $scopeEnd `
        -SubnetMask $scopeMask `
        -State Active

    Write-Host "=== Setting DHCP options (DNS, domain, gateway) ==="
    Set-DhcpServerv4OptionValue `
        -DnsServer $dnsIP `
        -DnsDomain $domainName `
        -Router $gateway
    
        Write-Host "=== DHCP configuration complete ==="
        
} -ArgumentList $dcName, $domainName, $dcIP, $scopeName, $scopeStart, $scopeEnd, $scopeMask, $gateway, $dnsIP

Write-Host "=== Build complete. Server1 should now be: DC + DNS + DHCP for $domainName ==="
Write-Host "You can now create a client VM, set it to use DHCP on 192.168.10.0/24, and join it to GOT.lab."

# Testing
# Get-VM Server1
# Start-VM -Name $VMName

