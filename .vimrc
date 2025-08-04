"   List of directories which will be searched when using the find type commands
set path+=**

" Display all the files when matching
set wildmenu
set wildignore+=*.pyc,*.pyo,*.so,*.swp,*.zip

" - check |netrw-browse-maps| for more mappings
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view

" When on, splitting a window will put the new window below the current one.
set splitbelow

" When on, splitting a window will put the new window right of the current one.
set splitright

" backspace:             specifies what <BS>, CTRL-W, etc. can do in Insert mode
set backspace=2

" whichwrap:        list of flags specifying which commands wrap to another line
set whichwrap=[,]

" winminheight:                      minimal number of lines used for any window
set winminheight=0
set winminwidth=0

" history:                                 how many command lines are remembered 
set history=100

" ruler:                                  show cursor position below each window
set ruler

" showcmd:                        show (partial) command keys in the status line
set showcmd

" incsearch:                          show match for partly typed search command
set incsearch

" number:                                     show the line number for each line
set nu

set nobackup                   " do not keep a backup file, use versions instead

set nocompatible

" disable beep and flash
set vb t_vb=

" I don't like search highlighting
set nohlsearch

syntax on


colorscheme molokai

" change colors when file is readonly
function CheckRo()
  if &readonly
    colorscheme pablo
  elseif &diff
    colorscheme diff
  else
    colorscheme molokai
  endif
endfunction
au BufReadPost * call CheckRo()

" when editing muliple file with :sp you can switch between them
" with <ctrl>-j and <ctrl>-k
map <C-J> <C-W>j<C-W>_
map <C-K> <C-W>k<C-W>_

" Status line
"--------------------------------------------------------------------------
set statusline= " clear the statusline for when vimrc is reloaded
set statusline+=%f\ " file name
set statusline+=%h%m%r%w " flags
set statusline+=[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{strlen(&fenc)?&fenc:&enc}, " encoding
set statusline+=%{&fileformat}] " file format
set statusline+=%= "left/right separator
set statusline+=%b,0x%-8B\ " current char
set statusline+=%c,%l/ "cursor column/total lines
set statusline+=%L\ %P "total lines/percentage in file
set ls=2
