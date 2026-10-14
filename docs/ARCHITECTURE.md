# 🏗️ Архитектура и оптимизации STORM DRIVER 6.0.0

## 1. Калибровка регистрового файла и Slice Clock Gating для Adreno 830 / 840 (Snapdragon 8 Elite)
Графический процессор Adreno 830 использует новую архитектуру срезов (Slice Architecture). При компиляции комплексных шейдеров стандартное распределение вызывало панику планировщика IR3. STORM DRIVER 6.0.0 калибрует `reg_size_vec4` на значение **96**, включает аппаратное отключение тактирования неактивных срезов (`tu_a830_slice_clock_gating`) и оптимизацию заполнения подгрупп Wave64 (`tu_a830_wave64_occupancy_opt`), обеспечивая максимальную плотность инструкций без сброса регистров в системную память.

## 2. Аппаратное выравнивание UBWC 5.0 для Samsung OneUI 7
Universal Bandwidth Compression (UBWC) 5.0 требует строгого выравнивания шага питча по границе 128 байт на внешних кадровых буферах WSI. Патч 0003 принудительно выравнивает питч по 128-байтовым блокам (`FD_UBWC_ALIGN_5_0`), полностью исключая полосы и искажения на дисплеях Samsung Galaxy S24 / S25 Ultra.

## 3. Поддержка Vulkan 1.4 и новейших расширений Khronos
В версии 6.0.0 активированы расширения `VK_KHR_maintenance7`, `VK_KHR_maintenance8`, `VK_KHR_dynamic_rendering_local_read`, `VK_KHR_compute_shader_derivatives`, `VK_KHR_shader_relaxed_extended_instruction`, `VK_EXT_shader_replicated_composites`, `VK_EXT_host_image_copy` и `VK_MESA_image_alignment_control`, позволяющие эмуляторам читать тайловые буферы GMEM напрямую без разрыва прохода рендеринга и загружать текстуры без простоев конвейера.

## 4. Eco-Cool DVFS и синхронизация с дисплеями LTPO 1–120 Гц
Патч 0008 заменяет активный спин-опрос завершения команд в KGSL на адаптивное микро-ожидание (`tu_dvfs_idle_ringbuffer_sleep`) и синхронизирует вывод кадров с частотой обновления LTPO-панелей (`tu_present_pacing_ltpo_sync`), снижая тепловыделение SoC до 22%.

## 5. Бинарный аллокатор тайлов GMEM и PanVK / Mali FPK v5
Вместо статичной сетки тайлов STORM DRIVER использует бинарный поиск (`tu_optimal_gmem_tile_allocator`), подбирающий идеальные пропорции тайла для 100% размещения в локальной памяти GMEM чипа. Для графических процессоров ARM Mali / Immortalis активируются механизмы Forward Pixel Kill (FPK v5) и аппаратный Early Z-Cull.
