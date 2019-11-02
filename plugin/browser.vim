" Browser and SCM Repository Detection
" ---
" Written by Rafael Bodill, justrafi+vim at gmail
" Opens a browser with SCM detection capabilities
"
" Options:
" - g:git_exec Git executable
" - g:hg_exec Mercurial executable

" Default VIM commands
command! -nargs=1 Open call <SID>open(<q-args>)
command! -range -nargs=? -complete=file OpenSCM
	\ call <SID>open_scm(<line1>, <line2>, <q-args>)

" Default various SCM executables
let s:git_exec = get(g:, 'git_exec', 'git')
let s:hg_exec = get(g:, 'hg_exec', 'hg')

function! s:open_scm(line1, line2, ...)
	" Open SCM repository with fine detail: Branch, file, line
	let l:path = expand(empty(a:1) ? '%' : a:1)
	let l:dir = isdirectory(l:path) ? l:path : fnamemodify(l:path, ':h')
	let l:scm_name = s:detect_scm(l:dir)
	if empty(l:scm_name)
		echohl WarningMsg | echomsg 'Unknown SCM, aborting.' | echohl None
		return
	endif

	" Parse SCM repository address and return proper URL
	let l:scm = s:parse_{l:scm_name}_url(l:dir)

	" Detect website and open it in browser
	let l:site_name = s:detect_site(l:scm['url'])
	if empty(l:site_name)
		call s:open(l:scm['url'])
	else
		let l:line_range = isdirectory(l:path) ? [] : [ a:line1, a:line2 ]
		let l:url = s:build_{l:site_name}_url(
			\ l:scm['url'], l:scm['ref'], l:path, l:line_range)
		call s:open(l:url)
	endif
endfunction

function! s:detect_scm(path)
	" Detect SCM in path given
	let l:path = shellescape(a:path)
	let l:scms = {
		\ 'git': s:git_exec . ' -C ' . l:path . ' rev-parse --is-inside-work-tree',
		\ }

	for [ l:name, l:cmd ] in items(l:scms)
		call system(l:cmd)
		if ! v:shell_error
			return l:name
		endif
	endfor
endfunction

function! s:detect_site(url)
	" Detect a well-known website
	for [ l:site, l:pat ] in [
			\   [ 'github', 'github\.com' ],
			\   [ 'bitbucket', 'bitbucket\.org' ],
			\ ]

		if a:url =~ l:pat
			return l:site
		endif
	endfor
endfunction

function! s:open(url)
	" Opens a file protocol on various operating-systems
	if empty(a:url)
		echohl WarningMsg | echomsg 'Please provide a URL to open' | echohl None
		return
	endif
	let l:url = shellescape(a:url)
	let l:cmd = get(g:, 'browser_command', '')
	if l:cmd ==# ''
		if has('win32') || has('win64')
			let l:cmd = '!start rundll32 url.dll,FileProtocolHandler ' . l:url
			silent! exec l:cmd
		elseif has('mac') || has('macunix') || has('gui_macvim')
			let l:cmd = 'open ' . l:url
			call system(l:cmd)
		elseif executable('xdg-open')
			let l:cmd = 'xdg-open ' . l:url
			call system(l:cmd)
		elseif executable('firefox')
			let l:cmd = 'firefox ' . l:url . ' &'
			call system(l:cmd)
		else
			echohl WarningMsg
			echomsg 'It seems that you don''t have a web browser, use this URL:'
			echohl None
			echo a:url
		endif
	endif
endfunction

function! s:build_bitbucket_url(url, ref, path, line_range)
	" Concat detailed Bitbucket URL
	let l:url = a:url . '/src/' . a:ref . '/' . a:path
	if ! empty(a:line_range) && ! empty(a:line_range[0])
		" Use line number range
		let l:url .= '#lines-' . string(a:line_range[0])
		if ! empty(a:line_range[1]) && a:line_range[0] != a:line_range[1]
			let l:url .= ':L' . string(a:line_range[1])
		endif
	endif
	return l:url
endfunction

function! s:build_github_url(url, ref, path, line_range)
	" Concat detailed GitHub URL
	let l:url = a:url
	if isdirectory(a:path)
		let l:url .= '/tree/' . a:ref
	else
		" Found file-path
		let l:url .= '/blob/' . a:ref . '/' . a:path
		if ! empty(a:line_range) && ! empty(a:line_range[0])
			" Use line number range
			let l:url .= '#L' . string(a:line_range[0])
			if ! empty(a:line_range[1]) && a:line_range[0] != a:line_range[1]
				let l:url .= '-L' . string(a:line_range[1])
			endif
		endif
	endif
	return l:url
endfunction

function! s:parse_common_remotes(remote)
	let l:pats = [
		\ [ '\v(\w+:\/\/)(.+\@)*([a-z0-9.]+)(\:[0-9]+)?\/*(.*)', 'https://\3/\5' ],
		\ [ '\v([a-z0-9.]+\@)*([a-z0-9.]+)\:(.*)', 'https://\2/\3' ]
		\ ]

	" Normalize remote URL
	for l:pat in l:pats
		if match(a:remote, l:pat[0]) > -1
			return substitute(a:remote, l:pat[0], l:pat[1], '')
		endif
	endfor
endfunction

function! s:parse_git_url(path)
	" Git: Parse remote URL
	let l:remote = system(s:git_exec . ' -C ' . a:path . ' ls-remote --get-url')
	let l:remote = trim(l:remote)
	let l:url = s:parse_common_remotes(l:remote)
	if empty(l:url)
		echohl WarningMsg
		echomsg 'Unable to identify a valid remote url' l:remote
		echohl None
		return
	endif
	let l:url = substitute(l:url, '\.git\/\?', '', '')

	" Find branch name
	let l:ref = system(s:git_exec . ' -C ' . a:path . ' symbolic-ref -q HEAD')
	let l:ref = substitute(l:ref, '^refs\/heads\/\(\w\+\)\W*$', '\1', '')

	if ! empty(l:ref) && ! v:shell_error
		return { 'url': l:url, 'ref': l:ref }
	endif
	echohl WarningMsg
	echomsg 'Unable to find HEAD reference with' s:git_exec
	echohl None
endfunction

function s:parse_hg_url(path)
	" Mercurial: Parse URL
	" TODO
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
