 if &shell =~# 'fish$'
  set shell=/run/current-system/sw/bin/bash
endif

set runtimepath+=~/.vim

let mapleader = " "

" ctrlp
nnoremap <C-p> :FZF <cr>

" Haskell

" Disable haskell-vim omnifunc
let g:haskellmode_completion_ghc = 0
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

let g:ycm_semantic_triggers = {'haskell' : ['.', '{-# ', 're!{-# \w+ ', 'import ', 're!import .+\(.*,?', 're!deriving \(.*,?']}

augroup NeomakeHaskell
  autocmd!
  autocmd! BufWritePost *.hs Neomake
augroup END

" NERDTree
let g:NERDTreeChDirMode = 2
let g:NERDTreeMinimalUI = 1

" Prevent deleting nerdtree buffer
autocmd FileType nerdtree cnoreabbrev <buffer> bd :call g:WorkaroundNERDTreeToggle()<CR>

function! g:WorkaroundNERDTreeToggle()
  try | :NERDTreeToggle | catch | :enew | endtry
  echo ''
endfunction

" Global Stuff
"-----------------------------------------------------------------------------

" Set filetype stuff to on
filetype plugin indent on
set ttyfast " Improves redrawing

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smartindent

" Necessary to show unicode glyphs
set encoding=utf-8

" Explicitly tell vim that the terminal supports 256 colors
set t_Co=256

" set the search scan to wrap lines
set wrapscan

"vset line wrapping off
set nowrap

" set the search scan so that it ignores case when the search is all lower
" case but recognizes uppercase if it's specified
set ignorecase
set smartcase

" set the forward slash to be the slash of note.  Backslashes suck
set shellslash
set shell=/bin/bash

" Make command line one lines high
set ch=1

" set visual bell -- i hate that damned beeping
set novb

" set line numbers
set nu

" Allow backspacing over indent, eol, and the start of an insert
set backspace=2

" Make sure that unsaved buffers that are to be put in the background are
" allowed to go in there (ie. the "must save first" error doesn't come up)
set hidden

" Set the status line the way i like it
set stl=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]

" tell VIM to always put a status line in, even if there is only one window
set laststatus=2

"" Don't update the display while executing macros
set lazyredraw

" Show the current command in the lower right corner
set showcmd

" Show the current mode
set showmode

" Switch on syntax highlighting.
syntax on

" Hide the mouse pointer while typing
set mousehide
" Set mouse click are to be more compatible and wider on unsupported screens

" Set up the gui cursor to look nice
set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=ve:ver35-Cursor
set guicursor+=o:hor50-Cursor
set guicursor+=i-ci:ver25-Cursor
set guicursor+=r-cr:hor20-Cursor
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

" set the gui options the way I like
set guioptions=ac

" This is the timeout used while waiting for user input on a multi-keyed macro
" or while just sitting and waiting for another key to be pressed measured
" in milliseconds.
"
" i.e. for the ",d" command, there is a "timeoutlen" wait period between the
"	   "," key and the "d" key.  If the "d" key isn't pressed before the
"	   timeout expires, one of two things happens: The "," command is executed
"	   if there is one (which there isn't) or the command aborts.
set timeoutlen=500

" Keep some stuff in the history
set history=100

" These commands open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

set nofoldenable

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8

" Allow the cursor to go in to "invalid" places
set virtualedit=all

" These things start comment lines
set comments=sl:/*,mb:\ *,ex:\ */,O://,b:#,:%,:XCOMM,n:>,fb:-

" Make the command-line completion better
set wildmenu

" Same as default except that I remove the 'u' option
set complete=.,w,b,t

" When completing by tag, show the whole tag, not just the function name
set showfulltag

" Set the textwidth to be 120 chars
set textwidth=120

" get rid of the silly characters in window separators
set fillchars=""

" Add ignorance of whitespace to diff
set diffopt+=iwhite

" Enable search highlighting
set hlsearch

" Incrementally match the search
set incsearch

" Set the tags files to be the following
" set tags+=vendor.tags

" Change startup messsage
set shortmess+=I

set background=dark

" Set color scheme to dejanr
let g:base16colorspace=256
colorscheme base16-default

" disable swapping
set nobackup
set noswapfile

" Toggle paste mode
nmap <silent> <leader>i :set invpaste<CR>:set paste?<CR>

" cd to the directory containing the file in the buffer
nmap <silent> <leader>cd :lcd %:h<CR>

" Turn off that stupid highlight search
nmap <silent> <leader>n :set invhls<CR>:set hls?<CR>

" Show all available VIM servers
nmap <silent> <leader>ss :echo serverlist()<CR>

" set text wrapping toggles
nmap <silent> <leader>w :set invwrap<CR>:set wrap?<CR>

" Edit the vimrc file
nmap <leader>ev :e $MYVIMRC<CR>
nmap <leader>sv :so $MYVIMRC<CR>

" Make horizontal scrolling easier
nmap <silent> <C-o> 20zl
nmap <silent> <C-i> 20zh

nmap <silent> <leader>q :q!<CR>

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

" I don't like it when the matching parens are automatically highlighted
" let loaded_matchparen = 1

" Show syntax highlighting groups for word under cursor
nmap <leader>g :call SyntaxAttr()<CR>

" Rebuild ctaglist
nmap <leader>cx :!ctags<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS

let g:snippets_dir = '~/.vim/snippets'

" Minimum window height = 0
set wmh=0

" Ignore this files when search files
set wildignore+=.git/*,*/.git/*,*.DS_Store,*/node_modules/*,*/dist/*
set wildignore+=*/cache/*,*/.sass-cache/*
set wildignore+=*/coverage/*,*/public/*,*-min.js,*-build.js

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => PHP
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre *.* :call <SID>StripTrailingWhitespaces()

" JSON
augroup json_autocmd
  autocmd!
  autocmd FileType json set autoindent
  autocmd FileType json set formatoptions=tcq2l
  autocmd FileType json set textwidth=78 shiftwidth=2
  autocmd FileType json set softtabstop=2 tabstop=2
  autocmd FileType json set expandtab
  autocmd FileType json set foldmethod=manual
augroup END

" Bash like keys for the command line
cnoremap <C-A> <Home>
cnoremap <C-E> <End>
cnoremap <C-K> <C-U>
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>rm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly ope a buffer for scripbble
map <leader>oq :e ~/buffer<cr>
au BufRead,BufNewFile ~/buffer iab <buffer> xh1 ===========================================
au BufNewFile,BufRead *.rs set filetype=rust

" CommandT
let g:CommandTMaxHeight = 20
let g:CommandTMinHeight = 20

" Remap arrow keys
inoremap <Up> <nop>
inoremap <Down> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>

" Use custom characters for tabstops and EOLs
set listchars=tab:▸\ ,eol:●

" Invisible character(tabstops, EOLs) custom color
highlight NonText guifg=#124956

" Toggle list, showing or hiding special chars
nmap <leader>l :setlocal list!<cr>

" Dont show special characters by default
set nolist

" Start daily report
nmap <silent> <leader>gn :enew<CR>:set ft=html<CR>idaily<tab>

" Vimux
let g:VimuxOrientation = "v"
let g:VimuxUseNearestPane = 1

nmap t :VimuxRunLastCommand<CR>
nmap <leader>s :w<CR>

if has('mouse')
  set mouse=a
  set mousehide

  if has('mouse_sgr')
    set ttymouse=sgr
  endif
endif

" dont map stupid s
nnoremap s <nop>

set guifont=PragmataPro:h13
let g:Powerline_symbols='fancy'

" Shortcut for file explorer
nmap <leader>f :NERDTreeFocus<CR>

" netrw settings
let g:netrw_banner = 0
let g:netrw_browse_split = 0

nmap <leader>b :CtrlPBuffer<CR>

" Set dictionary (Its used with C-X C-K to autocomplete words)
set dictionary=/usr/share/dict/words

" Using gf to jump to node js file
set suffixesadd+=.js
set path+=$PWD/node_modules
