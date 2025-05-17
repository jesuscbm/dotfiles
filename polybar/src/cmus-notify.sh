#!/usr/bin/env bash

declare -A dict

args=("$@")

for ((i=0; i<$#; i+=2)); do
    key=${args[$i]}
    val=${args[$((i+1))]}
    dict[$key]=$val
done

icon=""
case ${dict[status]} in
    "playing")
        icon=""
        ;;
    "paused")
        icon=""
        ;;
    "stopped")
        icon=""
        ;;
esac

# Check if there exists an image for the album
if [[ -n "${dict[file]}" ]]; then
    folder="$(dirname "${dict[file]}")"
    
    image=$(find "$folder" -maxdepth 1 -iname "*.png" | head -n 1)

    if [[ -z "$image" ]]; then
        image=$(find "$folder" -maxdepth 1 -iname "*.jpg" | head -n 1)
    fi

    if [[ -z "$image" ]]; then
        image="$HOME/.config/polybar/src/assets/infacto.png"  # fallback
    fi
fi


title="$icon"
text=""

if [[ -n "${dict[title]}" ]] && [[ -n "${dict[artist]}" ]]; then
    title+="  ${dict[title]} - ${dict[artist]}"
else
    title+="  ${dict[file]}"
fi

if [[ -n "${dict[album]}" ]] && [[ -n "${dict[tracknumber]}" ]]; then
    text+="${dict[album]} - ${dict[tracknumber]}"
fi

if [[ -n "${dict[duration]}" ]]; then
    minutes=$((${dict[duration]} / 60))
    seconds=$((${dict[duration]} % 60))
    text+="\n  󱎫  $minutes:$(printf '%02d' "$seconds")"
fi


notify-send -a "cmus" -r 777 -i "$image" "$title" "$text"

# status: paused
# file: /home/jesus/Music/Zotify Albums/alt-J/An Awesome Wave (Deluxe Version)/04-alt-J - Breezeblocks.ogg
# artist: alt-J
# albumartist: alt-J
# album: An Awesome Wave (Deluxe Version)
# tracknumber: 4
# title: Breezeblocks
# date: 2012
# duration: 227
