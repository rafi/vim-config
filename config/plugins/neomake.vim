
" Neomake
" ---------
let g:neomake_verbose = 1
let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 1
let g:airline#extensions#neomake#enabled = 0

" JAVASCRIPT / JSX
" ----------------
let g:neomake_jsx_enabled_makers = ['eslint']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_exe = './node_modules/.bin/eslint'

" YAML / ANSIBLE
" --------------
let g:neomake_yaml_enabled_makers = ['yamllint']
let g:neomake_ansible_enabled_makers = ['yamllint']
let g:neomake_ansible_yamllint_maker = neomake#makers#ft#yaml#yamllint()

" HTML
" ----
function! s:filter_item(entry, pattern)
	if a:entry.text =~? a:pattern
		let a:entry.valid = 0
	endif
endfunction

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
