#!/bin/sh

apt-get install git
mkdir -p ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
git clone https://github.com/karaagegohan/dotfiles ~/dotfiles
ln -s ~/dotfiles/.vimrc ~/.vimrc
mkdir .vim/colors
ln -s ~/dotfiles/.vim/colors ~/.vim/colors
