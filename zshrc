# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Configure history length
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=2000

setopt appendhistory extendedglob nomatch no_case_glob

# case insensitive completion for cd etc *N*
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

unsetopt beep
bindkey -v

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit

# Make less more friendly for non-text input files
if [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
elif [ -x /usr/bin/lesspipe.sh ]; then
    eval "$(SHELL=/bin/sh lesspipe.sh)"
fi

# Force color terminal
if [ "$TERM" = "xterm" ]; then
    TERM=xterm-256color
fi
autoload -U colors && colors

# Username prompt setup
PS1_USER="%{$fg[green]%}%n%{$reset_color%}"

# Hostname prompt setup (strip "linux-pc-" from hostname)
PS1_HOSTNAME="%{$fg[yellow]%}%m%{$reset_color%}"

# ClearCase prompt setup (strip ${USER}_ from $CLEARCASE_ROOT)
if [ -n "$CLEARCASE_ROOT" ]; then
    PS1_CLEARCASE="[%{$fg[red]%}$(echo $CLEARCASE_ROOT | awk -F_ '{ print $NF }')%{$reset_color%}]"
    umask 002
fi

# Git prompt setup (set branch name & status)
source $HOME/.zsh/git-prompt/zshrc.sh
ZSH_THEME_GIT_PROMPT_PREFIX=":"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR=" "
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[blue]%}•"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}⋆"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[red]%}⌁"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓"
PS1_GIT='$(git_super_status)'

PS1="${PS1_USER}@${PS1_HOSTNAME}${PS1_CLEARCASE}${PS1_GIT}> "

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

# Setup paths
PATH="$HOME/.local/bin:/opt/local/bin:/opt/clang/bin:$PATH"
MANPATH="$HOME/.local/man:$MANPATH"

# Setup variables
CSCOPE_EDITOR="vim"
EDITOR="vim"
INPUTRC="$HOME/.inputrc"
PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:/opt/local/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig"
PYTHONPATH="$HOME/.local/lib/python"

export CSCOPE_EDITOR EDITOR INPUTRC PKG_CONFIG_PATH PYTHONPATH

# Common aliases
alias c="clear"
alias ct="cleartool"
alias h="history"
alias where="which -a"

# Parallel build aliases
jobs=$(expr `cat /proc/cpuinfo | grep processor | wc -l` \* 2)
alias make="make -j$jobs"
alias scons="scons -j$jobs"
unset jobs

# Add RVM
if [ -f $HOME/.rvm/scripts/rvm ]; then
    . $HOME/.rvm/scripts/rvm
fi

# If this is an xterm set the title
case "$TERM" in
xterm*|rxvt*|screen*)
    precmd () { print -Pn "\e]0;%~\a" }
    ;;
*)
    ;;
esac

ulimit -c unlimited
