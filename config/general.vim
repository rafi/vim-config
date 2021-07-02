" Neovim settings
" ===

" General {{{
set mouse=nv                 " Disable mouse in command-line mode
set modeline                 " automatically setting options from modelines
set report=2                 " Report on line changes
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path+=**                 " Directories to search when using gf and friends
set isfname-==               " Remove =, detects filename in var=/foo/bar
set virtualedit=block        " Position cursor anywhere in visual block
set synmaxcol=2500           " Don't syntax highlight long lines
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
set formatoptions-=o         " Disable comment-continuation (normal 'o'/'O')
if has('patch-7.3.541')
	set formatoptions+=j       " Remove comment leader when joining lines
endif

if has('vim_starting')
	set encoding=utf-8
	scriptencoding utf-8
endif

" What to save for views and sessions:
set viewoptions=folds,cursor,curdir,slash,unix
set sessionoptions=curdir,help,tabpages,winsize

if has('mac') && has('vim_starting')
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
" Wildmenu {{{
" --------
if has('wildmenu')
	if ! has('nvim')
		set nowildmenu
		set wildmode=list:longest,full
	endif
	set wildignorecase
	set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
	set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
	set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
endif

" }}}
" Vim Directories {{{
" ---------------
set undofile
if ! has('nvim')
	set swapfile nobackup
	set directory=$XDG_DATA_HOME/nvim/swap//
	set undodir=$XDG_DATA_HOME/nvim/undo//
	set backupdir=$XDG_DATA_HOME/nvim/backup/
	set viewdir=$XDG_DATA_HOME/nvim/view/
	set spellfile=$XDG_DATA_HOME/nvim/spell/en.utf-8.add
endif

" History saving
set history=2000

if has('nvim') && ! has('win32') && ! has('win64')
	set shada='400,<20,@100,s10,f1,h,r/tmp,r/private/var
else
	set viminfo='400,<20,@50,f1,h,n$XDG_CACHE_HOME/viminfo
endif

augroup user_persistent_undo
	autocmd!
	au BufWritePre /tmp/*          setlocal noundofile
	au BufWritePre COMMIT_EDITMSG  setlocal noundofile
	au BufWritePre MERGE_MSG       setlocal noundofile
	au BufWritePre *.tmp           setlocal noundofile
	au BufWritePre *.bak           setlocal noundofile
augroup END

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
		\ && $HOME !=# expand('~'.$USER, 1)
		\ && $HOME ==# expand('~'.$SUDO_USER, 1)

	set noswapfile
	set nobackup
	set nowritebackup
	set noundofile
	if has('nvim')
		set shada="NONE"
	else
		set viminfo="NONE"
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
set noexpandtab     " Don't expand tabs to spaces
set tabstop=2       " The number of spaces a tab is
set shiftwidth=2    " Number of spaces to use in auto(indent)
set softtabstop=-1  " Automatically keeps in sync with shiftwidth
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
" set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

if exists('&breakindent')
	set breakindentopt=shift:2,min:20
endif

" }}}
" Timing {{{
" ------
set timeout ttimeout
set timeoutlen=500   " Time out on mappings
set ttimeoutlen=10   " Time out on key codes
set updatetime=400   " Idle time to write swap and trigger CursorHold
set redrawtime=2000  " Time in milliseconds for stopping display redraw

" }}}
" Searching {{{
" ---------
set ignorecase    " Search ignoring case
set smartcase     " Keep case when searching with *
set infercase     " Adjust case in insert completion mode
set incsearch     " Incremental search
set wrapscan      " Searches wrap around the end of the file

set complete=.,w,b,k  " C-n completion: Scan buffers, windows and dictionary

" Set popup max width/height.
set pumheight=10
if exists('+pumwidth')
	set pumwidth=10
endif

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
" Behavior {{{
" --------
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \	;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
" set switchbuf=useopen           " Look for matching window buffers first
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore whitespace

set completeopt=menuone         " Always show menu, even for one item
if has('patch-7.4.775')
	set completeopt+=noselect     " Do not select a match in the menu.
endif

if has('patch-8.1.0360') || has('nvim-0.5')
	set diffopt=internal,algorithm:patience
	" set diffopt=indent-heuristic,algorithm:patience
endif

" Use the new Neovim :h jumplist-stack
" if has('nvim-0.5')
" 	set jumpoptions=stack
" endif

" }}}
" Editor UI {{{
" --------------------
set noshowmode          " Don't show mode in cmd window
set shortmess=aoOTI     " Shorten messages and don't show intro
set scrolloff=2         " Keep at least 2 lines above/below
set sidescrolloff=5     " Keep at least 5 lines left/right
set nonumber            " Don't show line numbers
set noruler             " Disable default status ruler
set list                " Show hidden characters

set showtabline=2       " Always show the tabs line
set winwidth=30         " Minimum width for active window
set winminwidth=10      " Minimum width for inactive windows
" set winheight=4         " Minimum height for active window
" set winminheight=4      " Minimum height for inactive window
set pumheight=15        " Pop-up menu's line height
set helpheight=12       " Minimum help window height
set previewheight=12    " Completion preview height

set noshowcmd           " Don't show command in status line
set cmdheight=1         " Height of the command line
set cmdwinheight=5      " Command-line lines
set noequalalways       " Don't resize windows on split or close
set laststatus=2        " Always show a status line
set colorcolumn=+0      " Column highlight at textwidth's max character-limit
set display=lastline

" UI Symbols
" icons:  ▏│ ¦ ╎ ┆ ⋮ ⦙ ┊ 
let &showbreak='↳  '
set listchars=tab:\▏\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·

if has('folding') && has('vim_starting')
	set foldenable
	set foldmethod=indent
	set foldlevelstart=99
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
		autocmd FileType * if empty(&buftype) | setlocal signcolumn=yes | endif
	endif

	" Highlight current line only on focused window, unless:
	" 1. Cursor-line is already set to wanted value
	" 2. Denite or Clap buffers
	" 3. Preview window
	" 4. Completion popup menu is visible
	autocmd WinEnter,BufEnter,InsertLeave *
		\ if ! &cursorline && empty(&buftype) | setlocal cursorline | endif
	autocmd WinLeave,BufLeave,InsertEnter *
		\ if &cursorline && empty(&buftype) && ! &previewwindow && ! pumvisible()
		\ | setlocal nocursorline
		\ | endif

	" Reload vim configuration automatically on-save
	autocmd BufWritePost $VIM_PATH/{*.vim,*.yaml,vimrc} nested
		\ source $MYVIMRC | redraw

	" Automatically set read-only for files being edited elsewhere
	autocmd SwapExists * nested let v:swapchoice = 'o'

	" Update diff comparison once leaving insert mode
	autocmd InsertLeave * if &l:diff | diffupdate | endif

	" Equalize window dimensions when resizing vim window
	autocmd VimResized * wincmd =

	" Force write shada on leaving nvim
	autocmd VimLeave * if has('nvim') | wshada! | else | wviminfo! | endif

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
	autocmd BufWritePost * nested
		\ if &l:filetype ==# '' || exists('b:ftdetect')
		\ |   unlet! b:ftdetect
		\ |   filetype detect
		\ | endif

	" Reload Vim script automatically if setlocal autoread
	autocmd BufWritePost,FileWritePost *.vim nested
		\ if &l:autoread > 0 | source <afile> |
		\   echo 'source ' . bufname('%') |
		\ endif

	" When editing a file, always jump to the last known cursor position.
	" Credits: https://github.com/farmergreg/vim-lastplace
	autocmd BufReadPost *
		\ if index(['gitcommit', 'gitrebase', 'svn', 'hgcommit'], &filetype) == -1 &&
		\      index(['quickfix', 'nofile', 'help', 'prompt'], &buftype) == -1 &&
		\      ! &diff && ! &previewwindow &&
		\      line("'\"") > 0 && line("'\"") <= line("$")
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

augroup user_plugin_filetype " {{{
	autocmd!

	autocmd FileType apache setlocal path+=./;/

	autocmd FileType helm setlocal commentstring=#\ %s

	autocmd FileType html setlocal path+=./;/

	autocmd FileType crontab setlocal nobackup nowritebackup

	autocmd FileType yaml,yaml.docker-compose
		\ setlocal expandtab tabstop=2 shiftwidth=2

	autocmd FileType gitcommit setlocal spell

	autocmd FileType gitcommit,qfreplace setlocal nofoldenable

	autocmd FileType php setlocal matchpairs-=<:> iskeyword+=\\

	autocmd FileType python
		\ setlocal expandtab smarttab nosmartindent
		\ | setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80

	autocmd FileType markdown
		\ setlocal expandtab spell autoindent formatoptions=tcroqn2 comments=n:>

	" https://webpack.github.io/docs/webpack-dev-server.html#working-with-editors-ides-supporting-safe-write
	autocmd FileType css,javascript,javascriptreact setlocal backupcopy=yes

augroup END " }}}

" Internal vim plugins {{{
let g:sh_no_error = 1
let g:python_recommended_style = 0
let g:vimsyntax_noerror = 1
let g:vim_indent_cont = &shiftwidth
let g:ruby_no_expensive = 1
let g:PHP_removeCRwhenUnix = 0
" }}}

" Theme {{{
" ---
"
" Autoloads theme according to user selected colorschemes

function! s:theme_init()
	" Load cached colorscheme or hybrid by default
	if ! exists('g:colors_name')
		set background=dark
		silent! execute 'colorscheme' s:theme_cached_scheme('hybrid')
	endif
endfunction

function! s:theme_autoload()
	" source $VIM_PATH/themes/hybrid.vim
	if exists('g:colors_name')
		let theme_path = $VIM_PATH . '/themes/' . g:colors_name . '.vim'
		if filereadable(theme_path)
			execute 'source' fnameescape(theme_path)
		endif
		" Persist theme
		call writefile([g:colors_name], s:theme_cache_file())
	endif
endfunction

function! s:theme_cache_file()
	return $XDG_DATA_HOME . '/nvim/theme.txt'
endfunction

function! s:theme_cached_scheme(default)
	let l:cache_file = s:theme_cache_file()
	return filereadable(l:cache_file) ? readfile(l:cache_file)[0] : a:default
endfunction

function! s:theme_cleanup()
	if ! exists('g:colors_name')
		return
	endif
	highlight clear
endfunction

augroup user_theme
	autocmd!
	autocmd ColorScheme * call s:theme_autoload()
	if has('patch-8.0.1781') || has('nvim-0.3.2')
		autocmd ColorSchemePre * call s:theme_cleanup()
	endif
augroup END

call s:theme_init()
" }}}

" ### Disabled {{{
" if exists('+previewpopup')
" 	set previewpopup=height:10,width:60
" endif

" Pseudo-transparency for completion menu and floating windows
" if has('termguicolors') && &termguicolors
" 	if exists('&pumblend')
" 		set pumblend=10
" 	endif
" 	if exists('&winblend')
" 		set winblend=10
" 	endif
" endif

" if has('nvim-0.4')
" 		set signcolumn=auto:1-2
" " 	set signcolumn=yes
" " elseif exists('&signcolumn')
" " 	set signcolumn=auto
" endif
" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
