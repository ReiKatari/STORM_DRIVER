# Packaging script for STORM DRIVER 10.0.0 Universal Multi-Platform Edition
$ErrorActionPreference = 'Stop'
[System.Diagnostics.Process]::GetCurrentProcess().PriorityClass = [System.Diagnostics.ProcessPriorityClass]::BelowNormal

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
    (Join-Path $switchRoot 'Files\STORM_DRIVER_9.0.0.zip'),
    (Join-Path $driverRoot 'Files\STORM_DRIVER_9.0.0.zip'),
    (Join-Path $switchRoot 'Files\STORM_DRIVER_8.0.0.zip'),
    (Join-Path $driverRoot 'Files\STORM_DRIVER_8.0.0.zip')
)
$baseZip = $candidateZips | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $baseZip) {
    throw "Base driver archive not found in $($candidateZips -join ', ')"
}

$tempDir = Join-Path $buildRoot 'stage_driver_1000'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

Write-Host "Extracting base libraries from $baseZip..."
[System.IO.Compression.ZipFile]::ExtractToDirectory($baseZip, $tempDir)

Write-Host "Copying updated 10.0.0 configuration files and metadata..."
Copy-Item (Join-Path $configDir '*') $tempDir -Force

# Create PanVK aliases if not already present
$freedrenoSo = Join-Path $tempDir 'vulkan.freedreno.so'
if (Test-Path $freedrenoSo) {
    Copy-Item $freedrenoSo (Join-Path $tempDir 'vulkan.panfrost.so') -Force
    Copy-Item $freedrenoSo (Join-Path $tempDir 'libvulkan_panfrost.so') -Force
}

# Verify staged files
$stageFiles = Get-ChildItem $tempDir -File
Write-Host "`nStaged $($stageFiles.Count) files in distribution:"
$stageFiles | Select-Object Name, Length | Format-Table -AutoSize

$destFiles = @(
    (Join-Path $switchRoot 'Files\STORM_DRIVER_10.0.0.zip'),
    (Join-Path $driverRoot 'Files\STORM_DRIVER_10.0.0.zip')
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
            [System.IO.Compression.CompressionLevel]::Optimal
        )
        if ($file.Extension -eq '.so') {
            # POSIX 0755 (-rwxr-xr-x) for shared libraries
            $entry.ExternalAttributes = [int](0x81ED -shl 16)
        } else {
            # POSIX 0644 (-rw-r--r--) for configs and metadata
            $entry.ExternalAttributes = [int](0x81A4 -shl 16)
        }
    }
} finally {
    $zipArchive.Dispose()
}

# Sign with STORM SERTIFICATE
$jarsigner = 'C:\Users\ReiKa\.jdks\jdk-21.0.12.1+1\bin\jarsigner.exe'
$keystore = 'F:\STORM ALL PROJECTS\.storm-secrets\STORM_SERTIFICATE.jks'
$storePass = 'STORM_SIGNATURE_MASTER_2026!'
$alias = 'SIGNATURE'

if ((Test-Path $jarsigner) -and (Test-Path $keystore)) {
    Write-Host "Signing $primaryZip with unified STORM SERTIFICATE..."
    & $jarsigner -keystore $keystore -storepass $storePass -keypass $storePass $primaryZip $alias
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "jarsigner returned exit code $LASTEXITCODE"
    } else {
        Write-Host "STORM SERTIFICATE signature applied successfully."
    }
}

for ($i = 1; $i -lt $destFiles.Count; $i++) {
    Copy-Item $primaryZip $destFiles[$i] -Force
}

# Remove old 9.0.0 zip from Files
$old900 = Join-Path $switchRoot 'Files\STORM_DRIVER_9.0.0.zip'
if (Test-Path $old900) {
    Remove-Item $old900 -Force
    Write-Host "Removed legacy $old900"
}

Remove-Item $tempDir -Recurse -Force

Write-Host "`n=== Created STORM_DRIVER_10.0.0.zip successfully ==="
Get-Item $destFiles | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize
Get-FileHash $primaryZip -Algorithm SHA256 | Format-List
