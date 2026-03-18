
$Cred = Get-Credential -Message "Enter Domain Administrator credentials"

$VMs = @("Server1", "Client1")

foreach ($vm in $VMs) {
    Write-Host "`n===== $vm =====" -ForegroundColor Cyan

    try {
        Invoke-Command -VMName $vm -Credential $Cred -ScriptBlock {
            query user
        }
    }
    catch {
        Write-Host "Could not connect to $vm (invalid credentials or VM not running)." -ForegroundColor Red
    }
}
