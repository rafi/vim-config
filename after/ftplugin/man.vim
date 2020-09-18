
let s:save_cpo = &cpoptions
set cpoptions&vim

silent! nunmap <buffer> q
nnoremap <silent><buffer> q :<C-u>quit<CR>

nnoremap <silent><buffer> <Leader>o  :<C-u>call man#show_toc()<CR>

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= ' | '
else
	let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= "execute 'nunmap <buffer> <leader>o'"

let &cpoptions = s:save_cpo
