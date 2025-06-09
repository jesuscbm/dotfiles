#!/usr/bin/env bash

SEP1=$'\x1d'  # Group separator between entries
SEP2=$'\x1e'  # Unit separator between timestamp and content
HISTFILE="$HOME/.cliphist"
NUMBER_OF_ENTRIES=30

# Read the file and split into entries by SEP1
IFS="$SEP1" read -d '' -ra entries < "$HISTFILE"

# Get the most recent entries first (reverse the array)
for ((i=${#entries[@]}-1, count=0; i>=0 && count<NUMBER_OF_ENTRIES; i--, count++)); do
    # Extract content after SEP2 (skip date)
    content=$(echo -n "${entries[i]#*$SEP2}" | tr '\n' '​')
    echo -e "$content"
done | rofi -dmenu -p "Clipboard" | tr '​' '\n' | xclip -selection clipboard

