
" Neomake
" ---------
" Signs: ⚐ ▹ ▭ ▫

let g:neomake_error_sign = { 'texthl': 'ErrorMsg' }
let g:neomake_warning_sign = { 'texthl': 'WarningMsg' }

function! s:filter_item(entry, pattern)
	if a:entry.text =~? a:pattern
		let a:entry.valid = 0
	endif
endfunction

function! s:vint_filter(entry)
	let l:ignore_errors = [
		\   'Use scriptencoding when multibyte char',
		\   'Make the scope explicit like'
		\ ]
	for l:pattern in l:ignore_errors
		call s:filter_item(a:entry, l:pattern)
	endfor
endfunction
let g:neomake_vim_vint_maker = {}
let g:neomake_vim_vint_maker.postprocess = function('s:vint_filter')

function! s:tidy_filter(entry)
	let l:ignore_errors = [
		\   '> proprietary attribute "',
		\   '> attribute "lang" lacks value',
		\   '> attribute "href" lacks value',
		\   'trimming empty <'
		\ ]
	for l:pattern in l:ignore_errors
		call s:filter_item(a:entry, l:pattern)
	endfor
endfunction
let g:neomake_html_tidy_maker = {}
let g:neomake_html_tidy_maker.postprocess = function('s:tidy_filter')

" vim: set ts=2 sw=2 tw=80 noet :
