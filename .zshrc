export PATH=$PATH:$HOME/bin
export PATH="$RBENV_ROOT/bin:$PATH"
export DOTPATH=$HOME/dotfiles
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export TERM=xterm-256color
eval "$(rbenv init -)"

setopt prompt_subst
export RBENV_ROOT="$HOME/.rbenv"
# 重複を記録しない
setopt hist_ignore_dups
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 参考：http://tegetegekibaru.blogspot.jp/2012/08/zsh_2.html
PROMPT='
%F{cyan}[%m@%n]%f %d `prompt-git-current-branch`
%(!.# .$ )'

autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

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

function chpwd() { # {{{
  powered_cd_add_log
} # }}}

function powered_cd_add_log() { # {{{
  local i=0
  cat ~/.powered_cd.log | while read line; do
    (( i++ ))
    if [ i = 30 ]; then
      sed -i -e "30,30d" ~/.powered_cd.log
    elif [ "$line" = "$PWD" ]; then
      sed -i -e "${i},${i}d" ~/.powered_cd.log 
    fi
  done
  echo "$PWD" >> ~/.powered_cd.log
} # }}}

function powered_cd() { # {{{
  if [ $# = 0 ]; then
    cd $(gtac ~/.powered_cd.log | peco)
  elif [ $# = 1 ]; then
    cd $1
  else
    echo "powered_cd: too many arguments"
  fi
} # }}}

_powered_cd() { # {{{
  _files -/
} # }}}

compdef _powered_cd powered_cd

[ -e ~/.powered_cd.log ] || touch ~/.powered_cd.log

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

zle -N powered_cd
bindkey '^f' powered_cd

# }}}
