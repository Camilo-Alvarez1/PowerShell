$vmChoice = Read-Host "Select VM (Server1/Client1 or S/C)"

switch ($vmChoice.ToLower()) {
    "server1" { $vmName = "Server1" }
    "s"       { $vmName = "Server1" }
    "client1" { $vmName = "Client1" }
    "c"       { $vmName = "Client1" }
    default {
        Write-Host "Invalid selection. Please enter Server1, Client1, S, or C."
        exit
    }
}

# Prompt for LAB\Admins password
$cred = Get-Credential -UserName "LAB\Administrator" -Message "Enter LAB\Administrator password"

# Run gpupdate inside Client1 using PowerShell Direct
Invoke-Command -VMName "Client1" -Credential $cred -ScriptBlock {
    Write-Host "Running gpupdate /force inside Client1..."
    gpupdate /force
}
