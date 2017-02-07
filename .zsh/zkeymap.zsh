
_cd_back() { # {{{
  cd ./..
} # }}}
zle -N _cd_back
bindkey '^j' _cd_back
