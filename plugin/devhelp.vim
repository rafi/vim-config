" Open Dash or Zeal on words under cursor
" ---
"
" Behaviors:
" - Map `gK` for selected filetypes

if exists('g:loaded_devhelp') && g:loaded_devhelp
	finish
endif
let g:loaded_devhelp = 1

augroup plugin_devhelp
	autocmd!

	autocmd FileType yaml.ansible,php,css,less,html,markdown,vim,sql,ruby
		\ nmap <silent><buffer> gK :call <SID>show_help(expand('<cword>'))<CR>

	autocmd FileType javascript,javascriptreact,conf
		\ nmap <silent><buffer> gK :call <SID>show_help(expand('<cword>'), '')<CR>

augroup END

function! s:show_help(word, ...)
	" Open Dash/Zeal on word
	" Arguments: word, filetype
	let l:word = a:word
	let l:lang = a:0 > 0 && a:1 ? a:1 : &filetype
	let l:expr = split(l:lang, '\.')[-1] . ':' . l:word

	if executable('/Applications/Dash.app/Contents/MacOS/Dash')
		execute '!open -g dash://' . l:expr
	elseif executable('zeal')
		execute '!zeal --query "' . l:expr . '"'
	else
		echohl ErrorMsg
		echomsg 'Unable to find Dash or Zeal, install one of these.'
		echohl None
	endif
	redraw!
endfunction
