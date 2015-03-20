" -----------------------------------------------------
" Important
" -----------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required for Vundle

" -----------------------------------------------------
" Plugins
" -----------------------------------------------------
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'kien/ctrlp.vim'
Plugin 'junegunn/vim-easy-align'
Plugin 'pangloss/vim-javascript'
Plugin 'ervandew/supertab'
Plugin 'Shougo/neocomplete.vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'Raimondi/delimitMate'
Plugin 'marijnh/tern_for_vim'
Plugin 'bling/vim-airline'
Plugin 'Lokaltog/vim-easymotion'
" Plugin 'airblade/vim-gitgutter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'digitaltoad/vim-jade'
Plugin 'fatih/vim-go'
Plugin 'othree/javascript-libraries-syntax.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'tpope/vim-commentary'
Plugin 'groenewege/vim-less'
Plugin 'mhinz/vim-startify'
Plugin 'ryanss/vim-hackernews'
Plugin 'mxw/vim-jsx'
Plugin 'othree/html5.vim'
Plugin 'wavded/vim-stylus'
Bundle 'maksimr/vim-jsbeautify'
Bundle 'einars/js-beautify'
Bundle 'mattn/emmet-vim'

call vundle#end()            " required
filetype plugin indent on    " required

" -----------------------------------------------------
" Moving around, searching and patterns
" ------------------------------------------------------
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set smartcase                   " Case sensitive when uc present

set iskeyword-=.                " '.' is an end of word designator
set iskeyword-=#                " '#' is an end of word designator
set iskeyword-=-                " '-' is an end of word designator

set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too

" -----------------------------------------------------
" Displaying text
" -----------------------------------------------------
set guifont=Inconsolata\ for\ Powerline:h16
set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set nu                          " Line numbers on
set relativenumber              " Relative line numbers

set scrolljump=1                " Lines to scroll when cursor leaves screen
set scrolloff=8                 " Minimum lines to keep above and below cursor
set list                        " Show white space characters
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set nowrap                      " Don't wrap long lines Don't

" -----------------------------------------------------
" Syntax, highlighting and spelling
" -----------------------------------------------------
syntax on
syntax sync minlines=256
set background=dark
set t_Co=256
let g:solarized_termcolors=256
colorscheme solarized
set nospell                     " Spell checking on

" -----------------------------------------------------
" Multiple windows
" -----------------------------------------------------
set hidden                      " Allow buffer switching without saving
set splitright                  " A new window is put right of the current one
set splitbelow                  " A new window is put below of the current one
set laststatus=2                " Always show the status bar / Airline

" -----------------------------------------------------
" Using the mouse
" -----------------------------------------------------
set mouse=a "Enabled mouse for highlighting text
set mousehide "Hide mouse while characters are being typed

" -----------------------------------------------------
" Selecting text
" -----------------------------------------------------

" -----------------------------------------------------
" Editing text
" -----------------------------------------------------
set showmatch                   " Show matching brackets/parenthesis
autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> call StripTrailingWhitespace()
" -----------------------------------------------------
" Tabs and indenting
" -----------------------------------------------------
set autoindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab " use spaces instead of tabs.
set smarttab " let's tab key insert 'tab stops', and bksp deletes tabs.
set shiftround " tab / shifting moves to closest tabstop.
set smartindent " Intellegently dedent / indent new lines based on rules."

" -----------------------------------------------------
" Folding
" -----------------------------------------------------
set foldenable                  " Auto fold code

augroup vimrc
  au BufReadPre * setlocal foldmethod=indent
  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
augroup END

" -----------------------------------------------------
" Diff mode
" ----------------------------------------------------

" -----------------------------------------------------
" Mapping
" -----------------------------------------------------
set timeoutlen=250

" -----------------------------------------------------
" The swap file
" -----------------------------------------------------
set noswapfile " Turn off swp file creation

" -----------------------------------------------------
" Command line editing
" -----------------------------------------------------
set history=1000                " Store a ton of history (default is 20)
set wildmenu                    " Show list instead of just completing
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.

" -----------------------------------------------------
" Various
" -----------------------------------------------------
scriptencoding utf-8
set clipboard=unnamed

set undofile                                            " save central undo files
set undodir=~/.vim/tmp/undo/
set backup                                              " enable backups
set backupdir=~/.vim/tmp/backup/
set virtualedit=onemore                                 " Allow for cursor beyond last character
set nojoinspaces                                        " Don't add more spaces with joing lines with <S-J>

" -----------------------------------------------------
" Key (re)mappings
" -----------------------------------------------------
let mapleader = ' '  " Set space to <Leader>"
imap jk <Esc>
vmap jk <Esc>

noremap j gj
noremap k gk
" Make Y act like D and C
noremap Y y$

" Go to the end of what was just pasted.
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

vnoremap < <gv
vnoremap > >gv

noremap <tab> :bn<CR>
noremap <S-tab> :bp<CR>
noremap <Leader>x :bd<CR>

" Replace current word with what is in the clipboard
nnoremap S "_diwP

" Toggle comment line with <leader> c
map <Leader>c gcc

" Move lines around with Alt j and k in any mode
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==

inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi

vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" Adjust viewports to the same size
map <Leader>= <C-w>=

cmap w!! w !sudo tee > /dev/null %

nnoremap <leader>w :w<cr>

nnoremap <Leader>h :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>
vnoremap <Leader>h "hy:%s/<C-r>h//gc<left><left><left>

" vimrc edit and source
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

let g:indent_guides_enable_on_vim_startup = 0

nmap <leader>jf <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>

" -----------------------------------------------------
" PLugin settings
" -----------------------------------------------------
" NERFTree customizations
map <C-n> :NERDTreeToggle<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\~$', '\.swp$', '^\.git$']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" CtrlP customizations
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = { 'dir':  '\.git$' }
let s:ctrlp_fallback = 'ack %s --nocolor -f'
let g:ctrlp_user_command = {
      \ 'types': {
      \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
      \ },
      \ 'fallback': s:ctrlp_fallback
      \ }

"Fugitive customizations
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gr :Gread<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>ge :Gedit<CR>
" Mnemonic _i_nteractive
nnoremap <silent> <leader>gi :Git add -p %<CR>
nnoremap <silent> <leader>gg :SignifyToggle<CR>

" Start ieteractive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. <Leader>aip)
nmap <Leader>a <Plug>(EasyAlign)

" EasyMotion
nmap <Leader><Leader>s <Plug>(easymotion-s)

" change the default EasyMotion shading to something more readable with Solarized
hi link EasyMotionTarget ErrorMsg
hi link EasyMotionShade  Comment

" Settings for gitgutter to look right with solarized theme
highlight clear SignColumn
highlight GitGutterAdd ctermfg=2* guifg=darkgreen " Had to use the 2* to get it to turn green
highlight GitGutterChange ctermfg=yellow guifg=darkyellow
highlight GitGutterDelete ctermfg=red guifg=darkred
highlight GitGutterChangeDelete ctermfg=yellow guifg=darkyellow

" Airline
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1

" Expand region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Javascript library syntax highlighting settings
let g:used_javascript_libs = 'underscore,jquery,angularjs,chai'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Use goimports
let g:go_fmt_command = "goimports"
" -----------------------------------------------------
" Helper functions
" -----------------------------------------------------
" Strip whitespace
function! StripTrailingWhitespace()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " do the business:
  %s/\s\+$//e
  " clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

  autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
    " for html
  autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
    " for css or scss
  autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>

