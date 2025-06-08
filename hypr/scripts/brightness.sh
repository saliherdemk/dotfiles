#!/usr/bin/env sh

I2C_BUS=8 

get_brightness() {
    output=$(ddcutil --bus "$I2C_BUS" getvcp 10 2>/dev/null)

    if echo "$output" | grep -q "current value"; then
        current_brightness=$(echo "$output" | grep -oP '(?<=current value = )\s*\d+')
        current_brightness=$(echo "$current_brightness" | xargs)
        
        if [ "$current_brightness" -ge 75 ]; then
            icon="󰃠" 
        elif [ "$current_brightness" -ge 50 ]; then
            icon="󰃟" 
        elif [ "$current_brightness" -ge 25 ]; then
            icon="󰃝" 
        else
            icon="󰃞"
        fi

        echo "{\"text\":\"$icon\",\"tooltip\":\"Brightness: $current_brightness %\"}"
    else
        echo "{\"error\": \"Unable to retrieve current brightness.\"}"
        exit 1
    fi
}

adjust_brightness() {
    direction="$1"
    current_brightness=$(get_brightness | grep -oP '(?<=\"tooltip\":\"Brightness: )\d+')

    if [ $? -ne 0 ]; then
        exit 1
    fi

    if [ "$direction" = "+" ]; then
        new_brightness=$((current_brightness + 10)) 
    elif [ "$direction" = "-" ]; then
        new_brightness=$((current_brightness - 10))  
    else
        echo "{\"error\": \"Invalid direction. Use '+' or '-'.\"}"
        exit 1
    fi

    if [ "$new_brightness" -lt 0 ]; then
        new_brightness=0
    elif [ "$new_brightness" -gt 100 ]; then
        new_brightness=100
    fi

    ddcutil --bus "$I2C_BUS" --sleep-multiplier 0.2 setvcp 10 "$new_brightness"
}

if [ "$1" = "get" ]; then
    get_brightness
else
    adjust_brightness "$1"
    get_brightness 
fi

