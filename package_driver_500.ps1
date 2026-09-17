# Packaging script for STORM DRIVER 5.0.0 Universal Multi-Platform Edition
$ErrorActionPreference = 'Stop'

$srcConf = 'E:\STORM SWITCH 4\STORM DRIVER\Build\config_403_extract\00-storm.conf'
$targetConf = 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\00-storm.conf'

if (Test-Path $srcConf) {
    $confContent = [System.IO.File]::ReadAllText($srcConf, [System.Text.Encoding]::UTF8)

$universalAll = @"
            <!-- 15. Universal PC Windows (Winlator / Mobox / Box64 / DXVK / VKD3D) Compatibility -->
            <option name="vk_x11_override_min_image_count" value="2" />
            <option name="vk_wsi_force_bgra8_unorm_first" value="true" />
            <option name="vk_dont_care_as_load" value="true" />
            <option name="tu_clear_with_gmem" value="true" />
        </application>
"@

$targetMarker1 = "        </application>`r`n        <!-- ==================== DEDICATED PROFILES ==================== -->"
if ($confContent.Contains($targetMarker1)) {
    $confContent = $confContent.Replace($targetMarker1, "$universalAll`r`n`r`n        <!-- ==================== DEDICATED PROFILES ==================== -->")
} else {
    $targetMarker1Alt = "        </application>`n        <!-- ==================== DEDICATED PROFILES ==================== -->"
    $confContent = $confContent.Replace($targetMarker1Alt, "$universalAll`n`n        <!-- ==================== DEDICATED PROFILES ==================== -->")
}

$dedicatedNew = @"
        <!-- 27. Winlator, Mobox, Box64 and Wine PC Translation Layers -->
        <application name="Winlator and Wine PC Translation" application_name_match=".*(wine|winlator|box64|box86|mobox|fex|hangover|dxvk|vkd3d|d8vk|zink|wined3d).*">
            <option name="tu_adaptive_frame_pacing" value="true" />
            <option name="tu_timeline_sync" value="true" />
            <option name="tu_indirect_ubo_bounds" value="true" />
            <option name="tu_compute_flush_bits_optimize" value="true" />
            <option name="tu_bindless_textures" value="true" />
            <option name="tu_clear_with_gmem" value="true" />
            <option name="tu_subpass_fusion" value="false" />
            <option name="tu_subpass_fusion_v2" value="false" />
            <option name="tu_barrier_feedback_loops" value="true" />
            <option name="tu_huge_heap_8gb_align" value="true" />
            <option name="vk_dont_care_as_load" value="true" />
            <option name="vk_x11_override_min_image_count" value="2" />
            <option name="vk_wsi_force_bgra8_unorm_first" value="true" />
        </application>

        <!-- 28. AetherSX2 and NetherSX2 (Sony PlayStation 2) -->
        <application name="AetherSX2 and NetherSX2 (PS2)" application_name_match=".*(aethersx2|nethersx2|pcsx2).*">
            <option name="tu_tile_discard" value="false" />
            <option name="tu_indirect_ubo_bounds" value="true" />
            <option name="tu_subpass_fusion" value="false" />
            <option name="tu_subpass_fusion_v2" value="false" />
            <option name="tu_barrier_feedback_loops" value="true" />
            <option name="tu_depth_clamp_control_fix" value="true" />
        </application>

        <!-- 29. Citra, Lime3DS, Mandarine and Azahar (Nintendo 3DS) -->
        <application name="Citra, Lime3DS and Mandarine (3DS)" application_name_match=".*(citra|lime3ds|mandarine|azahar).*">
            <option name="tu_tile_discard" value="false" />
            <option name="tu_indirect_ubo_bounds" value="true" />
            <option name="tu_subpass_fusion" value="false" />
            <option name="tu_subpass_fusion_v2" value="false" />
            <option name="tu_depth_direction_fix" value="true" />
        </application>

        <!-- 30. Vita3K (Sony PlayStation Vita) -->
        <application name="Vita3K (PS Vita)" application_name_match=".*(vita3k).*">
            <option name="tu_tile_discard" value="false" />
            <option name="tu_indirect_ubo_bounds" value="true" />
            <option name="tu_subpass_fusion" value="false" />
            <option name="tu_subpass_fusion_v2" value="false" />
            <option name="tu_force_d32_unnormalized" value="true" />
            <option name="tu_depth_bounds" value="true" />
            <option name="tu_depth_bounds_test" value="true" />
        </application>

        <!-- 31. Dolphin (Nintendo GameCube and Wii) -->
        <application name="Dolphin (GameCube and Wii)" application_name_match=".*(dolphin).*">
            <option name="tu_tile_discard" value="false" />
            <option name="tu_indirect_ubo_bounds" value="true" />
            <option name="tu_depth_direction_fix" value="true" />
            <option name="tu_subpass_fusion" value="false" />
            <option name="tu_subpass_fusion_v2" value="false" />
        </application>

        <!-- 32. PPSSPP (Sony PlayStation Portable) -->
        <application name="PPSSPP (PSP)" application_name_match=".*(ppsspp).*">
            <option name="tu_tile_discard" value="true" />
            <option name="tu_optimal_gmem_tile_allocator" value="true" />
            <option name="tu_drop_tile_wfi" value="true" />
        </application>

        <!-- 33. DuckStation and SwanStation (Sony PlayStation 1) -->
        <application name="DuckStation and SwanStation (PS1)" application_name_match=".*(duckstation|swanstation).*">
            <option name="tu_tile_discard" value="true" />
            <option name="tu_drop_tile_wfi" value="true" />
            <option name="tu_optimal_gmem_tile_allocator" value="true" />
        </application>

        <!-- 34. MelonDS and DraStic (Nintendo DS) -->
        <application name="MelonDS and DraStic (NDS)" application_name_match=".*(melonds|drastic).*">
            <option name="tu_tile_discard" value="true" />
            <option name="tu_drop_tile_wfi" value="true" />
            <option name="tu_optimal_gmem_tile_allocator" value="true" />
        </application>
    </device>
"@

$targetMarker2 = "    </device>`r`n    <device driver=`"freedreno`">"
if ($confContent.Contains($targetMarker2)) {
    $confContent = $confContent.Replace($targetMarker2, "$dedicatedNew`r`n    <device driver=`"freedreno`">")
} else {
    $targetMarker2Alt = "    </device>`n    <device driver=`"freedreno`">"
    $confContent = $confContent.Replace($targetMarker2Alt, "$dedicatedNew`n    <device driver=`"freedreno`">")
}

[System.IO.File]::WriteAllText($targetConf, $confContent, [System.Text.Encoding]::UTF8)

# Duplicate to drirc, drirc.conf, drirc.xml
Copy-Item $targetConf 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\drirc' -Force
Copy-Item $targetConf 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\drirc.conf' -Force
Copy-Item $targetConf 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\drirc.xml' -Force
}

# Stage files
$tempDir = 'E:\STORM SWITCH 4\STORM DRIVER\Build\stage_driver_500'
if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

$baseZip = 'E:\STORM SWITCH 4\Files\STORM_DRIVER_4.0.3.zip'
if (-not (Test-Path $baseZip)) {
    $baseZip = 'E:\STORM SWITCH 4\Files\STORM_DRIVER_4.0.2.zip'
}

& 'C:\Program Files\7-Zip\7z.exe' x $baseZip "-o$tempDir" -y | Out-Null
Copy-Item 'E:\STORM SWITCH 4\STORM DRIVER\Build\config\*' $tempDir\ -Force

# Check stage
$stageFiles = Get-ChildItem $tempDir
Write-Host "Staged $($stageFiles.Count) files:"
$stageFiles | Select-Object Name, Length | Format-Table -AutoSize

if ($stageFiles.Count -ne 9) {
    throw "Expected exactly 9 files in staging directory, but found $($stageFiles.Count)!"
}

# Destinations
$destFiles = @(
    "E:\STORM SWITCH 4\Files\STORM_DRIVER_5.0.0.zip",
    "E:\STORM SWITCH 4\STORM DRIVER\Files\STORM_DRIVER_5.0.0.zip"
)
if (Test-Path 'E:\STORM DRIVER') {
    $destFiles += "E:\STORM DRIVER\STORM_DRIVER_5.0.0.zip"
}

foreach ($dest in $destFiles) {
    $parent = Split-Path $dest -Parent
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    if (Test-Path $dest) { Remove-Item $dest -Force }
}

$primaryZip = $destFiles[0]
& 'C:\Program Files\7-Zip\7z.exe' a -tzip $primaryZip "$tempDir\*" -mx=9 | Out-Null

for ($i = 1; $i -lt $destFiles.Count; $i++) {
    Copy-Item $primaryZip $destFiles[$i] -Force
}

foreach ($dest in $destFiles) {
    if (Test-Path $dest) { Unblock-File $dest }
}

Remove-Item $tempDir -Recurse -Force

Write-Host "=== Created STORM_DRIVER_5.0.0.zip successfully ==="
Get-Item $destFiles | Select-Object FullName, Length, LastWriteTime | Format-Table -AutoSize
Get-FileHash $primaryZip -Algorithm SHA256 | Format-List
