"      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
" `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
"
" github.com/rafi vim config

" references:
" https://github.com/ajh17/dotfiles
" https://github.com/indraniel/dotfiles
" https://github.com/justinforce/dotfiles
" https://github.com/joonty/myvim

" Runtime and Plugins {{{1
"------------------------------------------------------------------------------

" Respect XDG
set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM,$VIMRUNTIME
let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"

" Load pathogen plugin itself
runtime bundle/pathogen/autoload/pathogen.vim

" Load all plugins from bundle/
execute pathogen#infect()
syntax on
filetype plugin indent on

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
endif

" General Settings {{{1
"------------------------------------------------------------------------------

set nocompatible               " break away from old vi compatibility
set autoread                   " Files are read as soon as they are changed
set backspace=indent,eol,start " Intuitive backspacing in insert mode
set formatoptions+=1j          " Automatic formatting
set mouse=nv                   " enable mouse use for normal and visual modes
set modeline                   " automatically setting options from modelines
set report=2                   " report when 3 or more lines are changed
"set shortmess=atI              " shorten messages and don't show intro
set cmdheight=1                " explicitly set the height of the command line
set showcmd                    " Show (partial) command in status line.
set number                     " line numbers
set noerrorbells               " don't whine
set visualbell t_vb=           " and don't make faces
set lazyredraw                 " don't redraw while in macros
set hidden                     " hide buffers when abandoned instead of unload
set encoding=utf-8             " Set utf8 as standard encoding
set ffs=unix,dos,mac           " Use Unix as the standard file type
set sessionoptions-=options    " Don't save options and runtime in sessions
set magic                      " For regular expressions turn magic on
set path=.,**                  " Directories to search when using gf
set virtualedit=block          " Position cursor anywhere in visual block
set splitbelow splitright
set switchbuf=useopen

" Wildignore Settings {{{1
set wildmenu                   " turn on wild menu :e <Tab>
set wildmode=list:longest      " set wildmenu to list choice
set wildignorecase
set wildignore+=.hg,.git,.svn,*.pyc,*.spl,*.o,*.out,*.DS_Store,*.class,*.manifest,*~,#*#,%*
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,**/temp/***.obj
set wildignore+=**/cache/??,**/cache/mustache,**/cache/media,**/logs/????
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" History, Backup, Undo and Spelling settings {{{1
set history=700
set nobackup undofile noswapfile
set backupdir=$XDG_CACHE_HOME/vim/backup/
set directory=$XDG_CACHE_HOME/vim/swap//
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
set undodir=$XDG_CACHE_HOME/vim/undo//
set spellfile=$XDG_CONFIG_HOME/vim/spell/en.utf-8.add

" Indent and Fold Settings {{{1
setlocal noexpandtab    " Don't expand tabs to spaces.
set tabstop=2           " The number of spaces a tab is
set shiftwidth=2        " Number of spaces to use in auto(indent)
set softtabstop=2       " Just to be clear
set shiftround
set smartindent
set autoindent
set smarttab
set foldenable
set foldmethod=indent
set foldlevelstart=99

set whichwrap+=<,>,h,l
set complete-=i                " Don't scan current and included files
set completeopt-=preview       " No extra info buffer in completion menu
set nostartofline              " Cursor in same column for several commands

set list listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:.,trail:·
set showbreak=↪

set ttimeout
set timeoutlen=1200           " A little bit more time for macros
set ttimeoutlen=50            " Make esc work faster

set laststatus=2
set display+=lastline
set tabpagemax=50

set incsearch                 " incremental search
set ignorecase                " search ignoring case
set smartcase                 " keep case when searching with *
set hlsearch                  " highlight the search
set showmatch                 " show matching bracket
set diffopt=filler,iwhite     " ignore all whitespace and sync
set matchtime=5               " blink matching chars for 0.x seconds
set nostartofline             " leave my cursor position alone!

set showtabline=2
set scrolloff=2         " keep at least 2 lines above/below
set sidescrolloff=2     " keep at least 2 lines left/right
set textwidth=80
"set cursorline
"set colorcolumn=+1

call matchadd('ColorColumn', '\%81v', 100)

" Key bindings {{{1
"------------------------------------------------------------------------------

" Want a different map leader than \
let mapleader="\<Space>"

" Maps the semicolon to colon in normal mode
nmap ; :

" Make arrow keys useful
nnoremap <left> :vertical resize +2 <CR>
nnoremap <right> :vertical resize -2 <CR>
nnoremap <up> :resize +2 <CR>
nnoremap <down> :resize -2 <CR>

" Use backspace key for matchit.vim
nmap <BS> %
xmap <BS> %

" Remap some keys to be more useful
nnoremap ' `
nnoremap Q gq
nnoremap S i<CR><ESC>^m`gk:silent! s/\v +$//<CR>:noh<CR>``
nnoremap Y y$
nnoremap <CR> za

" Trick by Steve Losh: save a file if you forgot to sudo before editing
" http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
cmap W!! w !sudo tee % >/dev/null

" Create splits
nnoremap <leader>sh :sp<CR>
nnoremap <leader>sv :vsp<CR>

" Fast saving
nnoremap <Leader>w :w<CR>
vnoremap <Leader>w <Esc>:w<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
vnoremap <C-s> <Esc>:w<CR>

" Select blocks after indenting
xnoremap < <gv
xnoremap > >gv
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" Line number type toggle
nnoremap <Leader>l :set nonumber!<CR>

" Clear the highlighting of :set hlsearch
nmap <silent> <Leader>h :silent :nohlsearch<CR>

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

" CtrlP
nnoremap <Leader>. :CtrlPBufTagAll<CR>
nnoremap <Leader>r :CtrlP<CR>

" Instead of 1 line, move 3 at a time
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Show hidden characters (spaces, tabs, etc)
nmap <silent> <leader>s :set nolist!<CR>

" Fugitive shortcuts
nnoremap <silent> <leader>ga :Git add %:p<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gB :Gbrowse<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gg :Ggrep --ignore-case
map <silent> <leader>gbd :Gbrowse origin/develop^{}:%<CR>

map <Leader>y "+y
map <Leader>p "+p

" Tagbar keys
nmap <F8> :TagbarToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>

" Append modeline to EOF
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" When pressing <leader>cd switch to the directory of the open buffer
map <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Focus the current fold by closing all others
nnoremap <leader>flf mzzM`zzv

" Edit the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>es :so $MYVIMRC<CR>

" NERDTree keys
nmap <F1> :NERDTreeToggle<CR>
noremap <silent> <Leader>f :NERDTreeToggle<CR>

" Disable help key
inoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Toggle paste mode (particularly useful to temporarily disable autoindent)
set pastetoggle=<F2>

" Buffers
map <S-Left> :bp<CR>
map <S-Right> :bn<CR>

" Closes current buffer
nnoremap <silent> <Leader>q :close<CR>

" Make the Ctrk+Tab work in console, see also Xresources
map <Esc>[27;5;9~ <C-Tab>
map <Esc>[27;6;9~ <C-S-Tab>

" tab shortcuts
"map <C-t> :tabnew<CR>
nnoremap <C-Tab> :tabn<CR>
nnoremap <C-S-Tab> :tabp<CR>

" Under Tmux, make Vim recognize xterm escape sequences for Page and Arrow
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

" Functions and Commands {{{1
"------------------------------------------------------------------------------

"autocmd BufWritePost *.go,*.c,*.cpp,*.h,*.php silent! !ctags -R &

" Append modeline after last line in buffer
" http://vim.wikia.com/wiki/Modeline_magic
function! AppendModeline()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\	exe 'normal! g`"zvzz' |
	\ endif

" Changing cursor shape per mode (rxvt-unicode)
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>[3 q\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>[0 q\<Esc>\\"
else
  let &t_SI = "\<Esc>[3 q"
  let &t_EI = "\<Esc>[0 q"
endif

" Colors {{{1
"------------------------------------------------------------------------------

set t_Co=256
set background=dark

colorscheme hybrid " wombat256mod, mustang, jellybeans, kraihlight, pablo

" lightline disabled tabline
"highlight TabLineFill  ctermfg=8
"highlight TabLine      ctermfg=8 ctermbg=0
"highlight TabLineSel   ctermfg=8 ctermbg=0

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

"-------8<---------------------------------------------------------------------
