
" Key Bindings
"---------------------------------------------------------

" Non-standard {{{
" ------------

" Maps the semicolon to colon in normal mode
nmap ; :

if exists('g:elite_mode') && g:elite_mode
	" Make arrow keys useful
	nnoremap <Up>    :resize +2<CR>
	nnoremap <Down>  :resize -2<CR>
	nnoremap <Left>  :vertical resize +2<CR>
	nnoremap <Right> :vertical resize -2<CR>
endif

" Use backspace key for matchit.vim
nmap <BS> %
xmap <BS> %

" Use <C-Space> instead <C-@>
imap <C-Space>  <C-@>
nmap <C-Space>  <C-@>
cmap <C-Space>  <C-@>

" }}}
" Global niceties {{{
" ---------------

" I do not use clipboard=unnamed, these
" yank and paste from X11's clipboard.
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
nmap <Leader><Leader> V
vmap <Leader><Leader> <Esc>

" Remap some keys to be more useful
nnoremap ' `
nnoremap ` '
nnoremap <CR> za

" Improve cursor up/down
nnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> k v:count ? 'k' : 'gk'

" Start an external command with a single bang
nnoremap ! :!

" Allow misspellings when :wq
cabbrev Wq :wq
cabbrev qw :wq
cabbrev Qa :qa

" Exit insert mode without using Esc
inoremap jk <Esc>

" improve scroll
noremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line("w$") >= line('$') ? "L" : "H")
noremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line("w0") <= 1         ? "H" : "L")
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

" Navigate window
nnoremap <C-x> <C-w>x
nnoremap <silent> <C-w>z :ZoomToggle<CR>
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]' <bar><bar> &l:buftype ==# 'quickfix') ? "<CR>" : "<C-w>j"

" Increment and decrement
nnoremap + <C-a>
nnoremap - <C-x>

" Go to the first non-blank character of the line after paragraph motions
noremap } }^

" Select blocks after indenting
xnoremap < <gv
xnoremap > >gv|

" Use tab for indenting in visual mode
vnoremap <Tab> >gv|
vnoremap <S-Tab> <gv
nnoremap > >>_
nnoremap < <<_

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" disable EX-mode
nnoremap  Q <Nop>
nnoremap gQ <Nop>

" Operator [
onoremap [ <ESC>

" Navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" <C-g> in command line
cmap <C-g> <ESC><C-g>

" }}}
" File operations {{{
" ---------------

" When pressing <leader>cd switch to the directory of the open buffer
map <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Fast saving
nnoremap <Leader>w :w<CR>
vnoremap <Leader>w <Esc>:w<CR>
nnoremap <C-s> :<C-u>w<CR>
inoremap <C-s> <ESC>:<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
cnoremap <C-s> <C-u>w<CR>

" Save a file with sudo
" http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
cmap W!! w !sudo tee % >/dev/null

" }}}
" Editor UI {{{
" ---------

" Toggle paste mode, useful to temporarily disable autoindent
set pastetoggle=<F2>

" Show highlight names under cursor
map <F3> :echo 'hi<'.synIDattr(synID(line('.'), col('.'), 1), 'name')
	\.'> trans<'.synIDattr(synID(line('.'), col('.'), 0), 'name').'> lo<'
	\.synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name').'>'<CR>

" Toggle spell checking
" Toggle line numbers
" Show hidden characters
" Clear the highlighting search
nmap <Leader>ts :setlocal spell!<cr>
nmap <Leader>tn :setlocal nonumber!<CR>
nmap <Leader>tl :setlocal nolist!<CR>
nmap <Leader>th :nohlsearch<CR>
nmap <Leader>tw :setlocal wrap! breakindent!<CR>

" Tabs
nnoremap <silent> g0 :<C-u>tabfirst<CR>
nnoremap <silent> g$ :<C-u>tablast<CR>

" Buffers
map <S-Right> :bnext<CR>
map <S-Left>  :bprev<CR>

" Several ways for closing a buffer
nnoremap <silent> <Leader>q :close<CR>
nnoremap <silent> <Leader>x :bdelete<CR>
nnoremap <silent> <Leader>z :BufClose<CR>

" Split current buffer, go to previous window and previous buffer
nnoremap <leader>sv :split<CR>:wincmd p<CR>:e#<CR>
nnoremap <leader>sg :vsplit<CR>:wincmd p<CR>:e#<CR>

" }}}
" Totally Custom {{{
" --------------

" Remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" Diff
nnoremap <silent> <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"

" Make * and # work on visual mode too
xnoremap * :<C-u>call VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" C-r: Easier search and replace
xnoremap <C-r> :<C-u>call VSetSearch('/')<CR>:%s:<C-R>=@/<CR>::gc<Left><Left><Left>

" Location list
nmap <Leader>lj :lnext<CR>
nmap <Leader>lk :lprev<CR>

" Source line and selection in vim
vnoremap <Leader>S y:execute @@<CR>:echo 'Sourced selection.'<CR>
nnoremap <Leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>

" Append modeline to EOF
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Focus the current fold by closing all others
nnoremap [unite]z mzzM`zzv
" Yank buffer's absolute path to X11 clipboard
nnoremap [unite]y :let @+=expand("%:p")<CR>:echo 'Copied to clipboard.'<CR>

" Drag current line/s vertically and auto-indent
noremap  <leader>mk :m-2<CR>==
noremap  <leader>mj :m+<CR>==
vnoremap <leader>mk :m-2<CR>gv=gv
vnoremap <leader>mj :m'>+<CR>gv=gv

augroup MyAutoCmd " {{{

	autocmd FileType qf,diff  nnoremap <buffer> q  :q<CR>

	autocmd FileType php
		\ nnoremap <silent><buffer> <Leader>k :call pdv#DocumentCurrentLine()<CR>

	if has('mac')
		" Use Marked for real-time (on save) Markdown preview
		autocmd FileType markdown
			\ nnoremap <Leader>P :silent !open -a Marked\ 2.app '%:p'<CR>:redraw!<CR>
		" Use Dash on Mac, for context help
		autocmd FileType ansible,go,python,php,css,less,html,markdown
			\ nnoremap <silent><buffer> K :!open -g dash://"<C-R>=&ft<CR>:<cword>"&<CR><CR>
		autocmd FileType javascript,sql,ruby,conf,sh
			\ nnoremap <silent><buffer> K :!open -g dash://"<cword>"&<CR><CR>
	else
		" Use Zeal on Linux for context help
		autocmd FileType ansible,go,python,php,css,less,html,markdown
			\ nnoremap <silent><buffer> K :!zeal --query "<C-R>=&ft<CR>:<cword>"&<CR><CR>
		autocmd FileType javascript,sql,ruby,conf,sh
			\ nnoremap <silent><buffer> K :!zeal --query "<cword>"&<CR><CR>
	endif

augroup END
" }}}

" s: Windows and buffers(High priority) "{{{
" Credits: https://github.com/Shougo/shougo-s-github
" The prefix key.
nnoremap    [Window]   <Nop>
nmap    s [Window]
nnoremap <silent> [Window]p  :<C-u>call <SID>split_nicely()<CR>
nnoremap <silent> [Window]v  :<C-u>split<CR>
nnoremap <silent> [Window]g  :<C-u>vsplit<CR>
nnoremap <silent> [Window]t  :tabnew<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>
nnoremap <silent> [Window]D  :<C-u>call <SID>CustomBufferDelete(1)<CR>
nnoremap <silent> q :<C-u>call <SID>smart_close()<CR>

" Move around windows beyond tabs
nnoremap <silent> <Tab> :call <SID>NextWindowOrTab()<CR>
nnoremap <silent> <S-Tab> :call <SID>PreviousWindowOrTab()<CR>

function! s:smart_close() "{{{
	if winnr('$') != 1
		close
	else
		call s:alternate_buffer()
	endif
endfunction "}}}

function! s:NextWindow() "{{{
	if winnr('$') == 1
		silent! normal! ``z.
	else
		wincmd w
	endif
endfunction "}}}

function! s:NextWindowOrTab() "{{{
	if tabpagenr('$') == 1 && winnr('$') == 1
		call s:split_nicely()
	elseif winnr() < winnr("$")
		wincmd w
	else
		tabnext
		1wincmd w
	endif
endfunction "}}}

function! s:PreviousWindowOrTab() "{{{
	if winnr() > 1
		wincmd W
	else
		tabprevious
		execute winnr("$") . "wincmd w"
	endif
endfunction "}}}

function! s:split_nicely() "{{{
	if winwidth(0) > 2 * &winwidth
		vsplit
	else
		split
	endif
	wincmd p
endfunction "}}}

function! s:CustomBufferDelete(is_force) "{{{
	let current = bufnr('%')

	call s:alternate_buffer()

	if a:is_force
		silent! execute 'bdelete! ' . current
	else
		silent! execute 'bdelete ' . current
	endif
endfunction "}}}

function! s:alternate_buffer() "{{{
	let listed_buffer_len = len(filter(range(1, bufnr('$')),
				\ 's:buflisted(v:val) && getbufvar(v:val, "&filetype") !=# "unite"'))
	if listed_buffer_len <= 1
		enew
		return
	endif

	let cnt = 0
	let pos = 1
	let current = 0
	while pos <= bufnr('$')
		if s:buflisted(pos)
			if pos == bufnr('%')
				let current = cnt
			endif

			let cnt += 1
		endif

		let pos += 1
	endwhile

	if current > cnt / 2
		bprevious
	else
		bnext
	endif
endfunction "}}}

function! s:buflisted(bufnr) "{{{
	return exists('t:unite_buffer_dictionary') ?
		\ has_key(t:unite_buffer_dictionary, a:bufnr) && buflisted(a:bufnr) :
		\ buflisted(a:bufnr)
endfunction "}}}
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
