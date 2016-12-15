SOURCES += Xresources
SOURCES += bash.d/bash-aliases
SOURCES += bash.d/bash-git
SOURCES += bash.d/bash-git-prompt
SOURCES += bashrc
SOURCES += config/dunst
SOURCES += config/fish/config.fish
SOURCES += config/fish/functions
SOURCES += config/i3
SOURCES += config/i3status
SOURCES += cvsignore
SOURCES += dircolors
SOURCES += gitconfig
SOURCES += inputrc
SOURCES += mutt
SOURCES += offlineimaprc
SOURCES += tmux.conf
SOURCES += vim
SOURCES += vimrc
SOURCES += zsh.d/zsh-aliases
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
