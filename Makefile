SOURCES += bashrc
SOURCES += bash.d/bash-aliases
SOURCES += bash.d/bash-git
SOURCES += bash.d/bash-git-prompt
SOURCES += cvsignore
SOURCES += dircolors
SOURCES += gitconfig
SOURCES += inputrc
SOURCES += tmux.conf
SOURCES += vim
SOURCES += vimrc
SOURCES += Xresources
SOURCES += zshrc
SOURCES += zsh.d/zsh-aliases
SOURCES += zsh.d/zsh-ssh

ifeq ($(ECHOSTAR),y)
SOURCES += bash.d/bash-clearcase
SOURCES += bash.d/bash-echostar
SOURCES += zsh.d/zsh-clearcase
SOURCES += zsh.d/zsh-echostar
endif

DIRS += bash.d
DIRS += zsh.d

all:
	$(foreach d,$(DIRS),\
		$(info INSTALL .$(d))\
		$(shell mkdir -p $(HOME)/.$(d)))
	$(foreach file,$(SOURCES),\
		$(info INSTALL .$(file))\
		$(shell rm -rf $(HOME)/.$(file))\
		$(shell ln -fs $(CURDIR)/$(file) $(HOME)/.$(file)))
