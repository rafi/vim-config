" vim-badge - Bite-size badges for tab & status lines
" Maintainer: Rafael Bodill <justrafi at gmail dot com>
"-------------------------------------------------

" Configuration

" Maximum number of directories in filepath
let g:badge_status_filename_max_dirs =
	\ get(g:, 'badge_status_filename_max_dirs', 3)

" Maximum number of characters in each directory
let g:badge_status_dir_max_chars = get(g:, 'badge_status_dir_max_chars', 5)

" Less verbosity on specific filetypes (regexp)
let g:badge_filetype_blacklist = get(g:, 'badge_filetype_blacklist', '')

let g:badge_loading_charset =
	\ get(g:, 'badge_loading_charset',
	\ ['⠃', '⠁', '⠉', '⠈', '⠐', '⠠', '⢠', '⣠', '⠄', '⠂'])

let s:badge_scrollbar_charset =
	\ get(g:, 'badge_scrollbar_charset', [
	\ '_', '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'])

let g:badge_nofile = get(g:, 'badge_nofile', 'N/A')

let g:badge_project_separator = get(g:, 'badge_project_separator', '')

" Private variables
let s:caches = []

" Clear cache on save
augroup statusline_cache
	autocmd!
	autocmd BufWritePre,FileChangedShellPost,TextChanged,InsertLeave *
		\ unlet! b:badge_cache_trails
	autocmd BufReadPost,BufFilePost,BufNewFile,BufWritePost *
		\ for cache_name in s:caches | execute 'unlet! b:' . cache_name | endfor
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
	if &filetype ==# 'magit'
	"	let l:map = {}
	"	for l:file in magit#git#get_status()
	"		let l:map[l:file['unstaged']] = get(l:map, l:file['unstaged'], 0) + 1
	"	endfor
	"	for l:status in l:map
	"		let l:out = values(l:map)
	"	endfor
	else
		if exists('*gitgutter#hunk#summary')
			let l:summary = gitgutter#hunk#summary(bufnr('%'))
			for l:idx in range(0, len(l:summary) - 1)
				if l:summary[l:idx] > 0
					let l:out .= ' ' . l:icons[l:idx] . l:summary[l:idx]
				endif
			endfor
		endif
	endif
	return trim(l:out)
endfunction

function! badge#filename(...) abort
	" Provides relative path with limited characters in each directory name, and
	" limits number of total directories. Caches the result for current buffer.
	" Parameters:
	"   1: Buffer number, ignored if tab number supplied
	"   2: Maximum characters displayed in base filename
	"   3: Maximum characters displayed in each directory
	"   4: Cache key

	" Compute buffer id
	let l:bufnr = '%'
	if a:0 > 0
		let l:bufnr = a:1
	endif

	let l:filetype = getbufvar(l:bufnr, '&filetype')

	" Use buffer's cached filepath
	let l:cache_var_name = a:0 > 3 ? a:4 : 'filename'
	let l:cache_var_name =
		\ tolower('badge_cache_' . l:filetype . '_' . l:cache_var_name)
	let l:cache_var_name = substitute(l:cache_var_name, '[^a-z]', '_', 'g')

	let l:fn = getbufvar(l:bufnr, l:cache_var_name, '')
	if len(l:fn) > 0
		return l:fn
	endif

	let l:bufname = bufname(l:bufnr)

	if empty(getbufvar(l:bufnr, '&buftype')) && empty(l:bufname)
		" Placeholder for empty buffer
		let l:fn = g:badge_nofile
	else
		" Shorten dir names
		let l:max = a:0 > 2 ? a:3 : g:badge_status_dir_max_chars
		let short = substitute(l:bufname,
			\ "[^/]\\{" . l:max . "}\\zs[^/]\*\\ze/", '', 'g')

		" Decrease dir count
		let l:max = a:0 > 1 ? a:2 : g:badge_status_filename_max_dirs
		let parts = split(short, '/')
		if len(parts) > l:max
			let parts = parts[-l:max-1 : ]
		endif

		" Set icon
		let l:icon = ''
		if l:filetype ==# 'fern'
			let l:icon = ''
		elseif l:filetype ==# 'undotree'
			let l:icon = ''
		elseif l:filetype ==# 'qf'
			let l:icon = ''
			let parts = [ 'List' ]
		elseif l:filetype ==# 'TelescopePrompt'
			let l:icon = ''
			let parts = [ 'Telescope' ]
		elseif l:filetype ==# 'Trouble'
			let l:icon = ''
		elseif l:filetype ==# 'DiffviewFiles'
			let l:icon = ''
		elseif l:filetype ==# 'Outline'
			let l:icon = ''
		elseif l:filetype ==# 'NeogitStatus'
			let l:icon = ''
		elseif l:filetype ==# 'lsp-installer'
			let l:icon = ''
			let parts = [ 'LSP Installer' ]
		elseif l:filetype ==# 'spectre_panel'
			let l:icon = ''
			let parts = [ 'Spectre' ]
		elseif l:filetype ==# 'neo-tree'
			let l:icon = ''
		elseif l:filetype ==# 'neo-tree-popup'
			let l:icon = ''
			let parts = [ 'neo-tree' ]
		elseif get(g:, 'nvim_web_devicons')
			let l:icon = luaeval(
				\ 'require"nvim-web-devicons".get_icon(_A[1], _A[2], { default = true })',
				\ [fnamemodify(l:bufname, ':t:r'), fnamemodify(l:bufname, ':e')])
		elseif exists('*nerdfont#find')
			let l:icon = nerdfont#find(l:bufname)
		elseif exists('*defx_icons#get')
			let l:icon = get(defx_icons#get().icons.extensions, expand('%:e'), {})
			let l:icon = get(l:icon, 'icon', '')
		endif
		if ! empty(l:icon)
			let l:fn .= l:icon . get(g:, 'global_symbol_padding', ' ')
		endif

		let l:fn .= join(parts, '/')
	endif

	" Cache and return the final result
	call setbufvar(l:bufnr, l:cache_var_name, l:fn)
	if index(s:caches, l:cache_var_name) == -1
		call add(s:caches, l:cache_var_name)
	endif
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
			let match = is_dir ? finddir(pattern, curr_dir . ';')
				\ : findfile(pattern, curr_dir . ';')
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
		if exists('*gina#component#repo#branch')
			return gina#component#repo#branch()
		elseif exists('*gitbranch#name')
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
	" Returns syntax warnings from several plugins
	" Supports vim-lsp, ALE, Neomake, and Syntastic
	if &filetype =~? g:badge_filetype_blacklist
		return ''
	endif

	let l:msg = ''
	let l:errors = 0
	let l:warnings = 0
	let l:hints = 0
	let l:info = 0
	if exists('*luaeval')
			\ && luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
		" See :h diagnostic-severity
		let l:errors = luaeval('#vim.diagnostic.get(0, {severity=vim.diagnostic.severity.ERROR})')
		let l:warnings = luaeval('#vim.diagnostic.get(0, {severity=vim.diagnostic.severity.WARN})')
	elseif exists('*lsp#get_buffer_diagnostics_counts')
			\ && get(g:, 'lsp_diagnostics_enabled', 1)
		let l:counts = lsp#get_buffer_diagnostics_counts()
		let l:errors = get(l:counts, 'error', '')
		let l:warnings = get(l:counts, 'warning', '')
		let l:hints = get(l:counts, 'hint', '')
		let l:info = get(l:counts, 'information', '')
	elseif exists('*neomake#Make')
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
		let l:msg .= printf('%%#LspDiagnosticsDefaultError# %d%%* ', l:errors)
	endif
	if l:warnings > 0
		let l:msg .= printf('%%#LspDiagnosticsDefaultWarning# %d%%* ', l:warnings)
	endif
	if l:hints > 0
		let l:msg .= printf('%%#LspDiagnosticsDefaultHint# %d%%* ', l:hints)
	endif
	if l:info > 0
		let l:msg .= printf('%%#LspDiagnosticsDefaultInformation# %d%%* ', l:info)
	endif
	return l:msg
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

	if exists('*lsp#get_progress')
		let s:lsp_progress = lsp#get_progress()
		if len(s:lsp_progress) > 0 && has_key(s:lsp_progress[0], 'message')
			" Show only last progress message
			let s:lsp_progress = s:lsp_progress[0]
			let l:percent = get(s:lsp_progress, 'percentage')
			if ! empty(s:lsp_progress['message']) && l:percent != 100
				let l:out .= s:lsp_progress['server'] . ':'
					\ . s:lsp_progress['title'] . ' '
					\ . s:lsp_progress['message']
					\ . l:percent
				if l:percent >= 0
					let l:out .= ' ' . string(l:percent) . '%'
				endif
			endif
		endif
	endif
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

" Credits: https://github.com/glepnir/galaxyline.nvim
function! badge#scrollbar() abort
	let l:index = 0
	let l:current_line = line('.')
	let l:total_lines = line('$')
	let l:total_chars = len(s:badge_scrollbar_charset)
	if l:total_lines == 1
		return '·'  "•
	elseif l:current_line == l:total_lines
		let l:index = l:total_chars - 1
	else
	let l:line_ratio = floor(l:current_line) / floor(l:total_lines)
	let l:index = float2nr(l:line_ratio * l:total_chars)
	endif
	return s:badge_scrollbar_charset[l:index]
endfunction

function! s:numtr(number, charset) abort
	let l:result = ''
	for l:char in split(a:number, '\zs')
		let l:result .= a:charset[l:char]
	endfor
	return l:result
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
