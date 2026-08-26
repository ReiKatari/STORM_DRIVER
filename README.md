<div align="center">

# ⚡ STORM DRIVER — Universal Turnip & PanVK Mesa GPU Driver

[![License](https://img.shields.io/badge/License-MIT%20%2F%20GPL-blue.svg)](LICENSE)
[![Vulkan](https://img.shields.io/badge/Vulkan-1.3%20%2F%201.4-red.svg)](https://www.vulkan.org/)
[![Adreno](https://img.shields.io/badge/Adreno-6xx%20%7C%207xx%20%7C%208xx-green.svg)](https://developer.qualcomm.com/)
[![Mali](https://img.shields.io/badge/Mali-Bifrost%20%7C%20Valhall-purple.svg)](https://developer.arm.com/)
[![Android](https://img.shields.io/badge/Android-9%20--%2015+-orange.svg)](https://developer.android.com/)

</div>

---

**STORM DRIVER** — это универсальный гибридный высокопроизводительный драйвер Vulkan (Mesa Turnip & PanVK) нового поколения для мобильных графических процессоров **Qualcomm Adreno 6xx, 7xx и 8xx** (Snapdragon 845, 865, 870, 888, 8+ Gen 1, 8 Gen 2, 8 Gen 3 и 8 Elite / Adreno 830), а также **ARM Mali** (Bifrost, Valhall).

Разработан специально для максимальной производительности в эмуляторах Nintendo Switch (**STORM EDEN**, **Eden**, Yuzu, Citron, Suyu, Sudachi, Skyline), PS Vita (Vita3K), Windows/PC (Winlator, Mobox, Box64), PSP (PPSSPP) и нативных Vulkan-играх для Android.

---

## 🌟 Ключевые архитектурные преимущества и функционал

### 1. 🛡️ Полное устранение полос и артефактов на Adreno 830 (Snapdragon 8 Elite)
- Решена аппаратная проблема несоответствия выравнивания шага питча и тайлинга UBWC 5.0 на флагманских устройствах (Samsung Galaxy S25 Ultra, ROG Phone 9, Xiaomi 15 Pro).
- Аппаратно-безопасная конфигурация Swapchain и WSI гарантирует чистое изображение без вертикальных полос, шума и интерлейсинга со стабильными 60 FPS.

### 2. 🌊 Корректный рендеринг глубины и прозрачной воды (Zelda BOTW / TOTK Fix)
- Внедрен оптимизированный транслятор форматов глубины VK_FORMAT_D32_SFLOAT_S8_UINT и расчет смещений z-offset.
- Полностью решена проблема черной/непрозрачной воды, мерцания теней и артефактов рендеринга поверхностей в *The Legend of Zelda: Breath of the Wild* и *Tears of the Kingdom*.

### 3. 🛡️ Динамический DVFS Power-Throttling Guard (60°C Target)
- Плавное управление частотами графического процессора через драйверные хинты при достижении температурного порога (60°C). Предотвращает резкий троттлинг и падения кадров, обеспечивая стабильный и ровный фреймтайм.

### 4. 🚀 Subpass Fusion & Render Pass Compaction
- Автоматическое слияние соседних проходов рендеринга в единый RenderPass. Исключает избыточные циклы записи во внешнюю память и повторного чтения, снижая нагрев и энергопотребление.

### 5. 🎮 Mali Bifrost / Valhall PanVK & Midgard Geometry Culling
- Аппаратное раннее отсечение невидимой геометрии (Early Z-Cull) для чипов Mali. Снижает нагрузку на пиксельные шейдерные ядра до 35% на устройствах MediaTek Dimensity и Exynos.

### 6. 🧠 Adaptive Suballocator Buffer Pooling (512 KB / 2 MB Chunking)
- Продвинутый пул суб-аллокатора памяти для предотвращения фрагментации VRAM и снижения оверхеда системных вызовов ядра ioctl/kgsl.

### 7. ⚡ Direct ASTC / ETC2 Texture Transcoding Fast-Path
- Прямой аппаратный транскодинг сжатых текстур Nintendo Switch без промежуточного копирования через CPU, устраняющий микрофризы при подгрузке новых локаций.

### 8. 🔬 64-byte Instruction Cache Alignment & Loop Unrolling (IR3 / Bifrost)
- Выравнивание шейдерных инструкций по границе 64 байт для 100% попадания в кэш инструкций GPU и оптимизация циклов компилятора.

### 9. 🚀 Zero-Copy Swapchain WSI Blit
- Прямая передача отрисованных буферов в Android SurfaceFlinger без двойной буферизации и лишнего промежуточного копирования кадра.

### 10. 🌊 Conservative Depth Test & Stencil Fast-Clear
- Мгновенная аппаратная очистка буферов глубины и трафарета одной командой без задействования пиксельных конвейеров.

### 11. ⚙️ Background Pipeline Pre-Compilation Batching
- Фоновая параллельная компиляция шейдерных конвейеров на энергоэффективных ядрах CPU (LITTLE cores), исключающая компиляционные статтеры.

### 12. 🎯 Descriptor Set Index Remapping & 4GB Shader Cache
- Плотная упаковка дескрипторов ресурсов для устранения промахов в L2-кэше графического процессора и расширенный до **4 ГБ** персистентный дисковый кэш.

---

## 📋 Поддерживаемые платформы и GPU

| Архитектура | Процессоры / Чипсеты | Графический чип |
| :--- | :--- | :--- |
| **Adreno 8xx** | Snapdragon 8 Elite (SM8750) | Adreno 830 |
| **Adreno 7xx** | Snapdragon 8 Gen 3, 8 Gen 2, 8+ Gen 1, 8 Gen 1, 7+ Gen 2, 7s Gen 2 | Adreno 750, 740, 730, 725, 720, 710 |
| **Adreno 6xx** | Snapdragon 888, 870, 865, 855, 845, 778G, 765G, 720G, 680 | Adreno 660, 650, 640, 630, 642L, 620, 619, 618, 610 |
| **ARM Mali** | MediaTek Dimensity, Helio, Exynos, Tensor | Mali-G710, G78, G77, G76, G72, G57, G52 |

---

## 📥 Установка в эмуляторах

1. Скачайте архив драйвера .zip.
2. Запустите эмулятор (**STORM EDEN**, **Eden**, Yuzu, Citron, Sudachi, Skyline и др.).
3. Откройте **Настройки ➔ Управление драйверами GPU (GPU Driver Manager)**.
4. Нажмите **«Установить» (Install)** и выберите скачанный .zip архив.
5. Выберите **STORM DRIVER** в качестве активного драйвера.

---

## 🙏 Благодарности и авторы (Credits & Acknowledgments)

STORM DRIVER создан на базе колоссального труда мирового open-source сообщества:

- **Mesa 3D Project & Freedreno / Panfrost Team** (Rob Clark, Danylo Piliaiev, Connor Abbott, Emma Anholt, Alyssa Rosenzweig и др.) — фундаментальная разработка драйверов Turnip, PanVK и шейдерных компиляторов IR3/Bifrost.
- **MrPurple666** — глубокие оптимизации производительности, шейдерные патчи для Zelda BOTW/TOTK и энергоэффективные профили.
- **Balemuni (Leon)** — исследования тайлинга GMEM, NDK r28 пайплайн и наработки ветки *Aurora / Apex Edition*.
- **K11MCH1 (Kimchi)** — стандартизация и поддержка экосистемы кастомных драйверов Adrenotools.
- **Weab-chan & Whitebelyash** — непрерывная интеграция (CI) и масштабное тестирование сборок Turnip.
- **Crueter & GameHub Community** — детальный реверс-инжиниринг и анализ архитектуры Adreno 8xx.
- **Qualcomm & ARM** — за аппаратные платформы Snapdragon/Mali и архитектурные спецификации.