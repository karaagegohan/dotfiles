@echo off

IF NOT EXIST C:\Users\yoneoka\.vimrc (
mklink "C:\Users\yoneoka\.vimrc" "C:\Users\yoneoka\dotfiles\.vimrc"
)

IF NOT EXIST C:\Users\yoneoka\.gvimrc (
mklink "C:\Users\yoneoka\.gvimrc" "C:\Users\yoneoka\dotfiles\.gvimrc"
)


IF NOT EXIST C:\Users\yoneoka\.nvimrc (
mklink "C:\Users\yoneoka\.nvimrc" "C:\Users\yoneoka\dotfiles\.nvimrc"
)


