" Limit display of directories in path
let g:tabline_display_max_dirs = 1
" Limit display of characters in each directory in path
let g:tabline_display_max_dir_chars = 8

let g:tabline_tab_right_normal_edge =
	\ get(g:, 'tabline_tab_right_normal_edge', ' ')
let g:tabline_tab_right_active_edge =
	\ get(g:, 'tabline_tab_right_active_edge', '⮀ ')
let g:tabline_tab_project_edge =
	\ get(g:, 'tabline_tab_project_edge', '⮀')

" }}}
function! tabline#define_highlights() " {{{
	hi TabLine          ctermfg=236 ctermbg=243 guifg=#303030 guibg=#767676
	hi TabLineFill      ctermfg=236 guifg=#303030
	hi TabLineSel       ctermfg=241 ctermbg=234 guifg=#626262 guibg=#1C1C1C gui=NONE
	hi TabLineAlt       ctermfg=234 ctermbg=236 guifg=#1C1C1C guibg=#303030
	hi TabLineAltFill   ctermfg=252 ctermbg=238 guifg=#D0D0D0 guibg=#444444
	hi TabLineAltSel    ctermfg=238 ctermbg=236 guifg=#444444 guibg=#303030
	hi TabLineShade     ctermfg=235 ctermbg=234 guifg=#262626 guibg=#1C1C1C
endfunction

" }}}
function! tabline#render()
	" Main tabline function. Draws the whole damn tabline

	let s = '%#TabLineAltFill# %{ProjectName()} '
		\ .'%#TabLineAltSel#'.g:tabline_tab_project_edge
		\ .'%#TabLine#  '
	let nr = tabpagenr()
	for i in range(tabpagenr('$'))
		if i + 1 == nr
			let s .= '%#TabLineShade#░'
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine# '
		endif
		" Set the tab page number (for mouse clicks)
		let s .= '%'.(i + 1).'T'
		let s .= '%{tabline#tab_label('.(i + 1).')} '
		if i + 1 == nr
			let s .= '%#TabLineAlt#'.g:tabline_tab_right_active_edge
		else
			let s .= g:tabline_tab_right_normal_edge
		endif
	endfor

	" After the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	" Right-align the label to show session is loading or loaded
	if exists('g:SessionLoad')
		let arrows = ['-', '\', '|', '/']
		let s .= '%=%#TabLine#['.arrows[g:SessionLoad % 4].']'
		let g:SessionLoad = g:SessionLoad < 4 ? g:SessionLoad + 1 : 0
	elseif ! empty(v:this_session)
		let s .= '%=%#TabLine#[S]'
	endif

	return s
endfunction

" }}}
function! tabline#tab_label(n)
	" Returns a specific tab's label

	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let filepath = bufname(buflist[winnr - 1])
	if len(filepath) == 0
		let label = '[No Name]'
	else
		let pre = ''
		let project_dir = gettabvar(a:n, 'project_dir')
		if strridx(filepath, project_dir) == 0
			let filepath = strpart(filepath, len(project_dir))
			let pre .= gettabvar(a:n, 'project_name').g:tabline_tab_project_edge
		endif

		" Shorten dir names
		let short = substitute(filepath,
			\ "[^/]\\{".g:tabline_display_max_dir_chars."}\\zs[^/]\*\\ze/", '', 'g')
		" Decrease dir count
		let parts = split(short, '/')
		if len(parts) > g:tabline_display_max_dirs
			let parts = parts[-g:tabline_display_max_dirs-1 : ]
		endif
		let filepath = join(parts, '/')

		" Prepend the project name
		let label = pre.filepath
	endif
	return label
endfunction
" }}}

let &tabline='%!tabline#render()'
call tabline#define_highlights()
augroup tabline
	autocmd!
	autocmd ColorScheme * call tabline#define_highlights()
augroup END

" vim: set ts=2 sw=2 tw=80 noet :
