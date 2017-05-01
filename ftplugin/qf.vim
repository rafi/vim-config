let s:save_cpo = &cpoptions
set cpoptions&vim

let b:undo_ftplugin = 'setl fo< com< ofu<'

setlocal winminheight=2 winheight=3
setlocal nowrap
setlocal norelativenumber number
setlocal linebreak
setlocal nolist
setlocal cursorline
setlocal nobuflisted

nnoremap <buffer> <CR> <CR>zz<C-w>p
nnoremap <buffer> sv <C-w><CR>
nnoremap <buffer> sg <C-w><Enter><C-w>L
nnoremap <buffer> st <C-w><CR><C-w>T

let &cpoptions = s:save_cpo
