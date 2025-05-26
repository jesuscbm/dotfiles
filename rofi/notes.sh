#!/usr/bin/env bash

FOLDER="$HOME/Documents/Notes/"
options=$(printf "New note\nDelete note\n%s" "$(ls -t "$FOLDER" | grep "md$")")

choice=$(<<< "$options" rofi -dmenu -l 6 -p "Notes" )

if [ -z "$choice" ]; then
    exit 1
fi
if [[ "$choice" == "New note" ]]; then
    notename="$(rofi -dmenu -p "Name of note" -l 2 < /dev/null)" || exit 1
    if [ -z "$notename" ]; then
	notename="$(date +"%d-%m-%y %H:%M")"
    fi
    choice="$notename.md"
fi

if [[ "$choice" == "Delete note" ]]; then
    choice=$(<<< "$(ls -t "$FOLDER" | grep "md$")" rofi -dmenu -l 6 -p "Delete note" )
    if [ -z "$choice" ]; then
	exit 1
    fi
    rm "$FOLDER""$choice"
    exit 0
fi
kitty -e nvim "$FOLDER""$choice"
