#!/bin/bash

# Получение текущего трека из cmus
current_track=$(cmus-remote -Q | grep 'tag title' | cut -d' ' -f3-)
# Получение текущего исполнителя
current_artist=$(cmus-remote -Q | grep 'tag artist' | cut -d' ' -f3-)

# Формируем сообщение
if [ -z "$current_track" ]; then
    message="Нет воспроизводимого трека"
else
    message="$current_track"
fi

# Отправляем уведомление через dunstify
dunstify "cmus" "$message"
