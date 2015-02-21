
" Key Bindings
"---------------------------------------------------------

" Non-standard {{{
" ------------

" Want a different map leader than \
let mapleader="\<Space>"
let maplocalleader="\\"

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

" Remap some keys to be more useful
nnoremap ' `
nnoremap ` '
nnoremap Y y$
nnoremap <CR> za

" Improve cursor up/down
nnoremap <expr> j v:count ? 'j' : 'gj'
vnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
vnoremap <expr> k v:count ? 'k' : 'gk'

" improve scroll
noremap <expr> <C-f> max([winheight(0) - 2, 1]) . "\<C-d>" . (line("w$") >= line('$') ? "L" : "H")
noremap <expr> <C-b> max([winheight(0) - 2, 1]) . "\<C-u>" . (line("w0") <= 1         ? "H" : "L")
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

" Navigate window
nnoremap <C-x> <C-w>x
nnoremap <expr><C-m> (bufname('%') ==# '[Command Line]' <bar><bar> &l:buftype ==# 'quickfix') ? "<CR>" : "<C-w>j"
nnoremap <C-q> <C-w>

" Increment and decrement
nnoremap + <C-a>
nnoremap - <C-x>

" Go to the first non-blank character of the line after paragraph motions
noremap } }^

" Select blocks after indenting
xnoremap < <gv
xnoremap > >gv|

" Use tab for indenting in normal/visual modes
nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
vnoremap <Tab> >gv|
vnoremap <S-Tab> <gv

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" disable EX-mode
nnoremap  Q <Nop>
nnoremap gQ <Nop>

" Go to the starting position after visual modes
vnoremap <ESC> o<ESC>

" Operator [
onoremap [ <ESC>

" Navigation in command line
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" <C-g> in command line
cmap <C-g> <ESC><C-g>

" Escape from Select mode to Normal mode
snoremap <ESC> <C-c>

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

" Show hidden characters (spaces, tabs, etc)
" Line number type toggle
" Clear the highlighting of :set hlsearch
" Toggle spell checking
nmap <Leader>ts :setlocal spell!<cr>
nmap <Leader>tn :setlocal nonumber!<CR>
nmap <Leader>tl :setlocal nolist!<CR>
nmap <Leader>th :set hlsearch!<CR>

" Tabs
noremap <Leader>st  :tabnew<CR>
nnoremap <silent> <C-t> :<C-u>tabnew<CR>
inoremap <silent> <C-t> <ESC>:<C-u>tabnew<CR>
nnoremap <silent> g0 :<C-u>tabfirst<CR>
nnoremap <silent> g$ :<C-u>tablast<CR>
noremap <C-Tab>   :tabn<CR>
noremap <C-S-Tab> :tabp<CR>

" tag
nnoremap <C-@> <C-t>

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

" Split current buffer, go to previous window and previous buffer
"	nnoremap <leader>v :split<CR>:wincmd p<CR>:e#<CR>
"	nnoremap <leader>g :vsplit<CR>:wincmd p<CR>:e#<CR>

" }}}
" Totally Custom {{{
" --------------

" Remove spaces at the end of lines
nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" Diff
nnoremap <silent> <expr> ,d ":\<C-u>".(&diff?"diffoff":"diffthis")."\<CR>"

" Clear hlsearch and set nopaste
nnoremap <silent> <Esc><Esc> :<C-u>set nopaste<CR>:nohlsearch<CR>

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
