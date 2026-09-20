# Packaging script for STORM DRIVER 5.1.0 Universal Multi-Platform Edition
$ErrorActionPreference = 'Stop'

$tempDir = 'E:\STORM SWITCH 4\STORM DRIVER\Build\stage_driver_510'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

$baseZip = 'E:\STORM SWITCH 4\Files\STORM_DRIVER_5.0.0.zip'
if (-not (Test-Path $baseZip)) {
    $baseZip = 'E:\STORM SWITCH 4\Files\STORM_DRIVER_4.0.3.zip'
}

Write-Host "Extracting base libraries from $baseZip..."
& 'C:\Program Files\7-Zip\7z.exe' x $baseZip "-o$tempDir" -y | Out-Null

Write-Host "Copying updated 5.1.0 configuration files..."
Copy-Item 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\*' $tempDir\ -Force

# Verify staged files
$stageFiles = Get-ChildItem $tempDir
Write-Host "`nStaged $($stageFiles.Count) files in distribution:"
$stageFiles | Select-Object Name, Length | Format-Table -AutoSize

if ($stageFiles.Count -ne 9) {
    throw "Expected exactly 9 files in staging directory, but found $($stageFiles.Count)!"
}

# Target zip destinations
$destFiles = @(
    "E:\STORM SWITCH 4\Files\STORM_DRIVER_5.1.0.zip",
    "E:\STORM SWITCH 4\STORM DRIVER\Files\STORM_DRIVER_5.1.0.zip"
)
if (Test-Path 'E:\STORM DRIVER') {
    $destFiles += "E:\STORM DRIVER\STORM_DRIVER_5.1.0.zip"
}

foreach ($dest in $destFiles) {
    $parent = Split-Path $dest -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    if (Test-Path $dest) { Remove-Item $dest -Force }
}

$primaryZip = $destFiles[0]
Write-Host "Creating primary zip archive: $primaryZip..."
& 'C:\Program Files\7-Zip\7z.exe' a -tzip $primaryZip "$tempDir\*" -mx=9 | Out-Null

for ($i = 1; $i -lt $destFiles.Count; $i++) {
    Copy-Item $primaryZip $destFiles[$i] -Force
}

foreach ($dest in $destFiles) {
    if (Test-Path $dest) { Unblock-File $dest }
}

Remove-Item $tempDir -Recurse -Force

Write-Host "`n=== Created STORM_DRIVER_5.1.0.zip successfully ==="
Get-Item $destFiles | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize
Get-FileHash $primaryZip -Algorithm SHA256 | Format-List
