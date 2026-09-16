$workDir = "E:\STORM SWITCH 4\STORM DRIVER\Build\stage_clean_404"
if (Test-Path $workDir) { Remove-Item $workDir -Recurse -Force }
New-Item -ItemType Directory -Path $workDir -Force | Out-Null

$sourceZip = "E:\STORM EDEN 3\DRIVERS\STORM_DRIVER_0.0.29.zip"
& "C:\Program Files\7-Zip\7z.exe" x $sourceZip "-o$workDir" -y | Out-Null

Copy-Item "E:\STORM SWITCH 4\STORM DRIVER\Build\config\meta.json" "$workDir\meta.json" -Force

$stageFiles = Get-ChildItem $workDir
if ($stageFiles.Count -ne 5) {
    throw "Expected exactly 5 files in staging directory, but found $($stageFiles.Count)!"
}

$destFiles = @(
    "E:\STORM SWITCH 4\Files\STORM_DRIVER_4.0.4.zip",
    "E:\STORM DRIVER\STORM_DRIVER_4.0.4.zip",
    "E:\STORM SWITCH 4\STORM DRIVER\Files\STORM_DRIVER_4.0.4.zip"
)

foreach ($dest in $destFiles) {
    $parent = Split-Path $dest -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    if (Test-Path $dest) { Remove-Item $dest -Force }
}

$primaryZip = $destFiles[0]
& "C:\Program Files\7-Zip\7z.exe" a -tzip $primaryZip "$workDir\*" -mx=9 | Out-Null

for ($i = 1; $i -lt $destFiles.Count; $i++) {
    Copy-Item $primaryZip $destFiles[$i] -Force
}

foreach ($dest in $destFiles) {
    if (Test-Path $dest) { Unblock-File $dest }
}

Remove-Item $workDir -Recurse -Force

Write-Host "=== Created STORM_DRIVER_4.0.4.zip successfully ==="
Get-Item $destFiles | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize
Get-FileHash $primaryZip -Algorithm SHA256 | Format-List
