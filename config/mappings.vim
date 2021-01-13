" Key-mappings
" ===

" Elite-mode {{{
" ----------
if get(g:, 'elite_mode')

	" Disable arrow movement, resize splits instead.
	nnoremap <silent><Up>    :resize +1<CR>
	nnoremap <silent><Down>  :resize -1<CR>
	nnoremap <silent><Left>  :vertical resize +1<CR>
	nnoremap <silent><Right> :vertical resize -1<CR>

endif

" }}}
" Navigation {{{
" ----------

" Fix keybind name for Ctrl+Space
map <Nul> <C-Space>
map! <Nul> <C-Space>

" Double leader key for toggling visual-line mode
nmap <Leader><Leader> V
vmap <Leader><Leader> <Esc>

" Toggle fold
nnoremap <CR> za

" Focus the current fold by closing all others
nnoremap <S-Return> zMzvzt

" The plugin rhysd/accelerated-jk moves through display-lines in normal mode,
" these mappings will move through display-lines in visual mode too.
vnoremap j gj
vnoremap k gk

" Easier line-wise movement
nnoremap gh g^
nnoremap gl g$

" Location/quickfix list movement
nmap ]l :lnext<CR>
nmap [l :lprev<CR>
nmap ]q :cnext<CR>
nmap [q :cprev<CR>

" Whitespace jump (see plugin/whitespace.vim)
nnoremap ]w :<C-u>WhitespaceNext<CR>
nnoremap [w :<C-u>WhitespacePrev<CR>

" Navigation in command line
cnoremap <C-h> <Home>
cnoremap <C-l> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>

" }}}
" Scroll {{{
" ------

" Scroll step sideways
nnoremap zl z4l
nnoremap zh z4h

" Resize tab windows after top/bottom window movement
nnoremap <C-w>K <C-w>K<C-w>=
nnoremap <C-w>J <C-w>J<C-w>=

" Improve scroll, credits: https://github.com/Shougo
" noremap <expr> <C-f> max([winheight(0) - 2, 1])
"	\ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
" noremap <expr> <C-b> max([winheight(0) - 2, 1])
"	\ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
" nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
"	\ 'zt' : (winline() == 1) ? 'zb' : 'zz'
" noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
" noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")

" }}}
" Clipboard {{{
" ---------

" Yank from cursor position to end-of-line
nnoremap Y y$

" Yank buffer's relative/absolute path to clipboard
nnoremap <Leader>y :let @+=expand("%:~:.")<CR>:echo 'Yanked relative path'<CR>
nnoremap <Leader>Y :let @+=expand("%:p")<CR>:echo 'Yanked absolute path'<CR>

" Cut & paste without pushing to register
" xnoremap p  "0p
" nnoremap x "_x

" }}}
" Edit {{{
" ----

" Macros
nnoremap Q q
nnoremap gQ @q

" Start new line from any cursor position in insert-mode
inoremap <S-Return> <C-o>o

" Deletes selection and start insert mode
" vnoremap <BS> "_xi

" Re-select blocks after indenting in visual/select mode
xnoremap < <gv
xnoremap > >gv|

" Use tab for indenting in visual/select mode
xnoremap <Tab> >gv|
xnoremap <S-Tab> <gv

" Indent and jump to first non-blank character linewise
nmap >>  >>_
nmap <<  <<_

" Drag current line/s vertically and auto-indent
nnoremap <Leader>k :m-2<CR>==
nnoremap <Leader>j :m+<CR>==
vnoremap <Leader>k :m'<-2<CR>gv=gv
vnoremap <Leader>j :m'>+<CR>gv=gv

" Duplicate lines
nnoremap <Leader>d m`YP``
vnoremap <Leader>d YPgv

" Change current word in a repeatable manner
nnoremap <Leader>cn *``cgn
nnoremap <Leader>cN *``cgN

" Change selected word in a repeatable manner
vnoremap <expr> <Leader>cn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
vnoremap <expr> <Leader>cN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"

" Duplicate paragraph
nnoremap <Leader>cp yap<S-}>p

" Remove spaces at the end of lines
nnoremap <Leader>cw :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

" }}}
" Search & Replace {{{
" ----------------

" Use backspace key for matching parens
nmap <BS> %
xmap <BS> %

" Repeat latest f, t, F or T
nnoremap \ ;

" Select last paste
nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'

" Quick substitute within selected area
xnoremap sg :s//gc<Left><Left><Left>

" C-r: Easier search and replace visual/select mode
xnoremap <C-r> :<C-u>call <SID>get_selection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>

" Returns visually selected text
function! s:get_selection(cmdtype) "{{{
	let temp = @s
	normal! gv"sy
	let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
	let @s = temp
endfunction "}}}

" }}}
" Command & History {{{
" -----------------

" Start an external command with a single bang
nnoremap ! :!

" Put vim command output into buffer
nnoremap g! :<C-u>put=execute('')<Left><Left>

" Allow misspellings
cnoreabbrev qw wq
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev Qa qa
cnoreabbrev Bd bd
cnoreabbrev bD bd

" Switch history search pairs, matching my bash shell
cnoremap <expr> <C-p>  pumvisible() ? "\<C-p>" : "\<Up>"
cnoremap <expr> <C-n>  pumvisible() ? "\<C-n>" : "\<Down>"
cnoremap <Up>   <C-p>
cnoremap <Down> <C-n>

" }}}
" File operations {{{
" ---------------

" Switch (window) to the directory of the current opened buffer
map <Leader>cd :lcd %:p:h<CR>:pwd<CR>

" Open file under the cursor in a vsplit
nnoremap gf :vertical wincmd f<CR>

" Fast saving from all modes
nnoremap <Leader>w :write<CR>
xnoremap <Leader>w <Esc>:write<CR>
nnoremap <C-s> :<C-u>write<CR>
xnoremap <C-s> :<C-u>write<CR>
cnoremap <C-s> <C-u>write<CR>

" }}}
" Editor UI {{{
" ---------

" Toggle editor's visual effects
nmap <Leader>ts :setlocal spell!<cr>
nmap <Leader>tn :setlocal nonumber!<CR>
nmap <Leader>tl :setlocal nolist!<CR>
nmap <Leader>th :nohlsearch<CR>

" Smart wrap toggle (breakindent and colorcolumn toggle as-well)
nmap <Leader>tw :execute('setlocal wrap! breakindent! colorcolumn=' .
	\ (&colorcolumn == '' ? &textwidth : ''))<CR>

" Tabs
nnoremap <silent> g1 :<C-u>tabfirst<CR>
nnoremap <silent> g5 :<C-u>tabprevious<CR>
nnoremap <silent> g9 :<C-u>tablast<CR>
nnoremap <silent> <C-Tab> :<C-U>tabnext<CR>
nnoremap <silent> <C-S-Tab> :<C-U>tabprevious<CR>
nnoremap <silent> <A-j> :<C-U>tabnext<CR>
nnoremap <silent> <A-k> :<C-U>tabprevious<CR>
nnoremap <silent> <A-{> :<C-u>-tabmove<CR>
nnoremap <silent> <A-}> :<C-u>+tabmove<CR>
" nnoremap <silent> <A-[> :<C-u>tabprevious<CR>
" nnoremap <silent> <A-]> :<C-u>tabnext<CR>

" Show vim syntax highlight groups for character under cursor
nmap <silent> <Leader>h
	\ :echo 'hi<'.synIDattr(synID(line('.'), col('.'), 1), 'name')
	\ . '> trans<'.synIDattr(synID(line('.'), col('.'), 0), 'name') . '> lo<'
	\ . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') . '>'<CR>

" }}}
" Custom Tools {{{
" ------------

" Terminal
if exists(':tnoremap')
	if has('nvim')
		tnoremap   jj         <C-\><C-n>
	else
		tnoremap   <ESC><ESC>  <C-w>N
		tnoremap   jj          <C-w>N
	endif
endif

" Source line and selection in vim
vnoremap <Leader>S y:execute @@<CR>:echo 'Sourced selection.'<CR>
nnoremap <Leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>

" Context-aware action-menu, neovim only (see plugin/actionmenu.vim)
if has('nvim')
	nmap <silent> <LocalLeader>c :<C-u>ActionMenu<CR>
endif

" Session management shortcuts (see plugin/sessions.vim)
nmap <Leader>se :<C-u>SessionSave<CR>
nmap <Leader>sl :<C-u>SessionLoad<CR>

" Jump entire buffers in jumplist
nnoremap g<C-i> :<C-u>call JumpBuffer(-1)<CR>
nnoremap g<C-o> :<C-u>call JumpBuffer(1)<CR>

if has('mac')
	" Open the macOS dictionary on current word
	nmap <Leader>? :!open dict://<cword><CR>

	" Use Marked for real-time Markdown preview
	"
	if executable('/Applications/Marked 2.app/Contents/MacOS/Marked 2')
		autocmd user_events FileType markdown
			\ nmap <buffer><Leader>P :silent !open -a Marked\ 2.app '%:p'<CR>
	endif
endif

nnoremap <silent> <Leader>ml :call <SID>append_modeline()<CR>

" Append modeline after last line in buffer
" See: http://vim.wikia.com/wiki/Modeline_magic
function! s:append_modeline() "{{{
	let l:modeline = printf(' vim: set ts=%d sw=%d tw=%d %set :',
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, '%s', l:modeline, '')
	call append(line('$'), l:modeline)
endfunction "}}}

" }}}
" Windows, buffers and tabs {{{
" -------------------------

" Ultimatus Quitos
autocmd user_events BufWinEnter,BufNew,BufNewFile *
	\ if &buftype == '' && ! mapcheck('q', 'n')
	\ |   nnoremap <silent><buffer> q :<C-u>quit<CR>
	\ | endif

nnoremap <C-q> <C-w>
nnoremap <C-x> <C-w>x

" Window-control prefix
nnoremap  [Window]   <Nop>
nmap      s [Window]

nnoremap <silent> [Window]v  :<C-u>split<CR>
nnoremap <silent> [Window]g  :<C-u>vsplit<CR>
nnoremap <silent> [Window]t  :tabnew<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>
nnoremap <silent> [Window]b  :b#<CR>
nnoremap <silent> [Window]c  :close<CR>
nnoremap <silent> [Window]x  :<C-u>call <SID>window_empty_buffer()<CR>
nnoremap <silent> [Window]z  :<C-u>call <SID>zoom()<CR>

" Split current buffer, go to previous window and previous buffer
nnoremap <silent> [Window]sv :split<CR>:wincmd p<CR>:e#<CR>
nnoremap <silent> [Window]sg :vsplit<CR>:wincmd p<CR>:e#<CR>

" Background dark/light toggle and contrasts
nmap <silent> [Window]h :<C-u>call <SID>toggle_background()<CR>
nmap <silent> [Window]- :<c-u>call <SID>toggle_contrast(-v:count1)<cr>
nmap <silent> [Window]= :<c-u>call <SID>toggle_contrast(+v:count1)<cr>

function! s:toggle_background()
	if ! exists('g:colors_name')
		echomsg 'No colorscheme set'
		return
	endif
	let l:scheme = g:colors_name

	if l:scheme =~# 'dark' || l:scheme =~# 'light'
		" Rotate between different theme backgrounds
		execute 'colorscheme' (l:scheme =~# 'dark'
					\ ? substitute(l:scheme, 'dark', 'light', '')
					\ : substitute(l:scheme, 'light', 'dark', ''))
	else
		execute 'set background='.(&background ==# 'dark' ? 'light' : 'dark')
		if ! exists('g:colors_name')
			execute 'colorscheme' l:scheme
			echomsg 'The colorscheme `'.l:scheme
				\ .'` doesn''t have background variants!'
		else
			echo 'Set colorscheme to '.&background.' mode'
		endif
	endif
endfunction

function! s:toggle_contrast(delta)
	let l:scheme = ''
	if g:colors_name =~# 'solarized8'
		let l:schemes = map(['_low', '_flat', '', '_high'],
			\ '"solarized8_".(&background).v:val')
		let l:contrast = ((a:delta + index(l:schemes, g:colors_name)) % 4 + 4) % 4
		let l:scheme = l:schemes[l:contrast]
	endif
	if l:scheme !=# ''
		execute 'colorscheme' l:scheme
	endif
endfunction

function! s:window_empty_buffer()
	let l:current = bufnr('%')
	if ! getbufvar(l:current, '&modified')
		enew
		silent! execute 'bdelete '.l:current
	endif
endfunction

" Simple zoom toggle
function! s:zoom()
	if exists('t:zoomed')
		unlet t:zoomed
		wincmd =
	else
		let t:zoomed = { 'nr': bufnr('%') }
		vertical resize
		resize
		normal! ze
	endif
endfunction
" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
