# рџЏ—пёЏ STORM DRIVER Architecture Overview

## 1. Adreno 830 (Snapdragon 8 Elite) Register Calibration
The Adreno 830 GPU architecture introduces a new register file layout. When compiling complex shaders with high register pressure, standard allocations cause scheduler panics. STORM DRIVER calibrates `reg_size_vec4` to **96**, providing optimal occupancy across all shader units without register spills.

## 2. UBWC 5.0 Lossless Framebuffer Alignment
Universal Bandwidth Compression (UBWC) 5.0 requires 128-byte pitch alignment on external Android WSI swapchains. Without this, Samsung OneUI and high-refresh-rate displays produce vertical striping. STORM DRIVER dynamically clamps the image layout pitch to 128-byte boundaries.

## 3. GMEM Binary-Search Tiling Allocator
Rather than relying on static GMEM bin counts, STORM DRIVER uses a binary-search allocator (`tu_calc_tile_bins_bsearch`) to find the exact rectangular bin aspect ratio that fits entirely within the GPU's on-chip GMEM, eliminating expensive Sysmem fallback passes.

## 4. PanVK / Mali Geometry Culling
For ARM Mali devices (MediaTek Dimensity / Samsung Exynos), STORM DRIVER activates Forward Pixel Kill (FPK) and Early Z-Cull, eliminating occluded fragments before pixel shader execution.