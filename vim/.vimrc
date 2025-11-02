set nocompatible

" === Filetype detection ===
filetype on
filetype plugin on
filetype indent on

" === Formatting ===
syntax on
set nowrap
autocmd BufEnter *.md set wrap " Set wrapping only for Markdown files

set showcmd
set showmode
set showmatch

set number
set relativenumber

set cursorline

" === Settings ===

" Search
set incsearch
set ignorecase
set hlsearch

" Split window
set splitbelow
set splitright

" Tab
set shiftwidth=4
set tabstop=4
set expandtab

" Wildmenu/wildmode
set wildmenu
set wildmode=longest:full,full

" === Plugin ===

" Install vim-plug if missing
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Install plugins
call plug#begin()
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'mhinz/vim-signify'
Plug 'preservim/nerdtree'
Plug 'wfxr/minimap.vim'
Plug 'itchyny/lightline.vim'
Plug 'https://github.com/sheerun/vim-polyglot.git'
Plug 'natebosch/vim-lsc'
Plug 'wellle/context.vim'
Plug 'arcticicestudio/nord-vim'
call plug#end()

silent! colorscheme nord
set termguicolors
" hi Normal guibg='#1A202C'
hi Normal guibg=NONE

" fzf.vim
set rtp+=~/.fzf
let g:fzf_colors = {
\   'fg':      ['fg', 'Normal'],
\   'bg':      ['bg', 'Normal'],
\   'query':   ['fg', 'Normal'],
\   'hl':      ['fg', 'Comment'],
\   'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
\   'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
\   'hl+':     ['fg', 'Statement'],
\   'info':    ['fg', 'PreProc'],
\   'border':  ['fg', 'Ignore'],
\   'prompt':  ['fg', 'Conditional'],
\   'pointer': ['fg', 'Exception'],
\   'marker':  ['fg', 'Keyword'],
\   'spinner': ['fg', 'Label'],
\   'header':  ['fg', 'Comment']
\ }
let $BAT_THEME = 'Nord'

" vim-lsc
let g:lsc_server_commands = {
\   'python': 'pylsp',
\   'cpp': {
\     'command': 'clangd --background-index',
\     'suppress_stderr': v:true
\   },
\   'c': {
\     'command': 'clangd --background-index',
\     'suppress_stderr': v:true
\   },
\   'sh': 'bash-language-server start',
\   'vim': {
\     'name': 'vim-language-server',
\     'command': 'vim-language-server --stdio',
\     'message_hooks': {
\       'initialize': {
\         'initializationOptions': { 'vimruntime': $VIMRUNTIME, 'runtimepath': &rtp },
\       },
\     },
\   },
\   'yaml': 'yaml-language-server --stdio',
\ }

" lightline.vim
set laststatus=2
let g:lightline = { 'colorscheme': 'nord' }
let g:lightline.active = {
\ 'left': [ [ 'mode', 'paste' ],
\           [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
\ 'right': [ [ 'lineinfo' ],
\            [ 'percent' ],
\            [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ }
let g:lightline.component_function = {
\ 'gitbranch': 'FugitiveHead'
\ }
