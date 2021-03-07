" -- Custom Commands --
command W :w
command Qa :qa

" -- Vim Tweaks --

" Man page support
runtime ftplugin/man.vim

" Hide ~
highlight EndOfBuffer ctermfg=black ctermbg=black

" Italic Rust Comments
highlight rustCommentLineDoc cterm=italic gui=italic term=italic ctermfg=150 guifg=#b4be82

" Fern Text
highlight FernRoot cterm=bold gui=bold term=bold

" Rofi-Rasi File Support
au BufNewFile,BufRead /*.rasi setf css

" Set title
set titlestring=Editing:\ %f

" -- Plugin Config --

" Neomake
call neomake#configure#automake('w')

" Ack
let g:ackprg = 'ag --vimgrep'
cnoreabbrev Ack Ack!
set shellpipe=> " Prevent Ack Output Leaking Into Terminal

" -- Keyboard Remappings --

" F3 to save
noremap <silent> <F3>  :update<CR>
vnoremap <silent> <F3> <C-C>:update<CR>
inoremap <silent> <F3> <C-O>:update<CR>

" F7 to format a document
nmap <F7> gg=G<C-o><C-o>

" Run File On F5 (Cargo aware)
function! Runfile()
  let filetype=&filetype
  let file=expand('%:p') 

  if filetype == "rust"
    let is_rust_project = system("bash ~/Documents/Scripts/is_rust_project.sh " . file)
    if !empty(is_rust_project)
      :term cargo build
    else
      :QuickRun
    endif
  else
    :QuickRun
  endif
endfunc
nnoremap <F5> :call Runfile()<CR>

" Open Terminal On Ctrl - T
nnoremap <C-T> :terminal<Enter>

" Ctrl+C/Ctrl+V to copy/paste to/from system clipboard

function! Pastetext()
  set paste
  <ESC>"+pa
  set nopaste
endfunc

inoremap <C-v> :call Pastetext()<CR>
vnoremap <C-c> "+y
vnoremap <C-d> "+d


" Ctrl - F to open Fern
nnoremap <silent> <C-f> :Fern . -drawer -toggle<CR>

" Ctrl A to save
nmap <C-a> <esc>ggVG<CR>

" -- Etc --

" Highlight Group Under Cursor
function! HighlightGroup()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" -- Lightline Config --

" Auto-toggles statusline based on window size
function! CheckWindowSize()
  if winwidth(0) > 100 && winheight(0) > 30
    set laststatus=2
    set noshowmode
  else
    set laststatus=0
    set showmode
  endif
endfunction
call CheckWindowSize()
autocmd VimResized * :call CheckWindowSize()


let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ 'active': {
      \     'left': [ [ 'custom_filename' ], [], [ 'filetype' ] ],
      \     'right': [ [], [], [ 'custom_position' ] ]
      \  },
      \ 'inactive': {
      \     'left': [ [ 'custom_filename' ], [], [ 'filetype' ] ],
      \     'right': [ [], [], [ 'custom_position' ] ]
      \  },
      \ 'tabline': {
      \     'left': [ [ 'tabs' ] ],
      \     'right': []
      \   },
      \ 'component_function': {
      \     'custom_filename': 'CustomFileName',
      \     'custom_position': 'CustomPosition' 
      \   },
      \  'tab': {
      \     'active': [ 'filename', 'modified' ],
      \     'inactive': [ 'filename', 'modified' ]
      \   },
      \  'tab_component_function': {
      \     'filename': 'GetTabFileName'
      \   }
      \ }

" --- Lightline Functions ---

function! CustomPosition()
  let cursor = getcurpos()
  return cursor[1] . ":" . cursor[2]
endfunction

function! CustomFileName()
  let file = expand('%')
  if file =~? "fern://"
    return " Fern"
  elseif file =~? "!/bin/bash"
    return " Shell"
  else
    return nerdfont#find(@%) . " " . file
  endif
endfunction

function! GetTabFileName(n)
	  let buflist = tabpagebuflist(a:n)
	  let winnr = tabpagewinnr(a:n)
	  let bufname = bufname(buflist[winnr - 1])
    
    if bufname =~? "fern://"
      return " Fern"
    endif

    return nerdfont#find(bufname) . " " . bufname
endfunction
