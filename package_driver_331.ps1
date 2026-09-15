$tempDir = 'E:\STORM SWITCH 4\STORM DRIVER\Build\stage_driver_332'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
& 'C:\Program Files\7-Zip\7z.exe' x 'E:\STORM SWITCH 4\Files\STORM_DRIVER_3.3.1.zip' "-o$tempDir" -y
Copy-Item 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\*' $tempDir\ -Force
$zipOut = 'E:\STORM SWITCH 4\Files\STORM_DRIVER_3.3.2.zip'
if (Test-Path $zipOut) { Remove-Item $zipOut -Force }
& 'C:\Program Files\7-Zip\7z.exe' a -tzip $zipOut "$tempDir\*" -mx=9
Unblock-File $zipOut
Remove-Item $tempDir -Recurse -Force
Get-Item $zipOut | Select-Object Name, Length, LastWriteTime

