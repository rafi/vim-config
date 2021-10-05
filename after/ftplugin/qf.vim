" Quickfix and Location lists
" ---

let s:save_cpo = &cpoptions
set cpoptions&vim

" Setup filetype undo
if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= ' | '
else
	let b:undo_ftplugin = ''
endif

let b:undo_ftplugin .=
	\ 'setl cursorline< colorcolumn< signcolumn<'
	\ . " | execute 'nunmap <buffer> q'"
	\ . ' | unlet b:qf_isLoc'

" Local window settings
setlocal cursorline colorcolumn= signcolumn=yes

" let s:winheight = get(g:, 'qf_winheight', 10)
" if winheight(0) != s:winheight
" 	execute 'resize' s:winheight
" endif

" See :h cfilter-plugin
if ! exists(':Lfilter')
	try
		packadd cfilter
	endtry
endif

" Leave behind a variable that indicates this is a location-list, or not.
if ! exists('b:qf_isLoc')
	if exists('*win_gettype')
		let b:qf_isLoc = win_gettype() ==# 'loclist'
	else
		let b:qf_isLoc = get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0)
	endif
endif

" Setup key-mappings
nnoremap <buffer> q <Cmd>quit<CR>

if exists(':Lfilter')
	silent! nunmap <buffer> i
	silent! nunmap <buffer> r
	nnoremap <buffer><expr> i
		\ '<Cmd>' . (b:qf_isLoc == 1 ? 'L' : 'C') . "filter\<Space>//\<Left>"
	nnoremap <buffer><expr> r
		\ '<Cmd>' . (b:qf_isLoc == 1 ? 'L' : 'C'). "filter!\<Space>//\<Left>"

	let b:undo_ftplugin .= " | execute 'nunmap <buffer> r'"
		\ . " | execute 'nunmap <buffer> i'"
endif

let &cpoptions = s:save_cpo

" vim: set ts=2 sw=2 tw=80 noet :
