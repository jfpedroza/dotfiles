#!/bin/bash

capacity=$(cat /sys/class/power_supply/BAT0/capacity)

if [ "$1" = "color" ]; then
    if [ "$capacity" -gt 15 ]; then
        echo "colour76"
    else
        echo "red"
    fi
else
    echo $capacity
fi

