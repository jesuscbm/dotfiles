#!/usr/bin/env bash
RET=$(cmus-remote -Q 2>/dev/null | awk '{ print $2 }' | head -1)
case "$RET" in
        "stopped")
                echo ""
                ;;
        "paused")
                echo ""
                ;;
        "playing")
                echo ""
                ;;
        *)
                echo "󰝛"
                ;;
esac
