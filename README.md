<div align="center">

# ⚡ STORM DRIVER v1.0.0 — Universal Next-Gen Turnip & PanVK Mesa GPU Driver

[![License](https://img.shields.io/badge/License-MIT%20%2F%20GPL-blue.svg)](LICENSE)
[![Vulkan](https://img.shields.io/badge/Vulkan-1.3%20%2F%201.4-red.svg)](https://www.vulkan.org/)
[![Adreno](https://img.shields.io/badge/Adreno-6xx%20%7C%207xx%20%7C%208xx-green.svg)](https://developer.qualcomm.com/)
[![Mali](https://img.shields.io/badge/Mali-Bifrost%20%7C%20Valhall-purple.svg)](https://developer.arm.com/)
[![Android](https://img.shields.io/badge/Android-9%20--%2015+-orange.svg)](https://developer.android.com/)

**Created and maintained by ReiKatari & STORM Team**

</div>

---

**STORM DRIVER v1.0.0** — это релизная веха (Production Milestone): универсальный высокопроизводительный гибридный драйвер Vulkan (Mesa Turnip & PanVK) нового поколения для мобильных графических процессоров **Qualcomm Adreno 6xx, 7xx, 8xx** (Snapdragon 845, 865, 870, 888, 8+ Gen 1, 8 Gen 2, 8 Gen 3 и 8 Elite / Adreno 830), а также **ARM Mali** (Bifrost, Valhall).

Разработан для максимальной производительности, стабильности и охлаждения в эмуляторах Nintendo Switch (**STORM EDEN**, **Eden**, Yuzu, Citron, Suyu, Sudachi, Skyline), PS Vita (Vita3K), Windows/PC (Winlator, Mobox, Box64), PSP (PPSSPP) и нативных Vulkan-играх на Android.

---

## 🌟 Ключевые архитектурные преимущества и оптимизации v1.0.0

### 1. 🧠 Адаптивный размер GMEM-тайла по сложности шейдера
- Динамический расчет размеров тайла по формуле `tile_area = gmem_size / (per_pixel_footprint * attachment_count * complexity_weight)`. Исключает медленные сбросы в оперативную память.

### 2. ⚡ Канонический кэш PSO с нормализацией состояний (Canonical PSO Cache)
- Нормализация динамических состояний (viewport, blend, stencil) ускоряет повторную компиляцию пайплайнов на величину до 60%.

### 3. 🔬 GPU Compute-декодер и транскодер текстур Switch
- Аппаратное разжатие и перестановка GOB/Block Linear текстур прямо на вычислительных шейдерах GPU без нагрузки на CPU.

### 4. 🚀 Упреждающая выборка текстур в IR3 (Texture Prefetch Pass)
- Неблокирующие инструкции предзагрузки (`OPC_ISAM`) за 8 тактов до выполнения выборки маскируют задержки памяти.

### 5. 🖼️ Автоматическая генерация мипмапов (Compute Box-Filter)
- Автоматическое создание мип-цепочек для текстур размером >256x256 без нативных мипмапов, устраняя алиасинг и дрожание пикселей.

### 6. ⏱️ Zero-Stall Ping-Pong Submission
- Двойная буферизация командных потоков и таймлайн-семафоры `VK_KHR_timeline_semaphore` полностью исключают простои процессора.

### 7. 🎨 Hybrid 2D-UI Render Pass Extraction
- Автоматическая изоляция ортогональных элементов интерфейса (HUD, меню) в отдельный легковесный RenderPass без MSAA.

### 8. 🛡️ Полная поддержка Adreno 830 (Snapdragon 8 Elite) без полос
- Калибровка регистрового файла (`reg_size_vec4 = 96`) устраняет артефакты нестабильности и краши компилятора IR3.
- Аппаратное выравнивание шага питча и тайлинга UBWC 5.0 для Samsung Galaxy S25 Ultra, ROG Phone 9, Xiaomi 15 Pro.

### 9. 🎮 Глобальные расширения глубины для всех поколений Adreno
- **`VK_EXT_depth_bias_control`**: Включен для всех линеек Adreno (A6xx, A7xx, A8xx / Adreno 830), устраняя мерцание теней и Z-fighting.
- **`VK_EXT_depth_range_unrestricted`**: Корректный рендеринг бесконечных плоскостей обзора и зеркал.

### 10. 🌊 Zelda TOTK / BOTW Driconf Engine Rules
- Полная ликвидация непрозрачной/черной воды и артефактов поверхностей в *The Legend of Zelda: Breath of the Wild* и *Tears of the Kingdom*.
- Оптимизации `tile-discard`, `indirect-UBO-bounds`, GMEM autotune pinning и аппаратный фикс направления глубины (`tu_depth_direction_fix`).

### 11. 📱 Samsung OneUI UBWC 5.0 Buffer Fix (Patch 0003)
- Устранение графических искажений и цветового сдвига в системном кадровом буфере OneUI на смартфонах Samsung Galaxy S24 / S25 Ultra.

### 12. ⚡ Compute Flush Bits Optimization
- Устранение избыточных циклов синхронизации конвейера в `tu_dispatch`, повышающее фреймрейт в тяжелых играх.

### 13. 🛡️ Динамический DVFS Power-Throttling Guard (60°C Target)
- Плавное управление частотами GPU через драйверные хинты при достижении температурного порога (60°C).

### 14. 🎮 Mali Bifrost / Valhall PanVK & Midgard Geometry Culling
- Аппаратное раннее отсечение невидимой геометрии (Early Z-Cull) и Forward Pixel Kill v5 для чипов Mali.

---

## 📋 Поддерживаемые платформы и GPU

| Архитектура | Процессоры / Чипсеты | Графический чип |
| :--- | :--- | :--- |
| **Adreno 8xx** | Snapdragon 8 Elite (SM8750) | Adreno 830 |
| **Adreno 7xx** | Snapdragon 8 Gen 3, 8 Gen 2, 8+ Gen 1, 8 Gen 1, 7+ Gen 2, 7s Gen 2 | Adreno 750, 740, 730, 725, 720, 710 |
| **Adreno 6xx** | Snapdragon 888, 870, 865, 855, 845, 778G, 765G, 720G, 680 | Adreno 660, 650, 640, 630, 642L, 620, 619, 618, 610 |
| **ARM Mali** | MediaTek Dimensity, Helio, Exynos, Tensor | Mali-G710, G78, G77, G76, G72, G57, G52, Immortalis |

---

## 📥 Установка в эмуляторах

1. Скачайте актуальный архив драйвера `STORM_DRIVER_1.0.0.zip`.
2. Запустите эмулятор (**STORM EDEN**, **Eden**, Yuzu, Citron, Sudachi, Skyline и др.).
3. Откройте **Настройки ➔ Менеджер драйверов GPU (GPU Driver Manager)**.
4. Нажмите **«Установить» (Install)** и выберите скачанный .zip архив.
5. Выберите **STORM DRIVER** в качестве активного драйвера.

---

## 🛠️ Сборка из исходников (Building from Source)

### Требования:
- Linux (Ubuntu 22.04+ / Debian 12+) или WSL2
- Android NDK r28+
- Python 3.10+, Meson 1.3+, Ninja 1.11+
- CMake 3.25+

```bash
# Клонирование репозитория
git clone https://github.com/ReiKatari/STORM_DRIVER.git
cd STORM_DRIVER

# Применение набора патчей к Mesa
./scripts/apply_patches.sh /path/to/mesa-src

# Сборка драйвера
./scripts/build_turnip.sh --ndk /path/to/android-ndk-r28

# Упаковка .zip архива
python3 scripts/package_driver.py --out build/STORM_DRIVER_1.0.0.zip
```

---

## 🙏 Благодарности и авторы (Credits & Acknowledgments)

STORM DRIVER создан благодаря фундаментальным исследованиям и разработкам мирового open-source сообщества:

- **Mesa 3D Project & Freedreno / Panfrost Teams** (*Rob Clark, Danylo Piliaiev, Connor Abbott, Emma Anholt, Alyssa Rosenzweig, Boris Brezillon, faith, Samuel Pitoiset и др.*) — фундаментальная разработка драйверов Turnip, PanVK, Panfrost и компиляторов IR3 / Bifrost / Valhall.
- **Rick Amaral (rickamaral94 / Amaral-Adreno-Tools)** — инструментарий для работы с драйверами Adreno, библиотеки хуков и организация пайплайнов кастомных драйверов.
- **Aydar Kamaltdinov (aydar-kamaltdinov / mes)** — исследования и адаптация Mesa Turnip под Android, оптимизации компилятора и интеграция патчей.
- **MrPurple666** — глубокие оптимизации производительности, шейдерные патчи для Zelda BOTW/TOTK и энергоэффективные профили.
- **Balemuni (Leon)** — исследования тайлинга GMEM, NDK r28 пайплайн и наработки ветки *Aurora / Apex Edition*.
- **K11MCH1 (Kimchi)** — стандартизация и поддержка экосистемы кастомных драйверов Adrenotools.
- **Weab-chan & Whitebelyash** — непрерывная интеграция (CI) и масштабное тестирование сборок Turnip.
- **Crueter & GameHub Community** — детальный реверс-инжиниринг и анализ архитектуры Adreno 8xx / Snapdragon 8 Elite.
- **Bylaws (Danil)** — базовые библиотеки libadrenotools и динамический механизм инъекции драйверов.
- **Ryubing / Ryujinx Community** — глубокий анализ конвейеров Switch GPU, форматов глубины и трансляции шейдеров.
- **Yuzu & Eden Emulator Teams** — архитектура GPU-эмуляции Nintendo Switch и интеграция драйверов Vulkan.
- **Qualcomm & ARM** — за аппаратные платформы Snapdragon/Mali и архитектурные спецификации.
