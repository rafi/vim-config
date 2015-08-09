let g:python_host_prog  = '/opt/local/bin/python2.7'
let g:python3_host_prog = '/opt/local/bin/python3.4'
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/vimrc'
