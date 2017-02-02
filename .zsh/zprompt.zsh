# promot 

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

prompt_simple () {
  prompt_git_root_directory() { # {{{
    echo "in %{${fg[$1]}%}%2v%U%3v%u%4v%{${reset_color}%} "
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
      color=blue
    else
      color=red
    fi

    echo "on $fg[$color]$name%f "
  } # }}}

  prompt_username() { # {{{
    echo "$fg[$1]%n%#%{$reset_color%} "
  } # }}}

  prompt_hostname() { # {{{
    echo "at $fg[$1]%m%{$reset_color%} "
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
        echo "$fg[$1]M: $out%{$reset_color%} "
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
        echo "$fg[$1]D: $out%{$reset_color%} "
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
        echo "$fg[$1]U: $out%{$reset_color%} "
      fi
    fi
  } # }}}

  prompt_mode() { # {{{
    echo "%{${fg[yellow]}%}❰%#❱%{${reset_color}%} "
  } # }}}

  prompt_time() { # {{{
    echo "at $fg[$1]%w %*%{$reset_color%} "
  } # }}}

  prompt_input() { # {{{
    echo "%{${fg[cyan]}%}❱%{${reset_color}%}%{${fg[green]}%}❱%{${reset_color}%}%{${fg[yellow]}%}❱%{${reset_color}%} "
  } # }}}

  echo -e  \
    "`prompt_username magenta``prompt_hostname green``prompt_git_root_directory yellow``prompt_git_current_branch blue`\n`prompt_input`" 
}
PROMPT='`prompt_simple`'

# vim: set filetype=zsh:

