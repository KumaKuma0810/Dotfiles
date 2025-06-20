#!/bin/bash

# Настройки
MAX_LENGTH=40
ICON_PLAY="  "
ICON_PAUSE="  "
ICON_STOP="  "
ICON_NEXT="  "
ICON_PREV="   "

# ===== playerctl =====
PLAYER=$(playerctl --list-all 2>/dev/null | head -n 1)

if [[ -n "$PLAYER" ]]; then
    STATUS=$(playerctl --player="$PLAYER" status 2>/dev/null)
    META=$(playerctl --player="$PLAYER" metadata --format '{{artist}} - {{title}}' 2>/dev/null)

    if [[ -n "$STATUS" && -n "$META" ]]; then
        [[ ${#META} -gt $MAX_LENGTH ]] && META="${META:0:$MAX_LENGTH}…"

        case "$STATUS" in
            Playing) ICON="$ICON_PLAY" ;;
            Paused)  ICON="$ICON_PAUSE" ;;
            Stopped) ICON="$ICON_STOP" ;;
            *)       exit 0 ;;
        esac

        echo "%{A1:playerctl --player=$PLAYER previous:}$ICON_PREV%{A} %{A1:playerctl --player=$PLAYER play-pause:}$ICON%{A} %{A1:playerctl --player=$PLAYER next:}$ICON_NEXT%{A}  $META"
        exit 0
    fi
fi

# ===== cmus fallback =====
CMUS_STATUS=$(cmus-remote -Q 2>/dev/null)

if [[ $? -eq 0 ]]; then
    STATUS=$(echo "$CMUS_STATUS" | grep "^status" | awk '{print $2}')
    ARTIST=$(echo "$CMUS_STATUS" | grep "^tag artist" | cut -d ' ' -f 3-)
    TITLE=$(echo "$CMUS_STATUS" | grep "^tag title" | cut -d ' ' -f 3-)

    if [[ -z "$ARTIST" && -z "$TITLE" ]]; then
        META=""
    else
        META="$ARTIST - $TITLE"
    fi

    [[ ${#META} -gt $MAX_LENGTH ]] && META="${META:0:$MAX_LENGTH}…"

    case "$STATUS" in
        playing) ICON="$ICON_PLAY" ;;
        paused)  ICON="$ICON_PAUSE" ;;
        stopped) ICON="$ICON_STOP" ;;
        *)       exit 0 ;;
    esac

    echo "%{A1:cmus-remote --prev:}$ICON_PREV%{A} %{A1:cmus-remote --pause:}$ICON%{A} %{A1:cmus-remote --next:}$ICON_NEXT%{A}  $META"
    exit 0
fi

# ===== MPD (ncmpcpp) =====
MPD_STATUS=$(mpc status 2>/dev/null)

if [[ $? -eq 0 ]]; then
    STATUS=$(echo "$MPD_STATUS" | head -n 1 | awk '{print $1}')
    SONG=$(mpc current 2>/dev/null)

    if [[ -n "$SONG" ]]; then
        # Разделяем Artist и Title (если они есть в формате "Artist - Title")
        if [[ "$SONG" == *" - "* ]]; then
            IFS=' - ' read -r ARTIST TITLE <<< "$SONG"
        else
            ARTIST=""
            TITLE="$SONG"
        fi

        if [[ -n "$ARTIST" ]]; then
            META="$ARTIST - $TITLE"
        else
            META="$TITLE"
        fi

        [[ ${#META} -gt $MAX_LENGTH ]] && META="${META:0:$MAX_LENGTH}…"

        case "$STATUS" in
            playing:) ICON="$ICON_PLAY" ;;
            paused:)  ICON="$ICON_PAUSE" ;;
            stopped:) ICON="$ICON_STOP" ;;
            *)       ICON="$ICON_STOP" ;;  # Или что-то другое, если статус неизвестен
        esac

        # Управление через mpc
        echo "%{A1:mpc prev:}$ICON_PREV%{A} %{A1:mpc toggle:}$ICON%{A} %{A1:mpc next:}$ICON_NEXT%{A}  $META"
        exit 0
    fi
fi

# Ничего не запущено
exit 0
