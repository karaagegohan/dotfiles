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

# nvim # {{{
neovim_autocd() {
    [[ $NVIM_LISTEN_ADDRESS ]] && $HOME/.zsh/neovim_autocd
}
chpwd_functions+=( neovim_autocd )
# }}}

source $HOME/.zsh/zprompt
source $HOME/.zsh/zplug
source $HOME/.zsh/zoption
source $HOME/.zsh/zpeco
