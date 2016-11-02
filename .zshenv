# path {{{
export PGDATA=/usr/local/var/postgres
export PATH=$PATH:$HOME/bin
export TERM=xterm-256color
export PATH=$PATH:/opt/vagrant/bin

export PATH=$PATH:/opt/theos/bin
export THEOS=/opt/theos
export THEOS_MAKE_FILE=/opt/theos

export LC_ALL='en_US.UTF-8' 

if which pyenv > /dev/null 2>&1;
then
    export PYENV_ROOT=$HOME/.pyenv
    export PATH=$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init -)"
fi

if which rbenv > /dev/null 2>&1;
then
    export RBENV_ROOT="$HOME/.rbenv"
    export PATH=$RBENV_ROOT/shims:$PATH
    eval "$(rbenv init -)"
    export PYTHONPATH=/usr/local/Cellar/opencv/2.4.13/lib/python2.7/site-packages:PYTHONPATH

fi

export PATH=$PATH:$HOME/script/upload-googledrive

# }}}
