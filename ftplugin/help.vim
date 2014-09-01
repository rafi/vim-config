" Credits: https://github.com/dahu/vim-help

" jump to links with enter
nmap <buffer> <CR> <C-]>

" jump back with backspace
nmap <buffer> <BS> <C-T>

" skip to next option link
nmap <buffer> o /'[a-z]\{2,\}'<CR>

" skip to previous option link
nmap <buffer> O ?'[a-z]\{2,\}'<CR>

" skip to next subject link
nmap <buffer> s /\|\S\+\|<CR>l

" skip to previous subject link
nmap <buffer> S h?\|\S\+\|<CR>l

" skip to next tag (subject anchor)
nmap <buffer> t /\*\S\+\*<CR>l

" skip to previous tag (subject anchor)
nmap <buffer> T h?\*\S\+\*<CR>l

" quit
nmap <buffer> q :q<CR>

" skip to next/prev quickfix list entry (from a helpgrep)
nmap <buffer> <leader>j :cnext<CR>
nmap <buffer> <leader>k :cprev<CR>

" disable vim-help maps
nmap <buffer> <leader>q :<c-u>call <SID>disable_help_maps()<cr>

function! s:disable_help_maps()
	nunmap <buffer> <CR>
	nunmap <buffer> <BS>
	nunmap <buffer> o
	nunmap <buffer> O
	nunmap <buffer> s
	nunmap <buffer> S
	nunmap <buffer> t
	nunmap <buffer> T
	nunmap <buffer> q
	nunmap <buffer> <leader>j
	nunmap <buffer> <leader>k
endfunction
