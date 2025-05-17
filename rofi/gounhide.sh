#!/bin/env bash

ids=($(bspc query -N -n .hidden.window)) || exit
options="$(xtitle "${ids[@]}")"

id_index="$(<<< "$options" rofi -dmenu -format i -p "Unhide window")"
if [ -z "$id_index" ]; then
    exit 1
fi
bspc node "${ids[${id_index}]}" -g hidden=off -f
