# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# plugins=(
#     zsh-autosuggestions
#     git
#     extract 
#     web-search 
#     yum 
#     git-extras 
#     docker 
#     vagrant
# )
#
# source $ZSH/oh-my-zsh.sh
#
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

autoload -U colors && colors


# Command prompt
precmd() {
    EXIT_STT=$?
    PWD_LENGTH=$((${#PWD}-8))
    SHORT_PWD=$(pwd | tr '/' ' ' | awk '{printf(".../%s/%s", $(NF-1), $(NF))}')

    PS1_NAME=$(if [[ $COLUMNS -ge 60 && $PWD_LENGTH -lt $(($COLUMNS - 38)) ]] then printf "%%F{087}%%n@%%M%%f:%%F{082}%%~%%f"; elif [[ $COLUMNS -lt 60 && $PWD_LENGTH -lt $COLUMNS ]]  then printf "%%F{082}%%~%%f" ;elif [[ $COLUMNS -ge 60 && $PWD_LENGTH -ge $(($COLUMNS - 38)) ]]; then printf "%%F{087}%%n@%%M%%f:%%F{082}%s%%f" $SHORT_PWD; else printf "%%F{082}%s%%f" $SHORT_PWD; fi)

    PS1_BRANCH=$(if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && [[ $COLUMNS -ge 60 ]]; then printf "──[%%F{013}%s%%f]" $(git branch --show-current); elif [ $COLUMNS -ge 60 ]; then echo "──[%F{013}%T%f]"; fi)

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
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
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
alias rm='echo Want to use rm and not rt? (y/N)" && read -r reply && [[ $reply == y ]] && rm -rf'

# KEYBINDINGS
bindkey '\e[1;5C' forward-word  # Ctrl + Right Arrow
bindkey '\e[1;5D' backward-word # Ctrl + Left Arrow
bindkey '^H' backward-kill-word	# Ctrl + Basckspace

#PATH variable
export PATH=$PATH:~/.custom_commands:/usr/local/texlive/2024/bin/x86_64-linux:~/jdk-23.0.2/bin:~/Documents/apache-maven-3.9.9/bin

# PLUGIN config
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=2"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# COWSAY at start (if wide enough)
selection=$(echo "apt dragon-and-cow kangaroo pony-smaller turtle bud-frogs duck kiss ren tux bunny elephant koala sheep unipony calvin elephant-in-snake kosh skeleton unipony-smaller cheese eyes luke-koala snowman vader cock flaming-sheep mech-and-cow stegosaurus vader-koala cower fox milk stimpy www daemon ghostbusters moofasa suse default gnu moose three-eyes dragon hellokitty pony turkey" | cut -d " " -f $(($RANDOM % 47 + 1)))

if [[ $COLUMNS -ge 70 ]]; then
    if [[ $(($RANDOM % 2 )) -eq 1 ]]; then
	fortune | tr '\n' ' ' | cowsay -f $selection   
    else
	fortune | tr '\n' ' ' | cowthink -f $selection   
    fi
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
