# functions {{{

function peco-history-selection() { # {{{
  BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
  CURSOR=$#BUFFER
  zle reset-prompt
} # }}}

function git_commit_automatically_loop() { # {{{
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

function git_commit_automatically() { # {{{
  commit_message=$( git status \
    | sed '1,/Changes to be committed/ d' \
    | sed '1,/^$/ d' \
    | sed '/^$/,$ d' \
    | git_commit_automatically_loop
  )
  git commit -m "$commit_message | $*"
} # }}}

# }}}

# path {{{
export PGDATA=/usr/local/var/postgres
export PATH=$PATH:$HOME/bin
export PATH=$PATH:$HOME/bin/upload-gdrive
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

# }}}

# history {{{
setopt HIST_IGNORE_DUPS     # 前と重複する行は記録しない
setopt HIST_IGNORE_ALL_DUPS # 履歴中の重複行をファイル記録前に無くす
setopt HIST_IGNORE_SPACE    # 行頭がスペースのコマンドは記録しない
setopt HIST_FIND_NO_DUPS          # 履歴検索中、(連続してなくとも)重複を飛ばす
setopt HIST_REDUCE_BLANKS         # 余分な空白は詰めて記録
setopt HIST_NO_STORE              # histroyコマンドは記録しない
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt share_history 
# }}}

# promot {{{

# standard variables 
# --------------------------------------------------------
# | variable | value             | example               |
# |:--------:|:-----------------:|:---------------------:|
# | %M       | host name         | localhost.localdomain |
# | %m       | host name         | localhost             |
# |:--------:|:-----------------:|:---------------------:|
# | %n       | user name         | root                  |
# |:--------:|:-----------------:|:---------------------:|
# | %#       | state of user     | #(root) %(not root)   |
# |:--------:|:-----------------:|:---------------------:|
# | %y, %i   | terminal name     | pts/0                 |
# |:--------:|:-----------------:|:---------------------:|
# | %?, %h   | return value of   | 0                     |
# |          | latest command    |                       |
# |:--------:|:-----------------:|:---------------------:|
# | %!       | the number of     | 1                     |
# |          | history           |                       |
# |:--------:|:-----------------:|:---------------------:|
# | %d, %/   | current directory | /root/currentdir      |
# | %~       | current directory | ~/currentdir          |
# | %C       | current directory | currentdir            |
# | %c, %.   | current directory | currentdir            |
# |:--------:|:-----------------:|:---------------------:|
# | %D       | date              | yy-mm-dd              |
# | %W       | date              | mm/dd/yy              |
# | %w       | date              | day dd                |
# |:--------:|:-----------------:|:---------------------:|
# | %*       | time              | hh:mm:ss              |
# | %T       | time              | hh:mm                 |
# | %t, %@   | time              | hh:mm(am/pm format)   |
# --------------------------------------------------------

# variables can be used in vcs_info 
# ----------------------------------------
# | variable | value                     |
# |:--------:|:-------------------------:|
# | %s       | system name               |
# | %b       | branch name	             |
# | %i       | revision ID               |
# | %r       | repository name           |
# | %R       | root directory (absolute) |
# | %S       | directory (relative)      |
# | %a       | action                    |
# | %c       | stagedstr                 |
# | %u       | unstagedstr               |
# | %m       | others	$hook_com[misc]    |
# ----------------------------------------


autoload -Uz vcs_info
zstyle ':vcs_info:*' max-exports 3
zstyle ':vcs_info:*' formats '%s:%b ' '%r' '%R'
setopt prompt_subst

function precmd () { # {{{
  LANG=en_US.UTF-8 vcs_info
  psvar=()
  [[ -n ${vcs_info_msg_0_} ]] && psvar[1]="$vcs_info_msg_0_"

  if [[ -z ${vcs_info_msg_1_} ]] || [[ -z ${vcs_info_msg_2_} ]]; then
    psvar[2]=$PWD
  else
    psvar[2]=`echo $vcs_info_msg_2_|sed -e "s#$vcs_info_msg_1_\\$##g"`
    psvar[3]="$vcs_info_msg_1_"
    psvar[4]=`echo $PWD|sed -e "s#^$vcs_info_msg_2_##g"`
  fi
} # }}}

function prompt-git-root-directory { # {{{
  echo "in %{${fg[$1]}%}%2v%U%3v%u%4v%{${reset_color}%}"
} # }}}

function prompt-git-current-branch { # {{{
  local name
  local st
  local plus

  name=`git symbolic-ref HEAD 2> /dev/null`
  if [[ -z $name ]]
  then
    return
  fi
  name=`basename $name`

  st=`git status`
  if [[ -n `echo $st | grep "^nothing to"` ]]
  then
    plus=""
  else
    plus="+"
  fi

  echo "on $fg[$1]$name$plus%f"
} # }}}

function prompt-username() { # {{{
  echo "$fg[$1]%n%{$reset_color%}"
} # }}}

function prompt-hostname() { # {{{
  echo "at $fg[$1]%m%{$reset_color%}"
} # }}}

PROMPT='
%# `prompt-username cyan` `prompt-hostname green` `prompt-git-root-directory yellow` `prompt-git-current-branch blue`
→ '

# }}}

# ls {{{
autoload -U compinit
compinit

export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

alias ls="ls -GF"
alias gls="gls --color"

zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
# }}}

# completion {{{
autoload -U compinit; compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# }}}

# alias {{{

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias cdd='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias ,='cd ~'
# alias v='vim'
alias v='nvim'
alias g='git'
alias e='exit'
alias guu='git add . && git commit -m "update" && git push'
alias vlc='open /Applications/VLC.app -n'
alias yd='youtube-dl'
alias lx='latexmk -pdfdvi'

alias mkdiri='(){ mkdir $1; cd $1 }'


# }}}

# bindkey {{{

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# }}}

# zplug {{{
source ~/.zplug/init.zsh 

zplug "b4b4r07/enhancd", use:init.sh
zplug "mollifier/anyframe", at:4c23cb60
zplug "zsh-users/zsh-syntax-highlighting"

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
