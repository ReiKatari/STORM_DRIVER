# 📜 STORM DRIVER Changelog

### 2.0.0 (03.09.2026)
- **Architecture:** Полное слияние проверенной стабильной базы 0.0.29 и профилей 1.2.5.
- **Compatibility:** Устранены графические артефакты в Diablo II: Resurrected за счёт изоляции региональных Title ID (USA, EUR, JPN) в отдельные профили и восстановления `tu_force_d32_unnormalized`, `tu_indirect_ubo_bounds`, `tu_depth_clamp_control_fix`.
- **Compatibility:** Устранены графические артефакты и мерцания в Streets of Rage 4 за счёт разделения Title ID, отключения `tu_compute_detiling_gob_linear`, `tu_auto_mipmap_generation` и `tu_canonical_pso_cache`.
- **Zelda:** Полная сохранность прозрачной воды, правильного преломления и геометрии святилищ в The Legend of Zelda: Breath of the Wild и Tears of the Kingdom (`tu_tile_discard = false`, `tu_disable_fast_clears = true`, `tu_disable_lrz = true`, `tu_botw_depth_refract_fix = true`).
- **Global Base:** Безопасная глобальная основа (`tu_fast_clears = false`, `tu_tile_discard = false`, `tu_canonical_pso_cache = false` по умолчанию), предотвращающая регрессии в 2D и 3D играх.
- **Performance и Latency:** Восстановлена плавная адаптивная синхронизация кадров и Mailbox VSync (`tu_adaptive_frame_pacing = true`, `tu_frame_time_smoothing = true`, `tu_mail_box_vsync_pacing = true`, `tu_direct_surfaceflinger_blit = true`).
- **Thermal Management:** Включен полный комплекс энергосбережения и терморегулирования DVFS (`tu_thermal_governor_floor = true`, `tu_power_profile_balanced = true`, `tu_dynamic_thermal_budget = true`).
- **Packaging:** Добавлены все варианты бинарных библиотек (`vulkan.adreno.so`, `vulkan.freedreno.so`, `vulkan.purple.so`, `libvulkan_freedreno.so`) для 100% совместимости с любыми загрузчиками драйверов.

### 0.0.29 (30.08.2026)
- **Fix:** Исправлена ошибка валидации в менеджере драйверов Android ("Выбран неподходящий драйвер").
- **Depth:** Активировано расширение `VK_EXT_depth_bias_control` для всех поколений Adreno (A6xx, A7xx, A8xx / Adreno 830).
- **Depth:** Активировано расширение `VK_EXT_depth_range_unrestricted` для бесконечных плоскостей обзора и зеркал.
- **Zelda:** Полный набор правил Driconf для Zelda: TOTK и BOTW (`tile-discard`, `indirect-UBO-bounds`, GMEM pinning).
- **Samsung:** Интегрирован патч 0003 OneUI UBWC 5.0 для Galaxy S24/S25 Ultra.
- **Adreno 830:** Калибровка регистрового файла (`reg_size_vec4 = 96`) для 100% стабильности Snapdragon 8 Elite.
- **Compute:** Оптимизация `compute_flush_bits` в `tu_dispatch` для Unreal Engine 4/5 и 2D-физики.

### 0.0.28 (29.08.2026)
- **Features:** Интеграция Depth Bias Control и Adreno 830 zero-stripe cluster v3.
- **Optimization:** 4GB Monolithic Shader Cache (LZ4) и 512KB пулы аллокатора.

### 0.0.27 (28.08.2026)
- **Mali:** Интеграция Early Z-Culling и Forward Pixel Kill v4 для Bifrost/Valhall.
- **IR3:** Выравнивание I-кэша по границе 128 байт и Global Code Motion (`gcm=1`).

### 0.0.1 – 0.0.26
- Базовая разработка Turnip Mesa, динамический терморегулятор DVFS (целевая температура 60°C), Subpass Fusion, аппаратный транскодинг ASTC HDR в GMEM и совместимость с эмуляторами.
