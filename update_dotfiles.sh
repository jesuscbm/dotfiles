#!/bin/bash

DOTFILES="$HOME/.zshrc $HOME/.lscolors $HOME/.bashrc $HOME/.clang-format $HOME/.gitconfig $HOME/.Xresources $HOME/.gtkrc-2.0"
DOTDIRS="$HOME/.custom_commands $HOME/.config/zotify $HOME/.config/nvim $HOME/.config/kitty $HOME/.config/bspwm $HOME/.config/picom $HOME/.config/polybar $HOME/.config/dunst $HOME/.config/cmus $HOME/.config/gsimplecal $HOME/.config/btop $HOME/.config/lf $HOME/.config/rofi $HOME/.config/gtk-2.0 $HOME/.config/gtk-3.0 $HOME/.config/gtk-4.0 $HOME/.config/neofetch $HOME/.config/fastfetch $HOME/.config/cava $HOME/.config/rmpc/ $HOME/.config/mpd"

for i in $DOTFILES; do
	echo "Copying $(basename $i) file"
	rsync -av $i .
done

for i in $DOTDIRS; do
	dest="./$(basename "$i")"
	echo "Copying $(basename $i) directory"
	rsync --specials -r --delete "$i"/ $dest
	if [[ -e "./$(basename $i)/.git" ]]; then
		echo "Deleting $(basename $i)/.git"
		rm -rf "$(basename $i)/.git"
	fi
done

pacman -Qqe > paquetes.txt

rm ./zotify/credentials.json 2> /dev/null
rm -rf ./polybar/src/venv 2> /dev/null
