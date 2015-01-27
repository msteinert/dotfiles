# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Prefer Zsh
ZSH=$HOME/.local/$(lsb_release -is)-$(lsb_release -rs)/bin/zsh
[ -f $ZSH ] && exec $ZSH
[ -f /bin/zsh ] && exec /bin/zsh

# Don't put duplicate lines in the history
HISTCONTROL=ignoredups:ignorespace

# Append to the history file, don't overwrite it
shopt -s histappend

# For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Check the window size and updated it after each command
shopt -s checkwinsize

# Make less more friendly for non-text input files
if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
elif [ -x /usr/bin/lesspipe.sh ]; then
    eval "$(SHELL=/bin/sh lesspipe.sh)"
fi

if [ "$TERM" = "xterm" ]; then
    TERM=xterm-256color
fi

# Set color escape codes
intensity=00 # 00: normal, 01: bold, 02: faint
black="\[\033[$intensity;30m\]"
red="\[\033[$intensity;31m\]"
green="\[\033[$intensity;32m\]"
yellow="\[\033[$intensity;33m\]"
blue="\[\033[$intensity;34m\]"
magenta="\[\033[$intensity;35m\]"
cyan="\[\033[$intensity;36m\]"
white="\[\033[$intensity;37m\]"
reset="\[\033[00m\]"

# Username prompt setup
PS1_USER="$green\u$reset"

# Hostname prompt setup
PS1_HOSTNAME="$yellow\h$reset"

# Git prompt setup (set branch name & status)
if [ -f $HOME/.bash.d/bash-git-prompt ]; then
    PS1_GIT='$(__git_ps1 :%s)'
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
fi

PS1="${PS1_USER}@${PS1_HOSTNAME}${PS1_GIT}> "

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto -F"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
    alias cgrep="coccigrep --color"
else
    alias ls="ls -F"
    alias cgrep="coccigrep"
fi

# Enable programmable completion features
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Setup paths
PATH="$HOME/.local/bin:/opt/local/bin:/opt/clang/bin:$PATH"
MANPATH="$HOME/.local/man:$MANPATH"

# Setup variables
CSCOPE_EDITOR="vim"
EDITOR="vim"
INPUTRC="$HOME/.inputrc"
PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:/opt/local/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig"
PYTHONPATH="/usr/local/lib/python2.7/site-packages:$PYTHONPATH"

export CSCOPE_EDITOR EDITOR INPUTRC PKG_CONFIG_PATH PYTHONPATH

# Source definitions
if [ -d $HOME/.bash.d ]; then
    for i in $HOME/.bash.d/bash-*; do
        test -r $i && . $i
    done
    unset i
fi

# Node Completion
if [ -d $HOME/.node-completion ]; then
    for i in $HOME/.node-completion/*; do
        test -r $i && . $i
    done
    unset i
fi

# Add RVM
if [ -f $HOME/.rvm/scripts/rvm ]; then
    . $HOME/.rvm/scripts/rvm
fi

# If this is an xterm set the title
case "$TERM" in
xterm*|rxvt*|screen*)
    PS1="\[\e]0;\w\a\]$PS1"
    ;;
*)
    ;;
esac

unset intensity black red green yellow blue magenta cyan white reset

unset command_not_found_handle

ulimit -c unlimited
