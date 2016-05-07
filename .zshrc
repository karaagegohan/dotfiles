setopt prompt_subst

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

PROMPT='
[%n: %d] `prompt-git-current-branch`
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

# aliases # {{{

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias cdd='cd ~'
alias ..='cd ..'
alias ~='cd ~'

# }}}
