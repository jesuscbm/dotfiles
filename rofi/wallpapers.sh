#!/usr/bin/env bash

WPFOLDER=$HOME/Downloads/.wallpaper/
images=$(find $WPFOLDER -type f)
options=""

for i in $images; do
    options+="$(basename $i)\x0icon\x1f$i\n"
done
# Remove trailing newline
options=${options::-2}

choice="$(echo -e $options | rofi -dmenu -i -p "Wallpaper" -theme ~/.config/rofi/imagepicker.rasi)" || exit 1

if [ -n "$choice" ]; then
    feh --bg-fill "$WPFOLDER$choice"
fi
