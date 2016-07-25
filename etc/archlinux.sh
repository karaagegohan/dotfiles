has() { #{{{
    which $1 > /dev/null 2>&1 && true
}
#}}}

if !(has go)
then
    sudo pacman -S go
fi
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GOPATH=$HOME/go

if !(has peco)
then
    go get github.com/peco/peco/cmd/peco
fi
