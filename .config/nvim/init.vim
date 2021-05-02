" *******************************
" PLUGINS ***********************
" *******************************
" The following installs vim-plug automatically if it's not present
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" PLUGINS
call plug#begin("~/.vim/plugged")
"  Plug 'dracula/vim'
  Plug 'tveskag/nvim-blame-line'
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
  Plug 'thaerkh/vim-workspace'
  Plug 'tpope/vim-surround'
call plug#end()

" *******************************
" CUSTOM CONFIGS ****************
" *******************************

" GENERAL ************************* 
" Automatically set current working dir to the current file dir
" set autochdir

" enable mouse
set mouse=a
let mapleader = ' '

" automatically jump between tags (<div></div>, {} etc with %)
runtime macros/matchit.vim

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

" toggle workspace session handling
let g:workspace_session_directory = $HOME . '/.vim/sessions/'
nnoremap <A-s> :ToggleWorkspace<CR>

" airline statusbar
let g:airline#extensions#tabline#enabled = 1
" let g:airline_statusline_ontop=1
let g:airline_powerline_fonts = 1
let g:airline_theme='zenburn'
let g:airline#extensions#tabline#enabled = 0

" THEME ************************* 


let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

if (has("termguicolors"))
 set termguicolors
endif
syntax enable
colorscheme gruvbox
set background=dark

" NERDTree ***********************
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = '%#NonText#'
" Automaticaly close nvim if NERDTree is only thing left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber

" QUICKFIX LIST *****************************
nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz
nnoremap <C-q> :call ToggleQFList(1)<CR>
nnoremap <leader>q :call ToggleQFList(0)<CR>

let g:status_qf_l = 0
let g:status_qf_g = 0

fun! ToggleQFList(global)
    if a:global
        if g:status_qf_g == 1
            let g:status_qf_g = 0
            cclose
        else
            let g:status_qf_g = 1
            copen
        end
    else
        if g:status_qf_l == 1
            let g:status_qf_l = 0
            lclose
        else
            let g:status_qf_l = 1
            lopen
        end
    endif
endfun

" FUZZY SEARCH *******************************************************
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-c': 'split',
  \ 'ctrl-v': 'vsplit'
  \}
let $FZF_DEFAULT_OPTS='--layout=reverse --margin=1,2 --info=hidden --bind ctrl-a:select-all' 


" Keybindings
nnoremap <silent> <C-p> :FindFile<CR>
nnoremap <silent> <C-f> :SearchInAllFiles<cr>

" Commands
command! -bang -nargs=? -complete=dir FindFile call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': '--prompt 🔍'}), <bang>0)
command! -nargs=* -bang SearchInAllFiles call RipgrepFzf(<q-args>, <bang>0)

" Advanced ripgrep integration
" https://github.com/junegunn/fzf.vim/#example-advanced-ripgrep-integration
" --column and --line-number NEEDS to be set or it won't work properly
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--prompt', '🔍', '--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

" Hide status line when fzf is active
autocmd! FileType fzf set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 showmode ruler

" Open FZF in floating window
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }


" FLOATING WINDOW ***************************************************
function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    let win1 = nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    let win2 = nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
    " Close border-window AND buffer window on <Esc>
    " https://www.reddit.com/r/neovim/comments/ekzhme/help_wanted_changing_keymap_for_floating_window/
    tnoremap <silent> <buffer> <Esc> <C-\><C-n><CR>:bw!<CR>
endfunction

function! ToggleTerm(cmd)
    if empty(bufname(a:cmd))
        call CreateCenteredFloatingWindow()
        call termopen(a:cmd, { 'on_exit': function('OnTermExit') })
    else
        bwipeout!
    endif
endfunction

function! OnTermExit(job_id, code, event) dict
    if a:code == 0
        bwipeout!
    endif
endfunction

" Cool programs started in floting window
nnoremap <silent> <F1> :call ToggleTerm('lazygit')<CR> i
nnoremap <silent> <F2> :call ToggleTerm('ytop')<CR> i
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

" VIM STATUS LINE ****************
" set tabline=%!crystalline#bufferline()
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set cmdheight=1

" COC Go to definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" COC AUTO COMPLETE SUGGESTION WITH <TAB> ***************************
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

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

nnoremap <silent> <C-g> :ToggleBlameLine<CR>
