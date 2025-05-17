#! /usr/bin/bash
chosen=$(printf "󰐥 Power Off\n Restart\n󰤄 Suspend\n Log out\n Lock" | rofi -dmenu -i -l 5 -p "")
case "$chosen" in 
	"󰐥 Power Off") shutdown now;;
	" Restart") reboot ;;
     "󰤄 Suspend") systemctl suspend ;;
    " Log out") pkill -15 bspwm;;
    " Lock") betterlockscreen -l ;;
	*) exit 1 ;;
esac
