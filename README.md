# STORM DRIVER

**Универсальный кастомный высокопроизводительный графический драйвер Vulkan нового поколения для мобильных и настольных платформ на базе открытой кодовой базы Mesa Turnip и PanVK**

---

## **О проекте**

**STORM DRIVER** - это специализированный оптимизированный графический драйвер Vulkan, разработанный для мобильных графических процессоров **Qualcomm Adreno 6xx, 7xx, 8xx** (включая Snapdragon 8 Elite Gen 5 `SM8850` / Adreno 840 Oryon v2, Snapdragon 8 Elite `SM8750` / Adreno 830, линейку Adreno 710/720/722 и 730-750, а также Adreno 6xx) и **ARM Mali / Immortalis** (Bifrost, Valhall).

Драйвер ориентирован на обеспечение высочайшей производительности, стабильности кадровой частоты, предотвращение троттлинга и перегрева, устранение утечек видеопамяти при длительных игровых сессиях, а также на ликвидацию графических артефактов в играх и эмуляторах на Android и Linux.

---

## **Технологический стек**

- **Языки и компиляторы**: C, C++20, Python, Meson, Ninja, Android NDK (API 35+)
- **Графический API**: Vulkan 1.3 / 1.4 API Specifications, WSI, Android SurfaceFlinger LTPO 1-120Hz
- **Архитектуры GPU**: Qualcomm Adreno (A6xx, A7xx, A830 / A840 Snapdragon 8 Elite), ARM Mali (Bifrost, Valhall, Immortalis)
- **Компилятор шейдеров**: IR3 Shader Compiler с глобальным планированием и ZSTD-сжатием дискового кэша

---

## **Ключевые особенности и архитектурные решения**

- **Поддержка Adreno 840 (SM8850 Snapdragon 8 Elite Gen 5 Oryon v2) и Adreno 830**: аппаратная калибровка регистров `reg_size_vec4 = 96`, макро-тайлинг 24 МБ GMEM, поддержка 16 слайсов L2-кэша и Wave64 Occupancy.
- **Интеграция наработок Vauzi-17 для Adreno 710/720/722**: строгое выравнивание шага GMEM-тайлов (64/128-byte stride alignment), устраняющее полосы, градиентный шум и расслоение текстур.
- **Автоматическая защита от утечек памяти при длительных сессиях (4PDA #33080 Fix)**: интеллектуальный тайм-аут LRU-кэша буферных объектов (`tu_bo_cache_max_age_ms = 180000`), реклейм субаллокатора памяти и автоматическая очистка неиспользуемых пулов дескрипторов каждые 180 секунд без статтеров.
- **Изолированная 8-уровневая архитектура движков (Engine Architecture Tiers)**: строгое разграничение параметров конвейера, тайлинга и барьеров для различных графических движков (Tier 0-8), исключающее взаимное влияние настроек между играми.
- **Аппаратная защита 2D-атласа шрифтов в Diablo II: Resurrected и Xenoblade Chronicles X**: устранение гонки данных concurrent binning, ликвидация просадок FPS и сохранение целостности глифов шрифтов и спрайтов.
- **Защита вершинных буферов в Xenoblade Chronicles X: Definitive Edition**: внедрение `vertex_buffer_oob_guard` и `robust_buffer_access2`, устраняющее краши при использовании модов и фанатских локализаций.
- **Поддержка спецификаций Vulkan 1.4**: задействованы современные расширения Khronos, включая динамический локальный рендеринг и прямое копирование изображений с хоста.
- **Samsung OneUI UBWC 5.0 Framebuffer Lossless Guard**: предотвращение артефактов на внешних swapchain-буферах в устройствах Galaxy.
- **Eco-Cool DVFS и LTPO 1-120Hz Frame Pacing**: микро-сон кольцевого буфера KGSL при простое между кадрами для снижения нагрева аккумулятора.
- **Аппаратное отсечение геометрии для Mali**: Early Z-Cull и Forward Pixel Kill для чипов Dimensity и Exynos.
- **Оптимизированные профили для популярных игр**: The Legend of Zelda: Tears of the Kingdom, Breath of the Wild, Metroid Prime Remastered, Xenoblade Chronicles, Red Dead Redemption, Bayonetta 3 и десятков других проектов.

---

## **Поддерживаемые платформы и GPU**

| Архитектура | Процессоры / Платформы | Графический ускоритель |
| :--- | :--- | :--- |
| **Adreno 8xx** | Snapdragon 8 Elite Gen 5 (SM8850), Snapdragon 8 Elite (SM8750) | Adreno 840, Adreno 830 |
| **Adreno 7xx** | Snapdragon 8 Gen 3, 8 Gen 2, 8+ Gen 1, 8 Gen 1, 7+ Gen 2, 7s Gen 2, 7 Gen 3, 7+ Gen 3 | Adreno 750, 740, 730, 725, 722, 720, 710 |
| **Adreno 6xx** | Snapdragon 888, 870, 865, 855, 845, 778G, 765G, 720G | Adreno 660, 650, 640, 630, 642L, 620, 619, 618, 610 |
| **ARM Mali** | MediaTek Dimensity, Helio, Samsung Exynos, Google Tensor | Mali-G710, G78, G77, G76, G72, G57, G52, Immortalis |

---

## **Установка и использование**

1. Получите архив драйвера: `STORM_DRIVER.zip`.
2. Запустите поддерживаемое приложение или эмулятор.
3. Откройте **Настройки ➔ Менеджер драйверов GPU**.
4. Нажмите **Установить** и укажите файл `STORM_DRIVER.zip`.
5. Выберите **STORM DRIVER** в качестве активного графического драйвера.

---

## **Сборка из исходного кода**

### Требования к окружению:
- Операционная система: Linux (Ubuntu 22.04+ / Debian 12+) или Windows с подсистемой WSL2
- Android NDK: r28+
- Инструменты сборки: Python 3.10+, Meson 1.3+, Ninja 1.11+, CMake 3.25+

```bash
# Применение набора патчей к исходному коду Mesa
./scripts/apply_patches.sh /path/to/mesa-src

# Сборка драйвера
./scripts/build-storm-driver.sh --ndk /path/to/android-ndk

# Упаковка дистрибутива
python3 scripts/package_driver.py --out build/STORM_DRIVER.zip
```
