# Configuration
$VMName = "Server1"
$VMRoot = "C:\HyperV\VMs"
$VMPath = "$VMName\$VMName"
$VHDPath = "$VMPath\$VMName.vhdx"
$ISOPath = "C:\ISOs\WindowsServer2022.iso" # Update ISO file location

$MemoryStartup = 4GB
$VHDSize = 15GB
$CPUCount = 2

# Create a folder for the VM
if (-not (Test-Path $VMPath)) {
    New-Item -ItemType Directory -Path $VMPath | Out-Null
}

# Import Hyper-V Module
Import-Module Hyper-V
Get-Command -Module Hyper-V
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -All



# Create the VM
New-VM -n