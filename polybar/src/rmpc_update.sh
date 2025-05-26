#!/usr/bin/env bash
if pgrep mpd &> /dev/null; then
        RET=$((rmpc status 2>/dev/null) | head -n 1)
        if [[ "$RET" == *'"state":"Play"'* ]]; then
            echo ""
        elif [[ "$RET" == *'"state":"Pause"'* ]]; then
            echo ""
        else
            echo ""
        fi
elif playerctl status &> /dev/null; then
    RET=$(playerctl status 2>/dev/null)
    case "$RET" in
        "Stopped")
            echo ""
            ;;
        "Paused")
            echo ""
            ;;
        "Playing")
            echo ""
            ;;
        *)
            echo "󰝛"
            ;;
    esac
else
        echo "󰝛"
fi
