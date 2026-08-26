# ⚡ STORM DRIVER — Universal Turnip Mesa GPU Driver

[![License](https://img.shields.io/badge/License-MIT%20%2F%20GPL-blue.svg)](LICENSE)
[![Vulkan](https://img.shields.io/badge/Vulkan-1.3%20%2F%201.4-red.svg)](https://www.vulkan.org/)
[![Adreno](https://img.shields.io/badge/Adreno-6xx%20%7C%207xx%20%7C%208xx-green.svg)](https://developer.qualcomm.com/)
[![Android](https://img.shields.io/badge/Android-9%20--%2015+-orange.svg)](https://developer.android.com/)

**STORM DRIVER** — это универсальный гибридный высокопроизводительный драйвер Vulkan (Mesa Turnip) нового поколения для мобильных графических процессоров **Qualcomm Adreno 6xx, 7xx и 8xx** (Snapdragon 865, 870, 888, 8+ Gen 1, 8 Gen 2, 8 Gen 3 и 8 Elite / Adreno 830).

Разработан специально для использования в эмуляторах Nintendo Switch (**STORM EDEN**, Yuzu, Citron, Suyu, Sudachi, Skyline), PS Vita (Vita3K), Windows/PC (Winlator, Mobox, Box64), PSP (PPSSPP) и нативных Vulkan-играх для Android.

---

## 🌟 Ключевые архитектурные преимущества

### 1. 🛡️ Полное устранение полос и артефактов на Adreno 830 (Snapdragon 8 Elite)
- Решена аппаратная проблема несоответствия выравнивания шага питча и тайлинга UBWC 5.0 на флагманских устройствах (Samsung Galaxy S25 Ultra, ROG Phone 9, Xiaomi 15 Pro).
- Аппаратно-безопасная конфигурация Swapchain и WSI гарантирует чистое изображение без вертикальных полос, шума и интерлейсинга со стабильными 60 FPS.

### 2. 🌊 Корректный рендеринг глубины и прозрачной воды (Zelda BOTW / TOTK Fix)
- Внедрен оптимизированный транслятор форматов глубины VK_FORMAT_D32_SFLOAT_S8_UINT и расчет смещений z-offset.
- Полностью решена проблема черной/непрозрачной воды, мерцания теней и артефактов рендеринга поверхностей в *The Legend of Zelda: Breath of the Wild* и *Tears of the Kingdom*.

### 3. 🚀 Adaptive GMEM Binning Tile Sizing для высоких разрешений (1.5X / 2X / 4K)
- Автоматический расчет оптимальных геометрических габаритов тайлов внутри ультрабыстрой накристальной памяти **GMEM**.
- Предотвращает принудительный сброс конвейера в медленную системную оперативную память (sysmem) при рендеринге в 1080p / 1440p / 4K, сохраняя пиковую пропускную способность.

### 4. ⚡ Async Compute & Draw Synchronization (	u6_flush_tile_buffers)
- Безопасная аппаратная синхронизация буферов тайлов между графическими очередями отрисовки и параллельными вычислительными шейдерами (Compute Shaders).
- Устраняет микрофризы, просадки кадров и статтеры в тяжелых динамических сценах с объемным светом и частицами.

### 5. 🧠 Global Code Motion (GCM IR3) & 4GB Shader Cache
- Оптимизация распределения регистров (GPR register pressure) в низкоуровневом компиляторе шейдеров IR3 (gcm=1).
- Персистентный дисковый кэш конвейеров Vulkan емкостью до **4 ГБ**, предотвращающий компиляционные заикания при первом появлении спецэффектов.

### 6. 🎮 Встроенные оптимизационные профили Driconf
- Готовые аппаратно-выверенные профили для современных игровых движков:
  - **Unreal Engine 4 & 5** (корректные барьеры дескрипторов и ресурсов);
  - **Unity Engine** (оптимизация динамического батчинга и инстансинга);
  - Комплексные Switch-тайтлы (*The Legend of Zelda*, *Xenoblade Chronicles*, *Diablo II: Resurrected*, *Monster Hunter Rise*).

### 7. 📱 Универсальная совместимость (Android 9+ — 15+)
- Порог minApi выставлен на **24**, обеспечивая запуск как на старых версиях Android, так и на новейших Android 14 / 15.
- Пакет включает валидные точки входа ulkan.freedreno.so, ulkan.adreno.so и ulkan.purple.so для безупречной совместимости со всеми загрузчиками Adrenotools.

---

## 📋 Поддерживаемые GPU и платформы

| Серия GPU | Семейство чипсетов Snapdragon | Графический процессор |
| :--- | :--- | :--- |
| **Adreno 8xx** | Snapdragon 8 Elite (SM8750) | Adreno 830 |
| **Adreno 7xx** | Snapdragon 8 Gen 3, 8 Gen 2, 8+ Gen 1, 8 Gen 1, 7+ Gen 2, 7s Gen 2 | Adreno 750, 740, 730, 725, 720, 710 |
| **Adreno 6xx** | Snapdragon 888, 870, 865, 855, 845, 778G, 765G, 720G, 680 | Adreno 660, 650, 640, 630, 642L, 620, 619, 618, 610 |

---

## 📥 Установка в эмуляторах

1. Скачайте актуальный .zip архив драйвера.
2. Запустите эмулятор (**STORM EDEN**, Yuzu, Citron, Sudachi, Skyline и др.).
3. Откройте **Настройки ➔ Управление драйверами GPU (GPU Driver Manager)**.
4. Нажмите кнопку **«Установить» (Install)** и укажите скачанный архив.
5. Выберите **STORM DRIVER** в качестве активного драйвера.

---

## 🙏 Благодарности и авторы (Credits & Acknowledgments)

STORM DRIVER создан на базе колоссального труда мирового open-source сообщества:

- **Mesa 3D Project & Freedreno Team** (Rob Clark, Danylo Piliaiev, Connor Abbott, Emma Anholt и др.) — фундаментальная разработка драйвера Turnip и шейдерного компилятора IR3.
- **MrPurple666** — глубокие оптимизации производительности, шейдерные патчи для Zelda BOTW/TOTK и энергоэффективные профили.
- **Balemuni (Leon)** — исследования тайлинга GMEM, NDK r28 пайплайн и наработки ветки *Aurora / Apex Edition*.
- **K11MCH1 (Kimchi)** — стандартизация и поддержка экосистемы кастомных драйверов Adrenotools.
- **Weab-chan & Whitebelyash** — непрерывная интеграция (CI) и масштабное тестирование сборок Turnip.
- **Crueter & GameHub Community** — детальный реверс-инжиниринг и анализ архитектуры Adreno 8xx.
- **Qualcomm** — за аппаратную платформу Snapdragon и архитектуру Adreno.