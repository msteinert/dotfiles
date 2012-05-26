SOURCES += bashrc
SOURCES += bash-git
SOURCES += bashrc
SOURCES += dircolors
SOURCES += gconf
SOURCES += gitconfig
SOURCES += gitignore
SOURCES += inputrc
SOURCES += vim
SOURCES += vimrc
SOURCES += Xresources

DOTFILES = $(SOURCES:%=$(HOME)/.%)

all:

install: $(DOTFILES)

$(HOME)/.%: %
	cp -r $< $(dir $@)
