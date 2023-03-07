" Man ftplugin
" ---

let s:save_cpo = &cpoptions
set cpoptions&vim

setlocal softtabstop=-1

nnoremap <silent><buffer> <Leader>o  :<C-u>call man#show_toc()<CR>

if get(b:, 'pager')
	nnoremap <silent> <buffer> <nowait> q :lclose<CR><C-W>q
else
	nnoremap <silent> <buffer> <nowait> q :lclose<CR><C-W>c
endif

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= ' | '
else
	let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .=
	\ "execute 'nunmap <buffer> <leader>o' | execute 'nunmap <buffer> q'"

let &cpoptions = s:save_cpo
