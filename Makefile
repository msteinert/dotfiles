SOURCES += bash-aliases
SOURCES += bash-git
SOURCES += bashrc
SOURCES += cvsignore
SOURCES += dircolors
SOURCES += gitconfig
SOURCES += inputrc
SOURCES += vim
SOURCES += vimrc
SOURCES += Xresources

all:
	$(foreach file,$(SOURCES),\
		$(info INSTALL .$(file))\
		$(shell rm -f $(HOME)/.$(file))\
		$(shell ln -fs $(CURDIR)/$(file) $(HOME)/.$(file)))
