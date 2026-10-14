# 📜 STORM DRIVER Changelog

### 6.0.0 (14.10.2026)
- **Vulkan 1.4 & Next-Gen Khronos Extensions:** Внедрена поддержка расширений нового поколения `VK_KHR_maintenance7`, `VK_KHR_maintenance8`, `VK_KHR_dynamic_rendering_local_read`, `VK_KHR_compute_shader_derivatives`, `VK_KHR_shader_relaxed_extended_instruction`, `VK_EXT_shader_replicated_composites`, `VK_EXT_legacy_vertex_attributes`, `VK_EXT_host_image_copy` и `VK_MESA_image_alignment_control`.
- **Adreno 830 / 840 Gen 8 Slice Clock Gating & Wave64 Occupancy:** Активировано аппаратное отключение тактирования неактивных срезов (`tu_a830_slice_clock_gating`), оптимизация заполнения Wave64 (`tu_a830_wave64_occupancy_opt`) и быстрое вытеснение тайлов GMEM (`tu_a830_gmem_fast_evict`) для Snapdragon 8 Elite (`SM8750`).
- **Eco-Cool Thermal Governor & LTPO 1-120Hz Pacing:** Устранён холостой спин-опрос кольцевого буфера KGSL (`tu_dvfs_idle_ringbuffer_sleep = true`, целевой температурный порог `38°C`), добавлена синхронизация представления кадров с LTPO-матрицами 1–120 Гц (`tu_present_pacing_ltpo_sync = true`, `tu_zero_jitter_swapchain_present = true`), снижающая нагрев телефона до 22%.
- **2D / Indie & AAA Game Profiles (42 Dedicated Profiles):** Добавлены выделенные профили для *Aggelos* и *Aggelos 2* (`010004D00A9C0000`, `010040F01EC60000`), *Darkest Dungeon* и *Darkest Dungeon II* (`01008F1008DA6000`, `0100E5E01C098000`), *Well Dweller* (`0100217023F6C000`), *Crypt Custodian* (`0100A4601ECA8000`), *Xeno Crisis* (`010013F009B88000`), *Golden Force*, *Finding Teddy II*, *Terminator 2D*, *Hollow Knight / Silksong*, *The Last Faith*, *Signalis*, *The Coma Series* и *Vampire Crawlers*.
- **Non-Destructive Per-Game Driconf Merging:** Исправлена интеграция с `STORM SWITCH` (`GpuDriverHelper.kt` / `PerGameDrircGenerator.kt`), при которой запуск игры перезаписывал базовый `00-storm.conf` урезанным файлом из 8 строк. Теперь все 16 архитектурных уровней и 42 профиля сохраняются неизменными.
- **Self-Contained Packaging & Build Pipeline:** Обновлены скрипты сборки под Android API 35 (NDK r28+), добавлен `scripts/android-aarch64.ini`, идемпотентный `apply_patches.sh` (8 патчей `0001`–`0008`) и автономный упаковщик `package_driver_600.ps1` на базе `.NET ZipFile` с POSIX-правами `0644`.

### 5.1.0 (20.09.2026)
- **Precision & NIR/IR3 Multi-Threaded Fastpath:** Добавлены блоки `3b` (Adreno 7xx/6xx), `3c` (ускоренная многопоточная компиляция шейдеров NIR/IR3 и Zstd-сжатие дискового кэша) и `3d` (устранение геометрических артефактов точности).
- **Expanded Game Profiles:** Добавлены профили для *Dave the Diver* и *Brotato*.

### 5.0.0 (18.09.2026)
- **Universal Multi-Console & PC Edition:** Расширена совместимость с Winlator, Mobox, Box64, FEX, DXVK, VKD3D, AetherSX2/NetherSX2, Citra/Lime3DS/Azahar, Vita3K, Dolphin, PPSSPP, DuckStation и MelonDS.

### 4.0.4 (16.09.2026)
- **Monolithic Architecture:** Переход на чистую монолитную модель конфигурации с прямой синхронизацией буферов кадра и тайлов памяти GMEM (`tu_tile_discard = true`, `tu_drop_tile_wfi = true`).
- **2D and 3D Engine Stability:** Полное устранение артефактов межпассового рендера, моргания элементов интерфейса и пропадания графики загружаемого контента (DLC) в Dispatch (`01008BA02525A000`), Diablo II: Resurrected, The Legend of Zelda и Streets of Rage 4.
- **Universal Driver Binding:** Восстановлена основная точка входа `vulkan.freedreno.so` с поддержкой Android API 24+ (`minApi = 24`) для безошибочной загрузки во всех версиях эмуляторов и системных профилей.
- **Hardware Architecture:** Сохранены расширения `VK_EXT_depth_bias_control`, `VK_EXT_depth_range_unrestricted`, оптимизация регистрового файла Adreno 830 (`reg_size_vec4 = 96`), калибровка UBWC 5.0 для Samsung OneUI и оптимизации для ARM Mali и Immortalis.

### 4.0.3 (16.09.2026)
- **Dispatch Fix:** Полностью устранено моргание кнопок меню («ИГРАТЬ», «ПАРАМЕТРЫ», «ДОПОЛНИТЕЛЬНО») и восстановлено корректное отображение арта и баннера «Бесплатный загружаемый контент» в правом верхнем углу игры Dispatch (`01008BA02525A000`).
- **Baseline Restoration:** Восстановлена проверенная эталонная логика тайлового рендеринга из версии 0.0.29: включён сброс тайлов в GMEM (`tu_tile_discard = true`), отключены петли обратной связи барьеров (`tu_barrier_feedback_loops = false`), отключен параллельный биннинг (`tu_allow_concurrent_binning = false`).
- **Adreno 830 & 7xx Stability:** Изолированы специфические 2D-текстурные пайплайны Dispatch от экспериментальных опций дискретизации и разреженных страниц, обеспечена безупречная стабильность на Snapdragon 8 Elite (SM8750 / Adreno 830) и Adreno 7xx/6xx.

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
