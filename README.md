# ⚡ STORM DRIVER — Universal Turnip Mesa GPU Driver

[![License](https://img.shields.io/badge/License-MIT%20%2F%20GPL-blue.svg)](LICENSE)
[![Vulkan](https://img.shields.io/badge/Vulkan-1.3%20%2F%201.4-red.svg)](https://www.vulkan.org/)
[![Adreno](https://img.shields.io/badge/Adreno-6xx%20%7C%207xx%20%7C%208xx-green.svg)](https://developer.qualcomm.com/)
[![Android](https://img.shields.io/badge/Android-9%20--%2015+-orange.svg)](https://developer.android.com/)

**STORM DRIVER** — это универсальный гибридный высокопроизводительный драйвер Vulkan (Mesa Turnip 26.3.0-devel) нового поколения для мобильных графических процессоров **Qualcomm Adreno 6xx, 7xx и 8xx** (Snapdragon 865, 870, 888, 8+ Gen 1, 8 Gen 2, 8 Gen 3 и 8 Elite / Adreno 830).

Разработан специально для использования в эмуляторах Nintendo Switch (**STORM EDEN**, Yuzu, Citron, Suyu, Sudachi, Skyline), PS Vita (Vita3K), Windows/PC (Winlator, Mobox, Box64), PSP (PPSSPP) и нативных Vulkan-играх для Android.

---

## 🌟 Ключевые улучшения и особенности (v0.0.2)

### 1. 🛡️ Устранение бага полос и артефактов на Adreno 830 (Snapdragon 8 Elite)
- Решена аппаратная проблема сжатия UBWC 5.0 на флагманских устройствах (Samsung Galaxy S25 Ultra SM-S938B, ROG Phone 9, Xiaomi 15 Pro). 
- Принудительное декодирование кадровых поверхностей WSI (Swapchain) в Linear-формат полностью устраняет вертикальные микрополосы, интерлейсинг и искажения при активном геймплее 60 FPS.

### 2. 🚀 Adaptive Binning Tile Sizing для высоких разрешений (1.5X / 2X)
- Автоматическое динамическое масштабирование тайлов внутри быстрой памяти **GMEM**.
- Предотвращает аварийное переключение драйвера в медленный sysmem при масштабировании разрешения в играх до 1080p и 1440p, сохраняя высочайшую пропускную способность и стабильный фреймрейт.

### 3. ⚡ Async Compute & Draw Synchronization (	u6_flush_tile_buffers)
- Асинхронная синхронизация буферов GMEM между графическими конвейерами и очередями Compute Shaders.
- Устраняет микрофризы и статтеры в тяжелых сценах со сложными частицами, освещением и пост-эффектами.

### 4. 🧠 Global Code Motion (GCM IR3) & 4GB Shader Cache
- Оптимизация регистрового давления (GPR pressure) компилятора шейдеров IR3 (gcm=1).
- Расширенный до **4 ГБ** персистентный дисковый кэш скомпилированных пайплайнов Vulkan для исключения шейдерных компиляционных заиканий.

### 5. 🎮 Встроенные профили Driconf
- Готовые оптимизированные конфигурации для тяжелых движков:
  - **Unreal Engine 4 & 5** (корректная обработка дескрипторов и барьеров);
  - **Unity Engine** (оптимизация динамического батчинга);
  - Специфические Switch-хиты (*The Legend of Zelda: Tears of the Kingdom*, *Breath of the Wild*, *Xenoblade Chronicles*, *Diablo II: Resurrected*).

### 6. 📱 Максимальная совместимость (Android 9+ — 15+)
- Порог minApi выставлен на **24 / 28**, что позволяет без ошибок устанавливать драйвер на старых и новых версиях Android.
- Поддержка обоих форматов библиотек (ulkan.freedreno.so и ulkan.adreno.so) гарантирует работу через Adrenotools во всех мобильных эмуляторах.

---

## 📋 Поддерживаемые GPU и устройства

| Поколение | Поддерживаемые процессоры | Графический чип |
| :--- | :--- | :--- |
| **Adreno 8xx** | Snapdragon 8 Elite (SM8750) | Adreno 830 |
| **Adreno 7xx** | Snapdragon 8 Gen 3, 8 Gen 2, 8+ Gen 1, 8 Gen 1, 7+ Gen 2 | Adreno 750, 740, 730, 725, 710 |
| **Adreno 6xx** | Snapdragon 888, 870, 865, 855, 778G, 765G, 720G | Adreno 660, 650, 640, 642L, 620, 618 |

---

## 📥 Установка в эмуляторах

1. Скачайте архив STORM_DRIVER_0.0.2.zip.
2. Откройте ваш эмулятор (**STORM EDEN**, Yuzu, Citron и др.).
3. Перейдите в: **Настройки ➔ Управление драйверами GPU (GPU Driver Manager)**.
4. Нажмите **«Установить» (Install)** и выберите скачанный .zip архив.
5. Выберите **STORM DRIVER** в списке активных драйверов.

---

## 🙏 Благодарности и авторы (Credits & Acknowledgments)

STORM DRIVER создан благодаря многолетней работе мирового open-source сообщества разработки графических драйверов:

- **Mesa 3D Project & Freedreno Team** (Rob Clark, Danylo Piliaiev, Connor Abbott, Emma Anholt и др.) — за фундаментальную разработку свободного драйвера Turnip и компилятора IR3.
- **Balemuni (Leon)** — за передовые исследования тайлинга GMEM, NDK r28 пайплайн и наработки в ветке *Aurora / Apex Edition*.
- **K11MCH1 (Kimchi)** — за стандартизацию и развитие кастомных пакетов Turnip Adrenotools.
- **MrPurple666** — за глубокие оптимизации производительности и профили энергоэффективности.
- **Weab-chan & Whitebelyash** — за поддержку непрерывной интеграции (CI) и тестирование Turnip.
- **Crueter & GameHub Community** — за исследования архитектуры Adreno 8xx / Snapdragon 8 Elite.
- **Qualcomm** — за аппаратную платформу Snapdragon и спецификации архитектуры Adreno.
