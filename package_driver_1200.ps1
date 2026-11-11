# Packaging script for STORM DRIVER 12.0.0 Universal Multi-Platform Edition
$ErrorActionPreference = 'Stop'
[System.Diagnostics.Process]::GetCurrentProcess().PriorityClass = [System.Diagnostics.ProcessPriorityClass]::BelowNormal

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$buildRoot = $PSScriptRoot
$driverRoot = Split-Path $buildRoot -Parent
$switchRoot = Split-Path $driverRoot -Parent
$configDir = Join-Path $buildRoot 'config'
$scratchDir = 'C:\Users\ReiKa\.gemini\antigravity\brain\ce53db6d-080c-4f42-a933-9c05b144bcd6\scratch\drivers'

# 1. Synchronize 00-storm.conf across all Mesa driconf filenames
$srcConf = Join-Path $configDir '00-storm.conf'
foreach ($alias in @('drirc', 'drirc.conf', 'drirc.xml')) {
    Copy-Item $srcConf (Join-Path $configDir $alias) -Force
}

$tempDir = Join-Path $buildRoot 'stage_driver_1200'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

try {
    # 2. Extract Turnip binaries from scratch driver archives
    $gen8Zip = Join-Path $scratchDir 'Turnip_Gen8_V39_Patched.zip'
    $a7xxZip = Join-Path $scratchDir 'Turnip_v27.0.0-R2-Oneui.zip'

    if (-not (Test-Path $gen8Zip)) { throw "Missing $gen8Zip" }
    if (-not (Test-Path $a7xxZip)) { throw "Missing $a7xxZip" }

    Write-Host "Extracting Turnip Gen8 V39-patched Vulkan 1.4.367 from $gen8Zip..."
    $zipGen8 = [System.IO.Compression.ZipFile]::OpenRead($gen8Zip)
    try {
        $entryGen8 = $zipGen8.GetEntry('libvulkan_freedreno.so')
        if (-not $entryGen8) { throw "libvulkan_freedreno.so not found in $gen8Zip" }
        
        $tmpGen8 = Join-Path $tempDir 'gen8_raw.so'
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entryGen8, $tmpGen8, $true)
        
        Copy-Item $tmpGen8 (Join-Path $tempDir 'vulkan.adreno_gen8.so') -Force
        Copy-Item $tmpGen8 (Join-Path $tempDir 'vulkan.freedreno.so') -Force
        Copy-Item $tmpGen8 (Join-Path $tempDir 'libvulkan_freedreno.so') -Force
        Remove-Item $tmpGen8 -Force
    } finally {
        $zipGen8.Dispose()
    }

    Write-Host "Extracting Turnip 27.0.0-R2-Oneui Vulkan 1.4.367 from $a7xxZip..."
    $zipA7xx = [System.IO.Compression.ZipFile]::OpenRead($a7xxZip)
    try {
        $entryA7xx = $zipA7xx.GetEntry('libvulkan_freedreno.so')
        if (-not $entryA7xx) { throw "libvulkan_freedreno.so not found in $a7xxZip" }
        
        $dstA7xx = Join-Path $tempDir 'vulkan.adreno_a7xx.so'
        [System.IO.Compression.ZipFileExtensions]::ExtractToFile($entryA7xx, $dstA7xx, $true)
    } finally {
        $zipA7xx.Dispose()
    }

    Write-Host "Copying updated 12.0.0 configuration files and metadata..."
    Copy-Item (Join-Path $configDir '*') $tempDir -Force

    $stageFiles = Get-ChildItem $tempDir -File
    Write-Host "`nStaged $($stageFiles.Count) files in distribution:"
    $stageFiles | Select-Object Name, Length | Format-Table -AutoSize

    # 3. Define output archives (exactly matching package_driver_1100.ps1)
    $destFiles = @(
        (Join-Path $switchRoot 'Files\STORM_DRIVER_12.0.0.zip'),
        (Join-Path $driverRoot 'Files\STORM_DRIVER_12.0.0.zip')
    )

    foreach ($dest in $destFiles) {
        $parent = Split-Path $dest -Parent
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        if (Test-Path $dest) { Remove-Item $dest -Force }
    }

    # Clean stale 11.0.0 in target distribution folder (keeping historical archive in driverRoot\Files)
    $staleSwitch11 = Join-Path $switchRoot 'Files\STORM_DRIVER_11.0.0.zip'
    $staleSwitch11Tmp = Join-Path $switchRoot 'Files\STORM_DRIVER_11.0.0.zip.tmp'
    if (Test-Path $staleSwitch11) { Remove-Item $staleSwitch11 -Force }
    if (Test-Path $staleSwitch11Tmp) { Remove-Item $staleSwitch11Tmp -Force }

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

    Write-Host "`n=== Created STORM_DRIVER_12.0.0.zip successfully ==="
    Get-Item $destFiles | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize
    Get-FileHash $primaryZip -Algorithm SHA256 | Format-List
} finally {
    if (Test-Path $tempDir) {
        Remove-Item $tempDir -Recurse -Force
    }
}
