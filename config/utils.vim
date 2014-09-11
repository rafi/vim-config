
" Commands {{{1
"------------------------------------------------------------------------------

" Check timestamp more for 'autoread'
autocmd MyAutoCmd WinEnter * checktime

" Disable paste
autocmd MyAutoCmd InsertLeave *
		\ if &paste | set nopaste mouse=a | echo 'nopaste' | endif |
		\ if &l:diff | diffupdate | endif

" Update diff
autocmd MyAutoCmd InsertLeave * if &l:diff | diffupdate | endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
	\ if line("'\"") > 0 && line("'\"") <= line("$") |
	\	exe 'normal! g`"zvzz' |
	\ endif

" Functions {{{1
"------------------------------------------------------------------------------

" Simple way to turn off Gdiff splitscreen
" works only when diff buffer is focused
" See: http://stackoverflow.com/a/25530943/351947
command! Gdiffoff call Gdiffoff()
function! Gdiffoff()
	let diffbufnr = bufnr('^fugitive:')
	if diffbufnr > -1 && &diff
		diffoff | q
		if bufnr('%') == diffbufnr | Gedit | endif
		if has('cursorbind') | setlocal nocursorbind | endif
	else
		echo 'Error: Not in diff or file'
	endif
endfunction

" Makes * and # work on visual mode too.
" See: http://github.com/nelstrom/vim-visual-star-search
function! VSetSearch(cmdtype)
	let temp = @s
	normal! gv"sy
	let @/ = '\V'.substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
	let @s = temp
endfunction

" Append modeline after last line in buffer
" See: http://vim.wikia.com/wiki/Modeline_magic
function! AppendModeline()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction

" Nicer fold text
" See: http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! FoldText()
	let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
	let lines_count = v:foldend - v:foldstart + 1
	let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
	let foldchar = matchstr(&fillchars, 'fold:\zs.')
	let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
	let foldtextend = lines_count_text . repeat(foldchar, 8)
	let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
	return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
