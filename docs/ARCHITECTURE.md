# 🏗️ Архитектура и оптимизации STORM DRIVER 8.0.0

## 1. Ликвидация гонок Concurrent Binning и восстановление целостности глифов (Glyph-Safe Baseline)
В выпусках драйверов версий 6.0.0–7.0.0 глобальное включение параметра `tu_allow_concurrent_binning="true"` в секции `<application name="all">` приводило к опережению фазы биннинга относительно инкрементальных динамических обновлений 2D-атласа шрифтов (форматы R8 / BC4). В результате в играх с динамическими атласами (*Diablo II: Resurrected*, *Xenoblade Chronicles X DE* и др.) пропадали буквы интерфейса и диалогов.
В **STORM DRIVER 8.0.0** полностью восстановлен проверенный безопасный базовый профиль:
- В `<application name="all">` строго установлено `tu_allow_concurrent_binning="false"`.
- Параметр `tu_allow_concurrent_binning="true"` изолирован **исключительно** в **Tier 5** (чистые трехмерные движки первой стороны: *Super Mario Odyssey*, *Mario Kart 8 Deluxe*, *Super Smash Bros. Ultimate*, *Metroid Prime Remastered* и др.), где отсутствует динамический 2D-атлас и требуется максимальная пропускная способность тайлинга.

## 2. Исключение фиктивных опций и переход на скомпилированные параметры Mesa Turnip
Конфигурационные файлы прошлых ревизий содержали несуществующие параметры, которые игнорировались синтаксическим анализатором `xmlconfig.c`. В STORM DRIVER 8.0.0 используются исключительно реальные флаги `dri_option`, верифицированные в секции `.rodata` бинарного файла `vulkan.adreno.so`:
- `tu_allow_concurrent_binning`, `disable_cb` (явный запрет конкурентного биннинга для 2D-атласов);
- `tu_dont_care_as_load` (сохранение содержимого тайлов при `VK_ATTACHMENT_LOAD_OP_DONT_CARE`, исключающее затирание уже сгенерированных глифов);
- `tu_use_tex_coord_round_nearest_even_mode` (субпиксельное округление текстурных координат для идеальной резкости шрифтов и UI);
- `tu_override_uncached_as_cache_coherent`, `ubwc_coherency_quirk`;
- `tu_allow_oob_indirect_ubo_loads`, `tu_enable_d24s8_border_color_workaround`, `dual_color_blend_by_location`;
- `vk_x11_override_min_image_count`, `vk_wsi_force_bgra8_unorm_first`.

## 3. Восьмиуровневая изолированная архитектура движков и жанров (Engine Architecture Tiers)
Конфигурация драйвера разделена на 8 изолированных уровней, полностью исключающих кросс-контаминацию настроек:
- **Tier 0 — Universal Safe Baseline (`all`)**: базовая стабильность, `tu_allow_concurrent_binning="false"`, `tu_allow_oob_indirect_ubo_loads="true"`, `ubwc_coherency_quirk="true"`.
- **Tier 1 — Dynamic 2D Font Atlas & Isometric ARPGs**: аппаратная защита атласов шрифтов, отключение LRZ fast clear и принудительное сохранение тайлов для D2R, D3, Disco Elysium, Baldur's Gate, Divinity: Original Sin 2.
- **Tier 2 — Nintendo LunchPack / KingSystem & Monolith Soft Open-World**: воркэраунд для D24S8 border color, отключение консервативного LRZ для Zelda BotW/TotK/EoW и всей серии Xenoblade Chronicles.
- **Tier 3 — Unreal Engine 4 / 5 & HD-2D Deferred Renderers**: оптимизация субпиксельной выборки и барьеров глубины для SMT V, Hogwarts Legacy, Mortal Kombat 1/11, Octopath Traveler, Little Nightmares, Batman: Arkham.
- **Tier 4 — RE Engine, PlatinumGames & High-Speed Action**: когерентность некэшируемой памяти и ликвидация микростаттеров в Monster Hunter Rise, Astral Chain, Bayonetta, NieR: Automata, Resident Evil.
- **Tier 5 — Pure 3D First-Party High-Throughput Engines**: изолированный конкурентный биннинг (`tu_allow_concurrent_binning="true"`) для Super Mario Odyssey, Mario Kart 8, Smash Bros Ultimate, Metroid Prime/Dread, Pokemon Legends.
- **Tier 6 — 2D, Indie, Unity & Vector/Sprite Precision**: субпиксельное округление и dual-color blend для спрайтов в Hollow Knight, Hades, Dead Cells, Cuphead, Celeste, Streets of Rage 4, Prince of Persia TLC, Brotato, Balatro.
- **Tier 7 — Heavy AAA Open-World & Proprietary PC Ports**: аппаратная коррекция буферов глубины и кэширования для The Witcher 3, Red Dead Redemption, DOOM, Skyrim, No Man's Sky, Crysis, Persona 5 Royal.
- **Tier 8 — Cross-Platform Emulators & PC Translation Layers**: оптимизация WSI и оверрайд минимального числа изображений X11 для Winlator, Wine/DXVK/VKD3D, Vita3K, AetherSX2, Citra/Lime3DS, Dolphin, PPSSPP.

## 4. Аппаратная поддержка Adreno 840 / 830 / 825, Adreno 7xx, Adreno 6xx и ARM Mali
Полная аппаратная совместимость с чипами Snapdragon 8 Elite Gen 5 (SM8850, Adreno 840 Oryon v2), Snapdragon 8 Elite (SM8750, Adreno 830), линейками Adreno 7xx (A710/A720/A722/A725/A730/A740/A750), Adreno 6xx (A610–A660), а также графическими процессорами ARM Mali (Bifrost, Valhall, Immortalis).
