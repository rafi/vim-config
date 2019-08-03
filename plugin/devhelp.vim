" Open Dash or Zeal on words under cursor
" ---
"
" Behaviors:
" - Map `gK` for selected filetypes

if exists('g:loaded_devhelp')
	finish
endif
let g:loaded_devhelp = 1

augroup plugin_devhelp
	autocmd!

	autocmd FileType yaml.ansible,php,css,less,html,markdown
		\ nmap <silent><buffer> gK :call <SID>show_help(expand('<cword>'), &ft)<CR>

	autocmd FileType javascript,javascript.jsx,sql,ruby,conf
		\ nmap <silent><buffer> gK :call <SID>show_help(expand('<cword>'), '')<CR>

augroup END

function! s:show_help(...)
	let l:word = a:0 > 0 ? a:1 : ''
	let l:syn = a:0 > 1 ? a:2 : &filetype
	let l:expr = split(l:syn, '\.')[1] . ':' . l:word

	if executable('/Applications/Dash.app/Contents/MacOS/Dash')
		execute '!open -g dash://' . l:expr
	elseif executable('zeal')
		execute '!zeal --query "' . l:expr . '"'
	endif
endfunction
