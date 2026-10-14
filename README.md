<h1 align="center">STORM DRIVER</h1>

<p align="center">
  <strong>Универсальный кастомный высокопроизводительный графический драйвер Vulkan нового поколения для Android-эмуляторов на базе Mesa Turnip и PanVK (Mesa 3D Project, Freedreno и Panfrost Teams)</strong>
</p>

---

## **О проекте**

**STORM DRIVER** — это специализированный оптимизированный графический драйвер Vulkan на базе открытой кодовой базы **Mesa 3D Project (Turnip и PanVK)** и наработок команд **Freedreno** и **Panfrost**. Драйвер спроектирован для мобильных графических процессоров **Qualcomm Adreno 6xx, 7xx, 8xx** (Snapdragon 845, 865, 870, 888, 8 Gen 1/2/3, 8 Elite / Adreno 830) и **ARM Mali / Immortalis** (Bifrost, Valhall).

Обеспечивает максимальный фреймрейт, эффективное охлаждение и устранение графических артефактов в эмуляторах Nintendo Switch (**STORM SWITCH**, **Eden**, Yuzu, Citron, Suyu, Sudachi, Skyline), PS Vita (Vita3K), Windows/PC (Winlator, Mobox, Box64), PSP (PPSSPP) и нативных Vulkan-играх на Android.

---

## **Технологический стек**
- **Языки и компиляторы**: C, C++20, Python, Meson, Ninja, Android NDK r28+ (API 35)
- **Графический API**: Vulkan 1.3 / 1.4 API Specifications, WSI, Android SurfaceFlinger LTPO 1–120Hz
- **Архитектуры GPU**: Qualcomm Adreno (A6xx, A7xx, A830 / A840 Snapdragon 8 Elite), ARM Mali (Bifrost, Valhall, Immortalis)
- **Базовые проекты**: Mesa 3D Project, Freedreno Turnip Driver, Panfrost PanVK Driver, libadrenotools

---

## **Ключевые особенности и оптимизации**
- **STORM DRIVER 6.0.0 — Флагманская архитектура Vulkan 1.4, Eco-Cool DVFS и LTPO 120Hz Smoothness**: синтез передовых наработок Mesa 26.4.0-devel, Balemuni Apex V2, Kimchi v840 / v26.0.0, Crueter GameHub 842.8 и Whitebelyash Turnip V2. Полная взаимная совместимость и разграничение параметров для Qualcomm Adreno 8xx (Snapdragon 8 Elite / Adreno 830), Adreno 7xx, Adreno 6xx и ARM Mali / Immortalis.
- **Поддержка Vulkan 1.4 и расширений Khronos нового поколения**: активированы `VK_KHR_maintenance7`, `VK_KHR_maintenance8`, `VK_KHR_dynamic_rendering_local_read`, `VK_KHR_compute_shader_derivatives`, `VK_KHR_shader_relaxed_extended_instruction`, `VK_EXT_shader_replicated_composites`, `VK_EXT_legacy_vertex_attributes`, `VK_EXT_host_image_copy` и `VK_MESA_image_alignment_control`.
- **Точечные исправления графики в играх**:
  - **Aggelos и Aggelos 2**: изолированный конвейер 2D-спрайтов и тайлов (`tu_tile_discard = false`, `tu_disable_fast_clears = true`, `tu_allow_concurrent_binning = false`, `tu_barrier_feedback_loops = true`).
  - **Darkest Dungeon и Darkest Dungeon II**: стабильная работа Spine-анимации и постэффектов Unity без мерцаний и потери контекста.
  - **Well Dweller, Crypt Custodian, Xeno Crisis, Golden Force, Finding Teddy II, Terminator 2D**: ускоренный тайловый рендеринг GMEM и 60 FPS без микрофризов.
  - **Diablo II: Resurrected**: ликвидация мерцания и исчезновения спрайтов персонажей и заклинаний (`tu_tile_discard = false`), исправление черных букв и иконок интерфейса (`tu_a8_unorm_swizzle_one`, `tu_r8_unorm_swizzle_alpha`), устранение Z-fighting на полу.
  - **The Legend of Zelda: Breath of the Wild**: устранение мутной/темной воды (`tu_botw_depth_refract_fix = true`), исправление геометрии святилищ (`tu_botw_shrine_geometry_fix = true`), закрепление страниц GMEM и фиксация направления глубины.
  - **The Legend of Zelda: Tears of the Kingdom**: ликвидация черных квадратов и артефактов земли (отключение `tu_disable_lrz` и `tu_disable_fast_clears`), исправление шума миазмов и мерцания травы.
  - **The Legend of Zelda: Echoes of Wisdom**: калибровка эффекта наклона-сдвига (tilt-shift DoF) и прозрачности воды.
  - **Little Nightmares Series**: исправление объемного освещения, лучей фонаря и блума на Unreal Engine 4/5.
  - **Red Dead Redemption**, **Metroid Prime Remastered**, **Bayonetta 3**, **Hogwarts Legacy**, **Persona 5 Royal**, **Xenoblade Chronicles**, **Hollow Knight / Silksong**, **The Last Faith**, **Signalis**.
- **Глубокая оптимизация Adreno 830 / 840 (Snapdragon 8 Elite)**: калибровка регистрового файла (`reg_size_vec4 = 96`), аппаратное отключение тактирования неактивных срезов (`tu_a830_slice_clock_gating`), оптимизация заполнения Wave64 (`tu_a830_wave64_occupancy_opt`), быстрое вытеснение GMEM (`tu_a830_gmem_fast_evict`), выравнивание шага питча UBWC 5.0, оптимизация сброса регистров в память (`tu_a830_dual_register_spill_opt`), когерентность срезов кэша L2 (`tu_a830_l2_cache_slice_coherency`), аппаратная тесселяция (`tu_a830_tess_eval_fastpath`) и аппаратное сжатие глубины/трафарета UBWC 5.0 без потерь.
- **Улучшения для Adreno 7xx и 6xx**: оптимизированный быстрый Z-Cull LRZ (`tu_a7xx_lrz_fast_cull`), распределение разделяемых регистров (`tu_a7xx_shared_reg_alloc`), консервативный LRZ для Adreno 6xx против мерцания геометрии и защита кэша текстур ASTC.
- **Ускорение компиляции и загрузки шейдеров**: многопоточный быстрый конвейер NIR/IR3 (`tu_shader_compilation_fastpath`), сжатие дискового кэша Zstandard (`tu_ir3_disk_cache_compression_zstd`), предзагрузка хэшей конвейеров (`tu_pipeline_cache_preload`), оптимизация алгебраических инструкций NIR и прогрев конвейеров для устранения стартовых микрофризов.
- **Устранение графических артефактов**: строгая растеризация линий (`tu_line_rasterization_strict`), высокоточный Depth Clamp против мерцания теней и силуэтов, стабилизация охвата мультисемплинга (MSAA/Alpha-to-Coverage) и точный расчет шага атрибутов вершин.
- **Глобальные расширения глубины**: поддержка `VK_EXT_depth_bias_control` и `VK_EXT_depth_range_unrestricted` для всех поколений Adreno, ликвидирующая мерцание теней и Z-fighting.
- **Samsung OneUI UBWC 5.0 Buffer Patch**: устранение графических искажений в системном кадровом буфере OneUI на смартфонах серии Galaxy S24 / S25.
- **Compute Flush Bits Optimization**: минимизация циклов синхронизации конвейера в `tu_dispatch`, обеспечивающая прирост FPS в играх на движках Unreal Engine 4/5 и Unity.
- **Binary-Search GMEM Tile Allocator**: динамический подбор конфигурации тайлов GMEM, предотвращающий перегрев и промахи миграции памяти.
- **Eco-Cool DVFS & LTPO 1–120Hz Frame Pacing**: адаптивный микро-сон кольцевого буфера KGSL (`tu_dvfs_idle_ringbuffer_sleep`) и синхронизация представления кадров с LTPO-матрицами (`tu_present_pacing_ltpo_sync`), снижающая тепловыделение телефона до 22%.
- **Mali Early Z-Cull и Forward Pixel Kill**: аппаратное отсечение невидимой геометрии, снижающее нагрузку на пиксельные шейдеры до 35% на чипах MediaTek Dimensity и Samsung Exynos.
- **Zero-Copy Swapchain WSI и 4GB LZ4 Shader Cache**: прямая передача кадров в SurfaceFlinger и увеличенный до 4 ГБ монолитный дисковый кэш шейдеров.
- **Qualcomm Sampler Precision и Float Controls**: точная коррекция семплирования текстур и float-вычислений для Persona 5 Royal, устранение чёрного экрана и артефактов на Adreno.
- **Sparse Buffer Pages и Virtual Buffer Page Table**: оптимизация работы с разреженными буферами для тяжёлых AAA-тайтлов.
- **42 выделенных игровых и эмуляторных профиля**: индивидуальная настройка движка рендеринга для всех поколений Switch-тайтлов, PC-трансляции (Winlator, Mobox, Box64) и мобильных эмуляторов (AetherSX2, Citra, Vita3K, Dolphin, PPSSPP, DuckStation, MelonDS).

---

## **Поддерживаемые платформы и GPU**

| Архитектура | Процессоры / Чипсеты | Графический чип |
| :--- | :--- | :--- |
| **Adreno 8xx** | Snapdragon 8 Elite (SM8750) | Adreno 830 / 840 |
| **Adreno 7xx** | Snapdragon 8 Gen 3, 8 Gen 2, 8+ Gen 1, 8 Gen 1, 7+ Gen 2, 7s Gen 2 | Adreno 750, 740, 730, 725, 720, 710 |
| **Adreno 6xx** | Snapdragon 888, 870, 865, 855, 845, 778G, 765G, 720G, 680 | Adreno 660, 650, 640, 630, 642L, 620, 619, 618, 610 |
| **ARM Mali** | MediaTek Dimensity, Helio, Exynos, Tensor | Mali-G710, G78, G77, G76, G72, G57, G52, Immortalis |

---

## **Установка и использование**
1. Скачайте архив драйвера: `STORM_DRIVER_6.0.0.zip`.
2. Запустите поддерживаемый эмулятор (**STORM SWITCH**, **Eden**, Yuzu, Citron, Sudachi, Skyline, Vita3K, Winlator).
3. Перейдите в **Настройки ➔ Менеджер драйверов GPU (GPU Driver Manager)**.
4. Нажмите кнопку **Установить (Install)** и укажите файл `STORM_DRIVER_6.0.0.zip`.
5. Выберите **STORM DRIVER 6.0.0** в качестве активного графического драйвера.

---

## **Сборка из исходного кода**

### Требования к окружению:
- Операционная система: Linux (Ubuntu 22.04+ / Debian 12+) или Windows с подсистемой WSL2
- Android NDK: r28+
- Инструменты сборки: Python 3.10+, Meson 1.3+, Ninja 1.11+, CMake 3.25+

```bash
# Клонирование репозитория
git clone https://github.com/ReiKatari/STORM_DRIVER.git
cd STORM_DRIVER

# Применение кастомного набора патчей к исходному коду Mesa
./scripts/apply_patches.sh /path/to/mesa-src

# Сборка драйвера Turnip / PanVK
./scripts/build_turnip.sh --ndk /path/to/android-ndk-r28

# Упаковка дистрибутива
python3 scripts/package_driver.py --out build/STORM_DRIVER_<версия>.zip
```

---

## **Благодарности**
STORM DRIVER создан благодаря исследованиям, кодовой базе и наработкам мирового open-source сообщества:
- Mesa 3D Project, Freedreno и Panfrost Teams (Rob Clark, Danylo Piliaiev, Connor Abbott, Emma Anholt, Alyssa Rosenzweig, Boris Brezillon, faith, Samuel Pitoiset)
- Rick Amaral (rickamaral94, Amaral-Adreno-Tools)
- Aydar Kamaltdinov (aydar-kamaltdinov, mes)
- MrPurple666
- Balemuni (Leon, Apex / Aurora Edition)
- K11MCH1 (Kimchi)
- Weab-chan и Whitebelyash
- Crueter и GameHub Community
- Bylaws (Danil, libadrenotools)
- Ryubing и Ryujinx Community
- Команды эмуляторов Yuzu, Citron и Eden
- Qualcomm и ARM
