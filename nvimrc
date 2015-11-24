let g:python_host_prog  = '/opt/local/bin/python2.7'
let g:python3_host_prog = '/opt/local/bin/python3.4'

" Share the histories
augroup MyAutoCmd
	autocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
augroup END

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/vimrc'
