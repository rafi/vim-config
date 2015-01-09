
" General Settings
"------------------------------------------------------------------------------
" Vim core {{{
" --------
set autoread                 " Files are read as soon as they are changed
set mouse=nvi                " Disable mouse in command-line mode
set modeline                 " automatically setting options from modelines
set report=0                 " Don't report on line changes
set errorbells               " Errors trigger bell
set novisualbell             " But don't make faces
set lazyredraw               " don't redraw while in macros
set hidden                   " hide buffers when abandoned instead of unload
set encoding=utf-8           " Set utf8 as standard encoding (+multi_byte)
set ffs=unix,dos,mac         " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path=.,**                " Directories to search when using gf
set virtualedit=block        " Position cursor anywhere in visual block
set history=700              " Search and commands remembered
set synmaxcol=512            " Don't syntax highlight long lines
syntax sync minlines=256     " Update syntax highlighting for more lines
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
set sessionoptions-=options  " Don't save in sessions:
set sessionoptions-=folds    " - Options, runtime, folds
set sessionoptions-=help     " - Help windows

if has('patch-7.3.541')
	set formatoptions+=j       " Remove comment leader when joining lines
endif

if has('clipboard') || has('gui_running')
	set clipboard=             " Do not do anything with system's clipboard
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
set nobackup undofile noswapfile
set backupdir=$VARPATH/backup/
set directory=$VARPATH/swap//
set viminfo+=n$VARPATH/viminfo   " +viminfo
set undodir=$VARPATH/undo//      " +persistent_undo
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
set shiftround      " Round indent to multiple of 'shiftwidth'
set shiftwidth=2    " Number of spaces to use in auto(indent)
if has('smartindent')
	set smartindent   " Smart autoindenting on new lines
endif

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
set ttimeoutlen=20  " Make it fast please
set timeoutlen=1200 " A little bit more time for macros
set updatetime=1000 " Idle time to write swap

" }}}
" Searching {{{
" ---------
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase
set incsearch       " Incremental search (+extra_search)
set hlsearch        " Highlight the search (+extra_search)
set wrapscan        " Searches wrap around the end of the file
set noshowmatch     " Don't jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=3     " Tenths of a second to show the matching paren
"set cpoptions=-m    " Showmatch will wait 0.5s or until a character is typed

" }}}
" Behavior {{{
" --------
set linebreak                  " Break long lines at 'breakat' (+linebreak)
set breakat=\ \	;:,!?          " Long lines break chars
set nostartofline              " Cursor in same column for several commands
set whichwrap+=h,l,<,>,[,],~   " Move to following line on certain keys
set splitbelow splitright      " Splits open bottom right (+windows +vertsplit)
set switchbuf=usetab,split     " Switch buffer behavior
set backspace=indent,eol,start " Intuitive backspacing in insert mode
set diffopt=filler,iwhite      " Diff mode: show fillers, ignore white (+diff)
set formatprg=par\ -w78        " Using http://www.nicemice.net/par/
set tags=./tags,tags           " Tags are overridden by bundle/tagabana
set showfulltag                " Show tag and tidy search pattern in completion
set completeopt=menuone        " Show menu even for one item (+insert_expand)
set complete=.                 " Don't scan other windows, buffers, tags, includes
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
set pumheight=20        " Pop-up menu's line height (+insert_expand)
set cursorline          " Highlight line at cursor
set number              " Show line numbers
set noruler

set showtabline=2       " Always show the tabs line (+windows)
set tabpagemax=30       " Maximum number of tab pages (+windows)
set winwidth=30         " Minimum width for current window (+vertsplit)
set winheight=1         " Minimum height for current window (+windows)
set previewheight=8     " Completion preview height (+windows +quickfix)
set helpheight=12       " Minimum help window height (+windows)

set notitle             " No need for a title (+title)
set noshowcmd           " Don't show command in status line (+cmdline_info)
set cmdheight=1         " Height of the command line
set cmdwinheight=5      " Command-line lines (+vertsplit)
set noequalalways       " Don't resize windows on split or close
set display+=lastline   " Try showing more of last line
set laststatus=2        " Always show a status line

" Changing characters to fill special ui elements
set showbreak=↪               " (+linebreak)
set fillchars=vert:│,fold:─   " (+windows +folding)
set list listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·

" Do not display completion messages
" Patch: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
try
	set shortmess+=c
catch /^Vim\%((\a\+)\)\=:E539: Illegal character/
	autocmd MyAutoCmd VimEnter *
				\ highlight ModeMsg guifg=bg guibg=bg |
				\ highlight Question guifg=bg guibg=bg
endtry

" Highlight just a single character on the 81st *virtual* column (:h virtcol)
call matchadd('ColorColumn', '\%81v', 100)

" For snippet_complete marker
if has('conceal') && v:version >= 703
	set conceallevel=2 concealcursor=iv
endif

" }}}
" gVim Appearance {{{
" ---------------
if has('gui_running')
	set lines=58 columns=190   " Maximize gvim window

	if has('patch-7.4.394')
		" Use DirectWrite
		set renderoptions=type:directx,gammma:2.2,mode:3
	endif

	" Font
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
