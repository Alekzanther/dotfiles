" *******************************
" PLUGINS ***********************
" *******************************
call plug#begin("~/.vim/plugged")
"  Plug 'dracula/vim'
  Plug 'morhetz/gruvbox'
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
"  Plug 'rbong/vim-crystalline'
  Plug 'sheerun/vim-polyglot'
  Plug 'mhinz/vim-startify'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
call plug#end()

" *******************************
" CUSTOM CONFIGS ****************
" *******************************

" GENERAL ************************* 
" Automatically set current working dir to the current file dir
set autochdir

" Homogenous clipboard 
set clipboard=unnamedplus

" Hybrid line number
:set number relativenumber
:set nu rnu

" Case insensitive searching
set ignorecase
set smartcase

" No wrapping of text
set nowrap           " do not automatically wrap on load
set formatoptions-=t " do not automatically wrap text when typing

" Remove search highlighting on second <Enter>
nnoremap <silent> <CR> :noh<CR><CR>

" airline statusbar
let g:airline_statusline_ontop=1
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'

" THEME ************************* 
if (has("termguicolors"))
 set termguicolors
endif
syntax enable
colorscheme gruvbox

" NERDTree ***********************
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = '%#NonText#'
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" RIPGREP ************************
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
nnoremap <A-f> :Rg<CR>
" the following removes file name results when searching in files
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" TERMINAL ***********************
" open new split panes to right and below
set splitright
set splitbelow
" turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>
" start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
" open terminal on ctrl+n
function! OpenTerminal()
  split term://zsh
  resize 10
endfunction
nnoremap <c-n> :call OpenTerminal()<CR>
" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l


" FUZZY SEARCH *******************
nnoremap <C-p> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

" VIM STATUS LINE ****************
" set tabline=%!crystalline#bufferline()
" set showtabline=2
" set noshowmode
" set noruler
" set laststatus=0
" set noshowcmd

" START SCREEN *******************
let g:startify_lists = [
  \ { 'type': 'files',     'header': ['   Recent']            },
  \ { 'type': 'dir',       'header': ['   Recent '. getcwd()] },
  \ { 'type': 'sessions',  'header': ['   Sessions']       },
  \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
  \ { 'type': 'commands',  'header': ['   Commands']       },
  \ ]


let g:startify_custom_header =
  \ 'startify#pad(startify#fortune#boxed())'
