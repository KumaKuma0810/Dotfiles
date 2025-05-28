#!/bin/bash

ICON_ON="󰂯 "
ICON_OFF="󰂲 "
ICON_CONNECTED=""

# Проверка включён ли Bluetooth
if ! bluetoothctl show | grep -q "Powered: yes"; then
  echo "$ICON_OFF"
  exit 0
fi

# Получаем список подключённых устройств
connected_devices=$(bluetoothctl devices Connected | cut -d ' ' -f 3-)

if [[ -z "$connected_devices" ]]; then
  echo "$ICON_ON"
else
  echo "$ICON_CONNECTED $connected_devices"
fi
