#!/bin/bash

# Опции для меню выхода
options="Logout\nReboot\nShutdown\nSuspend"

# Используем rofi для отображения меню
choice=$(echo -e "$options" | rofi -dmenu -p "Select an action:")

case "$choice" in
    "Logout")
        i3-msg exit  # Для i3; замените на соответствующую команду для вашего WM/DE
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Shutdown")
        systemctl poweroff
        ;;
    "Suspend")
        systemctl suspend
        ;;
    *)
        exit 1  # Если ничего не выбрано, просто выйти
        ;;
esac
