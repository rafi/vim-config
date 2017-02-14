let s:save_cpo = &cpoptions
set cpoptions&vim

let b:undo_ftplugin = "setl fo< com< ofu<"

setlocal winheight=3
setlocal nowrap
setlocal norelativenumber number
setlocal linebreak
setlocal nolist
setlocal cursorline
setlocal statusline+=\ %L
setlocal nobuflisted

nnoremap <buffer> <CR> <CR>zz<C-w>p
nnoremap <buffer> sv <C-w><CR>
nnoremap <buffer> sg <C-w><Enter><C-w>L
nnoremap <buffer> st <C-w><CR><C-w>T

nnoremap <silent> <buffer> dd :call <SID>del_entry()<CR>
nnoremap <silent> <buffer> x :call <SID>del_entry()<CR>
vnoremap <silent> <buffer> d :call <SID>del_entry()<CR>
vnoremap <silent> <buffer> x :call <SID>del_entry()<CR>
nnoremap <silent> <buffer> u :<C-u>call <SID>undo_entry()<CR>

function! s:undo_entry()
  let history = get(w:, 'qf_history', [])
  if !empty(history)
    call setqflist(remove(history, -1), 'r')
  endif
endfunction

function! s:del_entry() range
  let qf = getqflist()
  let history = get(w:, 'qf_history', [])
  call add(history, copy(qf))
  let w:qf_history = history
  unlet! qf[a:firstline - 1 : a:lastline - 1]
  call setqflist(qf, 'r')
  execute a:firstline
endfunction

let &cpoptions = s:save_cpo

" vim: set ts=2 sw=2 tw=80 noet :
