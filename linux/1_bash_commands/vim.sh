#Зачем использовать vim
https://guides.hexlet.io/vim/
#great VIM tips site
https://vim.fandom.com/wiki/Vim_documentation
#Plugins for vim
https://vimawesome.com/
#
http://www.viemu.com/vi-vim-cheat-sheet.gif


#Change "/" to "/etc/" in text. Slash "\" shields backslash "/" so if you need to do shmthg with synbol "/" you write "\/"
:%s/\//\/etc\//g


#if cannot save file in ususal user(not root):
#The structure :w !cmd means "write the current buffer piped through command". So you can do, for example :w !cat and it will pipe the buffer through cat.
#Now % is the filename associated with the buffer
#So :w !sudo tee % will pipe the contents of the buffer through sudo tee FILENAME. This effectively writes the contents of the buffer out to the file.
:w !sudo tee %

#install plugin manager+nginx conf markup
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/chr4/nginx.vim ~/.vim/bundle/nginx.vim
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

#display line numbers
:set number
:set nu

#open remote file via vim(from vim directly)
:e scp://remoteuser@server.tld//absolute/path/to/document
