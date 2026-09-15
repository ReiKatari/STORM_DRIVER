Copy-Item 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\00-storm.conf' 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\drirc' -Force
Copy-Item 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\00-storm.conf' 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\drirc.conf' -Force
Copy-Item 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\00-storm.conf' 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\drirc.xml' -Force

$tempDir = 'E:\STORM SWITCH 4\STORM DRIVER\Build\stage_driver_403'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

$baseZip = 'E:\STORM SWITCH 4\Files\STORM_DRIVER_4.0.2.zip'
if (-not (Test-Path $baseZip)) {
    $baseZip = 'E:\STORM SWITCH 4\Files\STORM_DRIVER_4.0.1.zip'
}

& 'C:\Program Files\7-Zip\7z.exe' x $baseZip "-o$tempDir" -y
Copy-Item 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\*' $tempDir\ -Force

$zipOut1 = 'E:\STORM SWITCH 4\Files\STORM_DRIVER_4.0.3.zip'
$zipOut2 = 'E:\STORM DRIVER\STORM_DRIVER_4.0.3.zip'
$zipDir3 = 'E:\STORM SWITCH 4\STORM DRIVER\Files'
if (-not (Test-Path $zipDir3)) { New-Item -ItemType Directory -Path $zipDir3 -Force | Out-Null }
$zipOut3 = "$zipDir3\STORM_DRIVER_4.0.3.zip"

if (Test-Path $zipOut1) { Remove-Item $zipOut1 -Force }
if (Test-Path $zipOut2) { Remove-Item $zipOut2 -Force }
if (Test-Path $zipOut3) { Remove-Item $zipOut3 -Force }

& 'C:\Program Files\7-Zip\7z.exe' a -tzip $zipOut1 "$tempDir\*" -mx=9
if (Test-Path 'E:\STORM DRIVER') {
    Copy-Item $zipOut1 $zipOut2 -Force
}
Copy-Item $zipOut1 $zipOut3 -Force

Unblock-File $zipOut1
if (Test-Path $zipOut2) { Unblock-File $zipOut2 }
Unblock-File $zipOut3

Remove-Item $tempDir -Recurse -Force

Write-Host "STORM_DRIVER_4.0.3.zip built successfully!"
Get-Item $zipOut1, $zipOut3 | Select-Object Name, Length, LastWriteTime, Directory
Get-FileHash $zipOut1 -Algorithm SHA256 | Select-Object Hash, Path
