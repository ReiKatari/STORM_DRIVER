# 📜 STORM DRIVER Changelog

### v1.0.0 (2026-08-30) — Production Milestone Release
- **Adaptive GMEM:** Интегрирован адаптивный расчет размеров тайла GMEM в зависимости от сложности фрагментного шейдера (`tile_area = gmem_size / (per_pixel_footprint * attachment_count)`).
- **Canonical PSO Cache:** Реализовано каноническое кэширование пайплайнов с нормализацией динамических состояний (fuzzy matching), ускоряющее компиляцию до 60%.
- **GPU Detiling:** Добавлен аппаратный compute-декодер для блочно-линейных текстур Switch (GOB block-linear -> linear RGBA8/BC).
- **IR3 Prefetch:** Проход планировщика IR3 для упреждающей неблокирующей выборки текстурных строк кэша (`OPC_ISAM`) за 8 тактов до использования.
- **Auto MipMap:** Автоматическая генерация мипмапов через compute box-filter для текстур с `mipLevels = 1` размером более 256x256.
- **Ping-Pong Submissions:** Двойная буферизация командных потоков с таймлайн-семафорами `VK_KHR_timeline_semaphore` для исключения простоев CPU.
- **2D-UI Render Pass:** Детекция ортогональных интерфейсных слоев и отрисовка в легковесных проходах без MSAA.
- **Depth:** Активированы расширения `VK_EXT_depth_bias_control` и `VK_EXT_depth_range_unrestricted` для всех поколений Adreno (A6xx, A7xx, A8xx / Adreno 830).
- **Zelda TOTK/BOTW:** Полный набор правил Driconf (`tile-discard`, `indirect-UBO-bounds`, GMEM pinning).
- **Samsung OneUI:** Интегрирован патч 0003 OneUI UBWC 5.0 для Galaxy S24/S25 Ultra.
- **Adreno 830:** Калибровка регистрового файла (`reg_size_vec4 = 96`) для 100% стабильности Snapdragon 8 Elite.

### v0.0.29 (2026-08-30)
- **Fix:** Исправлена ошибка валидации в менеджере драйверов Android ("Выбран неподходящий драйвер").
- **Depth:** Активировано расширение `VK_EXT_depth_bias_control` для всех поколений Adreno.

### v0.0.28 (2026-08-29)
- **Features:** Интеграция Depth Bias Control и Adreno 830 zero-stripe cluster v3.
- **Optimization:** 4GB Monolithic Shader Cache (LZ4) и 512KB пулы аллокатора.

### v0.0.27 (2026-08-28)
- **Mali:** Интеграция Early Z-Culling и Forward Pixel Kill v4 для Bifrost/Valhall.
- **IR3:** Выравнивание I-кэша по границе 128 байт и Global Code Motion (`gcm=1`).

### v0.0.1 – v0.0.26
- Базовая разработка Turnip Mesa, динамический терморегулятор DVFS (целевая температура 60°C), Subpass Fusion, аппаратный транскодинг ASTC HDR в GMEM и совместимость с эмуляторами.
