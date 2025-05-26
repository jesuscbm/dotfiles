if pgrep mpd &> /dev/null; then
    rmpc togglepause
elif [ -z $(playerctl status 2> /dev/null) ]; then
    mpd &
    kitty --class rmpc -e rmpc &
else
    playerctl play-pause
fi
