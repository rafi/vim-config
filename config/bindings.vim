
" Key Bindings
"---------------------------------------------------------

" Non-standard {{{
" ------------

" Window prefix
nnoremap  [Window]   <Nop>
nmap      s [Window]

" Unite prefix
nnoremap [unite]  <Nop>
xnoremap [unite]  <Nop>
nmap     ; [unite]
xmap     ; [unite]

" Verbose
map <Nul> <C-Space>
map! <Nul> <C-Space>

" Map unused Vim commands to custom terminal bindings
map <F13> <S-Return>
map <F14> <C-Return>
map! <F13> <S-Return>
map! <F14> <C-Return>

if get(g:, 'elite_mode')
	" Arrows resize splits
	nnoremap <Up>    :resize +2<CR>
	nnoremap <Down>  :resize -2<CR>
	nnoremap <Left>  :vertical resize +2<CR>
	nnoremap <Right> :vertical resize -2<CR>
endif

" Enable yanking straight to OS clipboard, but not cut.
"if ( ! has('nvim') || $DISPLAY !=? '') && has('clipboard')
"	xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
"endif
"nnoremap x "_x

" Double leader key for toggling visual-line mode
nmap <Leader><Leader> V
vmap <Leader><Leader> <Esc>

" Toggle fold
nnoremap <CR> za
" Focus the current fold by closing all others
nnoremap <S-Return> zMza

" Use backspace key for matchit.vim
nmap <BS> %
xmap <BS> %

"}}}
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

" Start an external command with a single bang
nnoremap ! :!

" Allow misspellings when :wq
cabbrev Wq :wq
cabbrev qw :wq
cabbrev Qa :qa

" Start new line
inoremap <S-Return> <C-o>o

" Quick substitute within selected area
xnoremap s :s//g<Left><Left>

" Improve scroll, credits: https://github.com/Shougo
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
	\ 'zt' : (winline() == 1) ? 'zb' : 'zz'
noremap <expr> <C-f> max([winheight(0) - 2, 1])
	\ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
	\ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

" Navigate window
nnoremap <C-q> <C-w>
nnoremap <C-x> <C-w>x
nnoremap <C-w>z :ZoomToggle<CR>

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

" Disable EX-mode
nnoremap  Q <Nop>
nnoremap gQ <Nop>

" Navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" }}}
" File operations {{{
" ---------------

" When pressing <leader>cd switch to the directory of the open buffer
map <Leader>cd :cd %:p:h<CR>:pwd<CR>

" Fast saving
nnoremap <Leader>w :w<CR>
vnoremap <Leader>w <Esc>:w<CR>
nnoremap <C-s> :<C-u>w<CR>
vnoremap <C-s> :<C-u>w<CR>
cnoremap <C-s> <C-u>w<CR>

" Save a file with sudo
" http://forrst.com/posts/Use_w_to_sudo_write_a_file_with_Vim-uAN
cmap W!! w !sudo tee % >/dev/null

" }}}
" Editor UI {{{
" ---------

" Toggle paste mode
set pastetoggle=<F2>

" Show highlight names under cursor
map <F3> :echo 'hi<'.synIDattr(synID(line('.'), col('.'), 1), 'name')
	\.'> trans<'.synIDattr(synID(line('.'), col('.'), 0), 'name').'> lo<'
	\.synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name').'>'<CR>

" Toggle editor visuals
nmap <Leader>ts :setlocal spell!<cr>
nmap <Leader>tn :setlocal nonumber! norelativenumber!<CR>
nmap <Leader>tl :setlocal nolist!<CR>
nmap <Leader>th :nohlsearch<CR>
nmap <Leader>tw :setlocal wrap! breakindent!<CR>

" Tabs
nnoremap <silent> g0 :<C-u>tabfirst<CR>
nnoremap <silent> g$ :<C-u>tablast<CR>
nnoremap <silent> gr :<C-u>tabprevious<CR>

" }}}
" Totally Custom {{{
" --------------

" Remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" Diff
nnoremap <silent> <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"

" C-r: Easier search and replace
xnoremap <C-r> :<C-u>call VSetSearch('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>

" Location list movement
nmap <Leader>j :lnext<CR>
nmap <Leader>k :lprev<CR>

" Duplicate lines
nnoremap <Leader>d m`YP``
vnoremap <Leader>d YPgv

" Quick manual search and replace
nnoremap ± *``gn<C-g>
inoremap ± <C-o>gn<C-g>
snoremap <expr> . @.

" Source line and selection in vim
vnoremap <Leader>S y:execute @@<CR>:echo 'Sourced selection.'<CR>
nnoremap <Leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>

" Append modeline to EOF
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Yank buffer's absolute path to X11 clipboard
nnoremap <C-c> :let @+=expand("%:p")<CR>:echo 'Copied to clipboard.'<CR>

" Drag current line/s vertically and auto-indent
noremap  <Leader>mk :m-2<CR>==
noremap  <Leader>mj :m+<CR>==
vnoremap <Leader>mk :m-2<CR>gv=gv
vnoremap <Leader>mj :m'>+<CR>gv=gv

nnoremap <Leader>se :<C-u>SessionSave last<CR>
nnoremap <Leader>os :<C-u>execute 'source '.g:session_directory.'/last.vim'<CR>

augroup MyAutoCmd " {{{

	if has('mac')
		" Use Marked for real-time Markdown preview
		autocmd FileType markdown
			\ nnoremap <Leader>P :silent !open -a Marked\ 2.app '%:p'<CR>:redraw!<CR>
		" Use Dash on Mac, for context help
		autocmd FileType ansible,go,php,css,less,html,markdown
			\ nnoremap <silent><buffer> K :!open -g dash://"<C-R>=&ft<CR>:<cword>"&<CR><CR>
		autocmd FileType javascript,sql,ruby,conf,sh
			\ nnoremap <silent><buffer> K :!open -g dash://"<cword>"&<CR><CR>
	else
		" Use Zeal on Linux for context help
		autocmd FileType ansible,go,php,css,less,html,markdown
			\ nnoremap <silent><buffer> K :!zeal --query "<C-R>=&ft<CR>:<cword>"&<CR><CR>
		autocmd FileType javascript,sql,ruby,conf,sh
			\ nnoremap <silent><buffer> K :!zeal --query "<cword>"&<CR><CR>
	endif

augroup END
" }}}

" s: Windows and buffers {{{
" Credits: https://github.com/Shougo/shougo-s-github

nnoremap <silent> <Tab>      :wincmd w<CR>
nnoremap <silent> [Window]p  :<C-u>vsplit<CR>:wincmd w<CR>
nnoremap <silent> [Window]v  :<C-u>split<CR>
nnoremap <silent> [Window]g  :<C-u>vsplit<CR>
nnoremap <silent> [Window]t  :tabnew<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>
nnoremap <silent> [Window]x  :<C-u>call <SID>BufferEmpty()<CR>
nnoremap <silent> [Window]\  :b#<CR>
nnoremap <silent> [Window]q  :close<CR>
nnoremap <silent><expr> q winnr('$') != 1 ? ':<C-u>close<CR>' : ""

" Split current buffer, go to previous window and previous buffer
nnoremap <Leader>sv :split<CR>:wincmd p<CR>:e#<CR>
nnoremap <Leader>sg :vsplit<CR>:wincmd p<CR>:e#<CR>

function! s:BufferEmpty() "{{{
	let l:current = bufnr('%')
	if ! getbufvar(l:current, '&modified')
		enew
		silent! execute 'bdelete '.l:current
	endif
endfunction "}}}
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
