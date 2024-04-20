#!/bin/bash

# Get the default sink
default_sink=$(pactl info | grep 'Default Sink' | cut -d ' ' -f3)

# Get the current volume level
current_volume=$(pactl list sinks | grep -A 15 'Name: '$default_sink | grep 'Volume: front-left:' | awk '{print $5}' | sed 's/%//')

# Check if the volume is beyond 150%
if [ $current_volume -ge 150 ]; then
    echo "Volume is at the maximum limit of 150%"
else
    # If volume is within limits, just increase it by 5%
    pactl set-sink-volume $default_sink +5%
    # Check if the volume is beyond 150% after increasing
    current_volume=$(pactl list sinks | grep -A 15 'Name: '$default_sink | grep 'Volume: front-left:' | awk '{print $5}' | sed 's/%//')
    if [ $current_volume -gt 150 ]; then
        pactl set-sink-volume $default_sink 150%
    fi
fi
