# Copy files and send to VM

Write-Host "=== GOT-AD File Transfer Tool ===" -ForegroundColor Cyan

$vmName    = Read-Host "Enter the VM name (example: Server1 or Client1)"
$sourcePath = Read-Host "Enter the FULL source path on the HOST (file or folder)"
$destPath   = Read-Host "Enter the destination path INSIDE the VM (example: C:\Scripts\GOT-AD-Scripts)"
$defaultDest = "C:\Scripts\GOT-AD-Scripts"

if ([string]::IsNullOrWhiteSpace($destPath)) {
    $destPath = $defaultDest
    Write-Host "Using default destination: $destPath" -ForegroundColor Yellow
}

Write-Host "`nYou entered:" -ForegroundColor Yellow
Write-Host "VM Name:        $vmName"
Write-Host "Source Path:    $sourcePath"
Write-Host "Destination:    $destPath"
Write-Host ""

$confirm = Read-Host "Proceed with file transfer? (Y/N)"

if ($confirm -notmatch "^[Yy]$") {
    Write-Host "Operation cancelled." -ForegroundColor Red
    return
}

if (-not (Test-Path $sourcePath)) {
    Write-Host "ERROR: Source path does not exist." -ForegroundColor Red
    return
}

$sourceItem = Get-Item $sourcePath

try {
    if ($sourceItem.PSIsContainer) {
        # Folder: copy all files recursively
        Write-Host "`nSource is a FOLDER. Copying contents recursively..." -ForegroundColor Cyan

        Get-ChildItem -Path $sourcePath -Recurse -File | ForEach-Object {
            $relativePath = $_.FullName.Substring($sourcePath.Length).TrimStart('\')
            $targetPath   = Join-Path $destPath $relativePath

            Write-Host "Copying: $($_.FullName) -> $targetPath"

            Copy-VMFile -VMName $vmName `
                        -SourcePath $_.FullName `
                        -DestinationPath $targetPath `
                        -FileSource Host `
                        -CreateFullPath
        }
    }
    else {
        # Single file
        Write-Host "`nSource is a FILE. Copying single file..." -ForegroundColor Cyan

        Copy-VMFile -VMName $vmName `
                    -SourcePath $sourcePath `
                    -DestinationPath $destPath `
                    -FileSource Host `
                    -CreateFullPath
    }

    Write-Host "`nFile transfer complete!" -ForegroundColor Green
}
catch {
    Write-Host "`nERROR: File transfer failed." -ForegroundColor Red
    Write-Host $_
}