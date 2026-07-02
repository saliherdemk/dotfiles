#!/bin/bash

STATE_FILE="/tmp/hypr-submap"

LOCK=$''    
UNLOCK=$''

STATE=$(cat "$STATE_FILE" 2>/dev/null)

if [ "$STATE" == "$LOCK" ]; then
    hyprctl dispatch submap reset
    echo "$UNLOCK" > "$STATE_FILE"
else
    hyprctl dispatch submap gaming
    echo "$LOCK" > "$STATE_FILE"
fi
