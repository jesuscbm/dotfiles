# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Colors (ANSI escape codes)
RESET='\[\e[0m\]'
FG_WHITE='\[\e[97m\]'
FG_CYAN='\[\e[36m\]'
FG_GREEN='\[\e[32m\]'
FG_YELLOW='\[\e[33m\]'
FG_RED='\[\e[31m\]'
BG_MAGENTA='\[\e[45m\]'
BG_BLUE='\[\e[44m\]'
BG_GREEN='\[\e[42m\]'
BG_RED='\[\e[41m\]'

BG_PURPLE='\[\e[48;5;127m\]'
BG_PINK='\[\e[48;5;164m\]'
BG_MAGENTA='\[\e[48;5;134m\]'
FG='\[\e[38;5;15m\]'
FG_PURPLE='\[\e[38;5;127m\]'
FG_PINK='\[\e[38;5;164m\]'
FG_MAGENTA='\[\e[38;5;134m\]'

# Git branch or venv
function branch_or_venv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo -e "󰌠 $(basename "$VIRTUAL_ENV")"
    elif git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        BRANCH=$(git branch --show-current)
        echo -e " $BRANCH"
    else
        echo -e "󰥔 $(date +%_H:%M | tr -d ' ')"
    fi
}

# Exit status indicator
function exit_status_symbol() {
    local EXIT=$?
    if [ "$EXIT" -eq 0 ]; then
        echo -e "${FG_CYAN} 󰣇 ${RESET}"
    else
        echo -e "${FG_RED} 󰣇 ${RESET}"
    fi
}

# Short PWD formatter
function short_pwd() {
    local path=$(pwd)
    local shortened=$(echo "$path" | awk -F/ '{if (NF>=2) printf ".../%s/%s", $(NF-1), $NF; else print $0}')
    echo "$shortened"
}

# Construct prompt
function set_bash_prompt() {
    local COLUMNS=$(tput cols)
    local PWD_LEN=${#PWD}
    local SHORT_PATH=$(short_pwd)
    local JOB_COUNT=$(jobs -p | wc -l)
    local STATUS=$(exit_status_symbol)
    local BRANCH=$(branch_or_venv)

    local PROMPT_LEFT=""
    if [ "$COLUMNS" -ge 60 ] && [ "$PWD_LEN" -lt $((COLUMNS - 38)) ]; then
	PROMPT_LEFT="${FG}${FG_PURPLE}${RESET}${BG_PURPLE}${FG} \u ${RESET}${BG_PINK}${FG_PURPLE}${RESET}${BG_PINK}${FG} \w ${RESET}"
    elif [ "$COLUMNS" -lt 60 ] && [ "$PWD_LEN" -lt "$COLUMNS" ]; then
        PROMPT_LEFT="${BG_PINK}${FG}${RESET}${BG_PINK}${FG} \w ${RESET}"
    elif [ "$COLUMNS" -ge 60 ]; then
        PROMPT_LEFT="${FG}${FG_PURPLE}${RESET}${BG_PURPLE}${FG} \u ${RESET}${BG_PINK}${FG_PURPLE}${RESET}${BG_PINK}${FG} $SHORT_PATH ${RESET}"
    else
        PROMPT_LEFT="${BG_PINK}${FG}${RESET}${BG_PINK}${FG} $SHORT_PATH ${RESET}"
    fi

    PS1="${PROMPT_LEFT}${BG_MAGENTA}${FG_PINK}${RESET}${BG_MAGENTA}${FG}${BRANCH}${RESET}${FG_MAGENTA}${RESET}\n${STATUS}${FG_CYAN}󰅂 ${RESET}"
}

PROMPT_COMMAND="set_bash_prompt"
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias tonto='echo no hablas de nacho, eso esta claro'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

eval "$(zoxide init bash)"
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

export PATH=$PATH:~/.custom_commands:/usr/local/texlive/2024/bin/x86_64-linux:~/jdk-23.0.2/bin:~/Documents/apache-maven-3.9.9/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# selection=$(echo "apt dragon-and-cow kangaroo pony-smaller turtle bud-frogs duck kiss ren tux bunny elephant koala sheep unipony calvin elephant-in-snake kosh skeleton unipony-smaller cheese eyes luke-koala snowman vader cock flaming-sheep mech-and-cow stegosaurus vader-koala cower fox milk stimpy www daemon ghostbusters moofasa suse default gnu moose three-eyes dragon hellokitty pony turkey" | cut -d " " -f $(($RANDOM % 47 + 1)))
#
# if [[ $(tput cols) -ge 70 ]]; then
#     if [[ $(($RANDOM % 2 )) -eq 1 ]]; then
# 	fortune | cowsay -f $selection   
#     else
# 	fortune | cowthink -f $selection   
#     fi
#     echo
# fi
