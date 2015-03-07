
" General Settings
"---------------------------------------------------------
" General {{{
"set autoread                 " Files are read as soon as they are changed
set mouse=nvi                " Disable mouse in command-line mode
set modeline                 " automatically setting options from modelines
set report=0                 " Don't report on line changes
set noerrorbells             " Don't trigger bell on error
set visualbell t_vb=         " Don't make any faces
set lazyredraw               " don't redraw while in macros
set hidden                   " hide buffers when abandoned instead of unload
set encoding=utf-8           " Set utf8 as standard encoding (+multi_byte)
set ffs=unix,dos,mac         " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path=.,**                " Directories to search when using gf
set virtualedit=block        " Position cursor anywhere in visual block
set history=500              " Search and commands remembered
set synmaxcol=1000           " Don't syntax highlight long lines
syntax sync minlines=256     " Update syntax highlighting for more lines
set ttyfast                  " Indicate a fast terminal connection
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text

if has('patch-7.3.541')
	set formatoptions+=j       " Remove comment leader when joining lines
endif

" What to save for views:
set viewoptions=cursor,folds,slash,unix

" What not to save in sessions:
set sessionoptions-=options
set sessionoptions-=globals
set sessionoptions-=folds
set sessionoptions-=help

if has('clipboard') || has('gui_running')
	" Do not do anything with system's clipboard
	set clipboard=
endif

" }}}
" Wildmenu {{{
" --------
if has('wildmenu')
	set nowildmenu
	set wildmode=list:longest,full
	set wildoptions=tagfile
	set wildignorecase
	set wildignore+=.hg,.git,.svn,*.pyc,*.spl,*.o,*.out,*~,#*#,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/cache/??,**/cache/mustache,**/cache/media,**/logs/????
	set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.sass-cache/*
endif

" }}}
" Vim Directories {{{
" ---------------
set undofile swapfile nospell nobackup
set viminfo='10,/100,:500,<10,@10,s10,h,n$VARPATH/viminfo
set directory=$VARPATH/swap//,$VARPATH,~/tmp,/var/tmp,/tmp
set undodir=$VARPATH/undo//,$VARPATH,~/tmp,/var/tmp,/tmp
set backupdir=$VARPATH/backup/,$VARPATH,~/tmp,/var/tmp,/tmp
set viewdir=$VARPATH/view/
set spellfile=$VIMPATH/spell/en.utf-8.add

" }}}
" Tabs and Indents {{{
" ----------------
set textwidth=80    " Text width maximum chars before wrapping
set noexpandtab     " Don't expand tabs to spaces.
set tabstop=2       " The number of spaces a tab is
set softtabstop=2   " While performing editing operations
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'
set shiftwidth=2    " Number of spaces to use in auto(indent)

" }}}
" Folds {{{
" -----
if has('folding')
	set foldenable
	set foldmethod=syntax
	set foldlevelstart=99
	set foldtext=FoldText()
endif

" }}}
" Time {{{
" --------
set ttimeout
set ttimeoutlen=20  " Make it fast
set timeoutlen=1200 " A little bit more time for macros
set updatetime=300  " Idle time to write swap

" }}}
" Searching {{{
" ---------
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase
set incsearch       " Incremental search
set hlsearch        " Highlight the search
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed

" }}}
" Behavior {{{
" --------
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=usetab,split      " Switch buffer behavior
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore white
set formatprg=par\ -w78         " Using http://www.nicemice.net/par/
set tags=./tags,tags            " Tags are overridden by bundle/tagabana
set showfulltag                 " Show tag and tidy search in completion
set completeopt=menuone,preview " Show menu even for one item
set complete=.                  " No wins, buffs, tags, include scanning
if exists('+breakindent')
	set breakindent
	set wrap
else
	set nowrap
endif

" }}}
" Editor UI Appearance {{{
" --------------------
set noshowmode          " Don't show mode in cmd window
set shortmess=aoOTI     " Shorten messages and don't show intro
set scrolloff=2         " Keep at least 2 lines above/below
set sidescrolloff=2     " Keep at least 2 lines left/right
set pumheight=20        " Pop-up menu's line height
set number              " Show line numbers
set noruler

set showtabline=2       " Always show the tabs line
set tabpagemax=30       " Maximum number of tab pages
set winwidth=30         " Minimum width for current window
set winheight=1         " Minimum height for current window
set previewheight=8     " Completion preview height
set helpheight=12       " Minimum help window height

set display+=lastline,uhex
set notitle             " No need for a title
set noshowcmd           " Don't show command in status line
set cmdheight=1         " Height of the command line
set cmdwinheight=10     " Command-line lines
set noequalalways       " Don't resize windows on split or close
set laststatus=2        " Always show a status line

" Changing characters to fill special ui elements
set showbreak=↪
set fillchars=vert:│,fold:─
set list listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·

" Do not display completion messages
" Patch: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
if has('patch-7.4.314')
	set shortmess+=c
endif

" Highlight just a single character on the 81st virtual column
call matchadd('ColorColumn', '\%81v', 100)

" For snippet_complete marker
if has('conceal') && v:version >= 703
	set conceallevel=2 concealcursor=niv
endif

" Highlight current line only on focus buffer
augroup CursorLine
	au!
	au VimEnter,WinEnter,BufWinEnter * if &ft !~ 'unite'
		\ | setlocal cursorline | endif
	au WinLeave * if &ft !~ 'vimfiler\|gitv'
		\ | setlocal nocursorline | endif
augroup END

" Open Quickfix window automatically
autocmd MyAutoCmd QuickFixCmdPost [^l]* leftabove copen
	\ | wincmd p | redraw!
autocmd MyAutoCmd QuickFixCmdPost l* leftabove lopen
	\ | wincmd p | redraw!

" Fix window position of help/quickfix
autocmd MyAutoCmd FileType help if &l:buftype ==# 'help'
	\ | wincmd K | endif
autocmd MyAutoCmd FileType qf   if &l:buftype ==# 'quickfix'
	\ | wincmd J | endif

" Always open read-only when a swap file is found
autocmd MyAutoCmd SwapExists * let v:swapchoice = 'o'

" Automatically set expandtab
autocmd MyAutoCmd FileType * execute
	\ 'setlocal '.(search('^\t.*\n\t.*\n\t', 'n') ? 'no' : '').'expandtab'

" }}}
" gVim Appearance {{{
" ---------------
if has('gui_running')
	set lines=58 columns=190

	if has('patch-7.4.394')
		" Use DirectWrite
		set renderoptions=type:directx,gammma:2.2,mode:3
	endif

	" GUI Font
	if has('gui_gtk2')
		set guifont=PragmataPro\ 12
	elseif has('gui_macvim')
		set guifont=Menlo\ Regular:h14
	elseif has('gui_win32')
		set guifont=Consolas:h11:cANSI
	endif
endif
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
