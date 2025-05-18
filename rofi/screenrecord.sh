#!/usr/bin/env bash

RECORD_PID_FILE="/tmp/screenrec.pid"
RESOLUTION="1366x768"
FPS="30"
OUTPUT_DIR="$HOME/Videos"

start_recording() {
    mkdir -p "$OUTPUT_DIR"
    filename="$OUTPUT_DIR/recording_$(date +%s).mp4"

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

menu="Start recording\nStop recording"

choice=$(echo -e "$menu" | rofi -dmenu -i -l 2 -p "Screen Recorder")

case "$choice" in
    "Start recording") start_recording ;;
    "Stop recording") stop_recording ;;
    *) exit 0 ;;
esac
