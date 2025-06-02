#!/usr/bin/env bash

status=$(pamixer --get-mute)
icon_muted=""
icon_unmuted=""

if [ "$status" = "true" ]; then
    pamixer -u
    notify-send -t 800 -r 91190 -u low "$icon_unmuted  Sound On"
else
    pamixer -m
    notify-send -t 800 -r 91190 -u low "$icon_muted  Sound Muted"
fi
