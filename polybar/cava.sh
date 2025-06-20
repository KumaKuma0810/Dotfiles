#!/bin/bash

# Символы по громкости
blocks=(▁ ▂ ▃ ▄ ▅ ▆ ▇ █)
CAVA_FIFO="/tmp/cava.fifo"
CAVA_PIDFILE="/tmp/cava_polybar.pid"

# Проверка: играет ли звук?
is_playing() {
    # Извлекаем значения громкости монитора
    LATEST_VOLUME=$(pactl list sink-inputs | grep -Po 'Volume:.*?(\d+)%' | awk '{print $NF}' | sort -nr | head -n1)
    if [[ -z "$LATEST_VOLUME" ]]; then
        return 1 # Нет звука
    fi
    return 0 # Звук есть
}

# Запустить cava, если надо
start_cava() {
    [[ -p "$CAVA_FIFO" ]] || mkfifo "$CAVA_FIFO"
    if ! pgrep -xf "cava" > /dev/null; then
        cava & echo $! > "$CAVA_PIDFILE"
    fi
}

# Остановить cava, если она не нужна
stop_cava() {
    if [[ -f "$CAVA_PIDFILE" ]]; then
        kill "$(cat "$CAVA_PIDFILE")" 2>/dev/null
        rm -f "$CAVA_PIDFILE"
    fi
    rm -f "$CAVA_FIFO"
}

# Основной цикл
while true; do
    if is_playing; then
        start_cava

        # Читаем cava и красиво выводим
        while read -r line; do
            [[ -z "$line" ]] && continue
            bars=($line)
            out=""
            for v in "${bars[@]}"; do
                idx=$((v * (${#blocks[@]} - 1) / 255))
                out+="${blocks[$idx]}"
            done
            echo "$out"
        done < "$CAVA_FIFO"
    else
        stop_cava
        echo ""  # Пустая строка в Polybar
    fi
    sleep 1
done

