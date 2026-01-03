#!/usr/bin/env sh

FILE="/sys/class/hwmon/hwmon0/device/gpu_busy_percent"

if [ -f "$FILE" ]; then
    gpu_busy=$(cat "$FILE")
    echo $gpu_busy
else
    echo "{\"error\": \"File does not exist.\"}"
    exit 1
fi
