Clear-Host
Write-Host "=== Hyper-V VM Creation Wizard"

$VMType = Read-Host "Enter VM type (Server or Client)"

# Covert answer
switch ($VMType.ToLower()) {
    "server" { 
        $ISOPath = "C:\ISO\SERVER_EVAL_x64FRE_en-us.iso"
        Write-Host "=== Selected: Windows Server ISO ==="
    }
    
    "client" {
        $ISOPath = "C:\ISO\26200.6584.250915-1905.25h2_ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"
        Write-Host "=== Selected: Windows Client ISO ==="
    }

    Default {
        Write-Host "=== Invalid choice. Please run the script again ==="
        exit
    }
}

# Ask for VM name
$VMName = Read-Host "=== Enter the VM name ==="
$VMRoot = "C:\HyperV\VMs"
$VMPath = "$VMRoot\$VMName"
$VHDPath = "$VMPath\$VMName.vhdx"

Write-Host ""
Write-Host "=== Minimum Recommended Resources for Client VMs ==="
Write-Host ""

$minTable = @(
    [PSCustomObject]@{ Resource = "vCPU"; Minimum = "2"; Recommended = "2" }
    [PSCustomObject]@{ Resource = "RAM"; Minimum = "4 GB"; Recommended = "4 GB" }
    [PSCustomObject]@{ Resource = "VHD Size"; Minimum = "20 GB"; Recommended = "40–60 GB" }
    [PSCustomObject]@{ Resource = "TPM"; Minimum = "Required for Windows 11"; Recommended = "Enabled" }
)

$minTable | Format-Table -AutoSize

# Gather desired resorces
$CPUCount = Read-Host "=== Enter number of vCPUs (Recommended: 2)"
$CPUCount = [int]$CPUCount

$MemoryStartup = Read-Host "=== Enter startup RAM in GB (Recommended: 4)"
$MemoryStartup = [int]$MemoryStartup * 1GB

$VHDSize = Read-Host "=== Enter VHD size in GB (Recommended: 40-60)"
$VHDSize = [int]$VHDSize * 1GB

# Create a folder for the VM
if (-not (Test-Path $VMPath)) {
    New-Item -ItemType Directory -Path $VMPath | Out-Null
}

# Create the VM
New-VM -Name $VMName -MemoryStartupBytes $MemoryStartup -Generation 2 -Path $VMPath

# Enable TPM for Windows 11 compatibility
Set-VMKeyProtector -VMName $VMName -NewLocalKeyProtector
Enable-VMTPM -VMName $VMName

# Create and attach a Virtual Hard Disk
New-VHD -Path $VHDPath -SizeBytes $VHDSize -Dynamic
Add-VMHardDiskDrive -VMName $VMName -Path $VHDPath

# Attach the Windows Server ISO
Add-VMDvdDrive -VMName $VMName -Path $ISOPath

# Set the CPU count
Set-VMProcessor -VMName $VMName -Count $CPUCount

# Connect the VM to the defult switch
Connect-VMNetworkAdapter -VMName $VMName -SwitchName "Default Switch"

# Start the VM
Start-VM -Name $VMName

Write-Host "=== VM Creation Complete! ==="
Write-Host "VM Name: $VMName"
Write-Host "Type: $VMType"
Write-Host "RAM: $($MemoryStartup/1GB) GB"
Write-Host "CPU: $CPUCount"
Write-Host "VHD Size: $($VHDSize/1GB) GB"
Write-Host "ISO: $ISOPath"