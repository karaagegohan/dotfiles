export PATH=$PATH:$HOME/bin
export DOTPATH=$HOME/dotfiles
setopt prompt_subst

# 重複を記録しない
setopt hist_ignore_dups
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 参考：http://tegetegekibaru.blogspot.jp/2012/08/zsh_2.html
PROMPT='
%F{cyan}[%m@%n]%f %d `prompt-git-current-branch`
%(!.# .$ )'

function prompt-git-current-branch {
        local name st color
 
        name=`git symbolic-ref HEAD 2> /dev/null`
        if [[ -z $name ]]
        then
                return
        fi
        name=`basename $name`
 
        st=`git status`
        if [[ -n `echo $st | grep "^nothing to"` ]]
        then
                color="red"
        else
                color="green"
        fi
 
        echo "%F{$color}[$name]%f"
}

# alias # {{{

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias cdd='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias ,='cd ~'
alias v='vim'
alias e='exit'

# }}}

