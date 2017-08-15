# current directory is changed automatically in neovim terminal
neovim_autocd() {
    [[ $NVIM_LISTEN_ADDRESS ]] && $HOME/.zsh/neovim_autocd
}
chpwd_functions+=( neovim_autocd )

