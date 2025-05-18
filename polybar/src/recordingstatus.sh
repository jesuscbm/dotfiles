#!/usr/bin/env bash
if [ ! -z $(pgrep -f "ffmpeg.*x11grab") ]; then
    echo "󰑊"
else 
    echo "󰻃"
fi
