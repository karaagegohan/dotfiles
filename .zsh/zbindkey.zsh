_git_commit_add() { # {{{
  # BUFFER='git commit -m \":tada: add '
  # CURSOR=$#BUFFER
  local l=$(echo 'asdf')
  BUFFER="${LBUFFER}${l}"
  CURSOR=$#BUFFER
} # }}}
zle -N _git_commit_add
bindkey '^g^c^a' _git_commit_add
