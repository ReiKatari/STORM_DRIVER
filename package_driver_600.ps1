# Packaging script for STORM DRIVER 6.0.0 Universal Multi-Platform Edition
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$buildRoot = $PSScriptRoot
$driverRoot = Split-Path $buildRoot -Parent
$switchRoot = Split-Path $driverRoot -Parent
$configDir = Join-Path $buildRoot 'config'

# 1. Synchronize 00-storm.conf across all Mesa driconf filenames
$srcConf = Join-Path $configDir '00-storm.conf'
foreach ($alias in @('drirc', 'drirc.conf', 'drirc.xml')) {
    Copy-Item $srcConf (Join-Path $configDir $alias) -Force
}

# 2. Locate base archive with native .so binaries
$candidateZips = @(
    (Join-Path $driverRoot 'Files\STORM_DRIVER_5.1.0.zip'),
    (Join-Path $switchRoot 'Files\STORM_DRIVER_5.1.0.zip'),
    (Join-Path $driverRoot 'Files\STORM_DRIVER_5.0.0.zip')
)
$baseZip = $candidateZips | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $baseZip) {
    throw "Base driver archive not found in $($candidateZips -join ', ')"
}

$tempDir = Join-Path $buildRoot 'stage_driver_600'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

Write-Host "Extracting base libraries from $baseZip..."
[System.IO.Compression.ZipFile]::ExtractToDirectory($baseZip, $tempDir)

Write-Host "Copying updated 6.0.0 configuration files..."
Copy-Item (Join-Path $configDir '*') $tempDir -Force

# Verify staged files
$stageFiles = Get-ChildItem $tempDir -File
Write-Host "`nStaged $($stageFiles.Count) files in distribution:"
$stageFiles | Select-Object Name, Length | Format-Table -AutoSize

if ($stageFiles.Count -ne 9) {
    throw "Expected exactly 9 files in staging directory, but found $($stageFiles.Count)!"
}

$destFiles = @(
    (Join-Path $switchRoot 'Files\STORM_DRIVER_6.0.0.zip'),
    (Join-Path $driverRoot 'Files\STORM_DRIVER_6.0.0.zip')
)

foreach ($dest in $destFiles) {
    $parent = Split-Path $dest -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    if (Test-Path $dest) { Remove-Item $dest -Force }
}

$primaryZip = $destFiles[0]
Write-Host "Creating primary zip archive: $primaryZip..."
$zipArchive = [System.IO.Compression.ZipFile]::Open($primaryZip, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    foreach ($file in $stageFiles) {
        $entry = [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $zipArchive,
            $file.FullName,
            $file.Name,
            [System.IO.Compression.CompressionLevel]::SmallestSize
        )
        # POSIX 0644 permissions for Android adrenotools / dlopen compatibility
        $entry.ExternalAttributes = (0x81A4 -shl 16)
    }
} finally {
    $zipArchive.Dispose()
}

for ($i = 1; $i -lt $destFiles.Count; $i++) {
    Copy-Item $primaryZip $destFiles[$i] -Force
}

Remove-Item $tempDir -Recurse -Force

Write-Host "`n=== Created STORM_DRIVER_6.0.0.zip successfully ==="
Get-Item $destFiles | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize
Get-FileHash $primaryZip -Algorithm SHA256 | Format-List
