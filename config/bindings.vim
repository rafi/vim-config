
" Key Bindings {{{1
"------------------------------------------------------------------------------

" Non-standard {{{2
" ------------

" Want a different map leader than \
let mapleader="\<Space>"

" Maps the semicolon to colon in normal mode
nmap ; :

" Make arrow keys useful
nnoremap <Up>    :resize +4<CR>
nnoremap <Down>  :resize -4<CR>
nnoremap <Left>  :vertical resize +4<CR>
nnoremap <Right> :vertical resize -4<CR>

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
"nnoremap S <Nop>
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
"nnoremap <silent> n nzz
"nnoremap <silent> N Nzz
"nnoremap <silent> * *zz
"nnoremap <silent> # #zz
"nnoremap <silent> g* g*zz
"nnoremap <silent> g# g#zz

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

" Save a file with sudo
" http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
cmap W!! w !sudo tee % >/dev/null

" Editor UI {{{2
" ---------

" Disable help key, I use it for http://zealdocs.org
inoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Toggle paste mode, useful to temporarily disable autoindent
set pastetoggle=<F2>

" Show highlight names under cursor
map <F3> :echo 'hi<'.synIDattr(synID(line('.'), col('.'), 1), 'name')
	\.'> trans<'.synIDattr(synID(line('.'), col('.'), 0), 'name').'> lo<'
	\.synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name').'>'<CR>

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

" Several ways of close buffer
nnoremap <silent> <Leader>q :close<CR>
nnoremap <silent> <Leader>x :bdelete<CR>
nnoremap <silent> <Leader>z :BufClose<CR>

if has('quickfix')
	" Split current buffer, go to previous window and previous buffer
	nnoremap <leader>v :split<CR>:wincmd p<CR>:e#<CR>
	nnoremap <leader>g :vsplit<CR>:wincmd p<CR>:e#<CR>
endif

if has("gui_running")
	" gvim - toggle display of a GUI widgets (menu/toolbar/scrollbar)
	nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
	nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
	nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>
endif

" Totally Custom {{{2
" --------------

" Make * and # work on visual mode too
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" C-r: Easier search and replace
xnoremap <C-r> "hy:%s/<C-r>h//gc<Left><Left><Left>

" Location list
nmap <Leader>lj :lnext<CR>
nmap <Leader>lk :lprev<CR>

" Source line and selection in vim
vnoremap <leader>S y:execute @@<CR>:echo 'Sourced selection.'<CR>
nnoremap <leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>

" Append modeline to EOF
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Focus the current fold by closing all others
nnoremap <leader>ef mzzM`zzv

" Yank buffer's absolute path to X11 clipboard
nnoremap fy :let @+=expand("%:p")<CR>

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

" ChooseWin {{{3
nmap -         <Plug>(choosewin)
nmap <Leader>- <Plug>(choosewin-swap)

" Tagbar {{{3
nmap <F4> :TagbarToggle<CR>

" ColorPicker {{{3
nmap <Leader>co :ColorPicker<CR>

" Gundo {{{3
nnoremap <F5> :GundoToggle<CR>

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

autocmd FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings()
	"setlocal listchars=
	nunmap <buffer> <C-l>
	nunmap <buffer> <C-j>
	nmap <buffer> A     <Plug>(vimfiler_rename_file)
	nmap <buffer> '     <Plug>(vimfiler_toggle_mark_current_line)
	nmap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
	nmap <buffer> <C-q> <Plug>(vimfiler_quick_look)
	nmap <buffer> <C-w> <Plug>(vimfiler_switch_to_history_directory)
endfunction

" Lua Plugins {{{3
if has('lua')

" Unite {{{4
	nnoremap [unite]  <Nop>
	nmap     f [unite]
	nnoremap <silent> [unite]r  :<C-u>UniteResume -no-start-insert<CR>
	nnoremap <silent> [unite]f  :<C-u>Unite file_rec/async<CR>
	nnoremap <silent> [unite]i  :<C-u>Unite file_rec/git<CR>
	nnoremap <silent> [unite]g  :<C-u>Unite grep:. -no-wrap<CR>
	nnoremap <silent> [unite]u  :<C-u>Unite source<CR>
	nnoremap <silent> [unite]t  :<C-u>Unite tag -silent<CR>
	nnoremap <silent> [unite]T  :<C-u>Unite tag/include -silent<CR>
	nnoremap <silent> [unite]l  :<C-u>Unite location_list<CR>
	nnoremap <silent> [unite]q  :<C-u>Unite quickfix<CR>
	nnoremap <silent> [unite]e  :<C-u>Unite register<CR>
	nnoremap <silent> [unite]j  :<C-u>Unite change jump -profile-name=navigate<CR>
	nnoremap <silent> [unite]h  :<C-u>Unite history/yank<CR>
	nnoremap <silent> [unite]s  :<C-u>Unite session<CR>
	nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
	nnoremap <silent> [unite]ma :<C-u>Unite mapping -silent<CR>
	nnoremap <silent> [unite]me :<C-u>Unite output:message -silent<CR>
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
	inoremap <expr><C-j>   "\<Down>"
	inoremap <expr><C-k>   "\<Up>"
	inoremap <expr><C-f>   pumvisible() ? "\<PageDown>" : "\<Right>"
	inoremap <expr><C-b>   pumvisible() ? "\<PageUp>" : "\<Left>"
	imap <expr><S-Tab> pumvisible() ? "\<C-p>"
		\ : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
		\ : "\<S-Tab>")

	" <BS>: Close popup and delete preceding char
	inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
	" <C-y>, <C-e>: Close popup, close popup and cancel selection
	inoremap <expr><C-y> pumvisible() ? neocomplete#close_popup() : "\<C-r>"
	inoremap <expr><C-e> pumvisible() ? neocomplete#cancel_popup() : "\<End>"
	" <C-h>, <C-l>: Undo completion, complete common characters
	inoremap <expr><C-h> neocomplete#undo_completion()
	inoremap <expr><C-l> neocomplete#complete_common_string()

	" <CR>: If popup menu visible, expand snippet or close popup with selection.
	imap <expr><silent><CR> pumvisible() ?
		\ (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : neocomplete#close_popup())
		\ : "\<CR>"

	" <C+Space> unite completion
	" How weird is that <C-Space> in some(?) terminals is <Nul>?!
	imap <Nul>  <Plug>(neocomplete_start_unite_complete)

	" <Tab> completion:
	" 1. If popup menu is visible, select and insert next item
	" 2. Otherwise, if preceding chars are whitespace, insert tab char
	" 3. Otherwise, if preceding word is a snippet, expand it
	" 4. Otherwise, start manual autocomplete
	imap <expr><Tab> pumvisible() ? "\<C-n>"
		\ : (<SID>is_whitespace() ? "\<Tab>"
		\ : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
		\ : neocomplete#start_manual_complete()))

	smap <expr><Tab> pumvisible() ? "\<C-n>"
		\ : (<SID>is_whitespace() ? "\<Tab>"
		\ : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
		\ : neocomplete#start_manual_complete()))

	function! s:is_whitespace() "{{{
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~ '\s'
	endfunction "}}}

	" TODO: Not working
	"imap     <expr><C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
	"inoremap <expr><C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
	"imap     <expr><C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
	"inoremap <expr><C-x><C-f> neocomplete#start_manual_complete('file')
endif
