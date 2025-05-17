#!/usr/bin/env bash
echo -n "%{F#00B19F} %{F-}"

updates=$(pacman -Qu | wc -l)
updates=$((updates + $(yay -Qu | wc -l)))

if [ -z "$updates" ]; then
    echo -n "0"
else
    echo -n "$updates"
fi
