
" Neomake
" ---------

let g:neomake_verbose = 0
let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
let g:neomake_airline = 0
" let g:neomake_logfile = '/tmp/neomake.log'

function! s:filter_item(entry, pattern)
	if a:entry.text =~? a:pattern
		let a:entry.valid = 0
	endif
endfunction

" JAVASCRIPT / JSX
" ----------------
let g:neomake_javascript_eslint_exe = $PWD.'/node_modules/.bin/eslint'
let g:neomake_jsx_enabled_makers = ['eslint']
let g:neomake_javascript_enabled_makers = ['eslint']

" YAML / ANSIBLE
" --------------
let g:neomake_ansible_enabled_makers = ['yamllint']

function! s:yaml_filter(entry)
	let l:ignore_errors = [
		\   'too many spaces inside brac\(ket\|e\)s'
		\ ]
	for l:pattern in l:ignore_errors
		call s:filter_item(a:entry, l:pattern)
	endfor
endfunction
let g:neomake_ansible_yamllint_maker = {
	\ 'args': ['-f', 'parsable'],
	\ 'errorformat': '%E%f:%l:%c: [error] %m,%W%f:%l:%c: [warning] %m',
	\ 'postprocess': function('s:yaml_filter')
	\ }

let g:neomake_yaml_yamllint_maker = g:neomake_ansible_yamllint_maker

" VIM
" ---
function! s:vint_filter(entry)
	let l:ignore_errors = [
		\   'Use scriptencoding when multibyte char',
		\   'Make the scope explicit like',
		\   'Undefined variable: self (see'
		\ ]
	for l:pattern in l:ignore_errors
		call s:filter_item(a:entry, l:pattern)
	endfor
endfunction
let g:neomake_vim_vint_maker = {
	\ 'args': ['--style-problem', '--enable-neovim'],
	\ 'errorformat': '%f:%l:%c: %m,',
	\ 'postprocess': function('s:vint_filter')
	\ }

" HTML
" ----
function! s:tidy_filter(entry)
	let l:ignore_errors = [
		\   '> proprietary attribute "',
		\   '> attribute "lang" lacks value',
		\   '> attribute "href" lacks value',
		\   'trimming empty <'
		\ ]
	for l:pattern in l:ignore_errors
		call s:filter_item(a:entry, l:pattern)
	endfor
endfunction
let g:neomake_html_tidy_maker = {
	\ 'args': ['-e', '-q', '--gnu-emacs', 'true'],
	\ 'errorformat': '%A%f:%l:%c: Warning: %m',
	\ 'postprocess': function('s:tidy_filter')
	\ }

" vim: set ts=2 sw=2 tw=80 noet :
