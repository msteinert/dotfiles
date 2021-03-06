# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Set locale
export LANG=en_US.UTF-8

# Configure history length
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=2000

setopt appendhistory extendedglob no_case_glob
unsetopt beep nomatch

# Case insensitive completion for cd etc *N*
zstyle ':completion:*' completer _expand _complete _match
zstyle ':completion:*' completions 0
zstyle ':completion:*' glob 0
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' substitute 0
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

# Vi command line editing
autoload -U edit-command-line
zle -N edit-command-line
bindkey -v
bindkey '\e[3~' delete-char
bindkey '^r' history-incremental-search-backward
vi-cmd-mode() {
    zle -K vicmd
}
zle -N vi-cmd-mode
bindkey -M vicmd 'v' edit-command-line

# Make less more friendly for non-text input files
if [[ -x /usr/bin/lesspipe ]]; then
    eval "$(SHELL=/bin/sh lesspipe)"
elif [[ -x /usr/bin/lesspipe.sh ]]; then
    eval "$(SHELL=/bin/sh lesspipe.sh)"
fi

# Force color terminal
if [[ "$TERM" == "xterm" ]]; then
    TERM=xterm-256color
fi
autoload -U colors && colors

# Configure VCS Info
typeset -ga precmd_functions
autoload -Uz vcs_info
precmd_functions+='vcs_info'

# Set VCS style
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%{$fg[blue]%}•"
zstyle ':vcs_info:*' unstagedstr "%{$fg[red]%}•"
zstyle ':vcs_info:*' formats ":%b%c%u"
zstyle ':vcs_info:*' actionformats ":%b|%a%c%u"

# git: Show marker if there are stashed changes
# git: Show marker if there are untracked files in repository
zstyle ':vcs_info:git*+set-message:*' hooks git-hook
+vi-git-hook () {
    if [[ $(/usr/bin/stat -L --file-system --format="%T" "$(pwd)") != "nfs" ]]; then
        if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]]; then
            if [[ -n $(git rev-parse --verify refs/stash 2> /dev/null) ]]; then
                hook_com[staged]+="%{$fg[magenta]%}⋆"
            fi
            if [[ -n $(git status --porcelain | grep '??' 2> /dev/null) ]]; then
                hook_com[staged]+="%{$fg[yellow]%}•"
            fi
        fi
    fi
}

# Configure the prompt
setopt prompt_subst
PS1='%{$fg[green]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}%(1j.[%j].)${vcs_info_msg_0_}%{$reset_color%}> '

# Enable color support of ls and also add handy aliases
if [[ -x /usr/bin/dircolors ]]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto -F"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
else
    # Assume BSD (good enough for now)
    alias ls="ls -FG"
    alias grep="grep --color=auto"
    alias fgrep="fgrep --color=auto"
    alias egrep="egrep --color=auto"
fi

# Python
PYENV_ROOT=$HOME/.pyenv
PYTHONPATH="/usr/local/lib/python2.7/site-packages:$PYTHONPATH"

export PYENV_ROOT

# Go
GOROOT=$HOME/.local/go

export GOPATH

# Path
PATH="$HOME/.local/bin:$PATH"
PATH="$GOPATH/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$PYENV_ROOT/bin:$PATH"
PATH="/opt/local/bin:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"

MANPATH="$HOME/.local/man:$MANPATH"
MANPATH="$HOME/.local/share/man:$MANPATH"

# Editor settings
CSCOPE_EDITOR="vim"
EDITOR="vim"
INPUTRC="$HOME/.inputrc"

# Pkg-config
PKG_CONFIG_PATH=
PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"
PKG_CONFIG_PATH="/opt/local/lib/pkgconfig:$PKG_CONFIG_PATH"
PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"

# MacOS
DYLD_FALLBACK_LIBRARY_PATH="$HOME/.local/lib"

export CSCOPE_EDITOR DYLD_FALLBACK_LIBRARY_PATH EDITOR INPUTRC \
       PKG_CONFIG_PATH PYTHONPATH

# Source definitions
if [[ -d $HOME/.zsh.d ]]; then
    for i in $HOME/.zsh.d/zsh-*; do
        test -r $i && . $i
    done
    unset i
fi

# fzf
export FZF_DEFAULT_COMMAND="fd --type file"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# If this is an xterm set the title
case "$TERM" in
xterm*|rxvt*|screen*)
    precmd () { print -Pn "\e]0;%~\a" }
    ;;
*)
    ;;
esac

ulimit -c unlimited
