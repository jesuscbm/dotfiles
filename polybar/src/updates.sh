#!/usr/bin/env bash
echo -n "%{F#00B19F} %{F-}"

updates=$((pacman -Qu 2> /dev/null) | wc -l 2> /dev/null)
updates=$((updates + $( (yay -Qu 2> /dev/null) | wc -l 2> /dev/null)))

if [ -z "$updates" ]; then
    echo -n "0"
else
    echo -n "$updates"
fi
