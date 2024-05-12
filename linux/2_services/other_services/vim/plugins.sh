#install plugin manager+nginx conf markup
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/chr4/nginx.vim ~/.vim/bundle/nginx.vim
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#add to vi ~/.vimrc
set nocompatible              " be iMproved, required
filetype off                  " required
"set the runtime path to include Vundle and initialize"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"let Vundle manage Vundle, required"
Plugin 'VundleVim/Vundle.vim'
Plugin 'chr4/nginx.vim'
call vundle#end()            " required
filetype plugin indent on    " required

#install additional plugins
#Python autocomplete
#https://www.tabnine.com/
Add Plugin 'zxqfl/tabnine-vim'to your .vimrc.
Type :PluginInstall press Enter.



