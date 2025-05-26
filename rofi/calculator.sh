#!/usr/bin/env bash

text=$((dmenu -nb \#1a1b26 -nf \#c0caf5 -sb \#bb9af7 -sf \#15161e -i -fn 'FiraCode Nerd Font:size=11' -p "Calculator" < /dev/null || exit 1) | bc -l )

if [ -z "$text" ]; then
    exit 1
fi
text=$(printf "%.2f\n" "$text")

notify-send "Calculator" "$text" -r 72364
