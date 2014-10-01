" Credits: https://github.com/dahu/vim-help

" Jump to links with enter
nmap <buffer> <CR> <C-]>

" Jump back with backspace
nmap <buffer> <BS> <C-T>

" Skip to next option link
nmap <buffer> o /'[a-z]\{2,\}'<CR>:noh<CR>

" Skip to previous option link
nmap <buffer> O ?'[a-z]\{2,\}'<CR>:noh<CR>

" Skip to next subject link
nmap <buffer> s /\|\S\+\|<CR>l:noh<CR>

" Skip to previous subject link
nmap <buffer> S h?\|\S\+\|<CR>l:noh<CR>

" Skip to next tag (subject anchor)
nmap <buffer> t /\*\S\+\*<CR>l:noh<CR>

" Skip to previous tag (subject anchor)
nmap <buffer> T h?\*\S\+\*<CR>l:noh<CR>

" Quit
nmap <buffer> q :q<CR>

" Skip to next/prev quickfix list entry (from a helpgrep)
nmap <buffer> <Leader>j :cnext<CR>
nmap <buffer> <Leader>k :cprev<CR>

" Disable vim-help maps
nmap <buffer> <Leader>k :<c-u>call <SID>disable_help_maps()<cr>

" Disable
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
	nunmap <buffer> <Leader>j
	nunmap <buffer> <Leader>k
endfunction
