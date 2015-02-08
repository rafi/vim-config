
" Key Bindings
"------------------------------------------------------------------------------

" Non-standard {{{
" ------------

" Want a different map leader than \
let mapleader="\<Space>"
let maplocalleader="\<Space>"

" Maps the semicolon to colon in normal mode
nmap ; :

if exists('g:elite_mode') && g:elite_mode
	" Make arrow keys useful
	nnoremap <Up>    :resize +4<CR>
	nnoremap <Down>  :resize -4<CR>
	nnoremap <Left>  :vertical resize +4<CR>
	nnoremap <Right> :vertical resize -4<CR>
endif

" Use backspace key for matchit.vim
nmap <BS> %
xmap <BS> %

" }}}
" Global niceties {{{
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
nnoremap ` '
nnoremap Q gq
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

" }}}
" File operations {{{
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

" }}}
" Editor UI {{{
" ---------

" Toggle paste mode, useful to temporarily disable autoindent
set pastetoggle=<F2>

" Show highlight names under cursor
map <F3> :echo 'hi<'.synIDattr(synID(line('.'), col('.'), 1), 'name')
	\.'> trans<'.synIDattr(synID(line('.'), col('.'), 0), 'name').'> lo<'
	\.synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name').'>'<CR>

" Show hidden characters (spaces, tabs, etc)
" Line number type toggle
" Clear the highlighting of :set hlsearch
" Toggle spell checking
nmap <Leader>ts :setlocal spell!<cr>
nmap <Leader>tn :setlocal nonumber!<CR>
nmap <Leader>tl :setlocal nolist!<CR>
nmap <Leader>th :nohlsearch<CR>

" Tabs
noremap <Leader>st  :tabnew<CR>
noremap <C-x>     :tabclose<CR>
noremap <C-Tab>   :tabn<CR>
noremap <C-S-Tab> :tabp<CR>

" Splits
" I imagine v as an arrow, split below
nnoremap <Leader>sv :new<CR>
nnoremap <Leader>sg :vnew<CR>

" Buffers
map <S-Right> :bnext<CR>
map <S-Left>  :bprev<CR>

" Several ways of close buffer
nnoremap <silent> <Leader>q :close<CR>
nnoremap <silent> <Leader>x :bdelete<CR>
nnoremap <silent> <Leader>z :BufClose<CR>

if has('quickfix')
	" Split current buffer, go to previous window and previous buffer
"	nnoremap <leader>v :split<CR>:wincmd p<CR>:e#<CR>
"	nnoremap <leader>g :vsplit<CR>:wincmd p<CR>:e#<CR>
endif

" }}}
" Totally Custom {{{
" --------------

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

	" Use Zeal on Linux, and Dash on Mac, for context help
	if has('mac')
		autocmd FileType ansible,go,python,php,css,less,html,markdown
			\ nnoremap <silent><buffer> K :!open -g dash://"<C-R>=&ft<CR>:<cword>"&<CR><CR>
	else
		autocmd FileType ansible,go,python,php,css,less,html,markdown
			\ nnoremap <silent><buffer> K :!zeal --query "<C-R>=&ft<CR>:<cword>"&<CR><CR>
	endif

	if has('mac')
		autocmd FileType javascript,sql,ruby,conf,sh
			\ nnoremap <silent><buffer> K :!open -g dash://"<cword>"&<CR><CR>
	else
		autocmd FileType javascript,sql,ruby,conf,sh
			\ nnoremap <silent><buffer> K :!zeal --query "<cword>"&<CR><CR>
	endif

augroup END
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
