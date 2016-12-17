# functions {{{

tac=${commands[tac]:-"tail -r"}

is_git_repository() { # {{{
	local info 
	if test -z $(git rev-parse --git-dir 2> /dev/null); then 
    return 1;
	else 
    return 0;
	fi
} # }}}

peco_select_history() {# {{{
  BUFFER=$( \
    history -n 1 \
    | eval $tac \
    | peco --query "$LBUFFER" \
    )
  CURSOR=$#BUFFER
  zle clear-screen
}# }}}
zle -N peco_select_history
bindkey '^r' peco_select_history

peco_select_git_add() { # {{{
  if is_git_repository; then 
    local files=$( \
      git ls-files -m --others --exclude-standard \
      | peco --query "$LBUFFER" \
      | awk -F ' ' '{print $NF}' \
      )
    if [ -n "$files" ]; then
      BUFFER="git add $(echo "$files" | tr '\n' ' ')"
      CURSOR=$#BUFFER
    fi
    zle accept-line
    zle clear-screen
  fi
} # }}}
zle -N peco_select_git_add
bindkey "^g^a" peco_select_git_add

# }}}

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

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# }}}

# history {{{
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE
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

precmd () { # {{{
  LANG=en_US.UTF-8 vcs_info
  psvar=()
  [[ -n ${vcs_info_msg_0_} ]] && psvar[1]="$vcs_info_msg_0_"

  if [[ -z ${vcs_info_msg_1_} ]] || [[ -z ${vcs_info_msg_2_} ]]; then
    psvar[2]=$PWD
  else
    psvar[2]=`echo $vcs_info_msg_2_|sed -e "s#$vcs_info_msg_1_\\$##g"`
    psvar[3]="$vcs_info_msg_1_"
    psvar[4]=`echo $PWD|sed -e "s#^$vcs_info_msg_2_##g"`
    psvar[5]=`echo $vcs_info_msg_3_`
    echo $vcs_info_msg_3_
  fi
} # }}}

prompt_git_root_directory() { # {{{
  echo "in %{${fg[$1]}%}%2v%U%3v%u%4v%{${reset_color}%}"
} # }}}

prompt_git_current_branch() { # {{{
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

prompt_username() { # {{{
  echo "$fg[$1]%n%{$reset_color%}"
} # }}}

prompt_hostname() { # {{{
  echo "at $fg[$1]%m%{$reset_color%}"
} # }}}

prompt_git_modified_file() { # {{{
  if test -z $(git rev-parse --git-dir 2> /dev/null); then 
    echo ""
  else
    out=$( \
      git ls-files -m \
      | tr '\r' ' ' \
      | tr '\n' ' ' \
      )
    if [ -n "$out" ]; then
      echo "$fg[$1]M: $out%{$reset_color%}"
    fi
  fi
} # }}}

prompt_git_deleted_file() { # {{{
  if test -z $(git rev-parse --git-dir 2> /dev/null); then 
    echo ""
  else
    out=$( \
      git ls-files -d \
      | tr '\r' ' ' \
      | tr '\n' ' ' \
      )
    if [ -n "$out" ]; then
      echo "$fg[$1]D: $out%{$reset_color%}"
    fi
  fi
} # }}}

prompt_git_untracked_file() { # {{{
  if test -z $(git rev-parse --git-dir 2> /dev/null); then 
    echo ""
  else
    out=$( \
      git ls-files --others --exclude-standard \
      | tr '\r' ' ' \
      | tr '\n' ' ' \
      )
    if [ -n "$out" ]; then
      echo "$fg[$1]U: $out%{$reset_color%}"
    fi
  fi
} # }}}

PROMPT='
%# `prompt_username cyan` `prompt_hostname green` `prompt_git_root_directory yellow` `prompt_git_current_branch blue`
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

alias ls='ls -GF -l'
alias la='ls -GF -la'
alias cdd='cd ~'
alias ..='cd ../'
alias ...='cd ../../'
alias ,='cd ~'
alias v='nvim'
alias g='git'
alias e='exit'
alias guu='git add . && git commit -m "update" && git push'
alias vlc='open /Applications/VLC.app -n'
alias yd='youtube-dl'
alias lx='latexmk -pdfdvi'
alias rc='source ~/.zshrc'
alias ikill='pkill -f Japanese'

alias mkdiri='(){ mkdir $1; cd $1 }'
alias cdr='() { if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then cd `pwd`/`git rev-parse --show-cdup`; fi }'
alias rn='() {for f in *.$1 ; do ; mv $f ${f/$2/$3} ; done }'

alias ugd='upload-googledrive'

alias p='python'
alias r='ruby'

# }}}

# zplug {{{
source ~/.zplug/init.zsh 

zplug "b4b4r07/enhancd", use:init.sh
zplug "mollifier/anyframe", at:4c23cb60
zplug "zsh-users/zsh-syntax-highlighting"
# zplug "b4b4r07/emoji-cli"
# zplug "hchbaw/auto-fu.zsh", hook-build:"source auto-fu.zsh"
# zplug "zsh-users/zsh-autosuggestions", hook-build:"source zsh-autosuggestions.zsh"

# return whether the plugin is installed
zplug_installed() { # {{{
  local plugins
  plugins=$(zplug list)
  if [[ `echo $plugins | grep $1` ]];
  then 
    return 0;
  else
    return 1;
  fi
} # }}}

# install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then # {{{
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load --verbose
# }}}

# preferences for each plugin
if zplug_installed "hchbaw/auto-fu.zsh"; # {{{
then
  zle_line_init(){
    auto-fu-init
  }
  zle -N zle_line_init
  # zstyle ':auto-fu:highlight' input bold
  # zstyle ':auto-fu:highlight' completion fg=black,bold
  # zstyle ':auto-fu:highlight' completion/one fg=white,bold,underline
  # zstyle ':auto-fu:var' postdisplay $''
  # zstyle ':auto-fu:var' track-keymap-skip opp
  # zstyle ':auto-fu:var' disable magic-space
fi # }}}

# }}}

