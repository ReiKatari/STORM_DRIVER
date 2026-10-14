# 📥 Руководство по установке STORM DRIVER 6.0.0

## STORM SWITCH / Eden / Yuzu Android
1. Скачайте архив `STORM_DRIVER_6.0.0.zip`.
2. Перейдите в **Настройки ➔ Менеджер драйверов GPU**.
3. Нажмите **«Установить»** и выберите `STORM_DRIVER_6.0.0.zip`.
4. Выберите **STORM DRIVER 6.0.0** в списке активных драйверов.

## Winlator / Mobox / Box64
1. Скопируйте `vulkan.freedreno.so` в `/data/data/com.winlator/files/image/opt/turnip/`.
2. Установите переменную окружения `MESA_DRIRC_FILE`, указывающую на `drirc.xml` (или `DRIRC_CONFIGDIR` на каталог с `00-storm.conf`).
