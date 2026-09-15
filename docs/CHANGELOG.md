# 📜 STORM DRIVER Changelog

### 4.0.2 (15.09.2026)
- **Shader Pipeline:** Прокачан многопоточный конвейер компиляции шейдеров (`tu_shader_compilation_fastpath`), предварительная загрузка конвейеров (`tu_pipeline_cache_preload`) и ускоренная обработка SPIR-V (`tu_shader_spirv_mem_fastpath`).
- **Disk Cache:** Внедрено сжатие дискового кэша алгоритмом Zstandard (`tu_ir3_disk_cache_compression_zstd`) для мгновенной загрузки шейдеров и устранения стартовых микрофризов в тяжелых тайтлах.
- **Adreno 830 (Snapdragon 8 Elite):** Оптимизировано распределение регистров (`reg_size_vec4 = 96`), защита от утечек регистров (`tu_a830_dual_register_spill_opt`), когерентность срезов L2-кэша и векторный буст кластеров АЛУ (`tu_a830_vector_alu_cluster_boost`).
- **Adreno 750 / 740:** Включена аппаратная тесселяция (`tu_a830_tess_eval_fastpath`), агрессивная отсечка LRZ (`tu_a7xx_lrz_fast_cull`) и управление общими регистрами (`tu_a7xx_shared_reg_alloc`).
- **Vulkan Extensions:** Полная поддержка расширений `VK_EXT_depth_bias_control` и `VK_EXT_depth_range_unrestricted` для всех чипов Adreno.
- **Samsung OneUI:** Калибровка сжатия буфера кадра UBWC 5.0 (`tu_ubwc_oneui_fix`, `tu_ubwc_5_direct_align`, `tu_ubwc_5_stride_128_align`) с защитой от сбоев на устройствах линейки Samsung Galaxy.
- **GMEM Allocator:** Бинарный калибратор тайлового рендеринга (`tu_optimal_gmem_tile_allocator`), предотвращающий троттлинг и перегрев при длительных игровых сессиях.
- **Game Profiles:** Тонкая настройка стабильности и производительности для Zelda BotW/TotK, Streets of Rage 4, Mortal Kombat 1, Persona 5 Royal, Dave the Diver, Crypt of the NecroDancer и Unreal Engine 5.

### 4.0.1 (04.09.2026)
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
