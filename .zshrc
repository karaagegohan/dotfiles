# functions# {{{

function prompt-git-current-branch { # {{{
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
} # }}}

function peco-history-selection() { # {{{
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
} # }}}

git_commit_automatically_loop() { # {{{
  local action message
  while read line; do
    action=$(echo $line | awk '{print $1}' | sed "s/://")
    case $action in
      "new" ) added_changes="[add] $(echo $line | awk '{print $3}')" ;;
      "deleted" ) added_changes="[remove] $(echo $line | awk '{print $2}')" ;;
      "renamed" ) added_changes="[rename] $(echo $line | awk '{print $2 $3 $4}')" ;;
      "modified" ) added_changes="[improve] $(echo $line | awk '{print $2}')" ;;
    esac
    message="$message $added_changes"
  done
  echo $message
} # }}}

git_commit_automatically() { # {{{
  commit_message=$( git status \
    | sed '1,/Changes to be committed/ d' \
    | sed '1,/^$/ d' \
    | sed '/^$/,$ d' \
    | git_commit_automatically_loop
  )
  git commit -m "$commit_message | $*"
} # }}}

has() { #{{{
    which $1 > /dev/null 2>&1 && true
}
#}}}

# }}}

# path# {{{
export PATH=$PATH:$HOME/bin
export TERM=xterm-256color
export PATH=$PATH:/opt/vagrant/bin

if has pyrnv
then
    export PYENV_ROOT=$HOME/.pyenv
    export PATH=$PYENV_ROOT/bin:$PATH
fi

if has rbenv
then
    eval "$(rbenv init -)"
    export RBENV_ROOT="$HOME/.rbenv"
    export PATH=$RBENV_ROOT/shims:$PATH
fi

# }}}

# history# {{{
setopt hist_ignore_dups # idnore duplicates
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt share_history 
# }}}

# promot# {{{
setopt prompt_subst
PROMPT='
%F{cyan}[%m@%n]%f %d `prompt-git-current-branch`
%(!.# .$ )'
# }}}

# completion# {{{
autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# }}}

# alias # {{{

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias cdd='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias ,='cd ~'
alias v='vim'
alias nv='nvim'
alias e='exit'
alias guu='git add . && git commit -m "update" && git push'
alias vlc='open /Applications/VLC.app -n'
alias yd='youtube-dl'

# }}}

# bindkey # {{{

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# }}}

# zplug {{{
if !(has zplug)
then
    curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug
fi
source ~/.zplug/init.zsh

zplug "b4b4r07/enhancd", use:init.sh

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose
# }}}
