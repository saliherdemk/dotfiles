#!/usr/bin/env sh

cache_dir=${XDG_RUNTIME_DIR:-${XDG_CACHE_HOME:-"$HOME/.cache"}}
mkdir -p "$cache_dir" || exit 1
bus_cache="$cache_dir/waybar-brightness-bus"

detect_bus() {
    # shortcut: controls the first detected monitor; select explicitly for multiple monitors.
    I2C_BUS=$(ddcutil detect | grep -m1 -oP '(?<=I2C bus:  /dev/i2c-)\d+')
    case "$I2C_BUS" in
        ''|*[!0-9]*) return 1 ;;
    esac
    printf '%s\n' "$I2C_BUS" > "$bus_cache" || return 1
}

monitor_command() {
    I2C_BUS=$(cat "$bus_cache" 2>/dev/null)
    case "$I2C_BUS" in
        ''|*[!0-9]*) detect_bus || return 1 ;;
    esac
    if ddcutil --bus "$I2C_BUS" "$@"; then
        return 0
    fi
    detect_bus || return 1
    ddcutil --bus "$I2C_BUS" "$@"
}

get_brightness() {
    output=$(monitor_command getvcp 10 2>/dev/null) || {
        echo '{"error": "Unable to retrieve current brightness."}'
        exit 1
    }

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
        new_brightness=$((current_brightness + 5))
    elif [ "$direction" = "-" ]; then
        new_brightness=$((current_brightness - 5))
    else
        echo "{\"error\": \"Invalid direction. Use '+' or '-'.\"}"
        exit 1
    fi

    if [ "$new_brightness" -lt 0 ]; then
        new_brightness=0
    elif [ "$new_brightness" -gt 100 ]; then
        new_brightness=100
    fi

    monitor_command --sleep-multiplier 0.2 setvcp 10 "$new_brightness" || exit 1
}

if [ "$1" = "get" ]; then
    get_brightness
else
    adjust_brightness "$1"
    get_brightness 
fi
