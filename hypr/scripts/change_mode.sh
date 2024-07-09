#!/bin/bash

# File to store the current state
STATE_FILE="/tmp/hypr-submap"

# Check if the state file exists and read its value
if [ -f "$STATE_FILE" ]; then
    STATE=$(cat "$STATE_FILE")
else
    STATE=""
fi

# Toggle the state
if [ "$STATE" == "" ]; then
    hyprctl dispatch submap reset
    STATE=""
else
    hyprctl dispatch submap gaming
    STATE=""
fi

# Save the new state to the file
echo "$STATE" > "$STATE_FILE"
