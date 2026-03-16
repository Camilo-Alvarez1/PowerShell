# Configuration
$VMName = "Server1"
$VMRoot = "C:\HyperV\VMs"
$VMPath = "$VMRoot\$VMName"
$VHDPath = "$VMPath\$VMName.vhdx"
$ISOPath = "C:\ISO\SERVER_EVAL_x64FRE_en-us.iso" # Update ISO file location

$MemoryStartup = 4GB
$VHDSize = 15GB
$CPUCount = 2

# Create a folder for the VM
if (-not (Test-Path $VMPath)) {
    New-Item -ItemType Directory -Path $VMPath | Out-Null
}

# Import Hyper-V Module
# Import-Module Hyper-V # Needs PowerShell 5 not 7

# Create the VM
New-VM -Name $VMName -MemoryStartupBytes $MemoryStartup -Generation 2 -Path $VMPath

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
