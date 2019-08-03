" vim-etc - configuration and plugin-manager manager :)
" ---
" Maintainer: Rafael Bodill
" See: github.com/rafi/vim-config
"
" General utilities, mainly for dealing with user configuration parsing

function! etc#util#error(msg) abort
	for l:mes in etc#util#str2list(a:msg)
		echohl WarningMsg | echomsg '[vim-etc] ' . l:mes | echohl None
	endfor
endfunction

function! etc#util#debug(msg) abort
	for l:mes in etc#util#str2list(a:msg)
		echohl WarningMsg | echomsg '[vim-etc] ' . l:mes | echohl None
	endfor
endfunction

function! etc#util#ensure_directory(paths) abort
	for l:path in etc#util#str2list(a:paths)
		if ! isdirectory(l:path)
			call mkdir(l:path, 'p')
		endif
	endfor
endfunction

function! etc#util#load_config(filename) abort
	" Parse YAML/JSON config file
	if a:filename =~# '\.json$'
		" Parse JSON with built-in json_decode
		let l:json = readfile(a:filename)
		return has('nvim') ? json_decode(l:json) : json_decode(join(l:json))
	elseif a:filename =~# '\.ya\?ml$'
		" Parse YAML with common command-line utilities
		return etc#util#load_yaml(a:filename)
	endif
	call etc#util#error('Unknown config file format ' . a:filename)
	return ''
endfunction

function! etc#util#str2list(expr) abort
	" Convert string to list
	return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction

function! etc#util#source_file(path, ...) abort
	" Source user configuration files with set/global sensitivity
	let use_global = get(a:000, 0, ! has('vim_starting'))
	let abspath = resolve(g:etc#vim_path . '/' . a:path)
	if ! use_global
		execute 'source' fnameescape(abspath)
		return
	endif

	let tempfile = tempname()
	let content = map(readfile(abspath),
		\ "substitute(v:val, '^\\W*\\zsset\\ze\\W', 'setglobal', '')")
	try
		call writefile(content, tempfile)
		execute printf('source %s', fnameescape(tempfile))
	finally
		if filereadable(tempfile)
			call delete(tempfile)
		endif
	endtry
endfunction

" YAML related
" ---

let g:yaml2json_method = ''

function! etc#util#load_yaml(filename) abort
	if empty(g:yaml2json_method)
		let g:yaml2json_method = etc#util#_find_yaml2json_method()
	endif

	if g:yaml2json_method ==# 'ruby'
		let l:cmd = "ruby -e 'require \"json\"; require \"yaml\"; ".
			\ "print JSON.generate YAML.load \$stdin.read'"
	elseif g:yaml2json_method ==# 'python'
		let l:cmd = "python -c 'import sys,yaml,json; y=yaml.safe_load(sys.stdin.read()); print(json.dumps(y))'"
	elseif g:yaml2json_method ==# 'yq'
		let l:cmd = 'yq r -j -'
	else
		let l:cmd = g:yaml2json_method
	endif

	try
		let l:raw = readfile(a:filename)
		return json_decode(system(l:cmd, l:raw))
	catch /.*/
		call etc#util#error([
			\ string(v:exception),
			\ 'Error loading ' . a:filename,
			\ 'Caught: ' . string(v:exception),
			\ 'Please run: pip install --user PyYAML',
			\ ])
	endtry
endfunction

function! etc#util#_find_yaml2json_method() abort
	if exists('*json_decode')
		" First, try to decode YAML using a CLI tool named yaml2json, there's many
		if executable('yaml2json') && etc#util#_test_yaml2json()
			return 'yaml2json'
		elseif executable('yq')
			return 'yq'
		" Or, try ruby. Which is installed on every macOS by default
		" and has ruby built-in.
		elseif executable('ruby') && etc#util#_test_ruby_yaml()
			return 'ruby'
		" Or, fallback to use python3 and PyYAML
		elseif executable('python') && etc#util#_test_python_yaml()
			return 'python'
		endif
		call etc#util#error('Unable to find a proper YAML parsing utility')
	endif
	call etc#util#error('Please upgrade to neovim +v0.1.4 or vim: +v7.4.1304')
endfunction

function! etc#util#_test_yaml2json() abort
	" Test yaml2json capabilities
	try
		let result = system('yaml2json', "---\ntest: 1")
		if v:shell_error != 0
			return 0
		endif
		let result = json_decode(result)
		return result.test
	catch
	endtry
	return 0
endfunction

function! etc#util#_test_ruby_yaml() abort
	" Test Ruby YAML capabilities
	call system("ruby -e 'require \"json\"; require \"yaml\"'")
	return (v:shell_error == 0) ? 1 : 0
endfunction

function! etc#util#_test_python_yaml() abort
	" Test Python YAML capabilities
	call system("python -c 'import sys,yaml,json'")
	return (v:shell_error == 0) ? 1 : 0
endfunction
