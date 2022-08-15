SOURCES += Xresources
SOURCES += alacritty.yml
SOURCES += bash.d/bash-aliases
SOURCES += bash.d/bash-git
SOURCES += bash.d/bash-git-prompt
SOURCES += bashrc
SOURCES += cvsignore
SOURCES += dircolors
SOURCES += gitconfig
SOURCES += inputrc
SOURCES += tmux.conf
SOURCES += vim
SOURCES += vimrc
SOURCES += zsh.d/zsh-aliases
SOURCES += zsh.d/zsh-fzf
SOURCES += zshrc

ifeq ($(ECHOSTAR),y)
SOURCES += bash.d/bash-clearcase
SOURCES += bash.d/bash-echostar
SOURCES += zsh.d/zsh-clearcase
SOURCES += zsh.d/zsh-echostar
SOURCES += zsh.d/zsh-ssh
endif

ifeq ($(EXEGY),y)
SOURCES += zsh.d/zsh-exegy
endif

DIRS += bash.d
DIRS += config
DIRS += config/fish
DIRS += zsh.d

all:
	$(foreach d,$(DIRS),\
		$(info INSTALL .$(d))\
		$(shell mkdir -p $(HOME)/.$(d)))
	$(foreach file,$(SOURCES),\
		$(info INSTALL .$(file))\
		$(shell rm -rf $(HOME)/.$(file))\
		$(shell ln -fs $(CURDIR)/$(file) $(HOME)/.$(file)))
