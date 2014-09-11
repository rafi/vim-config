
" Key Bindings {{{1
"------------------------------------------------------------------------------

" Non-standard {{{2
" ------------

" Want a different map leader than \
let mapleader="\<Space>"
let maplocalleader="\<Space>"

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

if has('gui_running')
	" gvim - toggle display of a GUI widgets (menu/toolbar/scrollbar)
	nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
	nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
	nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>
endif

" Totally Custom {{{2
" --------------

" Make * and # work on visual mode too
xnoremap * :<C-u>call VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

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

"}}}
