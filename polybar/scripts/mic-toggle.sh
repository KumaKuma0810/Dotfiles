#!/bin/bash

# Получаем текущее состояние микрофона
MUTE=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print \$2}')

if [ "$MUTE" == "yes" ]; then
    # Если микрофон выключен, включаем его
    pactl set-source-mute @DEFAULT_SOURCE@ 0
    echo "🎤 Mic: ON"
else
    # Если микрофон включен, выключаем его
    pactl set-source-mute @DEFAULT_SOURCE@ 1
    echo "🔇 Mic: OFF"
fi

