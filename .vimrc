" basic settings
set showcmd
set showmode

" allow cursor keys in insert mode
set esckeys
set nocompatible

" use UTF-8 without BOM
set encoding=utf-8 nobomb

" show invisible characters
" set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_
" set list

" disable backup and swap files
set nobackup
set nowritebackup
set noswapfile

" centralize backups, swap files and undo history
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
if exists("&undodir")
	set undodir=~/.vim/undo
endif

" tab and indent
set tabstop=2
set softtabstop=2
set shiftwidth=2

" enable syntax highlighting
syntax on
" Enable line numbers
set number

" highlight searches
set hlsearch
" Ignore case of searches
set ignorecase

" highlight some keywords
highlight todoHighlight cterm=bold term=bold ctermfg=yellow
match todoHighlight /\(\FIXME|NOTE\|TODO\)/

" disable error bells
set noerrorbells

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
