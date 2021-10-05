" Whitespace utilities
" ---
"
" Behaviors:
" - Display special highlight for trailing whitespace and space preceding tabs
"
" Commands:
" - WhitespaceErase: Strips trailing whitespace from buffer
" - WhitespaceNext: Cursor jump to next whitespace issue
" - WhitespacePrev: Cursor jump to next whitespace issue
"
" Options:
" - g:whitespace_filetype_blacklist override default whitespace blacklist
" - g:whitespace_characters overrides default whitespace chars (default: \s)
" - g:whitespace_pattern overrides pattern (default: chars . \+$)
" - g:whitespace_pattern_normal overrides normal mode pattern
" - g:whitespace_pattern_insert overrides insert mode pattern

if exists('g:loaded_pluginwhitespace')
	finish
endif
let g:loaded_pluginwhitespace = 1

" Remove end of line white space
command! -range=% WhitespaceErase call <SID>WhitespaceErase(<line1>, <line2>)

" Search for trailing white space forwards
command! -range=% WhitespaceNext call <SID>WhitespaceJump(1, <line1>, <line2>)

" Search for trailing white space backwards
command! -range=% WhitespacePrev call <SID>WhitespaceJump(-1, <line1>, <line2>)

" Whitespace events
if v:version >= 702
	augroup plugin_whitespace
		autocmd!
		autocmd InsertEnter * call <SID>ToggleWhitespace('i')
		autocmd InsertLeave * call <SID>ToggleWhitespace('n')
	augroup END
endif

let s:ws_chars = get(g:, 'whitespace_characters', '\s')
let s:ws_pattern = get(g:, 'whitespace_pattern', s:ws_chars . '\+$')
let s:normal_pattern = get(g:, 'whitespace_pattern_normal',
	\ s:ws_pattern . '\| \+\ze\t')
let s:insert_pattern = get(g:, 'whitespace_pattern_insert',
	\ s:ws_chars . '\+\%#\@<!$')

let s:blacklist = get(g:, 'whitespace_filetype_blacklist', [
	\ 'diff', 'git', 'gitcommit', 'help', 'qf', 'denite', 'defx' ])

function! s:ToggleWhitespace(mode)
	if ! &modifiable || ! empty(&buftype) || index(s:blacklist, &filetype) > -1
		return
	elseif a:mode ==? ''
		call matchdelete(w:whitespace_match_id)
		return
	else
		let l:pattern = (a:mode ==# 'i') ? s:insert_pattern : s:normal_pattern
		if exists('w:whitespace_match_id')
			call matchdelete(w:whitespace_match_id)
			call matchadd('ExtraWhitespace', l:pattern, 10, w:whitespace_match_id)
		else
			highlight! link ExtraWhitespace SpellBad
			let w:whitespace_match_id = matchadd('ExtraWhitespace', l:pattern)
		endif
	endif
endfunction

function! s:WhitespaceErase(line1, line2)
	let l:save_cursor = getpos('.')
	silent! execute ':' . a:line1 . ',' . a:line2 . 's/' . s:ws_pattern . '//'
	call setpos('.', l:save_cursor)
endfunction

" Search for trailing whitespace
function! s:WhitespaceJump(direction, from, to)
	let l:opts = 'wz'
	let l:until = a:to
	if a:direction < 1
		let l:opts .= 'b'
		let l:until = a:from
	endif

	" Full file, allow wrapping
	if a:from == 1 && a:to == line('$')
		let l:until = 0
	endif

	" Go to pattern
	let l:found = search(s:normal_pattern, l:opts, l:until)
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
