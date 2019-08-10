" vim-badge - Bite-size badges for tab & status lines
" Maintainer: Rafael Bodill <justrafi at gmail dot com>
" Version:    0.2
"-------------------------------------------------

" Configuration {{{

" Limit display of directories in path
let g:badge_label_max_dirs =
	\ get(g:, 'badge_label_max_dirs', 1)

" Limit display of characters in each directory in path
let g:badge_label_max_dir_chars =
	\ get(g:, 'badge_label_max_dir_chars', 8)

" Maximum number of directories in filepath
let g:badge_filename_max_dirs =
	\ get(g:, 'badge_filename_max_dirs', 3)

" Maximum number of characters in each directory
let g:badge_filename_max_dir_chars =
	\ get(g:, 'badge_filename_max_dir_chars', 5)

" Less verbosity on specific filetypes (regexp)
let g:badge_quiet_filetypes =
	\ get(g:, 'badge_quiet_filetypes',
	\ 'qf\|help\|denite\|unite\|vimfiler\|gundo\|diff\|fugitive\|gitv\|magit')
" }}}

" Clear cache on save {{{
augroup statusline_cache
	autocmd!
	autocmd BufWritePre *
		\ unlet! b:badge_cache_trails b:badge_cache_syntax b:badge_cache_filename
augroup END
" }}}

function! badge#label(n, ...) abort "{{{
	" Returns a specific tab's label
	" Parameters:
	"   n: Tab number
	"   Project separator symbol, default: |
	"   Empty buffer name, default: [No Name]

	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let filepath = bufname(buflist[winnr - 1])
	if len(filepath) == 0
		let label = a:0 > 1 ? a:2 : '[No Name]'
	else
		let pre = ''
		let project_dir = gettabvar(a:n, 'project_dir')
		if strridx(filepath, project_dir) == 0
			let filepath = strpart(filepath, len(project_dir))
			let pre .= gettabvar(a:n, 'project_name').(a:0 > 0 ? a:1 : '|')
		endif

		" Shorten dir names
		let short = substitute(filepath,
			\ "[^/]\\{".g:badge_label_max_dir_chars."}\\zs[^/]\*\\ze/", '', 'g')
		" Decrease dir count
		let parts = split(short, '/')
		if len(parts) > g:badge_label_max_dirs
			let parts = parts[-g:badge_label_max_dirs-1 : ]
		endif
		let filepath = join(parts, '/')

		" Prepend the project name
		let label = pre . filepath
	endif
	return label
endfunction

" }}}
function! badge#project() abort "{{{
	" Try to guess the project's name

	let dir = badge#root()
	return fnamemodify(dir ? dir : getcwd(), ':t')
endfunction

" }}}
function! badge#filename() abort " {{{
	" Provides relative path with limited characters in each directory name, and
	" limits number of total directories. Caches the result for current buffer.

	" Use buffer's cached filepath
	if exists('b:badge_cache_filename') && len(b:badge_cache_filename) > 0
		return b:badge_cache_filename
	endif

	" VimFiler status string
	if &filetype ==# 'vimfiler'
		let b:badge_cache_filename = vimfiler#get_status_string()
	" Empty if owned by certain plugins
	elseif &filetype =~? g:badge_quiet_filetypes
		let b:badge_cache_filename = ''
	" Placeholder for empty buffer
	elseif expand('%:t') ==? ''
		let b:badge_cache_filename = 'N/A'
	" Regular file
	else
		" Shorten dir names
		let short = substitute(expand('%'), "[^/]\\{".g:badge_filename_max_dir_chars."}\\zs[^/]\*\\ze/", '', 'g')
		" Decrease dir count
		let parts = split(short, '/')
		if len(parts) > g:badge_filename_max_dirs
			let parts = parts[-g:badge_filename_max_dirs-1 : ]
		endif
		let b:badge_cache_filename = join(parts, '/')
	endif

	if exists('b:fugitive_type') && b:fugitive_type ==# 'blob'
		let b:badge_cache_filename .= ' (blob)'
	endif

	return b:badge_cache_filename
endfunction

" }}}
function! badge#root() abort "{{{
	" Find the root directory by searching for the version-control dir

	let dir = getbufvar('%', 'project_dir')
	let curr_dir = getcwd()
	if empty(dir) || getbufvar('%', 'project_dir_last_cwd') != curr_dir
		let patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
		for pattern in patterns
			let is_dir = stridx(pattern, '/') != -1
			let match = is_dir ? finddir(pattern, curr_dir.';')
				\ : findfile(pattern, curr_dir.';')
			if ! empty(match)
				let dir = fnamemodify(match, is_dir ? ':p:h:h' : ':p:h')
				call setbufvar('%', 'project_dir', dir)
				call setbufvar('%', 'project_dir_last_cwd', curr_dir)
				break
			endif
		endfor
	endif
	return dir
endfunction

" }}}
function! badge#branch() abort " {{{
	" Returns git branch name, using different plugins.

	if &filetype !~? g:badge_quiet_filetypes
		if exists('*gitbranch#name')
			return gitbranch#name()
		elseif exists('*vcs#info')
			return vcs#info('%b')
		elseif exists('fugitive#head')
			return fugitive#head(8)
		endif
	endif
	return ''
endfunction

" }}}
function! badge#syntax() abort " {{{
	" Returns syntax warnings from several plugins (Neomake and syntastic)

	if &filetype =~? g:badge_quiet_filetypes
		return ''
	endif

	if ! exists('b:badge_cache_syntax') || empty(b:badge_cache_syntax)
		let b:badge_cache_syntax = ''
		if exists('*neomake#Make')
			let b:badge_cache_syntax = neomake#statusline#LoclistStatus()
		elseif exists('*SyntasticStatuslineFlag')
			let b:badge_cache_syntax = SyntasticStatuslineFlag()
		endif
	endif

	return b:badge_cache_syntax
endfunction

" }}}
function! badge#trails(...) abort " {{{
	" Detect trailing whitespace and cache result per buffer
	" Parameters:
	"   Whitespace warning message, use %s for line number, default: WS:%s

	if ! exists('b:badge_cache_trails')
		let b:badge_cache_trails = ''
		if ! &readonly && &modifiable && line('$') < 9000
			let trailing = search('\s$', 'nw')
			if trailing != 0
				let label = a:0 == 1 ? a:1 : 'WS:%s'
				let b:badge_cache_trails .= printf(label, trailing)
			endif
		endif
	endif
	return b:badge_cache_trails
endfunction

" }}}
function! badge#modified(...) abort " {{{
	" Make sure we ignore &modified when choosewin is active
	" Parameters:
	"   Modified symbol, default: +

	let label = a:0 == 1 ? a:1 : '+'
	let choosewin = exists('g:choosewin_active') && g:choosewin_active
	return &modified && ! choosewin ? label : ''
endfunction

" }}}
function! badge#mode(...) abort " {{{
	" Returns file's mode: read-only and/or zoomed
	" Parameters:
	"   Read-only symbol, default: R
	"   Zoomed buffer symbol, default: Z

	let s:modes = ''
	if &filetype !~? g:badge_quiet_filetypes && &readonly
		let s:modes .= a:0 > 0 ? a:1 : 'R'
	endif
	if exists('t:zoomed') && bufnr('%') == t:zoomed.nr
		let s:modes .= a:0 > 1 ? a:2 : 'Z'
	endif

	return s:modes
endfunction

" }}}
function! badge#format() abort " {{{
	" Returns file format

	return &filetype =~? g:badge_quiet_filetypes ? '' : &fileformat
endfunction

" }}}
function! badge#session(...) abort "{{{
	" Returns an indicator for active session
	" Parameters:
	"   Active session symbol, default: [S]

	return empty(v:this_session) ? '' : a:0 == 1 ? a:1 : '[S]'
endfunction
" }}}

function! badge#indexing() abort
	let l:out = ''
	if exists('*gutentags#statusline')
		let l:out .= gutentags#statusline('[', ']')
	endif
	if exists('*coc#status')
		let l:out .= coc#status()
	endif
	if exists('g:SessionLoad') && g:SessionLoad == 1
		let l:out .= '[s]'
	endif
	return l:out
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
