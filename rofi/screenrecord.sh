#!/usr/bin/env bash

RECORD_PID_FILE="/tmp/screenrec.pid"
RESOLUTION="1366x768"
FPS="30"
VIDEO_OUTPUT_DIR="$HOME/Videos"
IMAGE_OUTPUT_DIR="$HOME/Pictures/Screenshots"

start_recording() {
    mkdir -p "$VIDEO_OUTPUT_DIR"
    filename = "$VIDEO_OUTPUT_DIR/$1.mp4"
    ffmpeg -y -video_size "$RESOLUTION" -framerate "$FPS" -f x11grab -i :0.0 "$filename" > /dev/null 2>&1 &
    echo $! > "$RECORD_PID_FILE"
    notify-send "FFmpeg" "Screen recording started"
}

stop_recording() {
    if [[ -f "$RECORD_PID_FILE" ]]; then
        pid=$(cat "$RECORD_PID_FILE")
        kill "$pid" && rm "$RECORD_PID_FILE"
        notify-send "FFmpeg" "Screen recording stopped"
    else
        notify-send "FFmpeg" "No recording process found"
    fi
}

take_screenshot() {
    IMAGE_OUTPUT_DIR="$HOME/Pictures/Screenshots"

    filename="$IMAGE_OUTPUT_DIR/screenshot_$(date +%d-%m-%y_%H:%M:%S)"
    sep = ""
    i = ""
    while [ -e $filename$sep$i ]; do
        sep="#"
        [ -n $i ] && i=$(( $i + 1 ))
        [ -z $i ] && i=1
    done
    filename="$filename$sep$i.png"

    scrot "$@" "$filename" && xclip -selection clipboard -t image/png "$filename" 
    notify-send -i "$filename" "Screenshot" "Screenshot saved to $filename and copied to clipboard" -r 923
}

menu="Fullscreen screenshot\nWindow screenshot\nRegion screenshot\nStart recording\nStop recording"

choice=$(echo -e "$menu" | rofi -dmenu -i -l 5 -p "Capture screen")


case "$choice" in
    "Fullscreen screenshot") take_screenshot ;;
    "Window screenshot") take_screenshot --focused ;;
    "Region screenshot") take_screenshot "-s -f" ;;
    "Start recording") start_recording $filename ;;
    "Stop recording") stop_recording $filename ;;
    *) exit 0 ;;
esac
