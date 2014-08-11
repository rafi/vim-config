function RafiTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif
		" Set the tab page number (for mouse clicks)
		let s .= '%'.(i + 1).'T'
		let s .= ' %{RafiTabLabel('.(i + 1).')} '
	endfor

	" After the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	" Right-align the label to close the current tab page
	if tabpagenr('$') > 1
		let s .= '%=%#TabLine#%999XX'
	endif

	return s
endfunction

function RafiTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let filepath = bufname(buflist[winnr - 1])
	if len(filepath) == 0
		let filepath = '[No Name]'
	else
		" Shorten dir names
		let short = substitute(filepath, "[^/]\\{3}\\zs[^/]\*\\ze/", "", "g")
		" Decrease dir count
		let parts = split(short, '/')
		if len(parts) > 3
			let parts = parts[-3-1 : ]
		endif
		let filepath = join(parts, '/')
	endif
	return filepath
endfunction

set tabline=%!RafiTabLine()
