"      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
" `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
"
" github.com/rafi vim config
" vim: set ts=2 sw=2 tw=80 noet :

" Runtime and Plugins {{{1
"------------------------------------------------------------------------------

" Respect XDG
set runtimepath=$XDG_CONFIG_HOME/vim,$XDG_CONFIG_HOME/vim/after,$VIM,$VIMRUNTIME
let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc"

" Load pathogen plugin itself
runtime bundle/pathogen/autoload/pathogen.vim

" To disable a plugin, add it's bundle name to the following list
let g:pathogen_disabled = []

" Plugins that require lua
if ! has('lua')
	call add(g:pathogen_disabled, 'neocomplete')
endif

" Plugins that require at least vim 7.3
if v:version < '703' || ! has('python')
	call add(g:pathogen_disabled, 'colorpicker')
	call add(g:pathogen_disabled, 'gundo')
	call add(g:pathogen_disabled, 'unite')
	call add(g:pathogen_disabled, 'unite-neomru')
	call add(g:pathogen_disabled, 'unite-outline')
	call add(g:pathogen_disabled, 'unite-quickfix')
	call add(g:pathogen_disabled, 'unite-tag')
	call add(g:pathogen_disabled, 'vimfiler')
	call add(g:pathogen_disabled, 'vimproc')
	call add(g:pathogen_disabled, 'neosnippet')
endif

" Load all plugins from bundle/
execute pathogen#infect()
syntax on
filetype plugin indent on

" Load matchit.vim, but only if the user hasn't installed a newer version.
if ! exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
	runtime! macros/matchit.vim
endif

" General Settings {{{1
"------------------------------------------------------------------------------
" Vim core {{{2
" --------
set nocompatible             " break away from old vi compatibility
set autoread                 " Files are read as soon as they are changed
set formatoptions+=1j        " Automatic formatting
set mouse=nv                 " enable mouse use for normal and visual modes
set modeline                 " automatically setting options from modelines
set report=2                 " report when 3 or more lines are changed
set noerrorbells             " don't whine
set novisualbell t_vb=       " and don't make faces
set lazyredraw               " don't redraw while in macros
set hidden                   " hide buffers when abandoned instead of unload
set encoding=utf-8           " Set utf8 as standard encoding (+multi_byte)
set ffs=unix,dos,mac         " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path=.,**                " Directories to search when using gf
set sessionoptions-=options  " Don't save options and runtime in sessions (+mksession)
set virtualedit=block        " Position cursor anywhere in visual block (+virtualedit)
set history=700              " Search and commands remembered
set synmaxcol=512            " Don't syntax highlight long lines
syntax sync minlines=256     " Update syntax highlighting for more lines

if has('clipboard') || has("gui_running")
	set clipboard=             " Do not do anything with system's clipboard
endif

" Wildmenu/ignore {{{2
" ---------------
if has('wild_menu')
	set wildmenu                 " turn on wild menu :e <Tab>
	set wildmode=list:longest    " set wildmenu to list choice
	set wildignorecase
	set wildignore+=.hg,.git,.svn,*.pyc,*.spl,*.o,*.out,*~,#*#,%*
	set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,*.manifest
	set wildignore+=**/cache/??,**/cache/mustache,**/cache/media,**/logs/????
	set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
endif

" Vim Directories {{{2
" ---------------
set nobackup undofile noswapfile
set backupdir=$XDG_CACHE_HOME/vim/backup/
set directory=$XDG_CACHE_HOME/vim/swap//
set viminfo+=n$XDG_CACHE_HOME/vim/viminfo     " +viminfo
set undodir=$XDG_CACHE_HOME/vim/undo//        " +persistent_undo
set spellfile=$XDG_CONFIG_HOME/vim/spell/en.utf-8.add

" Plugin Directories {{{2
" ------------------
let g:bookmark_auto_save_file    = $XDG_CACHE_HOME.'/vim/bookmarks'
let g:unite_data_directory       = $XDG_CACHE_HOME."/vim/unite"
let g:vimfiler_data_directory    = $XDG_CACHE_HOME.'/vim/vimfiler'
let g:neocomplete#data_directory = $XDG_CACHE_HOME.'/vim/complete'
let g:neosnippet#data_directory  = $XDG_CACHE_HOME.'/vim/snippet'
let g:neomru#file_mru_path       = $XDG_CACHE_HOME.'/vim/unite/mru/file'
let g:neomru#directory_mru_path  = $XDG_CACHE_HOME.'/vim/unite/mru/directory'
let g:neosnippet#snippets_directory =
			\$XDG_CONFIG_HOME.'/vim/snippets/rafi,'
			\.$XDG_CONFIG_HOME.'/vim/snippets/shougo/neosnippets,'
			\.$XDG_CONFIG_HOME.'/vim/bundle/go/gosnippets/snippets'

" Tabs and Indents {{{2
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

" Folds {{{2
" -----
if has('folding')
	set foldenable
	set foldmethod=syntax
	set foldlevelstart=99
	set foldtext=FoldText()
endif

" Timeouts {{{2
" --------
set ttimeout
set ttimeoutlen=20  " Make esc work faster
set timeoutlen=1200 " A little bit more time for macros

" Searching {{{2
" ---------
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set noshowmatch     " Don't jump to matching bracket
set incsearch       " Incremental search (+extra_search)
set hlsearch        " Highlight the search (+extra_search)

" Behavior {{{2
" --------
set nostartofline              " Cursor in same column for several commands
set whichwrap=b,s              " Move to following line on certain keys
set splitbelow splitright      " New split position: Bottom right (+windows +vertsplit)
set switchbuf=usetab,split     " Switch buffer behavior
set backspace=indent,eol,start " Intuitive backspacing in insert mode
set diffopt=filler,iwhite      " Diff mode: show fillers, ignore whitespace (+diff)
set tags=./tags,tags           " Tags are overridden by bundle/tagabana
set complete-=i                " Don't scan current and included files
set completeopt-=preview       " No extra info buffer in completion menu (+insert_expand)
set formatprg=par\ -w78        " Use http://www.nicemice.net/par/

" Editor UI Appearance {{{2
" --------------------
set shortmess=aoOTI     " Shorten messages and don't show intro
set scrolloff=2         " Keep at least 2 lines above/below
set sidescrolloff=2     " Keep at least 2 lines left/right
set pumheight=20        " Pop-up menu's line height (+insert_expand)
set nocursorline        " Do not highlight line at cursor
set nonumber            " No line numbers

set showtabline=2       " Always show the tabs line (+windows)
set tabpagemax=30       " Maximum number of tab pages (+windows)

set showcmd             " Show (partial) command in status line (+cmdline_info)
set cmdheight=1         " Explicitly set the height of the command line
set display+=lastline   " Try showing more of last line
set laststatus=2        " Always show a status line on windows

" Changing characters to fill special ui elements
set showbreak=↪               " (+linebreak)
set fillchars=vert:│,fold:─   " (+windows +folding)
set list listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·

" For snippet_complete marker
if has('conceal')
	set conceallevel=2 concealcursor=i
endif

" gui-Vim Appearance {{{2
" ------------------
if has("gui_running")
	set guioptions=mg          " Show _only_ menu bar and grey menu items
	set lines=58 columns=190   " Maximize gvim window

	" Font
	if has("gui_gtk2")
		set guifont=PragmataPro\ 12
	elseif has("gui_macvim")
		set guifont=Menlo\ Regular:h14
	elseif has("gui_win32")
		set guifont=Consolas:h11:cANSI
	endif
endif

" Plugin Settings {{{1
"------------------------------------------------------------------------------

let g:loaded_netrwPlugin = 1               " Disable netrw, using VimFiler
let g:neocomplete#enable_at_startup = 1    " Enable neocomplete
let g:unite_source_history_yank_enable = 1 " Unite: Store yank history
let g:bookmark_sign = '✓'                  " Bookmarks: Bookmark sign
let g:bookmark_annotation_sign = '⌦'       " Bookmarks: Annonation sign
let delimitMate_expand_cr = 1              " delimitMate
let g:vim_markdown_initial_foldlevel = 5   " Markdown: Don't start all folded
let g:Gitv_DoNotMapCtrlKey = 1             " Gitv: Do not map ctrl keys
let g:choosewin_label = 'SDFGHJKLZXCVBNM'  " ChooseWin: Window labels

" Set syntastic signs, must be in vimrc
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = '⚠'
let g:syntastic_warning_symbol = ''

" neosnippet
let g:neosnippet#enable_snipmate_compatibility = 1
let g:neosnippet#disable_runtime_snippets = { '_': 1 }


" vim-go, do not mess with my neosnippet config!
let g:go_disable_autoinstall = 1
let g:go_loaded_gosnippets = 1
let g:go_snippet_engine = "neosnippet"

" Emmet
let g:use_emmet_complete_tag = 1
let g:user_emmet_leader_key = '<C-z>'
let g:user_emmet_mode = 'i'
let g:user_emmet_install_global = 0
autocmd FileType html EmmetInstall

" Enable omni completions for file types
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown,mustache setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" URxvt & tmux fixes {{{1
"------------------------------------------------------------------------------

" Make the Ctrk+Tab work in console, see also .config/xorg/Xresources
map <Esc>[27;5;9~ <C-Tab>
map <Esc>[27;6;9~ <C-S-Tab>

" Under URxvt and Tmux, make Vim recognize xterm escape
" sequences for arrow keys combined with modifiers.
if &term =~ '^screen'
	" Ctrl+Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
	execute "set t_kP=\e[5;*~"
	execute "set t_kN=\e[6;*~"

	" Ctrl+Arrow keys http://unix.stackexchange.com/a/34723/64717
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif

" Cursor Shape {{{2
" ------------
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

" Key Bindings {{{1
"------------------------------------------------------------------------------

" Non-standard {{{2
" ------------

" Want a different map leader than \
let mapleader="\<Space>"

" Maps the semicolon to colon in normal mode
nmap ; :

" Make arrow keys useful
nnoremap <left>  :vertical resize +1<CR>
nnoremap <right> :vertical resize -1<CR>
nnoremap <up>    :resize +1<CR>
nnoremap <down>  :resize -1<CR>

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

" Keep search pattern at the center of the screen
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz
nnoremap <silent> g# g#zz

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

" Trick by Steve Losh: save a file if you forgot to sudo before editing
" http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
cmap W!! w !sudo tee % >/dev/null

" Editor UI {{{2
" ---------

" Disable help key, used by http://zealdocs.org
inoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Toggle paste mode
" Particularly useful to temporarily disable autoindent
set pastetoggle=<F2>

" Show highlight names under cursor
map <F3> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
	\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
	\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" Line number type toggle
nnoremap <Leader>l :set nonumber!<CR>

" Show hidden characters (spaces, tabs, etc)
nmap <silent> <leader>s :set nolist!<CR>

" Clear the highlighting of :set hlsearch
nmap <silent> <Leader>h :silent :nohlsearch<CR>

" Toggle spell checking
map <leader>ss :setlocal spell!<cr>

" Tabs
map     <C-t>     :tabnew<CR>
noremap <C-x>     :tabclose<CR>
noremap <C-Tab>   :tabn<CR>
noremap <C-S-Tab> :tabp<CR>

" Splits
" I imagine v as an arrow, split below
nnoremap <leader>sv :new<CR>
nnoremap <leader>sg :vnew<CR>

" Buffers
map <S-Right> :bnext<CR>
map <S-Left>  :bprev<CR>

" Closes current buffer
nnoremap <silent> <Leader>q :close<CR>

" Remove current buffer
nnoremap <silent> <Leader>x :bdelete<CR>

" gvim - toggle display of a GUI widgets (menu/toolbar/scrollbar)
nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

" Totally Custom {{{2
" --------------

" Make * and # work on visual mode too
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" Don't move on *
"nnoremap <silent> * :let stay_star_view = winsaveview()<CR>*:call winrestview(stay_star_view)<CR>

" Location list
nmap <Leader>lj :lnext<CR>
nmap <Leader>lk :lprev<CR>

" Source line and selection in vim
vnoremap <leader>S y:execute @@<CR>:echo 'Sourced selection.'<CR>
nnoremap <leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>

" Append modeline to EOF
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

if has('quickfix')
	" Split current buffer, go to previous window and previous buffer
	nnoremap <leader>v :split<CR>:wincmd p<CR>:e#<CR>
	nnoremap <leader>g :vsplit<CR>:wincmd p<CR>:e#<CR>
endif

" Focus the current fold by closing all others
nnoremap <leader>ef mzzM`zzv

" Yank buffer's absolute path to X11 clipboard
nnoremap <leader>cy :let @+=expand("%:p")<CR>

" Drag current line/s vertically and auto-indent
noremap  <leader>m :m+<CR>==
noremap  <leader>, :m-2<CR>==
vnoremap <leader>m :m'>+<CR>gv=gv
vnoremap <leader>, :m-2<CR>gv=gv

autocmd FileType qf call s:quickfix_settings()
function! s:quickfix_settings()
	" Jump to source with Enter
	nnoremap <buffer> <CR> :.cc<CR>
	" Quit the quickfix window with a single 'q' or Escape
	nnoremap <buffer> q     :bdelete<CR>
	nnoremap <buffer> <ESC> :bdelete<CR>
endfunction

" Plugins {{{2
" -------

" Tagbar {{{3
nmap <F4> :TagbarToggle<CR>

" ColorPicker {{{3
nmap <Leader>c :ColorPicker<CR>

" Assistant {{{3
nnoremap <unique> <Leader>i :call PopHelpList()<CR>

" Gundo {{{3
nnoremap <F5> :GundoToggle<CR>

" NERDCommenter {{{3
let NERDCreateDefaultMappings = 0
map <leader>ci <plug>NERDCommenterInvert
map <leader>cc <plug>NERDCommenterComment

" Fugitive {{{3
" ga gs gd gD gc gb gl gp gg gB gbd
nnoremap <silent> <leader>ga :Git add %:p<CR>
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gD :Gdiffoff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Gitv --all<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gB :Gbrowse<CR>
nnoremap <silent> <leader>gbd :Gbrowse origin/develop^{}:%<CR>

" VimFiler {{{3
noremap <silent> <Leader>f :VimFilerExplorer -winwidth=25 -split -toggle -no-quit<CR>
noremap <silent> <Leader>a :VimFilerExplorer -find -winwidth=25 -split -toggle -no-quit<CR>
noremap <silent> <Leader>dl :VimFilerExplorer -toggle -find<CR>
noremap <silent> <Leader>db :VimFilerBufferDir<CR>
noremap <silent> <Leader>ds :VimFilerSplit<CR>

autocmd FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings()
	nunmap <buffer> <C-l>
	nunmap <buffer> <C-j>
	nnoremap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
	nmap <buffer> ' <Plug>(vimfiler_toggle_mark_current_line)
	nmap <buffer> <C-q> <Plug>(vimfiler_quick_look)
	nmap <buffer> <C-w> <Plug>(vimfiler_switch_to_history_directory)
endfunction

" Lua Plugins {{{3
if has('lua')

" Unite {{{4
	nnoremap [unite]  <Nop>
	nmap     f [unite]
	nnoremap <silent> [unite]r  :<C-u>UniteResume<CR>
	nnoremap <silent> [unite]f  :<C-u>Unite file_rec/async<CR>
	nnoremap <silent> [unite]i  :<C-u>Unite file_rec/git<CR>
	nnoremap <silent> [unite]g  :<C-u>Unite grep:.<CR>
	nnoremap <silent> [unite]u  :<C-u>Unite source<CR>
	nnoremap <silent> [unite]t  :<C-u>Unite tag<CR>
	nnoremap <silent> [unite]T  :<C-u>Unite tag/include<CR>
	nnoremap <silent> [unite]l  :<C-u>Unite location_list<CR>
	nnoremap <silent> [unite]q  :<C-u>Unite quickfix<CR>
	nnoremap <silent> [unite]e  :<C-u>Unite register<CR>
	nnoremap <silent> [unite]j  :<C-u>Unite change jump -profile-name=navigate<CR>
	nnoremap <silent> [unite]h  :<C-u>Unite history/yank<CR>
	nnoremap <silent> [unite]s  :<C-u>Unite session<CR>
	nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
	nnoremap <silent> [unite]ma :<C-u>Unite mapping<CR>
	nnoremap <silent> [unite]me :<C-u>Unite output:message<CR>
	nnoremap <silent> <Leader>b :<C-u>Unite buffer file_mru bookmark<CR>
	nnoremap <silent> <Leader>t :<C-u>Unite tab<CR>
	" Open VimFiler with current file selected
	nnoremap <silent> [unite]a  :<C-u>VimFilerExplorer -find -winwidth=25 -split -toggle -no-quit<CR>
	" Open Unite with word under cursor or selection
	nnoremap <silent> <Leader>gf :execute 'UniteWithCursorWord file_rec/async -profile-name=navigate'<CR>
	nnoremap <silent> <Leader>gt :execute 'UniteWithCursorWord tag -profile-name=navigate'<CR>
	nnoremap <silent> <Leader>gg :execute 'UniteWithCursorWord grep:. -profile-name=navigate'<CR>
	vnoremap <silent> <Leader>gt :<C-u>call <SID>VSetSearch('/')<CR>:execute 'Unite tag -profile-name=navigate -input='.strpart(@/,2)<CR>
	vnoremap <silent> <Leader>gg :<C-u>call <SID>VSetSearch('/')<CR>:execute 'Unite grep:. -profile-name=navigate -input='.strpart(@/,2)<CR>

	autocmd FileType unite call s:unite_settings()
	function! s:unite_settings()
		nunmap <buffer> <C-h>
		nunmap <buffer> <C-k>
		nunmap <buffer> <C-l>
		nunmap <buffer> <C-r>
		nmap <silent><buffer> <C-r> <Plug>(unite_redraw)
		imap <silent><buffer> <C-j> <Plug>(unite_select_next_line)
		imap <silent><buffer> <C-k> <Plug>(unite_select_previous_line)
		nmap <silent><buffer> '     <Plug>(unite_toggle_mark_current_candidate)
		nmap <silent><buffer> e     <Plug>(unite_do_default_action)
		nmap <silent><buffer><expr> <C-v> unite#do_action('splitswitch')
		nmap <silent><buffer><expr> <C-s> unite#do_action('vsplitswitch')
		nmap <silent><buffer><expr> <C-t> unite#do_action('tabswitch')
		nmap <buffer> <ESC> <Plug>(unite_exit)
		imap <buffer> jj    <Plug>(unite_insert_leave)

		let unite = unite#get_current_unite()
		if unite.profile_name ==# '^search'
			nnoremap <silent><buffer><expr> r unite#do_action('replace')
		else
			nnoremap <silent><buffer><expr> r unite#do_action('rename')
		endif
	endfunction

" neocomplete and neosnippet {{{4

	" Movement within 'ins-completion-menu'
	inoremap <expr><C-j>   pumvisible() ? "\<Down>" : "\<C-j>"
	inoremap <expr><C-k>   pumvisible() ? "\<Up>" : "\<C-k>"
	inoremap <expr><C-f>   pumvisible() ? "\<PageDown>" : "\<C-b>"
	inoremap <expr><C-b>   pumvisible() ? "\<PageUp>" : "\<C-f>"
	inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

	" <C-h>, <BS>: Close popup and delete backword char
	inoremap <expr><C-h> pumvisible() ? neocomplete#smart_close_popup()."\<C-h>" : "\<C-h>"
	inoremap <expr><BS>  pumvisible() ? neocomplete#smart_close_popup()."\<C-h>" : "\<BS>"
	" <C-y>, <C-e>: Close popup, close popup and cancel selection
	inoremap <expr><C-y> pumvisible() ? neocomplete#close_popup() : "\<C-y>"
	inoremap <expr><C-e> pumvisible() ? neocomplete#cancel_popup() : "\<C-e>"
	" <C-g>, <C-l>: Undo completion, complete common characters
	inoremap <expr><silent><C-g>   pumvisible() ? neocomplete#undo_completion() : "\<C-g>"
	inoremap <expr><C-l>   pumvisible() ? neocomplete#complete_common_string() : "\<C-l>"

	" <CR>: close popup with selection or expand snippet
	imap <expr><silent><CR> pumvisible() ?
					\ (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : neocomplete#close_popup())
					\ : "\<CR>"

	" <Tab> completion
	" If item is a snippet, expand it.
	" Otherwise,
	" - If popup menu is visible, select and insert next item
	" - Otherwise, if preceding chars are whitespace, insert tab char
	" - Otherwise, start manual complete
	imap <expr><Tab> neosnippet#expandable_or_jumpable() ?
					\ "\<Plug>(neosnippet_expand_or_jump)"
					\ : (pumvisible() ? "\<C-n>" :
					\ (<SID>before_complete_check_backspace() ? "\<TAB>" :
					\ neocomplete#start_manual_complete()))

	function! s:before_complete_check_backspace() "{{{
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~ '\s'
	endfunction "}}}
endif

" Functions & Commands {{{1
"------------------------------------------------------------------------------

" Highlight just a single character on the 81 column
call matchadd('ColorColumn', '\%81v', 100)

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\	exe 'normal! g`"zvzz' |
	\ endif

" Simple way to turn off Gdiff splitscreen
" works only when diff buffer is focused
" See: http://stackoverflow.com/a/25530943/351947
command! Gdiffoff call Gdiffoff()
function! Gdiffoff()
	let diffbufnr = bufnr('^fugitive:')
	if diffbufnr > -1 && &diff
		diffoff | q
		if bufnr('%') == diffbufnr | Gedit | endif
		if has('cursorbind') | setlocal nocursorbind | endif
	else
		echo 'Error: Not in diff or file'
	endif
endfunction

" Makes * and # work on visual mode too.
" See: http://github.com/nelstrom/vim-visual-star-search
function! s:VSetSearch(cmdtype)
	let temp = @s
	normal! gv"sy
	let @/ = '\V'.substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
	let @s = temp
endfunction

" Append modeline after last line in buffer
" See: http://vim.wikia.com/wiki/Modeline_magic
function! AppendModeline()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction

" Nicer fold text
" See: http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! FoldText()
	let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
	let lines_count = v:foldend - v:foldstart + 1
	let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
	let foldchar = matchstr(&fillchars, 'fold:\zs.')
	let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
	let foldtextend = lines_count_text . repeat(foldchar, 8)
	let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
	return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

" Theme & Colors {{{1
"------------------------------------------------------------------------------

" Theme {{{2
" -----
set t_Co=256
set background=dark
colorscheme hybrid

" Custom Colors {{{2
" -------------

" General GUI {{{3
" No bold in gvim's error messages
highlight ErrorMsg     gui=NONE
" Whitespace
highlight SpecialKey   ctermfg=235  guifg=#30302c
" YAML scalar
highlight yamlScalar   ctermfg=250  guifg=#a8a897
" Last search highlighting and quickfix's current line
highlight Search       ctermfg=NONE ctermbg=232 cterm=reverse
" Brakets and pairs
highlight MatchParen   ctermfg=232  ctermbg=66
" Markdown headers
highlight link htmlH1 Statement
" Mode message (insert, visual, etc)
highlight ModeMsg      ctermfg=240
" Visual mode selection
highlight Visual       ctermbg=236

" Popup menu {{{3
highlight Pmenu       ctermfg=245 ctermbg=234
highlight PmenuSel    ctermfg=235 ctermbg=250
highlight PmenuSbar   ctermbg=235
highlight PmenuThumb  ctermbg=240

" Tabline {{{3
highlight TabLineFill      ctermfg=236 guifg=#303030
highlight TabLine          ctermfg=236 ctermbg=243 guifg=#303030 guibg=#767676
highlight TabLineSel       ctermfg=241 ctermbg=234 guifg=#626262 guibg=#1C1C1C gui=NONE
highlight TabLineSelRe     ctermfg=234 ctermbg=236 guifg=#1C1C1C guibg=#303030
highlight TabLineProject   ctermfg=252 ctermbg=238 guifg=#D0D0D0 guibg=#444444
highlight TabLineProjectRe ctermfg=238 ctermbg=236 guifg=#444444 guibg=#303030
highlight TabLineA         ctermfg=235 ctermbg=234 guifg=#262626 guibg=#1C1C1C

" Unite {{{3
highlight uniteCandidateMarker        ctermfg=4
highlight uniteCandidateInputKeyword  ctermfg=221 guifg=221 cterm=underline

" Grep {{{3
highlight link uniteSource__Grep        Directory
highlight link uniteSource__GrepLineNr  qfLineNr
highlight uniteSource__GrepLine         ctermfg=245 guifg=#808070
highlight uniteSource__GrepFile         ctermfg=4   guifg=#8197bf
highlight uniteSource__GrepSeparator    ctermfg=5   guifg=#f0a0c0
highlight uniteSource__GrepPattern      ctermfg=1   guifg=#cf6a4c

" Quickfix {{{3
highlight UniteQuickFixWarning              ctermfg=1
highlight uniteSource__QuickFix             ctermfg=8
highlight uniteSource__QuickFix_Bold        ctermfg=249
highlight link uniteSource__QuickFix_File   Directory
highlight link uniteSource__QuickFix_LineNr qfLineNr

" VimFiler {{{3
highlight vimfilerNormalFile  ctermfg=245 guifg=#808070
highlight vimfilerClosedFile  ctermfg=249 guifg=#a8a897
highlight vimfilerOpenedFile  ctermfg=254 guifg=#e8e8d3
highlight vimfilerNonMark     ctermfg=239 guifg=#4e4e43
highlight vimfilerLeaf        ctermfg=235 guifg=#30302c

" Signify {{{3
highlight SignifySignAdd    ctermfg=2 guifg=#6D9B37
highlight SignifySignDelete ctermfg=1 guifg=#D370A3
highlight SignifySignChange ctermfg=3 guifg=#B58858

" }}}
"-------8<---------------------------------------------------------------------
