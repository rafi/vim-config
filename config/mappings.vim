" Key-mappings
" ===
" Settings:
" - g:disable_mappings - Set true to disable this file entirely.
" - g:enable_universal_quit_mapping - Toggle 'q' for :quit mapping.
" - g:elite_mode - Enable to map arrow keys to window resize.

if get(g:, 'disable_mappings')
	finish
endif

" Elite-mode {{{
" ----------
if get(g:, 'elite_mode')

	" Disable arrow movement, resize windows instead.
	nnoremap <Up>    <cmd>resize +1<CR>
	nnoremap <Down>  <cmd>resize -1<CR>
	nnoremap <Left>  <cmd>vertical resize +1<CR>
	nnoremap <Right> <cmd>vertical resize -1<CR>

endif

" }}}
" Navigation {{{
" ----------

" Double leader key for toggling visual-line mode
nmap <Leader><Leader> V
xmap <Leader><Leader> <Esc>

" Toggle fold or select option from popup menu
nnoremap <expr><CR> pumvisible() ? '<CR>' : 'za'

" Focus the current fold by closing all others
nnoremap <S-Return> zMzv

" Moves through display-lines, unless count is provided.
nnoremap <expr> j v:count > 0 ? "m'" . v:count . 'j' : 'gj'
nnoremap <expr> k v:count > 0 ? "m'" . v:count . 'k' : 'gk'
xnoremap <expr> j v:count > 0 ? "m'" . v:count . 'j' : 'gj'
xnoremap <expr> k v:count > 0 ? "m'" . v:count . 'k' : 'gk'

" Easier line-wise movement
nnoremap gh g^
nnoremap gl g$

" Location/quickfix list movement
nmap ]q <cmd>cnext<CR>
nmap [q <cmd>cprev<CR>
nmap ]a <cmd>lnext<CR>
nmap [a <cmd>lprev<CR>

" Whitespace jump (see plugin/whitespace.vim)
nnoremap ]w <cmd>WhitespaceNext<CR>
nnoremap [w <cmd>WhitespacePrev<CR>

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
" nnoremap <C-w>K <C-w>K<C-w>=
" nnoremap <C-w>J <C-w>J<C-w>=

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

" Paste in visual-mode without pushing to register
xnoremap p :call <SID>visual_paste('p')<CR>
xnoremap P :call <SID>visual_paste('P')<CR>

" }}}
" Edit {{{
" ----

" Macros
if get(g:, 'enable_universal_quit_mapping', 1)
	nnoremap Q q
	nnoremap gQ @q
endif

" Start new line from any cursor position in insert-mode
inoremap <S-Return> <C-o>o

" Deletes selection and start insert mode
" xnoremap <BS> "_xi

" Re-select blocks after indenting in visual/select mode
xnoremap < <gv
xnoremap > >gv|

" Use tab for indenting in visual/select mode
xnoremap <Tab> >gv|
xnoremap <S-Tab> <gv

" Indent and jump to first non-blank character linewise
" nmap >>  >>_
" nmap <<  <<_

" Drag current line/s vertically and auto-indent
nnoremap <Leader>k <cmd>move-2<CR>==
nnoremap <Leader>j <cmd>move+<CR>==
xnoremap <Leader>k :move'<-2<CR>gv=gv
xnoremap <Leader>j :move'>+<CR>gv=gv

" Duplicate lines without affecting PRIMARY and CLIPBOARD selections.
nnoremap <Leader>d m`""Y""P``
xnoremap <Leader>d ""Y""Pgv

" Change current word in a repeatable manner
nnoremap <Leader>cn *``cgn
nnoremap <Leader>cN *``cgN

" Change selected word in a repeatable manner
xnoremap <expr> <Leader>cn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
xnoremap <expr> <Leader>cN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"

" Duplicate paragraph
nnoremap <Leader>cp yap<S-}>p

" Remove spaces at the end of lines
nnoremap <Leader>cw <cmd>keeppatterns %substitute/\s\+$//e<CR>

" }}}
" Search & Replace {{{
" ----------------

" Use backspace key for matching parens
nnoremap <BS> %
xnoremap <BS> %

" Repeat latest f, t, F or T
nnoremap \ ;

" Select last paste
nnoremap <expr> gpp '`['.strpart(getregtype(), 0, 1).'`]'

" Quick substitute within selected area
xnoremap sg :s//gc<Left><Left><Left>

" C-r: Easier search and replace visual/select mode
xnoremap <C-r> :<C-u>%s/\V<C-R>=<SID>get_selection()<CR>//gc<Left><Left><Left>

" }}}
" Command & History {{{
" -----------------

" Start an external command with a single bang
nnoremap ! :!

" Put vim command output into buffer
nnoremap g! :put=execute('')<Left><Left>

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
nmap <Leader>cd :lcd %:p:h<CR>:pwd<CR>

" Open file under the cursor in a vsplit
nnoremap gf <cmd>vertical wincmd f<CR>

" Fast saving from all modes
nnoremap <Leader>w <cmd>write<CR>
nnoremap <C-s> <cmd>write<CR>
xnoremap <C-s> <cmd>write<CR>
cnoremap <C-s> <cmd>write<CR>

" }}}
" Editor UI {{{
" ---------

" Toggle editor's visual effects
nmap <Leader>ts <cmd>setlocal spell!<CR>
nmap <Leader>tn <cmd>setlocal nonumber!<CR>
nmap <Leader>tl <cmd>setlocal nolist!<CR>
nmap <Leader>th <cmd>nohlsearch<CR>

" Smart wrap toggle (breakindent and colorcolumn toggle as-well)
nmap <Leader>tw <cmd>execute('setlocal wrap! breakindent! colorcolumn=' .
	\ (&colorcolumn == '' ? &textwidth : ''))<CR>

" Tabs: Many ways to navigate them
nnoremap g1 <cmd>tabfirst<CR>
nnoremap g5 <cmd>tabprevious<CR>
nnoremap g9 <cmd>tablast<CR>

nnoremap <A-j>     <cmd>tabnext<CR>
nnoremap <A-k>     <cmd>tabprevious<CR>
nnoremap <A-[>     <cmd>tabprevious<CR>
nnoremap <A-]>     <cmd>tabnext<CR>
nnoremap <C-Tab>   <cmd>tabnext<CR>
nnoremap <C-S-Tab> <cmd>tabprevious<CR>
nnoremap <C-S-j>   <cmd>tabnext<CR>
nnoremap <C-S-k>   <cmd>tabprevious<CR>

" Moving tabs
nnoremap <A-{> <cmd>-tabmove<CR>
nnoremap <A-}> <cmd>+tabmove<CR>

" Show syntax highlight groups for character under cursor
nmap <Leader>tt <cmd>echo
	\ 'hi<' . synIDattr(synID(line('.'), col('.'), 1), 'name')
	\ . '> trans<' . synIDattr(synID(line('.'), col('.'), 0), 'name') . '> lo<'
	\ . synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') . '>'<CR>

" }}}
" Custom Tools {{{
" ------------

" Terminal mappings
if exists(':tnoremap')
	if has('nvim')
		tnoremap jj <C-\><C-n>
	else
		tnoremap <Esc><Esc>  <C-w>N
		tnoremap jj          <C-w>N
	endif
endif

" Append mode-line to current buffer
nnoremap <Leader>ml <cmd>call <SID>append_modeline()<CR>

" Source line and selection in vim
xnoremap <Leader>S y:execute @@<CR>:echo 'Sourced selection.'<CR>
nnoremap <Leader>S ^vg_y:execute @@<CR>:echo 'Sourced line.'<CR>

" Jump entire buffers in jumplist
nnoremap g<C-i> <cmd>call <SID>jump_buffer(-1)<CR>
nnoremap g<C-o> <cmd>call <SID>jump_buffer(1)<CR>

" Context aware menu. See lua/contextmenu.lua
nnoremap <LocalLeader>c  <cmd>lua require'contextmenu'.show()<CR>

if has('mac')
	" Open the macOS dictionary on current word
	nnoremap <Leader>? <cmd>silent !open dict://<cword><CR>

	" Use Marked for real-time Markdown preview
	" See: https://marked2app.com/
	if executable('/Applications/Marked 2.app/Contents/MacOS/Marked 2')
		autocmd user_events FileType markdown
			\ nnoremap <buffer><Leader>P <cmd>silent !open -a Marked\ 2.app '%:p'<CR>
	endif
endif

" }}}
" Windows, buffers and tabs {{{
" -------------------------

" Ultimatus Quitos
if get(g:, 'enable_universal_quit_mapping', 1)
	autocmd user_events BufWinEnter,VimEnter *
		\  if ! maparg('q', 'n')
		\|   nnoremap <buffer> q <cmd>quit<CR>
		\| endif

	if &diff && has('vim_starting')
		set cursorline
		nnoremap q <cmd>quit<CR>
	endif
endif

" Switch with adjacent window
nnoremap <C-x> <C-w>x

" Window-control prefix
nnoremap  [Window]   <Nop>
nmap      s [Window]

nnoremap [Window]b  <cmd>buffer#<CR>
nnoremap [Window]c  <cmd>close<CR>
nnoremap [Window]d  <cmd>bdelete<CR>
nnoremap [Window]v  <cmd>split<CR>
nnoremap [Window]g  <cmd>vsplit<CR>
nnoremap [Window]t  <cmd>tabnew<CR>
nnoremap [Window]o  <cmd>only<CR>
nnoremap [Window]q  <cmd>quit<CR>
nnoremap [Window]x  <cmd>call <SID>window_empty_buffer()<CR>
nnoremap [Window]z  <cmd>call <SID>zoom()<CR>

" Split current buffer, go to previous window and previous buffer
nnoremap [Window]sv <cmd>split<CR>:wincmd p<CR>:e#<CR>
nnoremap [Window]sg <cmd>vsplit<CR>:wincmd p<CR>:e#<CR>

" Background dark/light toggle
nmap [Window]h <cmd>call <SID>toggle_background()<CR>

" }}}
" Helper functions {{{
" -------------------------

function! s:visual_paste(direction) range abort "{{{
	try
		let registers = {}
		for name in ['"', '0']
			let registers[name] = {'type': getregtype(name), 'value': getreg(name)}
		endfor
		execute 'normal!' 'gv' . a:direction
	finally
		for [name, register] in items(registers)
			call setreg(name, register.value, register.type)
		endfor
	endtry
endfunction "}}}

" Returns visually selected text
function! s:get_selection() abort "{{{
	try
		let reg = 's'
		let [save_reg, save_type] = [getreg(reg), getregtype(reg)]
		silent! normal! gv"sy
		return substitute(escape(@s, '\/'), '\n', '\\n', 'g')
	finally
		call setreg(reg, save_reg, save_type)
	endtry
endfunction "}}}

function! s:visual_search(cmdtype) "{{{
	try
		let reg = 's'
		let [save_reg, save_type] = [getreg(reg), getregtype(reg)]
		silent! normal! gv"sy
		let @/ = '\V' . substitute(escape(@s, a:cmdtype . '\'), '\n', '\\n', 'g')
		call histadd('/', @/)
	finally
		call setreg(reg, save_reg, save_type)
	endtry
endfunction "}}}

" Append modeline after last line in buffer
" See: http://vim.wikia.com/wiki/Modeline_magic
function! s:append_modeline() "{{{
	let l:modeline = printf(' vim: set ts=%d sw=%d tw=%d %set :',
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, '%s', l:modeline, '')
	call append(line('$'), l:modeline)
endfunction "}}}

" direction - 1=forward, -1=backward
" Credits: https://superuser.com/a/1455940/252171
function! s:jump_buffer(direction)
	let [ jumplist, curjump ] = getjumplist()
	let jumpcmdstr = a:direction > 0 ? '<C-o>' : '<C-i>'
	let jumpcmdchr = a:direction > 0 ? "\<C-o>" : "\<C-i>"
	let searchrange = a:direction > 0
		\ ? range(curjump - 1, 0, -1)
		\ : range(curjump + 1, len(jumplist))

	for i in searchrange
		let l:nr = jumplist[i]['bufnr']
		if l:nr != bufnr('%') && bufname(l:nr) !~? '^\a\+://'
			let n = abs((i - curjump) * a:direction)
			echo 'Executing' jumpcmdstr n . ' times'
			execute 'normal! ' . n . jumpcmdchr
			break
		endif
	endfor
endfunction

function! s:toggle_background() "{{{
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
endfunction "}}}

function! s:window_empty_buffer() "{{{
	let l:current = bufnr('%')
	if ! getbufvar(l:current, '&modified')
		enew
		silent! execute 'bdelete ' . l:current
	endif
endfunction "}}}

" Simple zoom toggle
function! s:zoom() "{{{
	if exists('t:zoomed')
		unlet t:zoomed
		wincmd =
	else
		let t:zoomed = { 'nr': bufnr('%') }
		vertical resize
		resize
		normal! ze
	endif
endfunction "}}}

" }}}
" Plugin Keyboard-Mappings {{{
" ---

if dein#tap('telescope.nvim')
	" General pickers
	nnoremap <localleader>r <cmd>Telescope resume initial_mode=normal<CR>
	nnoremap <localleader>R <cmd>Telescope pickers<CR>
	nnoremap <localleader>f <cmd>Telescope find_files<CR>
	nnoremap <localleader>g <cmd>Telescope live_grep<CR>
	nnoremap <localleader>b <cmd>Telescope buffers<CR>
	nnoremap <localleader>h <cmd>Telescope highlights<CR>
	nnoremap <localleader>j <cmd>Telescope jumplist<CR>
	nnoremap <localleader>m <cmd>Telescope marks<CR>
	nnoremap <localleader>o <cmd>Telescope vim_options<CR>
	nnoremap <localleader>t <cmd>Telescope lsp_dynamic_workspace_symbols<CR>
	nnoremap <localleader>v <cmd>Telescope registers<CR>
	nnoremap <localleader>u <cmd>Telescope spell_suggest<CR>
	nnoremap <localleader>s <cmd>Telescope session-lens search_session<CR>
	nnoremap <localleader>x <cmd>Telescope oldfiles<CR>
	nnoremap <localleader>z <cmd>lua require('plugins.telescope').pickers.zoxide()<CR>
	nnoremap <localleader>; <cmd>Telescope command_history<CR>
	nnoremap <localleader>/ <cmd>Telescope search_history<CR>

	" Git
	nnoremap <leader>gs <cmd>Telescope git_status<CR>
	nnoremap <leader>gr <cmd>Telescope git_branches<CR>
	nnoremap <leader>gc <cmd>Telescope git_commits<CR>
	nnoremap <leader>gC <cmd>Telescope git_bcommits<CR>
	nnoremap <leader>gh <cmd>Telescope git_stash<CR>

	" Location-specific find files/directories
	nnoremap <localleader>n <cmd>lua require('plugins.telescope').pickers.plugin_directories()<CR>
	nnoremap <localleader>w <cmd>ZkNotes<CR>

	" Navigation
	nnoremap <leader>/ <cmd>Telescope current_buffer_fuzzy_find<CR>
	nnoremap <leader>gt <cmd>lua require('plugins.telescope').pickers.lsp_workspace_symbols_cursor()<CR>
	nnoremap <leader>gf <cmd>lua require('plugins.telescope').pickers.find_files_cursor()<CR>
	nnoremap <leader>gg <cmd>lua require('plugins.telescope').pickers.grep_string_cursor()<CR>
	xnoremap <leader>gg <cmd>lua require('plugins.telescope').pickers.grep_string_visual()<CR>

	" LSP related
	nnoremap <localleader>dd <cmd>Telescope lsp_definitions<CR>
	nnoremap <localleader>di <cmd>Telescope lsp_implementations<CR>
	nnoremap <localleader>dr <cmd>Telescope lsp_references<CR>
	nnoremap <localleader>da <cmd>Telescope lsp_code_actions<CR>
	xnoremap <localleader>da :Telescope lsp_range_code_actions<CR>
endif

if dein#tap('neo-tree.nvim')
	nnoremap <LocalLeader>e <cmd>Neotree filesystem left toggle dir=./<CR>
	nnoremap <LocalLeader>a <cmd>Neotree filesystem left reveal<CR>
endif

if dein#tap('kommentary')
	nnoremap <Leader>v <Plug>kommentary_line_default
	xnoremap <Leader>v <Plug>kommentary_visual_default<C-c>
	xnoremap <Leader>V <Plug>kommentary_visual_increase<C-c>
endif

if dein#tap('symbols-outline.nvim')
	nnoremap <Leader>o <cmd>SymbolsOutline<CR>
endif

if dein#tap('vim-vsnip')
	imap <expr><C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
	smap <expr><C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
endif

if dein#tap('nvim-gps')
	nnoremap <Leader>f <cmd>lua print(require'nvim-gps'.get_location())<CR>
endif

if dein#tap('emmet-vim')
	autocmd user_events FileType html,css,vue,javascript,javascriptreact,svelte
		\ EmmetInstall
		\ | imap <silent><buffer> <C-y> <Plug>(emmet-expand-abbr)
endif

if dein#tap('vim-sandwich')
	nmap ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
	nmap dss <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
	nmap cs <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
	nmap css <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

	nmap <silent> sa <Plug>(operator-sandwich-add)
	xmap <silent> sa <Plug>(operator-sandwich-add)
	omap <silent> sa <Plug>(operator-sandwich-add)
	" omap <silent> sa <Plug>(operator-sandwich-g@)

	nmap <silent> sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
	" nmap <unique> sd <Plug>(sandwich-delete)
	xmap <silent> sd <Plug>(operator-sandwich-delete)
	nmap <silent> sdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

	nmap <silent> sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
	xmap <silent> sr <Plug>(operator-sandwich-replace)
	nmap <silent> srb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

	omap ir <Plug>(textobj-sandwich-auto-i)
	xmap ir <Plug>(textobj-sandwich-auto-i)
	omap ab <Plug>(textobj-sandwich-auto-a)
	xmap ab <Plug>(textobj-sandwich-auto-a)
	" omap is <Plug>(textobj-sandwich-query-i)
	" xmap is <Plug>(textobj-sandwich-query-i)
	" omap as <Plug>(textobj-sandwich-query-a)
	" xmap as <Plug>(textobj-sandwich-query-a)
endif

if dein#tap('vim-niceblock')
	silent! xmap I  <Plug>(niceblock-I)
	silent! xmap gI <Plug>(niceblock-gI)
	silent! xmap A  <Plug>(niceblock-A)
endif

if dein#tap('vim-edgemotion')
	nmap gj <Plug>(edgemotion-j)
	nmap gk <Plug>(edgemotion-k)
	xmap gj <Plug>(edgemotion-j)
	xmap gk <Plug>(edgemotion-k)
endif

if dein#tap('vim-quickhl')
	nmap <Leader>mt <Plug>(quickhl-manual-this)
	xmap <Leader>mt <Plug>(quickhl-manual-this)
endif

if dein#tap('vim-sidemenu')
	nmap <Leader>l <Plug>(sidemenu)
	xmap <Leader>l <Plug>(sidemenu-visual)
endif

if dein#tap('indent-blankline.nvim')
	nmap <Leader>ti <cmd>IndentBlanklineToggle<CR>
endif

if dein#tap('nvim-bqf')
	nmap <Leader>q <cmd>lua require('user').qflist.toggle()<CR>
endif

if dein#tap('goto-preview')
	nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
	nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
	nnoremap gpc <cmd>lua require('goto-preview').close_all_win()<CR>
	nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
endif

if dein#tap('committia.vim')
	let g:committia_hooks = {}
	function! g:committia_hooks.edit_open(info)
		resize 10
		imap <buffer><C-d> <Plug>(committia-scroll-diff-down-half)
		imap <buffer><C-u> <Plug>(committia-scroll-diff-up-half)
		imap <buffer><C-f> <Plug>(committia-scroll-diff-down-page)
		imap <buffer><C-b> <Plug>(committia-scroll-diff-up-page)
		imap <buffer><C-j> <Plug>(committia-scroll-diff-down)
		imap <buffer><C-k> <Plug>(committia-scroll-diff-up)
	endfunction
endif

if dein#tap('vim-shot-f')
	nmap f  <Plug>(shot-f-f)
	nmap F  <Plug>(shot-f-F)
	nmap t  <Plug>(shot-f-t)
	nmap T  <Plug>(shot-f-T)
	xmap f  <Plug>(shot-f-f)
	xmap F  <Plug>(shot-f-F)
	xmap t  <Plug>(shot-f-t)
	xmap T  <Plug>(shot-f-T)
	omap f  <Plug>(shot-f-f)
	omap F  <Plug>(shot-f-F)
	omap t  <Plug>(shot-f-t)
	omap T  <Plug>(shot-f-T)
endif

if dein#tap('todo-comments.nvim')
	nnoremap <LocalLeader>dt <cmd>TodoTelescope<CR>
endif

if dein#tap('trouble.nvim')
	nnoremap <leader>e <cmd>TroubleToggle document_diagnostics<CR>
	nnoremap <leader>r <cmd>TroubleToggle workspace_diagnostics<CR>
	nnoremap <leader>xq <cmd>TroubleToggle quickfix<CR>
	nnoremap <leader>xl <cmd>TroubleToggle loclist<CR>
	nnoremap ]t <cmd>lua require('trouble').next({skip_groups = true, jump = true})<CR>
	nnoremap [t <cmd>lua require('trouble').previous({skip_groups = true, jump = true})<CR>
	nnoremap gR <cmd>TroubleToggle lsp_references<CR>
endif

if dein#tap('diffview.nvim')
	nnoremap <Leader>gv <cmd>DiffviewOpen<CR>
endif

if dein#tap('vimwiki')
	nnoremap <Leader>W <cmd>VimwikiIndex<CR>
endif

if dein#tap('vim-choosewin')
	nmap -         <Plug>(choosewin)
	nmap <Leader>- <cmd>ChooseWinSwapStay<CR>
endif

if dein#tap('neogit')
	nnoremap <Leader>mg <cmd>Neogit<CR>
endif

if dein#tap('gina.vim')
	nnoremap <silent> <leader>ga <cmd>Gina add %:p<CR>
	nnoremap <silent> <leader>gd <cmd>Gina compare<CR>
	nnoremap <silent> <leader>gc <cmd>Gina commit<CR>
	nnoremap <silent> <leader>gb <cmd>Gina blame<CR>
	nnoremap <silent> <leader>gs <cmd>Gina status<CR>
	nnoremap <silent> <leader>gl <cmd>Gina log --all<CR>
	nnoremap <silent> <leader>gF <cmd>Gina! fetch<CR>
	nnoremap <silent> <leader>gp <cmd>Gina! push<CR>
	nnoremap <silent> <leader>go <cmd>,Gina browse :<CR>
	xnoremap <silent> <leader>go :Gina browse :<CR>
endif

if dein#tap('zen-mode.nvim')
	nnoremap <silent> <Leader>z <cmd>ZenMode<CR>
endif

if dein#tap('rest.nvim')
	nmap <silent> ,ht <Plug>RestNvim
endif

if dein#tap('any-jump.vim')
	" Normal mode: Jump to definition under cursor
	nnoremap <silent> <leader>ii <cmd>AnyJump<CR>

	" Visual mode: jump to selected text in visual mode
	xnoremap <silent> <leader>ii <cmd>AnyJumpVisual<CR>

	" Normal mode: open previous opened file (after jump)
	nnoremap <silent> <leader>ib <cmd>AnyJumpBack<CR>

	" Normal mode: open last closed search window again
	nnoremap <silent> <leader>il <cmd>AnyJumpLastResults<CR>
endif

if dein#tap('nvim-spectre')
	nnoremap <Leader>so <cmd>lua require('spectre').open()<CR>
	" Search current word
	nnoremap <Leader>sw <cmd>lua require('spectre').open_visual({select_word=true})<CR>
	xnoremap <silent><Leader>s <Esc>:lua require('spectre').open_visual()<CR>
	" Search in current file
	nnoremap <silent><Leader>sp viw:lua require('spectre').open_file_search()<CR>
endif

if dein#tap('undotree')
	nnoremap <Leader>gu <cmd>UndotreeToggle<CR>
endif

if dein#tap('thesaurus_query.vim')
	nnoremap <silent> <Leader>K <cmd>ThesaurusQueryReplaceCurrentWord<CR>
endif

if dein#tap('vim-asterisk')
	nmap *   <Plug>(asterisk-g*)
	nmap g*  <Plug>(asterisk-*)
	nmap #   <Plug>(asterisk-g#)
	nmap g#  <Plug>(asterisk-#)
	xmap *   <Plug>(asterisk-g*)
	xmap g*  <Plug>(asterisk-*)
	xmap #   <Plug>(asterisk-g#)
	xmap g#  <Plug>(asterisk-#)

	nmap z*  <Plug>(asterisk-z*)
	nmap gz* <Plug>(asterisk-gz*)
	nmap z#  <Plug>(asterisk-z#)
	nmap gz# <Plug>(asterisk-gz#)
	xmap z*  <Plug>(asterisk-z*)
	xmap gz* <Plug>(asterisk-gz*)
	xmap z#  <Plug>(asterisk-z#)
	xmap gz# <Plug>(asterisk-gz#)
endif

if dein#tap('nvim-treehopper')
	omap              am <cmd>lua require('tsht').nodes()<CR>
	xnoremap <silent> am :lua require('tsht').nodes()<CR>
endif

if dein#tap('sideways.vim')
	nnoremap <silent> <, <cmd>SidewaysLeft<CR>
	nnoremap <silent> >, <cmd>SidewaysRight<CR>
	nnoremap <silent> [, <cmd>SidewaysJumpLeft<CR>
	nnoremap <silent> ], <cmd>SidewaysJumpRight<CR>
	omap <silent> a, <Plug>SidewaysArgumentTextobjA
	xmap <silent> a, <Plug>SidewaysArgumentTextobjA
	omap <silent> i, <Plug>SidewaysArgumentTextobjI
	xmap <silent> i, <Plug>SidewaysArgumentTextobjI
endif

if dein#tap('splitjoin.vim')
	nmap sj <cmd>SplitjoinJoin<CR>
	nmap sk <cmd>SplitjoinSplit<CR>
endif

if dein#tap('linediff.vim')
	xnoremap <Leader>mdf :Linediff<CR>
	xnoremap <Leader>mda :LinediffAdd<CR>
	nnoremap <Leader>mds <cmd>LinediffShow<CR>
	nnoremap <Leader>mdr <cmd>LinediffReset<CR>
endif

if dein#tap('dsf.vim')
	nmap dsf <Plug>DsfDelete
	nmap csf <Plug>DsfChange
endif

" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
