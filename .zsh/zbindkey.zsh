_git_commit_add() { # {{{
  # BUFFER='git commit -m \":tada: add '
  # CURSOR=$#BUFFER
  local l=$(echo 'asdf')
  BUFFER="${LBUFFER}${l}"
  CURSOR=$#BUFFER
} # }}}
# zle -N _git_commit_add
# bindkey '^g^c^a' _git_commit_add

_is_git_repository() { # {{{
	local info 
	if test -z $(git rev-parse --git-dir 2> /dev/null); then 
    return 1;
	else 
    return 0;
	fi
} # }}}

_peco_select_history() {# {{{
  tac=${commands[tac]:-"tail -r"}
  BUFFER=$( \
    history -n 1 \
    | eval $tac \
    | peco --query "$LBUFFER" \
    )
  CURSOR=$#BUFFER
  zle clear-screen
}# }}}
zle -N _peco_select_history
bindkey '^r' _peco_select_history

_peco_select_git_add() { # {{{
  if _is_git_repository; then 
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
zle -N _peco_select_git_add
bindkey "^g^a" _peco_select_git_add
