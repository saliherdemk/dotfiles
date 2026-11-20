#!/usr/bin/env bash

device=/sys/class/backlight/amdgpu_bl1
[[ -d "$device" ]] || exit 0
read -r brightness < "$device/actual_brightness" || exit 1
read -r maximum < "$device/max_brightness" || exit 1
[[ "$brightness" =~ ^[0-9]+$ && "$maximum" =~ ^[0-9]+$ ]] || exit 1
(( maximum > 0 )) || exit 1

percent=$(( (brightness * 100 + maximum / 2) / maximum ))
icons=("󰃞" "󰃝" "󰃟" "󰃠")
index=$(( percent * 4 / 101 ))
(( index > 3 )) && index=3
printf '{"text":"%s","tooltip":"%s%% %s"}\n' "${icons[index]}" "$percent" "${icons[index]}"
