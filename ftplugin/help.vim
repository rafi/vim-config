" jump to links with CR
noremap <buffer> <CR> <C-]>

" jump back with BS
noremap <buffer> <BS> <C-T>

" skip to next option link
nnoremap <buffer> o /'[a-z]\{2,\}'<CR>

" skip to previous option link
nnoremap <buffer> O ?'[a-z]\{2,\}'<CR>

" skip to next subject link
nnoremap <buffer> s /\|\S\+\|<CR>l

" skip to previous subject link
nnoremap <buffer> S h?\|\S\+\|<CR>l

" quit
nnoremap <buffer> q :q<CR>

" skip to next/prev quickfix list entry (from a helpgrep)
nnoremap <buffer> <leader>j :cnext<CR>
nnoremap <buffer> <leader>k :cprev<CR>
