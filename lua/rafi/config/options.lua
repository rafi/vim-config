" Neovim settings
" ===

" General {{{
set mouse=nv                 " Disable mouse in command-line mode
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set path+=**                 " Directories to search when using gf and friends
set isfname-==               " Remove =, detects filename in var=/foo/bar
set virtualedit=block        " Position cursor anywhere in visual block

if has('vim_starting')
	set encoding=utf-8
	scriptencoding utf-8
endif

" History and persistence
set history=2000

if has('nvim') && ! has('win32') && ! has('win64')
	set shada='400,<20,@100,s10,f1,h,r/tmp,r/private/var
else
	set viminfo='400,<20,@50,f1,h,n$HOME/.cache/viminfo
endif

" What to save for views and sessions
set viewoptions=cursor,curdir
set sessionoptions=blank,curdir,help,terminal,tabpages

" Fast cliboard setup for macOS
if has('mac') && executable('pbcopy') && has('vim_starting')
	let g:clipboard = {
		\   'name': 'macOS-clipboard',
		\   'copy': {
		\      '+': 'pbcopy',
		\      '*': 'pbcopy',
		\    },
		\   'paste': {
		\      '+': 'pbpaste',
		\      '*': 'pbpaste',
		\   },
		\   'cache_enabled': 0,
		\ }
endif

if has('clipboard') && has('vim_starting')
	" set clipboard& clipboard+=unnamedplus
	set clipboard& clipboard^=unnamed,unnamedplus
endif

" }}}
" Vim Directories {{{
" ---------------
set undofile
if ! has('nvim')
	set swapfile nobackup
	set directory=$VIM_DATA_PATH/swap//
	set undodir=$VIM_DATA_PATH/undo//
	set backupdir=$VIM_DATA_PATH/backup/
	set viewdir=$VIM_DATA_PATH/view/
	set spellfile=$VIM_DATA_PATH/spell/en.utf-8.add
endif

augroup user_persistent_undo
	autocmd!
	au BufWritePre /tmp/*          setlocal noundofile
	au BufWritePre *.tmp           setlocal noundofile
	au BufWritePre *.bak           setlocal noundofile
	au BufWritePre COMMIT_EDITMSG  setlocal noundofile noswapfile
	au BufWritePre MERGE_MSG       setlocal noundofile noswapfile
augroup END

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
		\ && $HOME !=# expand('~' . $USER, 1)
		\ && $HOME ==# expand('~' . $SUDO_USER, 1)

	set nomodeline
	set noswapfile
	set nobackup
	set nowritebackup
	set noundofile
	if has('nvim')
		set shadafile=NONE
	else
		set viminfofile=NONE
	endif
endif

" Secure sensitive information, disable backup files in temp directories
if exists('&backupskip')
	set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
	set backupskip+=.vault.vim
endif

" Disable swap/undo/viminfo files in temp directories or shm
augroup user_secure
	autocmd!
	silent! autocmd BufNewFile,BufReadPre
		\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
		\ setlocal noswapfile noundofile
		\ | set nobackup nowritebackup
		\ | if has('nvim') | set shada= | else | set viminfo= | endif
augroup END

" }}}
" Tabs and Indents {{{
" ----------------
set textwidth=80    " Text width maximum chars before wrapping
set tabstop=2       " The number of spaces a tab is
set shiftwidth=2    " Number of spaces to use in auto(indent)
" set softtabstop=-1  " Automatically keeps in sync with shiftwidth
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

" }}}
" Timing {{{
" ------
set ttimeout
set timeoutlen=500   " Time out on mappings
set ttimeoutlen=10   " Time out on key codes
set updatetime=200   " Idle time to write swap and trigger CursorHold

" }}}
" Searching {{{
" ---------
set ignorecase    " Search ignoring case
set smartcase     " Keep case when searching with *
set infercase     " Adjust case in insert completion mode
set incsearch     " Incremental search

if exists('+inccommand')
	set inccommand=nosplit
endif

if executable('rg')
	set grepformat=%f:%l:%c:%m
	let &grepprg =
		\ 'rg --vimgrep --no-heading' . (&smartcase ? ' --smart-case' : '') . ' --'
elseif executable('ag')
	set grepformat=%f:%l:%c:%m
	let &grepprg =
		\ 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '') . ' --'
endif

" }}}
" Formatting {{{
" --------
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=uselast           " Use last window with quickfix entries
set backspace=indent,eol,start  " Intuitive backspacing in insert mode

if exists('&breakindent')
	set breakindentopt=shift:2,min:20
endif

set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
set formatoptions-=o         " Disable comment-continuation (normal 'o'/'O')
if has('patch-7.3.541')
	set formatoptions+=j       " Remove comment leader when joining lines
endif

" }}}
" Completion and Diff {{{
" --------
set complete=.,w,b,k  " C-n completion: Scan buffers, windows and dictionary

set completeopt=menu,menuone    " Always show menu, even for one item
if has('patch-7.4.775')
	set completeopt+=noselect     " Do not select a match in the menu.
endif

set diffopt+=iwhite             " Diff mode: ignore whitespace
if has('patch-8.1.0360') || has('nvim-0.5')
	set diffopt+=indent-heuristic,algorithm:patience
endif

" Use the new Neovim :h jumplist-stack
if has('nvim-0.5')
	set jumpoptions=stack
endif

" Command-line completion
if has('wildmenu')
	set wildignorecase
	set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
	set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
endif

" }}}
" Editor UI {{{
" --------------------
set noshowmode          " Don't show mode in cmd window
set shortmess=aoOTI     " Shorten messages and don't show intro
set scrolloff=2         " Keep at least 2 lines above/below
set sidescrolloff=5     " Keep at least 5 lines left/right
set numberwidth=2       " Minimum number of columns to use for the line number
set nonumber            " Don't show line numbers
set noruler             " Disable default status ruler
set list                " Show hidden characters

set showtabline=2       " Always show the tabs line
set helpheight=0        " Disable help window resizing
set winwidth=30         " Minimum width for active window
set winminwidth=1       " Minimum width for inactive windows
set winheight=1         " Minimum height for active window
set winminheight=1      " Minimum height for inactive window

set noshowcmd           " Don't show command in status line
set cmdwinheight=5      " Command-line lines
set equalalways         " Resize windows on split or close
set laststatus=2        " Always show a status line
set colorcolumn=+0      " Column highlight at textwidth's max character-limit
set display=lastline

" Display a single line, even when wrapped
if has('patch-8.1.2019') || has('nvim-0.6.0')
	set cursorlineopt=number,screenline
endif

" Set popup max width/height.
set pumheight=15        " Maximum number of items to show in the popup menu
if exists('+pumwidth')
	set pumwidth=10       " Minimum width for the popup menu
endif

" UI Symbols
" icons:  ▏│ ¦ ╎ ┆ ⋮ ⦙ ┊ 
let &showbreak='↳  '
set listchars=tab:\▏\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·

if has('folding') && has('vim_starting')
	set foldenable
	set foldmethod=indent
	set foldlevel=99
endif

if has('patch-7.4.314')
	" Do not display completion messages
	set shortmess+=c
endif

if has('patch-7.4.1570')
	" Do not display message when editing files
	set shortmess+=F
endif

augroup user_general_settings
	autocmd!

	" Show sign column only for normal file buffers.
	if exists('&signcolumn')
		autocmd FileType * if empty(&buftype)
			\ | setlocal signcolumn=yes
			\ | endif
	endif

	" Highlight current line only on focused normal buffer windows
	autocmd WinEnter,BufEnter,InsertLeave *
		\ if ! &cursorline && empty(&buftype)
		\ | setlocal cursorline
		\ | endif

	" Hide cursor line when leaving normal non-diff windows
	autocmd WinLeave,BufLeave,InsertEnter *
		\ if &cursorline && ! &diff && empty(&buftype) && ! &pvw && ! pumvisible()
		\ | setlocal nocursorline
		\ | endif

	" Reload vim configuration automatically on-save
	autocmd BufWritePost $VIM_PATH/{*.vim,*.yaml,vimrc} ++nested
		\ source $MYVIMRC | redraw

	" Automatically set read-only for files being edited elsewhere
	autocmd SwapExists * ++nested let v:swapchoice = 'o'

	" Update diff comparison once leaving insert mode
	autocmd InsertLeave * if &l:diff | diffupdate | endif

	" Equalize window dimensions when resizing vim window
	autocmd VimResized * wincmd =

	" Force write shada on leaving nvim
	autocmd VimLeave * if has('nvim') | wshada! | endif

	" Check if file changed when its window is focus, more eager than 'autoread'
	autocmd FocusGained * checktime

	" autocmd Syntax * if line('$') > 5000 | syntax sync minlines=200 | endif

	if has('nvim-0.5')
		" Highlight yank
		try
			autocmd TextYankPost *
				\ silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
		endtry

		" Neovim terminal settings
		autocmd TermOpen * setlocal modifiable
	endif

	" Update filetype on save if empty
	autocmd BufWritePost * ++nested
		\ if &l:filetype ==# '' || exists('b:ftdetect')
		\ |   unlet! b:ftdetect
		\ |   filetype detect
		\ | endif

	" Reload Vim script automatically if setlocal autoread
	autocmd BufWritePost,FileWritePost *.vim ++nested
		\ if &l:autoread > 0 | source <afile> |
		\   echo 'source ' . bufname('%') |
		\ endif

	" When editing a file, always jump to the last known cursor position.
	" Credits: https://github.com/farmergreg/vim-lastplace
	autocmd BufReadPost *
		\ if index(['gitcommit', 'gitrebase', 'svn', 'hgcommit'], &filetype) == -1
		\      && empty(&buftype) && ! &diff && ! &previewwindow
		\      && line("'\"") > 0 && line("'\"") <= line("$")
		\|   if line("w$") == line("$")
		\|     execute "normal! g`\""
		\|   elseif line("$") - line("'\"") > ((line("w$") - line("w0")) / 2) - 1
		\|     execute "normal! g`\"zz"
		\|   else
		\|     execute "normal! \G'\"\<c-e>"
		\|   endif
		\|   if foldclosed('.') != -1
		\|     execute 'normal! zvzz'
		\|   endif
		\| endif
augroup END

" }}}
" Filetype specific configuration {{{
" --------
augroup user_plugin_filetype
	autocmd!

	autocmd FileType apache,html setlocal path+=./;/

	autocmd FileType crontab setlocal nobackup nowritebackup

	autocmd FileType gitcommit setlocal spell

	autocmd FileType gitcommit,qfreplace setlocal nofoldenable

	autocmd FileType php setlocal matchpairs-=<:> iskeyword+=\\

	autocmd FileType markdown setlocal spell formatoptions=tcroqn2 comments=n:>

augroup END

" }}}
" Built-in runtime plugins {{{
let g:sh_no_error = 1
let g:python_recommended_style = 0
let g:vimsyntax_noerror = 1
let g:vim_indent_cont = &shiftwidth
let g:ruby_no_expensive = 1
let g:PHP_removeCRwhenUnix = 0

" }}}
" Theme {{{
" ---
" Autoloads theme according to user selected colorschemes

function! s:theme_autoload()
	if exists('g:colors_name')
		let theme_path = expand($VIM_PATH . '/themes/' . g:colors_name . '.vim')
		if filereadable(theme_path)
			execute 'source' fnameescape(theme_path)
		endif
		" Persist theme
		call writefile([g:colors_name], s:theme_cache_file())
	endif
endfunction

function! s:theme_cache_file()
	return expand($VIM_DATA_PATH . '/theme.txt')
endfunction

function! s:cached_colorscheme(default)
	let l:cache_file = s:theme_cache_file()
	return filereadable(l:cache_file) ? readfile(l:cache_file)[0] : a:default
endfunction

augroup user_theme
	autocmd!
	autocmd ColorScheme * call s:theme_autoload()
augroup END

" Load cached colorscheme or hybrid by default
if has('vim_starting') && ! exists('g:colors_name')
	set background=dark
	execute 'colorscheme' s:cached_colorscheme('hybrid')
endif

if has('patch-8.0.1781') || has('nvim-0.3.2')
	autocmd user_theme ColorSchemePre * if exists('g:colors_name')
		\| highlight clear
		\| endif
endif
" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
