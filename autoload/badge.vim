" vim-badge - Bite-size badges for tab & status lines
" Maintainer: Rafael Bodill <justrafi at gmail dot com>
"-------------------------------------------------

" Configuration

" Limit display of directories in path
let g:badge_tab_filename_max_dirs =
	\ get(g:, 'badge_tab_filename_max_dirs', 1)

" Limit display of characters in each directory in path
let g:badge_tab_dir_max_chars =
	\ get(g:, 'badge_tab_dir_max_chars', 5)

" Maximum number of directories in filepath
let g:badge_status_filename_max_dirs =
	\ get(g:, 'badge_status_filename_max_dirs', 3)

" Maximum number of characters in each directory
let g:badge_status_dir_max_chars =
	\ get(g:, 'badge_status_dir_max_chars', 5)

" Less verbosity on specific filetypes (regexp)
let g:badge_filetype_blacklist =
	\ get(g:, 'badge_filetype_blacklist',
	\ 'qf\|help\|vimfiler\|gundo\|diff\|fugitive\|gitv')

let g:badge_numeric_charset =
	\ get(g:, 'badge_numeric_charset',
	\ ['⁰','¹','²','³','⁴','⁵','⁶','⁷','⁸','⁹'])
	"\ ['₀','₁','₂','₃','₄','₅','₆','₇','₈','₉'])

let g:badge_loading_charset =
	\ get(g:, 'badge_loading_charset',
	\ ['⠃', '⠁', '⠉', '⠈', '⠐', '⠠', '⢠', '⣠', '⠄', '⠂'])

let g:badge_nofile = get(g:, 'badge_nofile', 'N/A')

let g:badge_project_separator = get(g:, 'badge_project_separator', '')

" Clear cache on save
augroup statusline_cache
	autocmd!
	autocmd BufWritePre,FileChangedShellPost * unlet! b:badge_cache_trails
	autocmd BufReadPost,BufFilePost,BufNewFile,BufWritePost *
		\ unlet! b:badge_cache_filename b:badge_cache_tab
augroup END

function! badge#project() abort
	" Try to guess the project's name

	let dir = badge#root()
	return fnamemodify(dir ? dir : getcwd(), ':t')
endfunction

function! badge#gitstatus(...) abort
	" Display git status indicators

	let l:icons = ['₊', '∗', '₋']  " added, modified, removed
	let l:out = ''
	" if &filetype ==# 'magit'
	"	let l:map = {}
	"	for l:file in magit#git#get_status()
	"		let l:map[l:file['unstaged']] = get(l:map, l:file['unstaged'], 0) + 1
	"	endfor
	"	for l:status in l:map
	"		let l:out = values(l:map)
	"	endfor
	" else
		if exists('*gitgutter#hunk#summary')
			let l:summary = gitgutter#hunk#summary(bufnr('%'))
			for l:idx in range(0, len(l:summary) - 1)
				if l:summary[l:idx] > 0
					let l:out .= ' ' . l:icons[l:idx] . l:summary[l:idx]
				endif
			endfor
		endif
	" endif
	return trim(l:out)
endfunction

function! badge#filename(...) abort
	" Provides relative path with limited characters in each directory name, and
	" limits number of total directories. Caches the result for current buffer.
	" Parameters:
	"   1: Buffer number, ignored if tab number supplied
	"   2: Tab number
	"   3: Enable to append total window count in tab
	"   4: Include project directory if different from current

	" Compute buffer name
	if a:0 > 1
		let l:buflist = tabpagebuflist(a:2)
		let l:bufnr = l:buflist[tabpagewinnr(a:2) - 1]
	elseif a:0 == 1
		let l:bufnr = a:1
	elseif a:0 == 0
		let l:bufnr = '%'
	endif

	" Use buffer's cached filepath
	let l:cache_var_name = 'badge_cache_' . (a:0 > 1 ? 'tab' : 'filename')
	let l:fn = getbufvar(l:bufnr, l:cache_var_name, '')
	if len(l:fn) > 0
		return l:fn
	endif

	let l:bufname = bufname(l:bufnr)
	let l:filetype = getbufvar(l:bufnr, '&filetype')

	if a:0 < 2 && l:filetype =~? g:badge_filetype_blacklist
		" Empty if owned by certain plugins
		let l:fn = ''
	elseif a:0 < 2 && l:filetype ==# 'defx'
		let l:defx = getbufvar(l:bufnr, 'defx')
		let l:fn = get(get(l:defx, 'context', {}), 'buffer_name')
		unlet! l:defx
	elseif a:0 < 2 && l:filetype ==# 'magit'
		let l:fn = magit#git#top_dir()
	elseif a:0 < 2 && l:filetype ==# 'vimfiler'
		let l:fn = vimfiler#get_status_string()
	elseif empty(l:bufname)
		" Placeholder for empty buffer
		let l:fn = g:badge_nofile
	else
		" let l:icons = defx_icons#get()
		" Shorten dir names
		let l:max = a:0 > 1 ?
			\ g:badge_tab_dir_max_chars : g:badge_status_dir_max_chars
		let short = substitute(l:bufname,
			\ "[^/]\\{" . l:max . "}\\zs[^/]\*\\ze/", '', 'g')

		" Decrease dir count
		let l:max = a:0 > 1 ?
			\ g:badge_tab_filename_max_dirs : g:badge_status_filename_max_dirs
		let parts = split(short, '/')
		if len(parts) > l:max
			let parts = parts[-l:max-1 : ]
		endif
		let l:fn = join(parts, '/')
	endif

	" Append fugitive blob type
	let l:fugitive = getbufvar(l:bufnr, 'fugitive_type')
	if l:fugitive ==# 'blob'
		let l:fn .= ' (blob)'
	endif

	" Append window count, for tabs
	if a:0 > 2 && a:3
		let l:win_count = tabpagewinnr(a:2, '$')
		if l:win_count > 1
			let l:fn .= s:numtr(l:win_count, g:badge_numeric_charset)
		endif
	endif

	" Prepend project dir, for tabs
	if a:0 > 3 && a:4
		" g:badge_project_separator
		" let project_dir = getbufvar(a:n, 'project_dir')
		" if strridx(filepath, project_dir) == 0
		"	let filepath = strpart(filepath, len(project_dir))
		"	let project .= fnamemodify(project_dir, ':t') . (a:0 > 0 ? a:1 : '|')
		"	let l:fn = project . l:fn
		"	endif
	endif

	" Cache and return the final result
	call setbufvar(l:bufnr, l:cache_var_name, l:fn)
	return l:fn
endfunction

function! badge#root() abort
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

function! badge#branch() abort
	" Returns git branch name, using different plugins.

	if &filetype !~? g:badge_filetype_blacklist
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

function! badge#syntax() abort
	" Returns syntax warnings from several plugins (ALE, Neomake, Syntastic)
	if &filetype =~? g:badge_filetype_blacklist
		return ''
	endif

	let l:msg = ''
	let l:errors = 0
	let l:warnings = 0
	if exists('*neomake#Make')
		let l:counts = neomake#statusline#get_counts(bufnr('%'))
		let l:errors = get(l:counts, 'E', '')
		let l:warnings = get(l:counts, 'W', '')
	elseif exists('g:loaded_ale')
		let l:counts = ale#statusline#Count(bufnr('%'))
		let l:errors = l:counts.error + l:counts.style_error
		let l:warnings = l:counts.total - l:errors
	elseif exists('*SyntasticStatuslineFlag')
		let l:msg = SyntasticStatuslineFlag()
	endif
	if l:errors > 0
		let l:msg .= printf(' %d ', l:errors)
	endif
	if l:warnings > 0
		let l:msg .= printf(' %d ', l:warnings)
	endif
	return substitute(l:msg, '\s*$', '', '')
endfunction

function! badge#trails(...) abort
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

function! badge#modified(...) abort
	" Make sure we ignore &modified when choosewin is active
	" Parameters:
	"   Modified symbol, default: +

	let label = a:0 == 1 ? a:1 : '+'
	let choosewin = exists('g:choosewin_active') && g:choosewin_active
	return &modified && ! choosewin ? label : ''
endfunction

function! badge#mode(...) abort
	" Returns file's mode: read-only and/or zoomed
	" Parameters:
	"   Read-only symbol, default: R
	"   Zoomed buffer symbol, default: Z

	let s:modes = ''
	if &filetype !~? g:badge_filetype_blacklist && &readonly
		let s:modes .= a:0 > 0 ? a:1 : 'R'
	endif
	if exists('t:zoomed') && bufnr('%') == t:zoomed.nr
		let s:modes .= a:0 > 1 ? a:2 : 'Z'
	endif

	return s:modes
endfunction

function! badge#format() abort
	" Returns file format

	return &filetype =~? g:badge_filetype_blacklist ? '' : &fileformat
endfunction

function! badge#session(...) abort
	" Returns an indicator for active session
	" Parameters:
	"   Active session symbol, default: [S]

	return empty(v:this_session) ? '' : a:0 == 1 ? a:1 : '[S]'
endfunction

function! badge#indexing() abort
	let l:out = ''

	if exists('*gutentags#statusline')
		let l:tags = gutentags#statusline('[', ']')
		if ! empty(l:tags)
			if exists('*reltime')
				let s:wait = split(reltimestr(reltime()), '\.')[1] / 100000
			else
				let s:wait = get(s:, 'wait', 9) == 9 ? 0 : s:wait + 1
			endif
			let l:out .= get(g:badge_loading_charset, s:wait, '') . ' ' . l:tags
		endif
	endif
	if exists('*coc#status')
		let l:out .= coc#status()
	endif
	if exists('g:SessionLoad') && g:SessionLoad == 1
		let l:out .= '[s]'
	endif
	return l:out
endfunction

function! s:numtr(number, charset) abort
	let l:result = ''
	for l:char in split(a:number, '\zs')
		let l:result .= a:charset[l:char]
	endfor
	return l:result
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
