"--------------------------------------------------------------------------------
source ~/.vim/plugin/setcolors.vim
autocmd CursorHold * call NextColor(1)

"--------------------------------------------------------------------------------
" configure pig syntaxs
"--------------------------------------------------------------------------------
augroup filetypedetect 
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig 
augroup END 


"--------------------------------------------------------------------------------
" configure expanding of tabs for various file types
"--------------------------------------------------------------------------------
au BufRead,BufNewFile *.py set expandtab
au BufRead,BufNewFile *.c set noexpandtab
au BufRead,BufNewFile *.h set noexpandtab
au BufRead,BufNewFile Makefile* set noexpandtab
au BufRead,BufNewFile *.txt set noexpandtab

" set noexpandtab for files without extension
autocmd BufNewFile,BufRead * if expand('%:t') !~ '\.' | set noexpandtab | endif


"--------------------------------------------------------------------------------
" configure editor with tabs and nice stuff...
"--------------------------------------------------------------------------------
set expandtab                   " enter spaces when tab is pressed
set textwidth=120               " break lines when line length increases
set tabstop=4                   " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4                " number of spaces to use for auto indent
set autoindent                  " copy indent from current line when starting a new line
set smartindent                 " smart indent which will be inserted in control block
set backspace=indent,eol,start  " make backspaces more powerfull

set mouse=a                     " enabling mouse=a has a small copy problem
set ruler                       " show line and column number
set number                      " show line number
set bg=light                    " for syntax highlighting purpose
set showcmd                     " show (partial) command in status line
set hlsearch                    " show all search results, press 'n' for next
set list                        " list all whitespace characters
set listchars=eol:$,tab:>-,trail:~,extends:»,precedes:«         " filetype indent plugin on

syntax on                       " syntax highlighting

"--------------------------------------------------------------------------------
" Formats the statusline
"--------------------------------------------------------------------------------
set laststatus=2
set statusline=%f                               " file name
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, " file encoding
set statusline+=%{&ff}]                         " file format
set statusline+=%y                              " filetype
set statusline+=%h                              " help file flag
set statusline+=%m                              " modified flag
set statusline+=%r                              " read only flag

" Puts in the current git status
"if count(g:pathogen_disabled, 'Fugitive') < 1   
"    set statusline+=%{fugitive#statusline()}
"endif

" Puts in syntastic warnings
"if count(g:pathogen_disabled, 'Syntastic') < 1  
"    set statusline+=%#warningmsg#
"    set statusline+=%{SyntasticStatuslineFlag()}
"    set statusline+=%*
"endif

set statusline+=\ %=                        " align left
set statusline+=Line:%l/%L[%p%%]            " line X of Y [percent of file]
set statusline+=\ Col:%c                    " current column
set statusline+=\ Buf:%n                    " Buffer number
set statusline+=\ [%b][0x%B]\               " ASCII and byte code under cursor
