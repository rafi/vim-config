" Rafi's Tabline
" ===

function! Tabline() abort
	" Active project name
	let s:tabline =
		\ '%#TabLineAlt# %{"  " . badge#project()} %#TabLineAltShade#'

	" Iterate through all tabs and collect labels
	let l:current = tabpagenr()
	for i in range(tabpagenr('$'))
		let l:nr = i + 1
		if l:nr == l:current
			" Active tab
			let s:tabline .=
				\ '%#TabLineFill#%#TabLineSel# ' .
				\ '%' . l:nr . 'T%{badge#filename(0, ' . l:nr . ', 1, 1)} ' .
				\ '%#TabLineFill#'
		else
			" Normal tab
			let s:tabline .=
				\ '%#TabLine#  '.
				\ '%' . l:nr . 'T%{badge#filename(0, ' . l:nr . ', 1, 1)} ' .
				\ ' '
		endif
	endfor

	" Empty elastic space and session indicator
	let s:tabline .=
		\ '%#TabLineFill#%T%=%#TabLine#' .
		\ '%{badge#session("' . fnamemodify(v:this_session, ':t:r') . '  ")}'

	return s:tabline
endfunction

let &tabline='%!Tabline()'
