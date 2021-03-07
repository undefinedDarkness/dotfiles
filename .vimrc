" Merry Christmas 2020 ⛄! 
" Happy New Year 2021!

" Plugin Manager
call plug#begin("~/.vim/plugged")

  " Language Compatability
  Plug 'sheerun/vim-polyglot'

  " Intellisense
  Plug 'bhurlow/vim-parinfer'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neomake/neomake' 

  " Pretty
  Plug 'cocopon/iceberg.vim'
  Plug 'itchyny/lightline.vim'

  " Fern File Manager
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/glyph-palette.vim'  

  " Run Current File
  Plug 'thinca/vim-quickrun'

  " Web Development
  Plug 'mattn/emmet-vim'
  Plug 'Valloric/MatchTagAlways'
  Plug 'ap/vim-css-color'

  " Other
  Plug 'dstein64/vim-startuptime'
  Plug 'mileszs/ack.vim'

call plug#end()

" Prevent FOUT

" St term
if $TERM ==? "st-256color"
  set t_8f=[38;2;%lu;%lu;%lum
  set t_8b=[48;2;%lu;%lu;%lum
  set ttymouse=sgr
" Kitty Term
elseif $TERM ==? "xterm-kitty"
  let &t_ut=''
endif

set background=dark
set t_Co=256
colorscheme iceberg
set termguicolors

" Vim Config
set mouse=a
set nowrap

set number
set title
set titlestring=Editing:⠀%f
set hidden
set splitbelow

set expandtab
set shiftwidth=2
set softtabstop=2
set cindent
set smartindent
set autoindent

set noshowmode

set signcolumn=number

filetype indent on
filetype plugin indent on

set encoding=utf-8

set splitbelow

" Include Tab Line & Fern Config & Vim Config
source $HOME/.vim/custom.vim
source $HOME/.vim/fern_config.vim
