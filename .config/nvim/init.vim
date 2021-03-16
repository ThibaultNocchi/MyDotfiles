set showcmd   " Show (partial) command in status line.
set incsearch " Cherche au fur et à mesure 
set autowrite " Automatically save before commands like :next and :make

set linebreak " “casse” les lignes plus longues que l'écran
set breakindent " Every wrapped line will continue visually indented (same amount of space as the beginning of that line), thus preserving horizontal blocks of text.
" Symbole pour représenter une ligne plus longue que l'écran
set showbreak=˪

set noshowmatch
set wildmenu " Plus sympa quand tu fais <Tab> dans la ligne de commande
set hidden " Hide buffers when they are abandoned
set autoread " When a file has been detected to have been changed outside of Vim and it has not been changed inside of Vim, automatically read it again.
set wildignore=*.aux,*.log
set undofile " Permet de undo/redo même après avoir fermé un fichier

" Open splits in a normal way
set splitbelow
set splitright


set autoindent " Copy indent from current line when starting a new line

set foldcolumn=1 "Set the foldcolumn (fold = "plier" du code pour le cacher)

" Use nicer symbols to symbolise invisible characters when list is enabled
set listchars=tab:▸\ ,eol:¬,space:␣

" Setting the statusline
set laststatus=2
set statusline=%m\ %f\ %=\ %y\ %r

augroup markdown
  autocmd!
  autocmd FileType markdown set spell
  autocmd FileType markdown set spelllang=fr,en
augroup END

augroup misc
	autocmd!
	autocmd BufWrite * mkview
	autocmd BufWinEnter * silent! loadview

  " Resize the splits when Vim is itself resized
  autocmd VimResized * wincmd =
augroup END

set tabstop=2
set softtabstop=2
set shiftwidth=2
