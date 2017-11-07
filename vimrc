" Note: Skip initialization for vim-tiny or vim-small.
if 1
	execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/vimrc'
endif

" after a re-source, fix syntax matching issues (concealing brackets):
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif
