#!/bin/bash

THRESHOLDS=(20 10 5)

BATTERY=$(cat /sys/class/power_supply/BAT0/capacity)

for THRESHOLD in "${THRESHOLDS[@]}"; do
    if [ "$BATTERY" -eq "$THRESHOLD" ]; then
        notify-send "Low Battery" "Battery level is at ${BATTERY}%."
    fi
done
