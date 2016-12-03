
" Whitespace utilities
"---------------------------------------------------------

" Remove end of line white space.
command! -range=% WhitespaceErase call <SID>WhitespaceErase(<line1>,<line2>)

" Whitespace "{{{
if v:version >= 702
	augroup WhitespaceMatch "{{{
		autocmd!
		autocmd InsertEnter * call <SID>ToggleWhitespace('i')
		autocmd InsertLeave * call <SID>ToggleWhitespace('n')
	augroup END "}}}
endif

function! s:ToggleWhitespace(mode) "{{{
	if &buftype =~? 'nofile\|help\|quickfix' || &filetype ==? ''
		return
	elseif a:mode ==? ''
		call matchdelete(w:whitespace_match_id)
		return
	else
		let l:pattern = (a:mode ==# 'i') ? '\s\+\%#\@<!$' : '\s\+$\| \+\ze\t'
		if exists('w:whitespace_match_id')
			call matchdelete(w:whitespace_match_id)
			call matchadd('ExtraWhitespace', l:pattern, 10, w:whitespace_match_id)
		else
			highlight! link ExtraWhitespace  SpellBad
			let w:whitespace_match_id = matchadd('ExtraWhitespace', l:pattern)
		endif
	endif
endfunction "}}}

function! s:WhitespaceErase(line1, line2) "{{{
	let l:save_cursor = getpos('.')
	silent! execute ':'.a:line1.','.a:line2.'s/\s\+$//'
	call setpos('.', l:save_cursor)
endfunction "}}}

"}}}
" vim: set ts=2 sw=2 tw=80 noet :
