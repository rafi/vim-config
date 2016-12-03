
" Zoom window toggling
"---------------------------------------------------------

command! ZoomToggle call s:ZoomToggle()

" Zoom / Restore window
function! s:ZoomToggle() "{{{
	if exists('t:zoomed') && t:zoomed > -1
		execute t:zoom_winrestcmd
		let t:zoomed = -1
	else
		let t:zoom_winrestcmd = winrestcmd()
		resize
		vertical resize
		let t:zoomed = bufnr('%')
	endif
endfunction "}}}

" vim: set ts=2 sw=2 tw=80 noet :
