function! Tabline() abort "{{{
	" Active project tab
	let s:tabline =
		\ '%#TabLine# %{badge#project()} %#TabLineFill#  '

	let nr = tabpagenr()
	for i in range(tabpagenr('$'))
		if i + 1 == nr
			" Active tab
			let s:tabline .=
				\ '%#TabLineFill#%#TabLineSel# '.
				\ '%'.(i+1).'T%{badge#label('.(i+1).', "▛", "N/A")} '.
				\ '%#TabLineFill# '
		else
			" Normal tab
			let s:tabline .=
				\ '%#TabLine#  '.
				\ '%'.(i+1).'T%{badge#label('.(i+1).', "▛", "N/A")} '.
				\ ' '
		endif
	endfor
	" Empty space and session indicator
	let s:tabline .=
		\ '%#TabLineFill#%T%=%#TabLine#%{badge#session("['.fnamemodify(v:this_session, ':t:r').']")}'
	return s:tabline
endfunction "}}}

let &tabline='%!Tabline()'
