#!/usr/bin/env bash

SCROLLFILE="/tmp/rmpc_scroll"
SCROLLWIDTH=15
STEP=2

print_mpd_status() {
        RET=$(rmpc status 2>/dev/null | head -n 1)
        if [[ "$RET" == *'"state":"Play"'* ]]; then
            echo -n " "
        elif [[ "$RET" == *'"state":"Pause"'* ]]; then
            echo -n " "
        else
            echo -n " "
            exit
        fi
}

print_playerctl_status() {
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
}

print_scroll_text() {
    local text="$1"
    local pos="$2"
    local len="${#text}"

    if (( pos >= len )); then
        pos=0
    fi

    if (( pos + SCROLLWIDTH > len )); then
        local part1="${text:pos}"
        local part2="${text:0:SCROLLWIDTH - (len - pos)}"
        echo -n "$part1$part2"
    else
        echo -n "${text:pos:SCROLLWIDTH}"
    fi
}

print_mpd_text() {
    RET=$(rmpc song 2>/dev/null | head -n 1)
    title="$(echo "$RET" | grep -o '"title":"[^"]*"' | cut -d':' -f2- | tr -d '"')"
    artist="$(echo "$RET" | grep -o '"albumartist":"[^"]*"' | cut -d':' -f2- | tr -d '"')"
    text="${title} - ${artist}  "
    echo "$text"
}

if pgrep mpd &> /dev/null; then
    print_mpd_status

    text="$(print_mpd_text)"

    # get current length and position
    if [ -f "$SCROLLFILE" ]; then
        mapfile -t args < "$SCROLLFILE"
        POSITION="${args[0]}"
        LENGTH="${args[1]}"
    fi

    if (( ${#text} <= SCROLLWIDTH )); then
        echo -n "$text"
        exit 0
    fi

    if [[ "${#text}" == "$LENGTH" ]]; then
        # If length matches to our current text's, we scroll
        POSITION=$(( ($POSITION + STEP) % $LENGTH ))
        print_scroll_text "$text" $POSITION
        echo $POSITION > "$SCROLLFILE"
        echo ${#text} >> "$SCROLLFILE"
    else
        # If it doesn't, we start from the beginning
        echo 0 > "$SCROLLFILE"
        echo ${#text} >> "$SCROLLFILE"
        print_scroll_text "$text" 0
    fi

elif playerctl status &> /dev/null; then
    print_playerctl_status
else
    echo "󰝛"
fi
