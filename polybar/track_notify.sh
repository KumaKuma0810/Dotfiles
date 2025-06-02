#!/bin/bash

# Временный путь для обложек
TMP_COVER="/tmp/track_cover.jpg"

# Подписываемся на события смены трека
playerctl --follow metadata | while read -r _; do
    # Получаем данные
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    cover_url=$(playerctl metadata mpris:artUrl 2>/dev/null)

    # Проверка, что есть трек и артист
    if [[ -z "$title" || -z "$artist" ]]; then
        continue
    fi

    # Обрезаем 'file://' если локальный путь
    if [[ "$cover_url" == file://* ]]; then
        local_path="${cover_url#file://}"
        cp "$local_path" "$TMP_COVER"
    elif [[ "$cover_url" == http* ]]; then
        curl -sL "$cover_url" -o "$TMP_COVER"
    else
        # Нет обложки — удаляем старую
        rm -f "$TMP_COVER"
    fi

    # Формируем текст уведомления
    message="$artist - $title"

    # Показываем уведомление с обложкой, если она есть
    if [[ -f "$TMP_COVER" ]]; then
        notify-send "🎵 Now Playing" "$message" -i "$TMP_COVER"
    else
        notify-send "🎵 Now Playing" "$message" -i multimedia-player
    fi
done

