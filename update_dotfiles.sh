#!/bin/bash

DOTFILES="$HOME/.zshrc $HOME/.bashrc $HOME/.clang-format $HOME/.gitconfig"
DOTDIRS="$HOME/Downloads/.wallpaper/ $HOME/.custom_commands/ $HOME/.config/zotify/ $HOME/.config/lf/ $HOME/.config/nvim/ $HOME/.config/kitty/ $HOME/.config/xfce4/ $HOME/.config/bspwm "

for i in $DOTFILES; do
	echo "Copying $(basename $i) file"
	cp $i -t .
done

for i in $DOTDIRS; do
	echo "Copying $(basename $i) directory"
	rsync --specials -r --delete $i $(basename $i)
	if [[ -e "./$(basename $i)/.git" ]]; then
		echo "Deleting $(basename $i)/.git"
		rm -rf "$(basename $i)/.git"
	fi
done


rm ./zotify/credentials.json
