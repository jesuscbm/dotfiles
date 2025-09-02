# zmodload zsh/zprof
# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi
source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

source ~/.lscolors
LSCOLORS=$(vivid generate tokyonight-night)

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;
# cmp opts
zstyle ':completion:*' menu select # tab opens cmp menu
zstyle ':completion:*' special-dirs true # force . and .. to show in cmp menu
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33 # colorize cmp menu
# zstyle ':completion:*' file-list true # more detailed list
zstyle ':completion:*' squeeze-slashes false # explicit disable to allow /*/ expansion

autoload -U colors && colors

# Plugins
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load Aloxaf/fzf-tab
zstyle ':completion:*:git-checkout:*' sort false
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'

# User configuration

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_ALL_DUPS
HISTCONTROL=ignoreboth # consecutive duplicates & commands starting with space are not saved

# fzf
source <(fzf --zsh) # allow for fzf history widget

# main opts
setopt append_history inc_append_history share_history # better history
# on exit, history appends rather than overwrites; history is appended as soon as cmds executed; history shared across sessions
setopt auto_menu menu_complete # autocmp first menu match
setopt autocd # type a dir to cd
setopt auto_param_slash # when a dir is completed, add a / instead of a trailing space
setopt no_case_glob no_case_match # make cmp case insensitive
setopt globdots # include dotfiles
setopt extended_glob # match ~ # ^
setopt interactive_comments # allow comments in shell
unsetopt prompt_sp # don't autoclean blanklines
stty stop undef # disable accidental ctrl s

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR='nvim'

# autoload -U colors && colors

# Command prompt
precmd() {
    EXIT_STT=$?
    PWD_LENGTH=$((${#PWD}-12))
    SHORT_PWD=$(pwd | tr '/' ' ' | awk '{printf(".../%s/%s", $(NF-1), $(NF))}')

    FIRSTBGCOLOR=127
    FIRSTFGCOLOR=15
    SECONDBGCOLOR=164
    SECONDFGCOLOR=15
    THIRDBGCOLOR=134
    THIRDFGCOLOR=15
    ERRORCOLOR=red
    OKCOLOR=cyan

    PS1_NAME=$(if [[ $COLUMNS -ge 60 && $PWD_LENGTH -lt $(($COLUMNS - 38)) ]] then printf "%%F{$FIRSTBGCOLOR}%%f%%K{$FIRSTBGCOLOR}%%F{$FIRSTFGCOLOR} %%n %%f%%F{$FIRSTBGCOLOR}%%K{$SECONDBGCOLOR}%%f%%k%%K{$SECONDBGCOLOR}%%F{$SECONDFGCOLOR} %%~ %%f%%k"; elif [[ $COLUMNS -lt 60 && $PWD_LENGTH -lt $COLUMNS ]]  then printf "%%F{$SECONDBGCOLOR}%%f%%K{$SECONDBGCOLOR}%%F{$SECONDFGCOLOR} %%~ %%f%%k" ;elif [[ $COLUMNS -ge 60 && $PWD_LENGTH -ge $(($COLUMNS - 38)) ]]; then printf "%%F{$FIRSTBGCOLOR}%%f%%K{$FIRSTBGCOLOR}%%F{$FIRSTFGCOLOR} %%n %%f%%F{$FIRSTBGCOLOR}%%K{$SECONDBGCOLOR}%%f%%k%%K{$SECONDBGCOLOR}%%F{$SECONDFGCOLOR} %s %%f%%k" $SHORT_PWD; else printf "%%F{$SECONDBGCOLOR}%%f%%K{$SECONDBGCOLOR}%%F{$SECONDFGCOLOR} %s%%f%%k" $SHORT_PWD; fi)

    PS1_BRANCH=$(if [ -n "$VIRTUAL_ENV" ]; then printf "󰌠 %s" $(basename "$VIRTUAL_ENV"); elif git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [[ $COLUMNS -ge 60 ]]; then printf " %s" $(git branch --show-current); elif [ $COLUMNS -ge 60 ]; then echo "󰥔 %T"; fi)

    PS1_STATUS=$(if [[ $EXIT_STT -eq 0 ]]; then echo "%F{$OKCOLOR} 󰣇 %f"; else echo "%F{$ERRORCOLOR} 󰣇 %f"; fi)

    PS1_INCOGNITO="$(if [[ -z $HISTFILE ]]; then echo "%F{$THIRDBGCOLOR} 󰗹%f"; fi)"
    NEWLINE=$'\n'

    PROMPT=${debian_chroot:+($debian_chroot)}$PS1_NAME%F{015}%F{$SECONDBGCOLOR}%K{$THIRDBGCOLOR}%f%F{$THIRDFGCOLOR}$PS1_BRANCH%f%k%F{$THIRDBGCOLOR}%f$PS1_INCOGNITO$NEWLINE$PS1_STATUS%F{cyan}󰅂%f\ 

    JOBS="%F{117}Jobs: %j %f"

    BATLEVEL=$(cat /sys/class/power_supply/BAT0/capacity)
    if [ "$BATLEVEL" -ge 60 ]; then
	BATCOLOR=cyan
    elif [ "$BATLEVEL" -ge 40 ]; then
	BATCOLOR=green
    elif [ "$BATLEVEL" -ge 20 ]; then
	BATCOLOR=yellow
    else
	BATCOLOR=red
    fi
    BATTERY=%F{$BATCOLOR}Battery:\ $BATLEVEL%%%f 

    RPROMPT=$(if [[ $COLUMNS -ge 60 ]]; then echo $JOBS$BATTERY; fi)
}
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

lfcd () {
    # `command` is needed in case `lfcd` is aliased to `lf`
    cd "$(command lf -print-last-dir "$@")"
}
# Alias

alias lf='lfcd'
alias ll='exa -l'
alias la='exa -a'
alias l='exa'
alias ls='exa'
alias tonto='echo no hablas de nacho, eso esta claro'
alias givemeass='objdump -drwC -Mintel'
alias nv="nvim"
alias v="nvim"
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
alias rt='trash'
alias rm='echo "Want to use rm and not rt? (y/N)" && read -r reply && [[ $reply == y ]] && rm -rf'
alias changewp='feh --bg-fill -z --recursive Downloads/.wallpapers2/'
alias dmenu="dmenu -nb #1a1b26 -nf #c0caf5 -sb #bb9af7 -sf #15161e -i -fn 'FiraCode Nerd Font:size=11'"
alias c=clear
alias g=git
alias incognito="if [[ -z \$HISTFILE ]]; then HISTFILE=$HISTFILE; else unset HISTFILE; fi"

# KEYBINDINGS
# zle -al to see all keybindings
bindkey '\e[1;5C' forward-word  # Ctrl + Right Arrow
bindkey '\e[1;5D' backward-word # Ctrl + Left Arrow
bindkey '^H' backward-kill-word	# Ctrl + Basckspace
bindkey "^[[3~" delete-char	# Delete
bindkey "^[[3;5~" kill-word	# Ctrl + Delete

bindkey -e # emacs mode

#PATH variable
export PATH=$PATH:~/.custom_commands

# PLUGIN config
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=2"

# COWSAY at start (if wide enough)
# selection=$(echo "actually alpaca beavis.zen blowfish bong bud-frogs bunny cheese cower cupcake daemon default dragon dragon-and-cow elephant elephant-in-snake eyes flaming-sheep fox ghostbusters head-in hellokitty kiss kitty koala kosh llama luke-koala mech-and-cow meow milk moofasa moose mutilated ren sheep skeleton small stegosaurus stimpy supermilker surgery sus three-eyes turkey turtle tux udder vader vader-koala www" | cut -d " " -f $(($RANDOM % 51 + 1)))
#
# if [[ $COLUMNS -ge 70 ]]; then
# 	#    if [[ $(($RANDOM % 2 )) -eq 1 ]]; then
# 	# fortune | tr '\n' ' ' | cowsay -f $selection   
# 	#    else
# 	# fortune | tr '\n' ' ' | cowthink -f $selection   
# 	#    fi
#     fastfetch
#     echo
# fi

# ZOXIDE setup
eval "$(zoxide init zsh)"

# Enviroment variables
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="librewolf"
export MANPAGER='nvim +Man!'

# export JAVA_HOME=/home/jesus/jdk-23.0.2
# export PATH=$JAVA_HOME/bin:$PATH

# Created by `pipx` on 2025-05-17 01:22:11
export PATH="$PATH:/home/jesus/.local/bin"

# pyenv asqueroso
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"

# zprof
