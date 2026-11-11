# 🏗️ Архитектура и оптимизации STORM DRIVER 12.0.0

## 1. Ликвидация гонок Concurrent Binning и восстановление целостности глифов (Glyph-Safe Baseline)
В выпусках драйверов версий 6.0.0-7.0.0 глобальное включение параметра `tu_allow_concurrent_binning="true"` в секции `<application name="all">` приводило к опережению фазы биннинга относительно инкрементальных динамических обновлений 2D-атласа шрифтов (форматы R8 / BC4). В результате в играх с динамическими атласами (*Diablo II: Resurrected*, *Xenoblade Chronicles X DE* и др.) пропадали буквы интерфейса и диалогов.
В **STORM DRIVER 12.0.0** полностью сохранен проверенный безопасный базовый профиль:
- В `<application name="all">` строго установлено `tu_allow_concurrent_binning="false"`.
- Параметр `tu_allow_concurrent_binning="true"` изолирован **исключительно** в **Tier 5** (чистые трехмерные движки первой стороны: *Super Mario Odyssey*, *Mario Kart 8 Deluxe*, *Super Smash Bros. Ultimate*, *Metroid Prime Remastered* и др.), где отсутствует динамический 2D-атлас и требуется максимальная пропускная способность тайлинга.

## 2. Искоренение деструктивных опций и переход на чистые скомпилированные параметры Mesa Turnip Vulkan 1.4.367
В **STORM DRIVER 12.0.0** произведена фундаментальная ревизия и очистка driconf от деструктивных опций, вызывавших регрессии рендеринга:
- **Устранение `tu_dont_care_as_load`**: Принудительное превращение `VK_ATTACHMENT_LOAD_OP_DONT_CARE` в `LOAD` вызывало накопление предыдущих кадров и наложение слоев изображения (frame ghosting, двоение картинки). Параметр полностью удален из всех профилей.
- **Устранение `disable_conservative_lrz` и `tu_ignore_frag_depth_direction`**: Отключение консервативной отсечки глубины LRZ приводило к разрушению геометрии стен дворцов и открытого мира в движках Snowdrop и LunchPack. Параметры полностью удалены.
- **Устранение `tu_override_uncached_as_cache_coherent`**: Небезопасный оверрайд кэш-когерентности заменен на валидированные нативные механизмы когерентности памяти.
- **Актуальные верифицированные флаги `dri_option`**:
  - `tu_allow_concurrent_binning`, `disable_cb` (явный запрет конкурентного биннинга для 2D-атласов);
  - `tu_use_tex_coord_round_nearest_even_mode` (субпиксельное округление текстурных координат для идеальной резкости шрифтов и UI);
  - `ubwc_coherency_quirk`;
  - `tu_allow_oob_indirect_ubo_loads`, `tu_enable_fast_border_color_for_undefined_formats`, `dual_color_blend_by_location`;
  - `vk_x11_override_min_image_count`, `vk_wsi_force_bgra8_unorm_first`.

## 3. Девятиуровневая изолированная архитектура движков и жанров (Engine Architecture Tiers)
Конфигурация драйвера разделена на 8 изолированных уровней, полностью исключающих кросс-контаминацию настроек:
- **Tier 0 - Universal Safe Baseline (`all`)**: базовая стабильность, `tu_allow_concurrent_binning="false"`, `tu_allow_oob_indirect_ubo_loads="true"`, `ubwc_coherency_quirk="true"`.
- **Tier 1 - Dynamic 2D Font Atlas & Isometric ARPGs**: аппаратная защита атласов шрифтов, отключение LRZ fast clear и субпиксельное округление для D2R, D3, Disco Elysium, Baldur's Gate, Divinity: Original Sin 2.
- **Tier 2 - Nintendo LunchPack / KingSystem & Monolith Soft Open-World**: воркэраунд для border color, безопасный LRZ для Zelda BotW/TotK/EoW и всей серии Xenoblade Chronicles.
- **Tier 3 - Unreal Engine 4 / 5 & HD-2D Deferred Renderers**: оптимизация субпиксельной выборки и барьеров глубины для SMT V, Hogwarts Legacy, Mortal Kombat 1/11, Octopath Traveler, Little Nightmares, Batman: Arkham.
- **Tier 4 - RE Engine, PlatinumGames & High-Speed Action**: оптимизация синхронизации памяти и ликвидация микростаттеров в Monster Hunter Rise, Astral Chain, Bayonetta, NieR: Automata, Resident Evil.
- **Tier 5 - Pure 3D First-Party High-Throughput Engines**: изолированный конкурентный биннинг (`tu_allow_concurrent_binning="true"`) для Super Mario Odyssey, Mario Kart 8, Smash Bros Ultimate, Metroid Prime/Dread, Pokemon Legends.
- **Tier 6 - 2D, Indie, Unity & Vector/Sprite Precision**: субпиксельное округление и dual-color blend для спрайтов в Hollow Knight, Hades, Dead Cells, Cuphead, Celeste, Streets of Rage 4, Prince of Persia TLC, Brotato, Balatro.
- **Tier 7 - Heavy AAA Open-World & Proprietary PC Ports**: аппаратная коррекция буферов глубины и кэширования для The Witcher 3, Red Dead Redemption, DOOM, Skyrim, No Man's Sky, Crysis, Persona 5 Royal.
- **Tier 8 - Cross-Platform Emulators & PC Translation Layers**: оптимизация WSI и оверрайд минимального числа изображений X11 для Winlator, Wine/DXVK/VKD3D, Vita3K, AetherSX2, Citra/Lime3DS, Dolphin, PPSSPP.

## 4. Поколенческое разделение Turnip Vulkan 1.4.367 (Adreno 8xx vs 7xx/6xx)
В поставку **STORM DRIVER 12.0.0** интегрированы два независимых оптимизированных бинарных ядра Turnip:
- **Gen8 V39-patched (`vulkan.adreno_gen8.so`, `vulkan.freedreno.so`, `libvulkan_freedreno.so`, 8,460,728 B)**: Полная аппаратная поддержка поколения Adreno 830 / 840 (Snapdragon 8 Elite SM8750 / SM8850 Oryon v2), a8xx, a7xx и OneUI.
- **Turnip 27.0.0-R2-Oneui (`vulkan.adreno_a7xx.so`, 8,362,496 B)**: Высокооптимизированное ядро Vulkan 1.4.367 для чипсетов Adreno 7xx (710-750) и Adreno 6xx с калибровками для OneUI.

## 5. Поддержка STORM SWITCH (dev.storm_switch) и Legacy окружения
В driconf добавлены выделенные секции `<application name="STORM SWITCH" executable="dev.storm_switch">` для актуального пакета эмулятора, а также сохранена совместимость с `<application name="STORM SWITCH (Legacy)" executable="org.yuzu.yuzu_emu">` для Turnip, PanVK, Panfrost и RADV.
