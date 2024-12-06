#!/bin/bash

updates=$(checkupdates)

update_count=$(checkupdates | wc -l)

if [ "$update_count" -gt 0 ]; then
    tooltip=$(echo "$updates" | sed 's/"/\\"/g' | sed ':a;N;$!ba;s/\n/\\n/g')

    echo "{\"text\":\"$update_count 󱑤\",\"tooltip\":\"$tooltip\"}"
else
    echo ""
fi

