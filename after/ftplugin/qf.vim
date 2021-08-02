" Quickfix and Location lists
" ---

let s:save_cpo = &cpoptions
set cpoptions&vim

" Local window settings
setlocal cursorline colorcolumn=

if exists('&signcolumn')
	setlocal signcolumn=yes
endif

" let s:winheight = get(g:, 'qf_winheight', 10)
" if winheight(0) != s:winheight
" 	execute 'resize' s:winheight
" endif

if ! exists(':Lfilter')
	try
		packadd cfilter
	endtry
endif

if ! exists('b:qf_isLoc')
	" Are we in a location list or a quickfix list?
	let b:qf_isLoc = get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0)
endif

silent! nunmap <buffer> <Esc>
silent! nunmap <buffer> i
silent! nunmap <buffer> r

nnoremap <silent><buffer> <Esc> :pclose!<CR>:quit<CR>

if exists(':Lfilter')
	nnoremap <buffer><expr> i
		\ (b:qf_isLoc == 1 ? ':L' : ':C') . "filter\<Space>//\<Left>"
	nnoremap <buffer><expr> r
		\ (b:qf_isLoc == 1 ? ':L' : ':C'). "filter!\<Space>//\<Left>"
endif

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= ' | '
else
	let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .=
	\ 'setl cursorline< colorcolumn< signcolumn<'
	\ . " | execute 'nunmap <buffer> <Esc>'"
	\ . " | execute 'nunmap <buffer> r'"
	\ . " | execute 'nunmap <buffer> i'"

let &cpoptions = s:save_cpo
