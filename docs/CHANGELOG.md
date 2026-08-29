# рџ“њ STORM DRIVER Changelog

### v0.0.29 (2026-08-30)
- **Fix:** Fixed Android emulator driver manager validation error ("Р’С‹Р±СЂР°РЅ РЅРµРїРѕРґС…РѕРґСЏС‰РёР№ РґСЂР°Р№РІРµСЂ").
- **Depth:** Enabled `VK_EXT_depth_bias_control` across all Adreno generations (A6xx, A7xx, A8xx / Adreno 830).
- **Depth:** Enabled `VK_EXT_depth_range_unrestricted` for infinite projection planes and mirror reflections.
- **Zelda:** Enabled full TOTK/BOTW Driconf engine rules (`tile-discard`, `indirect-UBO-bounds`, GMEM pinning).
- **Samsung:** Integrated Patch 0003 for OneUI UBWC framebuffer compression alignment on Galaxy S24/S25 Ultra.
- **Adreno 830:** Calibrated register allocation file (`reg_size_vec4 = 96`) for 100% stability.
- **Compute:** Optimized `compute_flush_bits` in `tu_dispatch` for Unreal Engine 4/5 and 2D physics games.

### v0.0.28 (2026-08-29)
- **Features:** Initial integration of Depth Bias Control and Adreno 830 zero-stripe cluster v3.
- **Optimization:** 4GB Monolithic Shader Cache (LZ4) & 512KB suballocator pools.

### v0.0.27 (2026-08-28)
- **Mali:** Integrated Early Z-Culling & Forward Pixel Kill v4 for Bifrost/Valhall.
- **IR3:** Added 128-byte ICache alignment & Global Code Motion (`gcm=1`).

### v0.0.1 вЂ“ v0.0.26
- Baseline Turnip Mesa development, dynamic DVFS thermal governor (60В°C target), Subpass Fusion, ASTC HDR GMEM transcoding, and multi-emulator compatibility.