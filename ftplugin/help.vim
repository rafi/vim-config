" Snippets from vim-help
" Credits: https://github.com/dahu/vim-help

if exists('b:did_ftplugin')
	finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:undo_ftplugin = 'setlocal spell<'
setlocal nospell

setlocal nolist
setlocal nohidden
setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-

if winnr('$') > 2 + (bufname('defx') ==# '' ? 0 : 1)
	wincmd K
else
	wincmd L
endif

" Exit help window with 'q'
nnoremap <silent><buffer> q :quit<CR>

" Jump to links with enter
nmap <buffer> <CR> <C-]>

" Jump back with backspace
nmap <buffer> <BS> <C-T>

" Skip to next option link
nmap <buffer> o /'[a-z]\{2,\}'<CR>

" Skip to previous option link
nmap <buffer> O ?'[a-z]\{2,\}'<CR>

" Skip to next subject link
nmap <buffer><nowait> f /\|\S\+\|<CR>l

" Skip to previous subject link
nmap <buffer> F h?\|\S\+\|<CR>l

" Skip to next tag (subject anchor)
nmap <buffer> t /\*\S\+\*<CR>l

" Skip to previous tag (subject anchor)
nmap <buffer> T h?\*\S\+\*<CR>l

let &cpoptions = s:save_cpo
" vim: set ts=2 sw=2 tw=80 noet :
