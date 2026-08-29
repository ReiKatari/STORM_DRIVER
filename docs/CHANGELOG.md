# 📜 STORM DRIVER Changelog

### v0.0.29 (2026-08-30)
- **Fix:** Исправлена ошибка валидации в менеджере драйверов Android ("Выбран неподходящий драйвер").
- **Depth:** Активировано расширение `VK_EXT_depth_bias_control` для всех поколений Adreno (A6xx, A7xx, A8xx / Adreno 830).
- **Depth:** Активировано расширение `VK_EXT_depth_range_unrestricted` для бесконечных плоскостей обзора и зеркал.
- **Zelda:** Полный набор правил Driconf для Zelda: TOTK и BOTW (`tile-discard`, `indirect-UBO-bounds`, GMEM pinning).
- **Samsung:** Интегрирован патч 0003 OneUI UBWC 5.0 для Galaxy S24/S25 Ultra.
- **Adreno 830:** Калибровка регистрового файла (`reg_size_vec4 = 96`) для 100% стабильности Snapdragon 8 Elite.
- **Compute:** Оптимизация `compute_flush_bits` в `tu_dispatch` для Unreal Engine 4/5 и 2D-физики.

### v0.0.28 (2026-08-29)
- **Features:** Интеграция Depth Bias Control и Adreno 830 zero-stripe cluster v3.
- **Optimization:** 4GB Monolithic Shader Cache (LZ4) и 512KB пулы аллокатора.

### v0.0.27 (2026-08-28)
- **Mali:** Интеграция Early Z-Culling и Forward Pixel Kill v4 для Bifrost/Valhall.
- **IR3:** Выравнивание I-кэша по границе 128 байт и Global Code Motion (`gcm=1`).

### v0.0.1 – v0.0.26
- Базовая разработка Turnip Mesa, динамический терморегулятор DVFS (целевая температура 60°C), Subpass Fusion, аппаратный транскодинг ASTC HDR в GMEM и совместимость с эмуляторами.
