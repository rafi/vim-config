" Write history on idle
augroup MyAutoCmd
	autocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
augroup END

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/vimrc'
