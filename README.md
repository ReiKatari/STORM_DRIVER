<h1 align="center">STORM DRIVER</h1>

<p align="center">
  <strong>Универсальный кастомный высокопроизводительный графический драйвер Vulkan нового поколения для Android-эмуляторов на базе Mesa Turnip и PanVK (Mesa 3D Project, Freedreno и Panfrost Teams)</strong>
</p>

---

## **О проекте**

**STORM DRIVER** — это специализированный оптимизированный графический драйвер Vulkan на базе открытой кодовой базы **Mesa 3D Project (Turnip & PanVK)** и наработок команд **Freedreno** и **Panfrost**. Драйвер спроектирован для мобильных графических процессоров **Qualcomm Adreno 6xx, 7xx, 8xx** (Snapdragon 845, 865, 870, 888, 8 Gen 1/2/3, 8 Elite / Adreno 830) и **ARM Mali / Immortalis** (Bifrost, Valhall).

Обеспечивает максимальный фреймрейт, эффективное охлаждение и устранение графических артефактов в эмуляторах Nintendo Switch (**STORM EDEN**, **Eden**, Yuzu, Citron, Suyu, Sudachi, Skyline), PS Vita (Vita3K), Windows/PC (Winlator, Mobox, Box64), PSP (PPSSPP) и нативных Vulkan-играх на Android.

---

## **Технологический стек**
- **Языки и компиляторы**: C, C++20, Python, Meson, Ninja, Android NDK r28+
- **Графический API**: Vulkan 1.3 / 1.4 API Specifications, WSI, Android SurfaceFlinger
- **Архитектуры GPU**: Qualcomm Adreno (A6xx, A7xx, A830 / Snapdragon 8 Elite), ARM Mali (Bifrost, Valhall, Immortalis)
- **Базовые проекты**: Mesa 3D Project, Freedreno Turnip Driver, Panfrost PanVK Driver, libadrenotools

---

## **Ключевые особенности и оптимизации**
- **Полная поддержка Adreno 830 (Snapdragon 8 Elite)**: калибровка регистрового файла (`reg_size_vec4 = 96`) и выравнивание шага питча UBWC 5.0 устраняют полосы, мерцания и краши IR3.
- **Глобальные расширения глубины**: поддержка `VK_EXT_depth_bias_control` и `VK_EXT_depth_range_unrestricted` для всех поколений Adreno, ликвидирующая мерцание теней и Z-fighting.
- **Комплекс оптимизаций для Zelda BOTW / TOTK**: устранение непрозрачной/темной воды, исправление глубины святилищ (Shrines) и оптимизация `tu_depth_direction_fix`.
- **Samsung OneUI UBWC 5.0 Buffer Patch**: устранение графических искажений в системном кадровом буфере OneUI на смартфонах серии Galaxy S24 / S25.
- **Compute Flush Bits Optimization**: минимизация циклов синхронизации конвейера в `tu_dispatch`, обеспечивающая прирост FPS в играх на движках Unreal Engine 4/5 и Unity.
- **Binary-Search GMEM Tile Allocator**: динамический подбор конфигурации тайлов GMEM, предотвращающий перегрев и промахи миграции памяти.
- **Динамический DVFS Power-Throttling Guard (60°C Target)**: плавное управление частотами GPU для предотвращения резкого троттлинга и просадок кадров.
- **Subpass Fusion и Render Pass Compaction**: автоматическое объединение проходов рендеринга для снижения энергопотребления.
- **Mali Early Z-Cull & Forward Pixel Kill**: аппаратное отсечение невидимой геометрии, снижающее нагрузку на пиксельные шейдеры до 35% на чипах MediaTek Dimensity и Samsung Exynos.
- **Zero-Copy Swapchain WSI и 4GB LZ4 Shader Cache**: прямая передача кадров в SurfaceFlinger и увеличенный до 4 ГБ монолитный дисковый кэш шейдеров.

---

## **Поддерживаемые платформы и GPU**

| Архитектура | Процессоры / Чипсеты | Графический чип |
| :--- | :--- | :--- |
| **Adreno 8xx** | Snapdragon 8 Elite (SM8750) | Adreno 830 |
| **Adreno 7xx** | Snapdragon 8 Gen 3, 8 Gen 2, 8+ Gen 1, 8 Gen 1, 7+ Gen 2, 7s Gen 2 | Adreno 750, 740, 730, 725, 720, 710 |
| **Adreno 6xx** | Snapdragon 888, 870, 865, 855, 845, 778G, 765G, 720G, 680 | Adreno 660, 650, 640, 630, 642L, 620, 619, 618, 610 |
| **ARM Mali** | MediaTek Dimensity, Helio, Exynos, Tensor | Mali-G710, G78, G77, G76, G72, G57, G52, Immortalis |

---

## **Установка и использование**
1. Скачайте архив драйвера: `STORM_DRIVER_<версия>.zip`.
2. Запустите поддерживаемый эмулятор (**STORM EDEN**, **Eden**, Yuzu, Citron, Sudachi, Skyline, Vita3K, Winlator).
3. Перейдите в **Настройки ➔ Менеджер драйверов GPU (GPU Driver Manager)**.
4. Нажмите кнопку **Установить (Install)** и укажите файл `STORM_DRIVER_<версия>.zip`.
5. Выберите **STORM DRIVER** в качестве активного графического драйвера.

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
