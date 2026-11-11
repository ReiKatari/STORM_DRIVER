# Packaging script for STORM DRIVER 11.0.0 Universal Multi-Platform Edition
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

$tempDir = Join-Path $buildRoot 'stage_driver_1100'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

# 2. Locate base .so libraries: prefer Rutabaga v3 Mesa 26.3.0-devel git-b00479181d
$rutabagaSo = 'F:\STORM SWITCH 2\WORK\stevenmxz_gamesir\extracted\libvulkan_freedreno.so'
if (Test-Path $rutabagaSo) {
    Write-Host "Using Mesa 26.3.0-devel Rutabaga base library from $rutabagaSo..."
    Copy-Item $rutabagaSo (Join-Path $tempDir 'libvulkan_freedreno.so') -Force
    Copy-Item $rutabagaSo (Join-Path $tempDir 'vulkan.freedreno.so') -Force
    Copy-Item $rutabagaSo (Join-Path $tempDir 'vulkan.adreno.so') -Force
    Copy-Item $rutabagaSo (Join-Path $tempDir 'vulkan.purple.so') -Force
    Copy-Item $rutabagaSo (Join-Path $tempDir 'vulkan.panfrost.so') -Force
    Copy-Item $rutabagaSo (Join-Path $tempDir 'libvulkan_panfrost.so') -Force
} else {
    $candidateZips = @(
        (Join-Path $switchRoot 'Files\STORM_DRIVER_10.0.0.zip'),
        (Join-Path $driverRoot 'Files\STORM_DRIVER_10.0.0.zip')
    )
    $baseZip = $candidateZips | Where-Object { Test-Path $_ } | Select-Object -First 1
    if (-not $baseZip) {
        throw "Base driver archive not found in $($candidateZips -join ', ')"
    }
    Write-Host "Extracting base libraries from $baseZip..."
    [System.IO.Compression.ZipFile]::ExtractToDirectory($baseZip, $tempDir)
    
    $metaInf = Join-Path $tempDir 'META-INF'
    if (Test-Path $metaInf) { Remove-Item $metaInf -Recurse -Force }
}

Write-Host "Copying updated 11.0.0 configuration files and metadata..."
Copy-Item (Join-Path $configDir '*') $tempDir -Force

$stageFiles = Get-ChildItem $tempDir -File
Write-Host "`nStaged $($stageFiles.Count) files in distribution:"
$stageFiles | Select-Object Name, Length | Format-Table -AutoSize

$destFiles = @(
    (Join-Path $switchRoot 'Files\STORM_DRIVER_11.0.0.zip'),
    (Join-Path $driverRoot 'Files\STORM_DRIVER_11.0.0.zip')
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
            $entry.ExternalAttributes = [int](0x81ED -shl 16)
        } else {
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
        throw "jarsigner signing failed with exit code $LASTEXITCODE"
    } else {
        Write-Host "STORM SERTIFICATE signature applied successfully."
    }
}

# Apply POSIX 0755/0644 attributes to the signed archive
Write-Host "Applying POSIX 0755/0644 permissions to signed archive..."
$pythonScript = @"
import zipfile, os

zpath = r'$primaryZip'
entries = []
with zipfile.ZipFile(zpath, 'r') as zin:
    for info in zin.infolist():
        entries.append((info, zin.read(info.filename)))

temp_zip = zpath + '.perm.tmp'
with zipfile.ZipFile(temp_zip, 'w', compression=zipfile.ZIP_DEFLATED) as zout:
    for info, data in entries:
        new_info = zipfile.ZipInfo(info.filename, date_time=info.date_time)
        new_info.compress_type = info.compress_type
        new_info.comment = info.comment
        new_info.extra = info.extra
        new_info.create_system = 3  # UNIX
        if info.filename.endswith('.so'):
            new_info.external_attr = 0o100755 << 16  # -rwxr-xr-x
        else:
            new_info.external_attr = 0o100644 << 16  # -rw-r--r--
        zout.writestr(new_info, data)

os.replace(temp_zip, zpath)
"@
python -c $pythonScript

# Final verification with jarsigner
Write-Host "Verifying signature with jarsigner -verify..."
& $jarsigner -verify $primaryZip
if ($LASTEXITCODE -ne 0) {
    throw "jarsigner -verify failed with exit code $LASTEXITCODE"
}
Write-Host "jarsigner -verify verified OK."

for ($i = 1; $i -lt $destFiles.Count; $i++) {
    Copy-Item $primaryZip $destFiles[$i] -Force
}

Remove-Item $tempDir -Recurse -Force

Write-Host "`n=== Created STORM_DRIVER_11.0.0.zip successfully ==="
Get-Item $destFiles | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize
Get-FileHash $primaryZip -Algorithm SHA256 | Format-List
