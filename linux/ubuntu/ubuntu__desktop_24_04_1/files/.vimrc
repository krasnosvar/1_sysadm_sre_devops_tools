set nocompatible              " be iMproved, required
filetype off                  " required
"set the runtime path to include Vundle and initialize"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"let Vundle manage Vundle, required"

"10 essential Vim plugins
"https://medium.com/@huntie/10-essential-vim-plugins-for-2018-39957190b7a9
Plugin 'VundleVim/Vundle.vim'
Plugin 'chr4/nginx.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'hashivim/vim-terraform'
Plugin 'bash-support.vim'
Plugin 'fatih/vim-go'
Plugin 'hdima/python-syntax'
Plugin 'scrooloose/nerdtree'
map <C-o> :NERDTreeToggle<CR>
Plugin 'itchyny/lightline.vim'
call vundle#end()            " required

filetype plugin indent on    " required
"autocmd VimEnter * NERDTree " start NERD automatically when vim opens
