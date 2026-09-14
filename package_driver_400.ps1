$tempDir = 'E:\STORM SWITCH 4\STORM DRIVER\Build\stage_driver_400'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
& 'C:\Program Files\7-Zip\7z.exe' x 'E:\STORM SWITCH 4\Files\STORM_DRIVER_3.3.3.zip' "-o$tempDir" -y
Copy-Item 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\*' $tempDir\ -Force
$zipOut1 = 'E:\STORM SWITCH 4\Files\STORM_DRIVER_4.0.0.zip'
$zipOut2 = 'E:\STORM SWITCH 4\STORM DRIVER\Files\STORM_DRIVER_4.0.0.zip'
if (Test-Path $zipOut1) { Remove-Item $zipOut1 -Force }
if (Test-Path $zipOut2) { Remove-Item $zipOut2 -Force }
& 'C:\Program Files\7-Zip\7z.exe' a -tzip $zipOut1 "$tempDir\*" -mx=9
Copy-Item $zipOut1 $zipOut2 -Force
Unblock-File $zipOut1
Unblock-File $zipOut2
Remove-Item $tempDir -Recurse -Force
Get-Item $zipOut1, $zipOut2 | Select-Object Name, Length, LastWriteTime, Directory
Get-FileHash $zipOut1 -Algorithm SHA256 | Select-Object Hash, Path
