
" General Settings
"---------------------------------------------------------
" General {{{
set mouse=nvi                " Disable mouse in command-line mode
set modeline                 " automatically setting options from modelines
set report=0                 " Don't report on line changes
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path=.,**                " Directories to search when using gf
set virtualedit=block        " Position cursor anywhere in visual block
set history=500              " Search and commands remembered
set synmaxcol=1000           " Don't syntax highlight long lines
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text

if has('vim_starting')
	set encoding=utf-8
	scriptencoding utf-8
endif

if has('patch-7.3.541')
	set formatoptions+=j       " Remove comment leader when joining lines
endif

" What to save for views:
set viewoptions-=options viewoptions+=slash,unix

" What to save in sessions:
set sessionoptions-=blank
set sessionoptions-=options
set sessionoptions-=globals
set sessionoptions-=folds
set sessionoptions-=help
set sessionoptions-=buffers
set sessionoptions+=tabpages

if ( ! has('nvim') || $DISPLAY !=? '') && has('clipboard')
	if has('unnamedplus')
		set clipboard& clipboard+=unnamedplus
	else
		set clipboard& clipboard+=unnamed
	endif
endif

" }}}
" Wildmenu {{{
" --------
if has('wildmenu')
	set nowildmenu
	set wildmode=list:longest,full
	set wildoptions=tagfile
	set wildignorecase
	set wildignore+=.git,*.pyc,*.spl,*.o,*.out,*~,#*#,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
endif

" }}}
" Vim Directories {{{
" ---------------
if has('nvim')
	set shada='30,/100,:50,<10,@10,s50,h,n$VARPATH/shada
else
	set viminfo='30,/100,:500,<10,@10,s10,h,n$VARPATH/viminfo
endif
set undofile swapfile nobackup
set directory=$VARPATH/swap//,$VARPATH,~/tmp,/var/tmp,/tmp
set undodir=$VARPATH/undo//,$VARPATH,~/tmp,/var/tmp,/tmp
set backupdir=$VARPATH/backup/,$VARPATH,~/tmp,/var/tmp,/tmp
set viewdir=$VARPATH/view/
set nospell spellfile=$VIMPATH/spell/en.utf-8.add

let g:session_directory = $VARPATH.'/session/'

" Don't backup files in temp directories or shm
if exists('&backupskip')
	set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
endif

" Don't keep swap files in temp directories or shm
augroup swapskip
	autocmd!
	silent! autocmd BufNewFile,BufReadPre
		\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
		\ setlocal noswapfile
augroup END

" Don't keep undo files in temp directories or shm
if has('persistent_undo')
	augroup undoskip
		autocmd!
		silent! autocmd BufWritePre
			\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
			\ setlocal noundofile
	augroup END
endif

" Don't keep viminfo for files in temp directories or shm
augroup viminfoskip
	autocmd!
	silent! autocmd BufNewFile,BufReadPre
		\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
		\ setlocal viminfo=
augroup END

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
set timeout ttimeout
set timeoutlen=750  " Time out on mappings
set ttimeoutlen=250 " Time out on key codes
set updatetime=1500 " Idle time to write swap and trigger CursorHold

if has('nvim')
	" https://github.com/neovim/neovim/issues/2017
	set ttimeoutlen=-1
endif

" }}}
" Searching {{{
" ---------
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed

" }}}
" Behavior {{{
" --------
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=usetab,split      " Switch buffer behavior
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore white
set showfulltag                 " Show tag and tidy search in completion
set complete=.                  " No wins, buffs, tags, include scanning
set completeopt=menuone         " Show menu even for one item
set completeopt+=noselect       " Do not select a match in the menu
if has('patch-7.4.775')
	set completeopt+=noinsert
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
set relativenumber      " Use relative instead of absolute line numbers
set noruler             " Disable default status ruler
set list                " Show hidden characters

set showtabline=2       " Always show the tabs line
set tabpagemax=30       " Maximum number of tab pages
set winwidth=30         " Minimum width for current window
set winheight=1         " Minimum height for current window
set previewheight=8     " Completion preview height
set helpheight=12       " Minimum help window height

set display=lastline
set notitle             " No need for a title
set noshowcmd           " Don't show command in status line
set cmdheight=2         " Height of the command line
set cmdwinheight=5      " Command-line lines
set noequalalways       " Don't resize windows on split or close
set laststatus=2        " Always show a status line
set colorcolumn=80      " Highlight the 80th character limit

" Do not display completion messages
" Patch: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
if has('patch-7.4.314')
	set shortmess+=c
endif

" Do not display message when editing files
if has('patch-7.4.1570')
	set shortmess+=F
endif

" For snippet_complete marker
if has('conceal') && v:version >= 703
	set conceallevel=2 concealcursor=niv
endif

" vim: set ts=2 sw=2 tw=80 noet :
