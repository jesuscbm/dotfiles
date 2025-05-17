# Zinit installer
if [[ ! -f ~/.zinit/bin/zinit.zsh ]]; then
  mkdir -p ~/.zinit
  git clone https://github.com/zdharma-continuum/zinit ~/.zinit/bin
fi

source ~/.zinit/bin/zinit.zsh
autoload -Uz compinit
compinit -D
# Plugins
# zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zdharma-continuum/zinit-annex-patch-dl
zinit light zdharma-continuum/zinit-annex-bin-gem-node
zinit light Aloxaf/fzf-tab
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

# User configuration

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR='nvim'

# autoload -U colors && colors

# Command prompt
precmd() {
    EXIT_STT=$?
    PWD_LENGTH=$((${#PWD}-8))
    SHORT_PWD=$(pwd | tr '/' ' ' | awk '{printf(".../%s/%s", $(NF-1), $(NF))}')

    PS1_NAME=$(if [[ $COLUMNS -ge 60 && $PWD_LENGTH -lt $(($COLUMNS - 38)) ]] then printf "%%F{087}%%n@%%M%%f:%%F{082}%%~%%f"; elif [[ $COLUMNS -lt 60 && $PWD_LENGTH -lt $COLUMNS ]]  then printf "%%F{082}%%~%%f" ;elif [[ $COLUMNS -ge 60 && $PWD_LENGTH -ge $(($COLUMNS - 38)) ]]; then printf "%%F{087}%%n@%%M%%f:%%F{082}%s%%f" $SHORT_PWD; else printf "%%F{082}%s%%f" $SHORT_PWD; fi)

    PS1_BRANCH=$(if [ -n "$VIRTUAL_ENV" ]; then printf "──[%%F{013}%s%%f]" $(basename "$VIRTUAL_ENV"); elif git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [[ $COLUMNS -ge 60 ]]; then printf "──[%%F{013}%s%%f]" $(git branch --show-current); elif [ $COLUMNS -ge 60 ]; then echo "──[%F{013}%T%f]"; fi)

    PS1_STATUS=$(if [[ $EXIT_STT -eq 0 ]]; then echo "%F{087}"; else echo "%F{009}"; fi)
    NEWLINE=$'\n'

    PROMPT=${debian_chroot:+($debian_chroot)}%F{015}┌──[%f$PS1_NAME%F{015}]%f$PS1_BRANCH$NEWLINE╰─$PS1_STATUS\$\ %f 

    # JOBS=$(if [[ $(jobs | wc -l) -gt 0 ]]; then printf "%%F{158}Jobs %%j%%f "; fi)
    JOBS="%F{117}Jobs: %j %f"

    BATLEVEL=$(cat /sys/class/power_supply/BAT1/capacity)
    if [ "$BATLEVEL" -ge 50 ]; then
	# Green to Yellow (154 to 190)
	BATCOLOR=$((154 + (190 - 154) * (100 - $BATLEVEL) / 50))
    else
	# Yellow to Red (190 to 196)
	BATCOLOR=$((190 + (196 - 190) * (50 - $BATLEVEL) / 50))
    fi
    BATTERY=%F{$BATCOLOR}Battery:\ $BATLEVEL%%%f 

    RPROMPT=$(if [[ $COLUMNS -ge 60 ]]; then echo $JOBS$BATTERY; fi)
}
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

# Alias
alias ll='lsd -l'
alias la='lsd -a'
alias l='lsd'
alias ls='lsd'
alias tonto='echo no hablas de nacho, eso esta claro'
alias givemeass='objdump -drwC -Mintel'
alias nv="nvim"
alias fullgrind='valgrind --leak-check=full -s --track-origins=yes'
alias pls=sudo
alias thanks='echo de nada'
alias greprec='grep -rn . -e'
alias kittyconf='nv ~/.config/kitty/kitty.conf'
alias py="python3.8"
alias heaviestfiles="sudo find / -type f -size +500M 2>/dev/null | xargs du -h | sort -hr | head -20"
alias brainrot="mpv --vo=kitty --really-quiet ~/.local/share/nvim/lazy/brainrot.nvim/brainrot.mp4"
alias image="kitty +kitten icat"
alias diffk="kitty +kitten diff"
alias myip="curl http://ipecho.net/plain; echo"
alias danisay="fortune | tr '\\n' ' ' | xargs -I{} -0 dsay \"{}\""
alias zotyalbum='zotify --output "new/{artist}/{album}/{track_number}-{artists} - {song_name}"'
alias lf='/home/jesuscbm/.config/lf/lf-kitty'
alias rt='trash'
alias rm='echo "Want to use rm and not rt? (y/N)" && read -r reply && [[ $reply == y ]] && rm -rf'
alias changewp='feh --bg-fill -z --recursive Downloads/.wallpapers2/'

# KEYBINDINGS
bindkey '\e[1;5C' forward-word  # Ctrl + Right Arrow
bindkey '\e[1;5D' backward-word # Ctrl + Left Arrow
bindkey '^H' backward-kill-word	# Ctrl + Basckspace
bindkey "^[[3~" delete-char	# Delete
bindkey "^[[3;5~" kill-word	# Ctrl + Delete

bindkey -e # emacs mode

#PATH variable
export PATH=$PATH:~/.custom_commands:/usr/local/texlive/2024/bin/x86_64-linux:~/jdk-23.0.2/bin:~/Documents/apache-maven-3.9.9/bin

# PLUGIN config
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=2"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# COWSAY at start (if wide enough)
selection=$(echo "actually alpaca beavis.zen blowfish bong bud-frogs bunny cheese cower cupcake daemon default dragon dragon-and-cow elephant elephant-in-snake eyes flaming-sheep fox ghostbusters head-in hellokitty kiss kitty koala kosh llama luke-koala mech-and-cow meow milk moofasa moose mutilated ren sheep skeleton small stegosaurus stimpy supermilker surgery sus three-eyes turkey turtle tux udder vader vader-koala www" | cut -d " " -f $(($RANDOM % 51 + 1)))

if [[ $COLUMNS -ge 70 ]]; then
	#    if [[ $(($RANDOM % 2 )) -eq 1 ]]; then
	# fortune | tr '\n' ' ' | cowsay -f $selection   
	#    else
	# fortune | tr '\n' ' ' | cowthink -f $selection   
	#    fi
    neofetch
    echo
fi

# ZOXIDE setup
eval "$(zoxide init zsh)"

# LF setup
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="librewolf"

export JAVA_HOME=/home/jesuscbm/jdk-23.0.2
export PATH=$JAVA_HOME/bin:$PATH

# Created by `pipx` on 2025-05-17 01:22:11
export PATH="$PATH:/home/jesus/.local/bin"
