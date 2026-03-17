# Ask for the VM name you want to join
$VMName = Read-Host "=== Enter the VMs Name that you want to domainjoin ==="

# Ask for LOCAL admin credentials (required for PowerShell Direct)
$LocalCred = Get-Credential -Message "=== Enter the LOCAL Administrator credentials for $VMName ==="

# Gather domain administrator credentials
$DomainCred = Get-Credential -Message "=== Enter the domains Administrator credentials (LAB\Administrator) ===="

# Allow for a computer name change
$NewName = Read-Host "=== Enter the desired computer name (or press Enter to keep the current name) ==="

Invoke-Command -VMName $VMName -Credential $LocalCred -ScriptBlock {
    param($NewName, $DomainCred)

    Write-Host "=== Prepairing client for domain join ==="

    # Rename the computer if requested
    if ($NewName -and $env:COMPUTERNAME -ne $NewName) {
        Write-Host "=== Renaming computer to $NewName ==="
        Rename-Computer -NewName $NewName -Force
    }

    Write-Host "=== Joining $NewName to GOT.lab ==="
    Add-Computer -DomainName "GOT.lab" -Credential $DomainCred -Force

    Write-Host "=== Restarting Computer ==="
    Restart-Computer -Force
} -ArgumentList $NewName, $DomainCred