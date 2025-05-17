if pgrep cmus; then
	cmus-remote --pause
else
	kitty --class cmus-term -e cmus &
fi
