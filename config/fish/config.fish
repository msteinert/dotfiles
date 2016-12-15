set -e fish_greeting
fish_vi_key_bindings

set -x PYENV_ROOT $HOME/.pyenv
set -x PYTHONPATH /usr/local/lib/python2.7/site-packages:$PYTHONPATH

set -x GOPATH $HOME/go
set -x GOROOT $HOME/src/git/go

set -x PATH $GOPATH/bin $PATH
set -x PATH $GOROOT/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH
set -x PATH $HOME/.local/swift/usr/bin $PATH
set -x PATH $PYENV_ROOT/bin $PATH
set -x PATH /usr/local/bin $PATH
set -x PATH /usr/local/sbin $PATH
set -x PATH /usr/local/share/scala/bin $PATH

set -x CSCOPE_EDITOR vim
set -x EDITOR vim
set -x INPUTRC $HOME/.inputrc

ulimit -c unlimited
