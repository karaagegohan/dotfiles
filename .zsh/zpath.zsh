# path 
export PATH=$PATH:$HOME/bin
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/script/gdrive
export PATH=/usr/local/opt/openssl/bin:$PATH

# color
export TERM=xterm-256color

# language
export LC_ALL='en_US.UTF-8' 

# for postgress
export PGDATA=/usr/local/var/postgres

# for theos
export PATH=$PATH:/opt/theos/bin
export THEOS=/opt/theos
export THEOS_MAKE_FILE=/opt/theos

# for anyenv
if [ -d $HOME/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
	for env in `ls $HOME/.anyenv/envs`
	do
		export PATH="$HOME/.anyenv/envs/$env/shims:$PATH"
	done
fi

# for golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# for julia
export PATH=$PATH:/Applications/Julia-0.5.app/Contents/Resources/julia/bin

# vim: set filetype=zsh:

