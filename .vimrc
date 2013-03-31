filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Awesome git integration
Bundle 'tpope/vim-fugitive'
" Awesome undotree navigation
Bundle 'sjl/gundo.vim'
" Awesome file system navigation
Bundle 'scrooloose/nerdtree'
" Awesome pydoc on K
Bundle 'fs111/pydoc.vim'
" Awesome mass file renaming
Bundle 'vim-scripts/renamer.vim'
" Awesome tag navigation
Bundle 'vim-scripts/taglist.vim'
" Awesome latex integration
Bundle 'jcf/vim-latex'
" Awesomer less replacement
Bundle 'rkitover/vimpager'
" Awesome fancy status line
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim'}
" Awesome gpg integration
Bundle 'https://git.gitorious.org/vim-gnupg/vim-gnupg.git'
" Awesome coffeescript syntax file
Bundle 'kchmck/vim-coffee-script'
" Awesome git status in your vim gutter
Bundle 'airblade/vim-gitgutter'
" Semantic completion. Awesome!
Bundle 'Valloric/YouCompleteMe'
" Awesome error output for YCM
Bundle 'scrooloose/syntastic'

filetype plugin indent on

" Wrap too long lines
set wrap

" Tabs are 4 characters
set tabstop=4

" (Auto)indent uses one tab
set shiftwidth=4

" spaces instead of tabs
" set expandtab

" guess indentation
set autoindent

" Expand the command line using tab
set wildchar=<Tab>

" show line numbers
set number

" Fold using markers {{{
" like this
" }}}
set foldmethod=marker

" enable all features
set nocompatible

" powerful backspaces
set backspace=indent,eol,start

" highlight the searchterms
set hlsearch

" jump to the matches while typing
set incsearch

" ignore case while searching
set ignorecase

" don't wrap words
set textwidth=0

" history
set history=50

" 1000 undo levels
set undolevels=1000

" show a ruler
set ruler

" show partial commands
set showcmd

" show matching braces
set showmatch

" write before hiding a buffer
set autowriteall

" allows hidden buffers to stay unsaved, but we do not want this, so comment
" it out:
"set hidden

"set wmh=0

" auto-detect the filetype
filetype plugin indent on

" syntax highlight
syntax on

" we use a dark background, don't we?
set bg=dark

" Always show the menu, insert longest match
set completeopt=menuone,longest

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

set mouse=a
set t_Co=256
colorscheme zenburn

" Always show the statusline
set laststatus=2
let g:Powerline_symbols = 'unicode'

nnoremap <F5> :GundoToggle<CR>
nnoremap <F3> :NERDTreeToggle<CR>

" http://stackoverflow.com/questions/2575545/vim-pipe-selected-text-to-shell-cmd-and-receive-output-on-vim-info-command-line/2585673#2585673
function Test() range
  let lines = join(getline(a:firstline, a:lastline), "\n")
  echo shellescape(lines)
  echo system(lines)
endfunction
com -range=% Test :<line1>,<line2>call Test()

" Persistent undo file, awesome when used with Gundo
" from https://github.com/L-P/dotfiles/blob/master/.vimrc
set undofile
set undodir=~/.vim/undo

set directory=~/.vim/swap

set wildmenu
set wildmode=list:full

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
autocmd Syntax * syn match ExtraWhitespace /\s\+$/ containedin=ALL

highlight Tab ctermbg=237
autocmd Syntax * syn match Tab /\t/ containedin=ALL

" Latex Suite

" Starting with Vim 7, the filetype of empty .tex files defaults to
" 'plaintex' instead of 'tex', which results in vim-latex not being loaded.
" The following changes the default filetype back to 'tex':
let g:tex_flavor='latex'

let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_GotoError=0
let g:Imap_UsePlaceHolders=0
