#!/bin/sh

mkdir -p ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.gvimrc ~/.gvimrc
ln -s ~/dotfiles/.xvimrc ~/.xvimrc
ln -s ~/dotfiles/.nvimrc ~/.nvimrc

