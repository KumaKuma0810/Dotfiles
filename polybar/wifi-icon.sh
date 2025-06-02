#!/bin/bash

# Получаем уровень сигнала в процентах
signal=$(grep '\s*w' /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')

# Получаем SSID
ssid=$(iwgetid -r)

# Назначаем иконку по уровню сигнала
if [[ -z "$ssid" ]]; then
    icon="󰤭" # Disconnected
    ssid="Not connected"
elif (( $signal >= 80 )); then
    icon="󰤨" # Full
elif (( $signal >= 60 )); then
    icon="󰤥"
elif (( $signal >= 40 )); then
    icon="󰤢"
elif (( $signal >= 20 )); then
    icon="󰤟"
else
    icon="󰤯" # Weak
fi

# Выводим строку
echo "$icon $ssid"
