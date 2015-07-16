fpath=(~/.zsh/Completion $fpath)

HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=5000

# zsh options; man zshoptions
setopt sharehistory
setopt histignoredups
setopt histignorealldups
setopt histfindnodups
setopt histignorespace

setopt extendedglob
setopt notify
setopt correct
setopt interactivecomments
setopt multios

setopt autocd
setopt autopushd
setopt pushdignoredups
setopt pushdsilent

setopt autolist
unsetopt listambiguous

setopt listpacked
setopt listtypes

unsetopt flowcontrol
unsetopt beep

bindkey -e
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^[[Z' reverse-menu-complete
bindkey '^[/' undo

# configure zsh's autocompletion system; man zshcompsys
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ':completion:*' completer _expand _complete _match _approximate
zstyle ':completion:*' matcher-list '+' '+m:{[:lower:]}={[:upper:]}' '+r:|[._-]=** r:|=**' '+l:|=* r:|=*'
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' ignore-parents parent pwd
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' expand suffix
zstyle ':completion:*:kill:*' command 'ps -u$USER'

zstyle ':completion::expand:*' tag-order 'expansions all-expansions'
zstyle ':completion:*' remove-all-dups true
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%B%d:%b'
zstyle ':completion:*' verbose true
zstyle ':completion:*' file-sort access
zstyle ':completion:*' list-colors no=00 fi=00 di=01\;34 pi=33 so=01\;35 bd=00\;35 cd=00\;34 or=00\;41 mi=00\;45 ex=01\;32
zstyle ':completion:*' menu 'select=0'
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''

zstyle ':completion:*' insert-tab false
zstyle ':completion:*' prompt ''\''%e'\'''
zstyle ':completion:*:manuals' separate-sections true

autoload -Uz compinit
compinit

# Initialize prompt
autoload -Uz promptinit
promptinit
prompt adam2

# Show which git-branch we are in
function precmd() {
#    if [ -d .git ]; then
     if git rev-parse --is-inside-git-dir > /dev/null 2>&1; then
      RPROMPT='%F{yellow}['
      RPROMPT=$RPROMPT''`git symbolic-ref HEAD 2> /dev/null | cut -b 12-`']'
    else
      RPROMPT=''
    fi;
}

#PS1="%~$ "
#export MOZ_NO_REMOTE=1

### Aliases
##### EXPORT SCREEN ALIAS #########
alias xin='xrandr --output LVDS1 --auto --output VGA1 --off '
alias xoutl='xrandr --output VGA1 --mode 1920x1080 --left-of LVDS1'
alias xoutr='xrandr --output VGA1 --mode 1920x1080 --right-of LVDS1'
alias gsm='gnome-system-monitor &'
alias gcl='gnome-control-center &'

################################
alias dirs="dirs -v"
alias emacs="emacs -nw"
alias mp='mplayer'
alias df='df -h'
alias du='du -hs'

alias la='ls -aG --color'
alias ll='ls -lhG --color'
alias ls='ls -G --color'
alias lsr='ls -lrt -G --color'
alias l='ls -G --color'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias grep='grep --color -E'
alias bat='upower -i /org/freedesktop/UPower/devices/battery_BAT0| grep -E "state|to\ full|percentage" | xargs -0 notify-send'

alias info='info --vi-keys'

alias pi='sudo aptitude install'
alias pr='sudo aptitude remove'
alias pp='sudo aptitude purge'
alias pud='sudo aptitude update'
alias pug='sudo aptitude safe-upgrade'
alias pufg='sudo aptitude full-upgrade'
alias pse='aptitude search'
alias psh='aptitude show'

alias halt='sudo shutdown -h now'
alias reboot='sudo reboot'

alias e='emacsclient -n'

alias -g ack='ack-grep'
alias -g G='| grep'
alias -g L='| less'

alias sz='source ~/.zshrc'
alias ez='e ~/.zshrc'

alias sshr="ssh -p $srp $sr"

alias entertain='mplayer "$(find "." -type f -regextype posix-egrep -regex ".*\.(avi|mkv|flv|mpg|mpeg|mp4|wmv|3gp|mov|divx)" | shuf -n1)"'
alias rand='tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"'

alias aaw="cd ~/work/ad-aggregator-web"
alias aai="cd ~/work/ad-aggregator-infra"
alias aad="cd ~/work/ad-aggregrator-doc"
alias aag="cd ~/work/ad-aggregator"
alias pmp="cd ~/workspace/pmpowertool/WebContent/"
function qa {
  ssh ggarg@qa$1.kiwiup.com -p $2
}

function vol {
    pactl set-sink-volume 0 $1%
}

### Exports
export PKG_CONFIG_PATH=/home/yeban/opt/lib/pkgconfig/:${PKG_CONFIG_PATH}

export PYTHONSTARTUP=$HOME/.pythonrc
export RSENSE_HOME=/home/yeban/opt/rsense-0.3
#export PATH=$PATH:/$HOME/opt/ncbi-blast/bin

export _JAVA_AWT_WM_NONREPARENTING=1

s() { find . -iname "*$@*" }

# precmd() {
#     # reset LD_PRELOAD that might have been set in preexec()
#     export LD_PRELOAD=''

#     # send a visual bell to awesome
#     echo -ne '\a'

#     # set cwd in terminals
#     case $TERM in
#         xterm|rxvt|rxvt-unicode|screen)
#             print -Pn "\e]2;%d\a"
#             ;;
#     esac

#     # for autojump
#     z --add "$(pwd -P)"
# }

preexec () {
    local command=${(V)1//\%\%\%}
    local first=${command%% *}

    # set terminal's title to the currently executing command
    case $TERM in
        xterm|rxvt|rxvt-unicode|screen)
            command=$(print -Pn "%40>...>$command" | tr -d "\n")
            print -Pn "\e]2;$command\a"
            ;;
    esac

    # automatically use proxychains for git, bzr, and ssh
#     case $first in
#         git|bzr|ssh)
#             export LD_PRELOAD=libproxychains.so.3
#             ;;
#     esac
}

# Set default working directory of tmux to the given directory; use the current
# working directory if none given.
#
# TODO: this does not honour .rvmrc
cdt(){
    [[ -n "$1" ]] && dir="$1" || dir="${PWD}"
    if [[ -d "$dir" ]]; then
        tmux "set-option" "default-path" "${dir}"
        return 0
    else
        echo "tcd: no such directory: ${dir}"
        return 1
    fi
}

# Automatically append a / after ..
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}
zle -N rationalise-dot
bindkey . rationalise-dot

# Start history-incremental-search-backward with whatever has already been typed
# on the command line.
#history-incremental-search-backward-initial() {
    #zle history-incremental-search-backward $BUFFER
#}
#zle -N history-incremental-search-backward-initial
#bindkey '^R' history-incremental-search-backward-initial
#bindkey -M isearch '^R' history-incremental-search-backward

# Load RVM; http://rvm.beginrescueend.com/
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then source "$HOME/.rvm/scripts/rvm" ; fi

# Auto jump; https://github.com/sjl/z-zsh
. $HOME/.zsh/z.sh

# Rooter; https://github.com/yeban/rooter.sh
. $HOME/.zsh/rooter.sh/rooter.sh

#set JAVA_HOME
# -- The line below was set earlier in some machine. Can be ignored safely.
# JAVA_HOME=/usr/lib/jvm/java-6-sun-1.6.0.26/jre/
#The line below was added for Kiwi office laptop.
JAVA_HOME=/usr/lib/jdk/jdk1.6.0_30/
export JAVA_HOME
PATH=$PATH:$JAVA_HOME/bin
export PATH

export PATH=$PATH:/home/$USER/development/android-sdk-linux/platform-tools
export PATH=$PATH:/home/$USER/development/android-sdk-linux/tools
export PATH=$PATH:/home/$USER/development/play-2.2.2
export PATH=$PATH:/home/$USER/development/idea-IC-139.1117.1/bin/
export PATH=/usr/lib/jdk/jdk1.6.0_30/bin/:$PATH

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

cat ~/my_motd.txt

