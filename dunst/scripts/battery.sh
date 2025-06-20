#!/bin/bash

# Получить уровень заряда
PERCENT=$(acpi -b | grep -P -o '[0-9]+(?=%)')
STATUS=$(acpi -b | awk '{print $3}' | sed 's/,//')

ICON=""
MSG=""

# Критически низкий уровень
if [ "$STATUS" = "Discharging" ]; then
    if [ "$PERCENT" -le 10 ]; then
        ICON="⚠️"
        MSG="Критически низкий заряд: $PERCENT%"
        dunstify -r 9994 -u critical "$ICON $MSG"
    elif [ "$PERCENT" -le 20 ]; then
        ICON="🔋"
        MSG="Низкий заряд: $PERCENT%"
        dunstify -r 9994 -u normal "$ICON $MSG"
    fi
fi

# Полностью заряжен
if [ "$STATUS" = "Charging" ] && [ "$PERCENT" -ge 98 ]; then
    ICON="🔌"
    MSG="Батарея почти заряжена: $PERCENT%"
    dunstify -r 9994 -u low "$ICON $MSG"
fi

