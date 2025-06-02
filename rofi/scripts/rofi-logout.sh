#!/bin/bash

# --- Неоновые иконки и названия ---
options="  Logout\n  Reboot\n  Shutdown\n  Suspend\n󰜺   Cancel"

# --- Вызов Rofi с кастомной темой ---
choice=$(echo -e "$options" | rofi -dmenu -p "Выберите действие:") 

# --- Действия ---
case "$choice" in
    *Logout)
        i3-msg exit
        ;;
    *Reboot)
        systemctl reboot
        ;;
    *Shutdown)
        systemctl poweroff
        ;;
    *Suspend)
        systemctl suspend
        ;;
    *)
        exit 1
        ;;
esac

