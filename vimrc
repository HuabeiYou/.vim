set nocompatible
set hidden
set showcmd
set hlsearch
set ignorecase
set backspace=indent,eol,start
set smartcase
set smartindent
set smarttab
set nostartofline
set ruler
set confirm
set visualbell
set t_vb=
set cmdheight=2
set relativenumber
set notimeout ttimeout ttimeoutlen=200
set softtabstop=2
set expandtab
set cursorline
set noshowmode
set laststatus=2
set clipboard=unnamed
set mouse=a
set encoding=UTF-8

set wildmenu
set wildmode=list:longest
set wildignore=*.docx,*.xlsx,*.jpg,*.png,*.gif,*.img,*.pdf,*.pyc,*.exe,*.flv,*.mp4,*.mov,*.iso

filetype on
filetype indent on
filetype plugin on
syntax on

" Use a line cursor within insert mode and a block cursor everywhere else.
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" PLUGINS ---------------------------------------------------------------- {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
call plug#begin()
Plug 'sheerun/vim-polyglot' " Syntax highlight
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary' " fileType based comment
Plug 'tpope/vim-sleuth'     " smart shift and tab
Plug 'tinted-theming/base16-vim', { 'branch': 'main' }
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/vim-slash'
Plug 'tpope/vim-endwise'
Plug 'jiangmiao/auto-pairs'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" display buffers in status line
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" Airline theme
let g:airline_theme='base16'

" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
    \ { 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Comment'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

" asyncomplete --------------------------------------------------------- {{{
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
let g:asyncomplete_auto_completeopt = 0
set completeopt=menuone,noinsert,noselect,preview
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
" }}}

" colors
set background=dark
let base16colorspace=256
if (match($TERM, "-256color") != -1) && (match($TERM, "screen-256color") == -1)
  set termguicolors
endif
if !has('gui_running')
  set t_Co=256
endif
if filereadable(expand("$HOME/.config/tinted-theming/set_theme.vim"))
  let g:base16_shell_path="$HOME/.config/base16-shell/scripts/"
  source $HOME/.config/tinted-theming/set_theme.vim
endif

" lsp ------------------------------------------------------------------ {{{
let g:lsp_diagnostics_enabled = 0         " disable diagnostics support
function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)

  let g:lsp_format_sync_timeout = 1000
  autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
  au!
  " call s:on_lsp_buffer_enabled only for languages that has the
  " server registered.
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}

" }}}

" KEYMAPS --------------------------------------------------------------- {{{
let mapleader=" "

inoremap jk <Esc>

nnoremap <leader>e :Lexplore<CR>
nnoremap <C-h> <C-w>h<CR>
nnoremap <C-j> <C-w>j<CR>
nnoremap <C-k> <C-w>k<CR>
nnoremap <C-l> <C-w>l<CR>

nnoremap <leader>h :noh<CR>
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprevious<CR>
nnoremap <leader>c :bdelete<CR>
nnoremap <leader>/ :Commentary<CR>
nnoremap <leader>w :w<CR>

vnoremap > >gv
vnoremap < <gv
vnoremap <leader>/ :Commentary<CR>

" vim-slash: place the current match at the center of the window
noremap <plug>(slash-after) zz

" FZF
nnoremap <leader>f :Files<CR>
nnoremap <leader>s :Rg<CR>

" Command-mode abbreviation to replace the :edit Vim command.
cnoreabbrev e Edit


" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

" Undo changes after closing a file
if version >= 703
  set undodir=~/.vim/backup
  set undofile
  set undoreload=10000
endif

" Display cursorline only in active window.
augroup cursor_off
  autocmd!
  autocmd WinLeave * set nocursorline
  autocmd WinEnter * set cursorline
augroup END

" use riggrep for search
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--disabled', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  let spec = fzf#vim#with_preview(spec, 'right', 'ctrl-/')
  call fzf#vim#grep(initial_command, 1, spec, a:fullscreen)
endfunction
command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" }}}
