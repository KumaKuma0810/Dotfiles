#!/bin/bash

CRITICAL=5
WARNING=20

while true; do
    # получаем уровень заряда
    BATTERY=$(cat /sys/class/power_supply/BAT*/capacity)
    STATUS=$(cat /sys/class/power_supply/BAT*/status)

    if [[ "$STATUS" == "Discharging" ]]; then
        if [[ $BATTERY -le $CRITICAL ]]; then
            notify-send -u critical "🔋 Критический заряд: $BATTERY%. Уход в гибернацию..."
            systemctl hibernate
        elif [[ $BATTERY -le $WARNING ]]; then
            notify-send -u normal "⚠️ Низкий заряд: $BATTERY%"
        fi
    fi

    sleep 60
done

