"      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
" `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
"
" github.com/rafi vim config

" references:
" https://github.com/indraniel/dotfiles/
" https://github.com/justinforce/dotfiles/
" https://github.com/joonty/myvim

"==============================================================================
" Basic
"------------------------------------------------------------------------------

set nocompatible              " break away from old vi compatibility
set esckeys                   " allow func keys that start with an <Esc> in insert mode
set mouse=a                   " allows mouse scrolling and selection in terminal

set report=0                  " report back on all changes
set shortmess=atI             " shorten messages and don't show intro

set cmdheight=1               " explicitly set the height of the command line
set showcmd                   " Show (partial) command in status line.
set showmode                  " Show the current mode
set number                    " yay line numbers
set ruler                     " show current position at bottom
set noerrorbells              " don't whine
set visualbell t_vb=          " and don't make faces
set lazyredraw                " don't redraw while in macros
set wrap                      " soft wrap long lines
set list                      " show invisible characters
set noswapfile
set nobackup                  " do not backup when overwriting files
set hidden                    " hide buffers when abandoned instead of unload
set encoding=utf-8
set foldmethod=marker

set wildmenu                  " turn on wild menu :e <Tab>
set wildmode=list:longest     " set wildmenu to list choice
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/cache/*,*.sassc

" REMOTE hosts
"set ttyfast
"set nofsync

execute pathogen#infect()
filetype plugin indent on
syntax on

set smartindent
set autoindent
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set complete-=i
set smarttab

set nrformats-=octal
set shiftround

set ttimeout
set ttimeoutlen=50

set laststatus=2
set display+=lastline
set autoread                  " Files are read as soon as they are changed
set history=1000
set tabpagemax=50

set splitbelow
set splitright

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
endif

" Searching
set incsearch                 " incremental search
set ignorecase                " search ignoring case
set smartcase                 " keep case when searching with *
set hlsearch                  " highlight the search
set showmatch                 " show matching bracket
set diffopt=filler,iwhite     " ignore all whitespace and sync
set matchtime=5               " blink matching chars for .x seconds
set nostartofline             " leave my cursor position alone!

" Formatting
" t - autowrap to textwidth
" c - autowrap comments to textwidth
" r - autoinsert comment leader with <Enter>
" q - allow formatting of comments with :gq
" l - don't format already long lines
set formatoptions=crql

setlocal noexpandtab          " Don't expand tabs to spaces.
set tabstop=2
set shiftwidth=2
set showtabline=2
set scrolloff=3               " keep at least 3 lines above/below
set sidescrolloff=3           " keep at least 3 lines left/right

set foldenable
set textwidth=90
set cursorline

" Highlight 91 and onward
set colorcolumn=+1
"let &colorcolumn=join(range(91,200),",")

" Changing cursor shape per mode
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
if exists('$TMUX')
	" tmux will only forward escape sequences to the terminal if surrounded by a DCS sequence
	" cursor color in insert mode
"	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;9\x7\<Esc>\\"
	" cursor color otherwise
"	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;11\x7\<Esc>\\"
"	silent !echo -ne "\033Ptmux;\033\033]12;11\007\033\\"
	" reset cursor when vim exits
"	autocmd VimLeave * silent !echo -ne "\033Ptmux;\033\033]12;4\007\033\\"
"	let &t_SI .= "\<Esc>Ptmux;\<Esc>\<Esc>[4 q\<Esc>\\"
"	let &t_EI .= "\<Esc>Ptmux;\<Esc>\<Esc>[2 q\<Esc>\\"
"	autocmd VimLeave * silent !echo -ne "\033Ptmux;\033\033[0 q\033\\"
else
	" cursor color in insert mode
"	let &t_SI = "\<Esc>]12;9\x7"
	" cursor color otherwise
"	let &t_EI = "\<Esc>]12;11\x7"
"	silent !echo -ne "\033]12;11\007"
	" reset cursor when vim exits
"	autocmd VimLeave * silent !echo -ne "\033]12;4\007"
"	let &t_SI .= "\<Esc>[4 q"
"	let &t_EI .= "\<Esc>[2 q"
"	autocmd VimLeave * silent !echo -ne "\033[0 q"
endif

"==============================================================================
" Plugin configuration
"------------------------------------------------------------------------------

let g:lightline = {
	\ 'colorscheme': 'jellybeans',
	\ 'separator': { 'left': '░', 'right': '<' },
	\ 'subseparator': { 'left': '|', 'right': '|' }
	\ }

" tagbar autoopen and compact view
let g:tagbar_compact = 1
"autocmd VimEnter * nested :call tagbar#autoopen(1)

" php refactor phar path
let g:php_refactor_command='php ~/bin/refactor.phar'

let g:vim_markdown_initial_foldlevel=5

" When invoked, unless a starting directory is specified, CtrlP will set its local working
" directory according to this variable:
" http://kien.github.io/ctrlp.vim/
let g:ctrlp_working_path_mode = 'ra'

" NERDTree custom configuration
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeQuitOnOpen=1

" Open NERDTree automatically when vim starts up with no files
autocmd vimenter * if !argc() | NERDTree | endif

" Close vim if the only window left open is a NERDTree
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Syntastic
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_enable_balloons = 1
let g:syntastic_auto_loc_list=1

"==============================================================================
" Key bindings
"------------------------------------------------------------------------------

" Want a different map leader than \
let mapleader=" "

" Maps the semicolon to colon in normal mode
nmap ; :

" Trick by Steve Losh: save a file if you forgot to sudo before editing
" http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
cmap w!! w !sudo tee % >/dev/null

" Quick insert mode exit
imap jk <Esc>

" Create splits
nnoremap <leader>sh :sp<CR>
nnoremap <leader>sv :vsp<CR>
" Move across splits with Alt+m,n.
nnoremap m <C-w>j
nnoremap , <C-w>k
nnoremap n <C-w>h
nnoremap . <C-w>l

" Fast saving
nnoremap <Leader>w :w<CR>
vnoremap <Leader>w <Esc>:w<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
vnoremap <C-s> <Esc>:w<CR>

" Select blocks after indenting
vnoremap < <gv
vnoremap > >gv

" Line number type toggle
nnoremap <Leader>l :set nonumber!<CR>

" Clear the highlighting of :set hlsearch
nmap <silent> <Leader>h :silent :nohlsearch<CR>

" CtrlP
"nnoremap <Leader>t :CtrlP getcwd()<CR>
"nnoremap <Leader>f :CtrlPClearAllCaches<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>j :CtrlP ~/<CR>
nnoremap <Leader>r :CtrlP<CR>

" Instead of 1 line, move 3 at a time
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Show hidden characters (spaces, tabs, etc)
nmap <silent> <leader>s :set nolist!<CR>

" PHPDoc commands
"inoremap <C-d> <ESC>:call PhpDocSingle()<CR>i
"nnoremap <C-d> :call PhpDocSingle()<CR>
"vnoremap <C-d> :call PhpDocRange()<CR>

" Fugitive shortcuts
"nnoremap <Leader>c :Gcommit -a<CR>i
"nnoremap <Leader>g :Git
"nnoremap <Leader>a :Git add %:p<CR>

map <Leader>y "+y
map <Leader>p "+p

" Yank to primary clipboard with Ctrl+c
map <C-c> "+y

" Tagbar keys
nmap <F8> :TagbarToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>

" When pressing <leader>cd switch to the directory of the open buffer
map <Leader>cd :cd %:p:h<CR>

" Remap <C-space> to word completion
noremap! <Nul> <C-n>

" Faster shortcut for commenting. Requires T-Comment plugin
"map <Leader>c <c-_><c-_>

" Shortcut to fold tags
"nnoremap <Leader>ft Vatzf

" Edit the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>es :so $MYVIMRC<CR>

" NERDTree keys
nmap <F1> :NERDTreeToggle<CR>
noremap <silent> <Leader>f :NERDTreeToggle<CR>

" Buffers
map <Esc>[27;5;9~ <C-Tab>
map <Esc>[27;6;9~ <C-S-Tab>
nnoremap <C-Tab> :bn<CR>
nnoremap <C-S-Tab> :bp<CR>

" Closes current buffer
nnoremap <silent> <Leader>q :close<CR>

" tab shortcuts
"map <C-t> :tabnew<CR>
map <S-Left> :tabp<CR>
map <S-Right> :tabn<CR>

" Make Vim recognize xterm escape sequences for Page and Arrow
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
	" Ctrl+Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
	execute "set t_kP=\e[5;*~"
	execute "set t_kN=\e[6;*~"

	" Arrow keys http://unix.stackexchange.com/a/34723
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif

"==============================================================================
" Functions
"------------------------------------------------------------------------------

"==============================================================================
" Colors
"------------------------------------------------------------------------------

set t_Co=256
set background=dark

colorscheme hybrid " wombat256mod, mustang, jellybeans, kraihlight, pablo

" wombat256mod changes
"highlight Normal       ctermbg=235
"highlight ColorColumn  ctermbg=0
"highlight CursorLine   ctermbg=236
"highlight CursorLineNr ctermfg=240
"highlight CursorColumn ctermbg=234
"highlight SpecialKey   ctermfg=237 ctermbg=235
"highlight SignColumn   ctermbg=236
"highlight LineNr       ctermfg=238 ctermbg=0
"highlight TabLineFill  ctermfg=236
"highlight TabLine      ctermfg=242 ctermbg=235
"highlight TabLineSel   ctermfg=250 ctermbg=236

" mustang changes
"highlight CursorLine   ctermbg=235 cterm=NONE
""highlight CursorLineNr ctermfg=240
"highlight SpecialKey   ctermfg=235 ctermbg=234
"highlight SignColumn   ctermbg=234
"highlight LineNr       ctermfg=235 ctermbg=234
"highlight ColorColumn  ctermbg=0

"==============================================================================
" Fonts
"------------------------------------------------------------------------------

set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:.,trail:·
"set listchars=tab:>·,trail:·
set showbreak=↪

"==============================================================================
" History Niceties
"------------------------------------------------------------------------------

" Only do this part when compiled with support for autocommands.
if has("autocmd")
" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\	exe 'normal! g`"zvzz' |
	\ endif
endif

"==============================================================================
" Storage and Directories
"------------------------------------------------------------------------------

" Saves file when Vim window loses focus
autocmd BufLeave,FocusLost * silent! wall

" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

" viminfo stores the the state of your previous editing session
set viminfo+=n~/.vim/viminfo

if exists("+undofile")
	" undofile - This allows you to use undos after exiting and restarting
	" This, like swap and backups, uses .vim-undo first, then ~/.vim/undo
	" :help undo-persistence
	" This is only present in 7.3+
	set undodir=./.vim-undo//
	set undodir+=~/.vim/undo//
	set undofile
endif

"-------8<---------------------------------------------------------------------
