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

" Local window settings
setlocal cursorline colorcolumn= signcolumn=yes

" Setup key-mappings

" See :h cfilter-plugin
if ! exists(':Lfilter')
	try
		packadd cfilter
	endtry
endif

if exists(':Lfilter')
	nnoremap <buffer><expr> i
		\ ':' . (win_gettype() == 'loclist' ? 'L' : 'C') . "filter\<Space>//\<Left>"
	nnoremap <buffer><expr> r
		\ ':' . (win_gettype() == 'loclist' ? 'L' : 'C'). "filter!\<Space>//\<Left>"

	let b:undo_ftplugin .= " | execute 'nunmap <buffer> r'"
		\ . " | execute 'nunmap <buffer> i'"
endif

let &cpoptions = s:save_cpo

" vim: set ts=2 sw=2 tw=80 noet :
