#!/bin/bash

if [ -f /sys/class/power_supply/BAT0/capacity ]; then
    capacity=$(cat /sys/class/power_supply/BAT0/capacity)
elif [ -f /sys/class/power_supply/BAT1/capacity ]; then
    capacity=$(cat /sys/class/power_supply/BAT1/capacity)
fi

if [ "$1" = "color" ]; then
    if [ "$capacity" -gt 15 ]; then
        echo "colour76"
    else
        echo "red"
    fi
else
    echo "$capacity"
fi
