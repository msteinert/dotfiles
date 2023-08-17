SOURCES += alacritty.yml
SOURCES += cvsignore
SOURCES += dircolors
SOURCES += gitconfig
SOURCES += inputrc
SOURCES += tmux.conf

SOURCES += vim
SOURCES += vimrc

DIRS += zsh.d
SOURCES += zsh.d/zsh-aliases
SOURCES += zsh.d/zsh-fzf
SOURCES += zshrc

BASH ?= n
ifeq ($(BASH),y)
DIRS += bash.d
SOURCES += bash.d/bash-aliases
SOURCES += bash.d/bash-git
SOURCES += bash.d/bash-git-prompt
SOURCES += bashrc
endif

LINUX ?= n
ifeq ($(LINUX),y)
DIRS += config
endif

all:
	$(foreach d,$(DIRS),\
		$(info INSTALL .$(d))\
		$(shell mkdir -p $(HOME)/.$(d)))
	$(foreach file,$(SOURCES),\
		$(info INSTALL .$(file))\
		$(shell rm -rf $(HOME)/.$(file))\
		$(shell ln -fs $(CURDIR)/$(file) $(HOME)/.$(file)))
