"      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
" `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
"
" github.com/rafi vim config

" references and credits:
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
" Vim core {{{2
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
set nonumber                   " no line numbers
set noerrorbells               " don't whine
set novisualbell t_vb=         " and don't make faces
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
set synmaxcol=256              " Don't syntax highlight long lines
syntax sync minlines=256       " Update syntax highlighting for more lines

" Wildmenu/ignore Settings {{{2
set wildmenu                   " turn on wild menu :e <Tab>
set wildmode=list:longest      " set wildmenu to list choice
set wildignorecase
set wildignore+=.hg,.git,.svn,*.pyc,*.spl,*.o,*.out,*.DS_Store,*.class,*.manifest,*~,#*#,%*
set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,**/temp/***.obj
set wildignore+=**/cache/??,**/cache/mustache,**/cache/media,**/logs/????
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*

" Caches and Directories {{{2
set history=700
set nobackup undofile noswapfile
set backupdir=$XDG_CACHE_HOME/vim/backup/
set directory=$XDG_CACHE_HOME/vim/swap//
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo
set undodir=$XDG_CACHE_HOME/vim/undo//
set spellfile=$XDG_CONFIG_HOME/vim/spell/en.utf-8.add

" Indent and Fold Settings {{{2
set textwidth=80
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

set ttimeout
set timeoutlen=1200           " A little bit more time for macros
set ttimeoutlen=50            " Make esc work faster

" Search Settings {{{2
set incsearch                 " incremental search
set ignorecase                " search ignoring case
set smartcase                 " keep case when searching with *
set hlsearch                  " highlight the search
set showmatch                 " show matching bracket
set diffopt=filler,iwhite     " ignore all whitespace and sync
set matchtime=5               " blink matching chars for 0.x seconds
set nostartofline             " leave my cursor position alone!

" Editor UI Appearance {{{2
set showtabline=2
set scrolloff=2         " keep at least 2 lines above/below
set sidescrolloff=2     " keep at least 2 lines left/right
set nocursorline

set laststatus=2
set display+=lastline
set tabpagemax=50

set list listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:.,trail:·
set showbreak=↪

" disable netrw
let g:loaded_netrwPlugin = 1  " Disable netrw.vim, I use VimFiler

" highlight just a single character on the 80th column
call matchadd('ColorColumn', '\%81v', 100)

" Terminal Hacks {{{1
"------------------------------------------------------------------------------

" Make the Ctrk+Tab work in console, see also Xresources
" I'm using rxvt-unicode
map <Esc>[27;5;9~ <C-Tab>
map <Esc>[27;6;9~ <C-S-Tab>

" Under URxvt and Tmux, make Vim recognize xterm escape
" sequences for Page and Arrow keys combined with modifiers
" such as Shift, Control, and Alt.
" See: http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
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

" Changing cursor shape per mode {{{2
" For rxvt-unicode:
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

" Key bindings {{{1
"------------------------------------------------------------------------------

" Non-standard {{{2
" ------------

" Want a different map leader than \
let mapleader="\<Space>"

" Maps the semicolon to colon in normal mode
nmap ; :

" Make arrow keys useful
nnoremap <left> :vertical resize +1<CR>
nnoremap <right> :vertical resize -1<CR>
nnoremap <up> :resize +1<CR>
nnoremap <down> :resize -1<CR>

" Use backspace key for matchit.vim
nmap <BS> %
xmap <BS> %

" Global niceties {{{2
" ---------------

" I do not use clipboard=unnamed, these
" yank and paste from X11's clipboard.
map <Leader>y "+y
map <Leader>p "+p

" Instead of 1 line, move 3 at a time
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" Remap some keys to be more useful
nnoremap ' `
nnoremap Q gq
nnoremap S i<CR><ESC>^m`gk:silent! s/\v +$//<CR>:noh<CR>``
nnoremap Y y$
nnoremap <CR> za

" Select blocks after indenting
xnoremap < <gv
xnoremap > >gv

" Use tab for indenting in normal/visual modes
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" File operations {{{2
" ---------------

" When pressing <leader>cd switch to the directory of the open buffer
map <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Edit the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>es :so $MYVIMRC<CR>

" Fast saving
nnoremap <Leader>w :w<CR>
vnoremap <Leader>w <Esc>:w<CR>
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>
vnoremap <C-s> <Esc>:w<CR>

" Trick by Steve Losh: save a file if you forgot to sudo before editing
" http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
cmap W!! w !sudo tee % >/dev/null

" Editor UI {{{2

" Toggle paste mode
" Particularly useful to temporarily disable autoindent
set pastetoggle=<F2>

" Line number type toggle
nnoremap <Leader>l :set nonumber!<CR>

" Show hidden characters (spaces, tabs, etc)
nmap <silent> <leader>s :set nolist!<CR>

" Clear the highlighting of :set hlsearch
nmap <silent> <Leader>h :silent :nohlsearch<CR>

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

" Tabs
map <C-t> :tabnew<CR>
map <C-x> :tabclose<CR>
noremap <C-Tab> :tabn<CR>
noremap <C-S-Tab> :tabp<CR>

" Splits
" I imagine v as an arrow, split below
nnoremap <leader>sv :sp<CR>
nnoremap <leader>sg :vsp<CR>

" Buffers
map <S-Right> :bnext<CR>
map <S-Left> :bprev<CR>

" Closes current buffer
nnoremap <silent> <Leader>q :close<CR>

" Remove current buffer
nnoremap <silent> <Leader>x :bdelete<CR>

" Totally Custom {{{2
" --------------

" Append modeline to EOF
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Focus the current fold by closing all others
nnoremap <leader>ef mzzM`zzv

" Yank buffer's absolute path to X11 clipboard
nnoremap <leader>cy :let @+=expand("%:p")<CR>

" Plugins {{{2
" -------

" NERDCommenter {{{3
let NERDCreateDefaultMappings = 0
map <leader>cc <plug>NERDCommenterInvert

" Unite {{{3
nnoremap [unite]  <Nop>
nmap     f [unite]
nnoremap <silent> [unite]f  :<C-u>Unite file_rec/async -start-insert -buffer-name=files<CR>
nnoremap <silent> [unite]g  :<C-u>Unite file_rec/git -start-insert<CR>
nnoremap <silent> [unite]u  :<C-u>Unite source -silent -vertical -start-insert<CR>
nnoremap <silent> [unite]b  :<C-u>Unite buffer file_mru bookmark -auto-resize -silent<CR>
nnoremap <silent> [unite]/  :<C-u>Unite grep:. -auto-resize -silent -no-quit<CR>
nnoremap <silent> [unite]t  :<C-u>Unite tag -silent -start-insert<CR>
nnoremap <silent> [unite]R  :<C-u>Unite register -silent -buffer-name=register<CR>
nnoremap <silent> [unite]j  :<C-u>Unite change jump -silent<CR>
nnoremap <silent> [unite]y  :<C-u>Unite history/yank<CR>
nnoremap <silent> [unite]o  :<C-u>Unite outline -no-quit -keep-focus -vertical<CR>
nnoremap <silent> [unite]ma :<C-u>Unite mapping -silent<CR>
nnoremap <silent> [unite]me :<C-u>Unite output:message -silent<CR>
nnoremap <silent> [unite]r  :<C-u>UniteResume -no-start-insert<CR>

autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
	nunmap <buffer> <C-h>
	nunmap <buffer> <C-k>
	nunmap <buffer> <C-l>
	nunmap <buffer> <C-r>
	nmap <silent><buffer> <C-r> <Plug>(unite_redraw)
	imap <silent><buffer> <C-j> <Plug>(unite_select_next_line)
	imap <silent><buffer> <C-k> <Plug>(unite_select_previous_line)
	nmap <silent><buffer> '     <Plug>(unite_toggle_mark_current_candidate_up)
	nmap <silent><buffer> ;     <Plug>(unite_insert_enter)
	nmap <silent><buffer> e     <Plug>(unite_do_default_action)
	nmap <silent><buffer><expr> <C-v> unite#do_action('split')
	nmap <silent><buffer><expr> <C-s> unite#do_action('vsplit')
	nmap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
	nmap <buffer> <ESC> <Plug>(unite_exit)
	imap <buffer> jj    <Plug>(unite_insert_leave)
	imap <buffer> kk    <Plug>(unite_insert_leave)

	let unite = unite#get_current_unite()
	if unite.profile_name ==# '^search'
		nnoremap <silent><buffer><expr> r unite#do_action('replace')
	else
		nnoremap <silent><buffer><expr> r unite#do_action('rename')
	endif
endfunction

" Fugitive {{{3
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

" Tagbar {{{3
nmap <F8> :TagbarToggle<CR>
nnoremap <Leader>t :TagbarToggle<CR>

" VimFiler {{{3
noremap <silent> <Leader>f :VimFilerExplorer -winwidth=25 -split -toggle -no-quit<CR>
noremap <silent> <Leader>db :VimFilerBufferDir<CR>
noremap <silent> <Leader>ds :VimFilerSplit<CR>
nmap <F1> :VimFilerExplorer<CR>

autocmd FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings()
	nunmap <buffer> <C-l>
	nunmap <buffer> <C-j>
	nmap <buffer> ' <Plug>(vimfiler_toggle_mark_current_line)
	nmap <buffer> <C-q> <Plug>(vimfiler_quick_look)
	nmap <buffer> <C-w> <Plug>(vimfiler_switch_to_history_directory)
	nnoremap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
endfunction

" Disable help key
inoremap <F1> <ESC>
vnoremap <F1> <ESC>

" gvim {{{2
" ----

" toggle display of a GUI widget (menu/toolbar/scrollbar)
nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

" Functions and Commands {{{1
"------------------------------------------------------------------------------

" TODO: Figure out the best way to update ctags.
"       Currently using vim-autotag plugin
"autocmd BufWritePost *.go,*.c,*.cpp,*.h,*.php silent! !ctags -R &

" Simple way to turn off Gdiff splitscreen
" works only when diff buffer is focused
if !exists(":Gdiffoff")
	command Gdiffoff diffoff | q | Gedit
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\	exe 'normal! g`"zvzz' |
	\ endif

" Append modeline after last line in buffer
" See: http://vim.wikia.com/wiki/Modeline_magic
function! AppendModeline()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction

" gvim Fonts {{{1
"------------------------------------------------------------------------------

if has("gui_running")
"	set guioptions-=m  " remove menu bar
	set guioptions-=T  " remove toolbar
	set guioptions-=r  " remove right-hand scroll bar
	set guioptions-=L  " remove left-hand scroll bar

	" font
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
    "set guifont=envypn\ 11
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif

  " Maximize gvim window
  set lines=58 columns=190
endif

" Theme and Colors {{{1
"------------------------------------------------------------------------------

set t_Co=256
set background=dark

colorscheme hybrid " wombat256mod, mustang, jellybeans, kraihlight, pablo

highlight Search       ctermfg=9 ctermbg=236 guibg=Black guifg=Magenta
highlight SpecialKey   ctermfg=235 ctermbg=234

" VimFiler {{{2
highlight vimfilerNormalFile  ctermfg=245 ctermbg=234 guifg=#777777
highlight vimfilerClosedFile  ctermfg=249 ctermbg=234 guifg=#AAAAAA
highlight vimfilerOpenedFile  ctermfg=254 ctermbg=234 guifg=#FFFFFF
highlight vimfilerNonMark     ctermfg=239 ctermbg=234 guifg=#555555
highlight vimfilerLeaf        ctermfg=235 ctermbg=234 guifg=#333333

" Signify {{{2
highlight SignifySignAdd    ctermbg=234 ctermfg=2 guifg=#009900 guibg=#1C1C1C
highlight SignifySignDelete ctermbg=234 ctermfg=1 guifg=#ff2222 guibg=#1C1C1C
highlight SignifySignChange ctermbg=234 ctermfg=3 guifg=#bbbb00 guibg=#1C1C1C

" Disabled: Lightline when disabling tabline {{{2
"highlight TabLineFill  ctermfg=8
"highlight TabLine      ctermfg=8 ctermbg=0
"highlight TabLineSel   ctermfg=8 ctermbg=0

" Disabled: wombat256mod theme mod {{{2
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

" Disabled: mustang theme mod {{{2
"highlight CursorLine   ctermbg=235 cterm=NONE
""highlight CursorLineNr ctermfg=240
"highlight SpecialKey   ctermfg=235 ctermbg=234
"highlight SignColumn   ctermbg=234
"highlight LineNr       ctermfg=235 ctermbg=234
"highlight ColorColumn  ctermbg=0

"-------8<---------------------------------------------------------------------
