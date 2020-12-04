" Configuration and plugin-manager manager :)
" ---
" Maintainer: Rafael Bodill
" See: github.com/rafi/vim-config
"
" Plugin-manager agnostic initialization and user configuration parsing

" Set custom augroup
augroup user_events
	autocmd!
augroup END

" Initializes options
let s:package_manager = get(g:, 'etc_package_manager', 'dein')
if empty(s:package_manager) || s:package_manager ==# 'none'
	finish
endif

" Enables 24-bit RGB color in the terminal
if has('termguicolors')
	if empty($COLORTERM) || $COLORTERM =~# 'truecolor\|24bit'
		set termguicolors
	endif
endif

if ! has('nvim')
	set t_Co=256
	" Set Vim-specific sequences for RGB colors
	" Fixes 'termguicolors' usage in vim+tmux
	" :h xterm-true-color
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Disable vim distribution plugins

" let g:loaded_gzip = 1
" let g:loaded_tar = 1
" let g:loaded_tarPlugin = 1
" let g:loaded_zip = 1
" let g:loaded_zipPlugin = 1

let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1

let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1
let g:no_gitrebase_maps = 1

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

" Set main configuration directory as parent directory
let $VIM_PATH =
	\ get(g:, 'etc_vim_path',
	\   exists('*stdpath') ? stdpath('config') :
	\   ! empty($MYVIMRC) ? fnamemodify(expand($MYVIMRC, 1), ':h') :
	\   ! empty($VIMCONFIG) ? expand($VIMCONFIG, 1) :
	\   ! empty($VIM_PATH) ? expand($VIM_PATH, 1) :
	\   fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
	\ )

" Set data/cache directory as $XDG_CACHE_HOME/vim
let $DATA_PATH =
	\ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vim', 1)

" Collection of user plugin list config file-paths
let s:config_paths = get(g:, 'etc_config_paths', [
	\ $VIM_PATH . '/config/plugins.yaml',
	\ $VIM_PATH . '/config/local.plugins.yaml',
	\ $VIM_PATH . '/usr/vimrc.yaml',
	\ $VIM_PATH . '/usr/vimrc.json',
	\ $VIM_PATH . '/vimrc.yaml',
	\ $VIM_PATH . '/vimrc.json',
	\ ])

" Filter non-existent config paths
call filter(s:config_paths, 'filereadable(v:val)')

function! s:main()
	if has('vim_starting')
		" When using VIMINIT trick for exotic MYVIMRC locations, add path now.
		if &runtimepath !~# $VIM_PATH
			set runtimepath^=$VIM_PATH
			set runtimepath+=$VIM_PATH/after
		endif

		" Ensure data directories
		for s:path in [
				\ $DATA_PATH,
				\ $DATA_PATH . '/undo',
				\ $DATA_PATH . '/backup',
				\ $DATA_PATH . '/session',
				\ $DATA_PATH . '/swap',
				\ $VIM_PATH . '/spell' ]
			if ! isdirectory(s:path)
				call mkdir(s:path, 'p', 0770)
			endif
		endfor

		" Python interpreter settings
		if has('nvim')
			" Try the virtualenv created by venv.sh
			let l:virtualenv = $DATA_PATH . '/venv/bin/python'
			if empty(l:virtualenv) || ! filereadable(l:virtualenv)
				" Fallback to old virtualenv location
				let l:virtualenv = $DATA_PATH . '/venv/neovim3/bin/python'
			endif
			if filereadable(l:virtualenv)
				let g:python3_host_prog = l:virtualenv
			endif

		elseif has('pythonx')
			if has('python3')
				set pyxversion=3
			elseif has('python')
				set pyxversion=2
			endif
		endif
	endif

	" Initializes chosen package manager
	call s:use_{s:package_manager}()
endfunction

function! s:use_dein()
	let l:cache_path = $DATA_PATH . '/dein'

	if has('vim_starting')
		" Use dein as a plugin manager
		let g:dein#auto_recache = 1
		let g:dein#install_max_processes = 12

		" Add dein to vim's runtimepath
		if &runtimepath !~# '/dein.vim'
			let s:dein_dir = l:cache_path . '/repos/github.com/Shougo/dein.vim'
			" Clone dein if first-time setup
			if ! isdirectory(s:dein_dir)
				execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
				if v:shell_error
					call s:error('dein installation has failed! is git installed?')
					finish
				endif
			endif

			execute 'set runtimepath+='.substitute(
				\ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
		endif
	endif

	" Initialize dein.vim (package manager)
	if dein#load_state(l:cache_path)
		let l:rc = s:parse_config_files()
		if empty(l:rc)
			call s:error('Empty plugin list')
			return
		endif

		" Start propagating file paths and plugin presets
		call dein#begin(l:cache_path, extend([expand('<sfile>')], s:config_paths))

		for plugin in l:rc
			" If vim already started, don't re-add existing ones
			if has('vim_starting')
					\ || ! has_key(g:dein#_plugins, fnamemodify(plugin['repo'], ':t'))
				call dein#add(plugin['repo'], extend(plugin, {}, 'keep'))
			endif
		endfor

		" Add any local ./dev plugins
		if isdirectory($VIM_PATH . '/dev')
			call dein#local($VIM_PATH . '/dev', { 'frozen': 1, 'merged': 0 })
		endif
		call dein#end()

		" Save cached state for faster startups
		if ! g:dein#_is_sudo
			call dein#save_state()
		endif

		" Update or install plugins if a change detected
		if dein#check_install()
			if ! has('nvim')
				set nomore
			endif
			call dein#install()
		endif
	endif
endfunction

function! s:use_plug() abort
	" vim-plug package-manager initialization
	let l:cache_root = $DATA_PATH . '/plug'
	let l:cache_init = l:cache_root . '/init.vimplug'
	let l:cache_repos = l:cache_root . '/repos'

	augroup user_plugin_vimplug
		autocmd!
	augroup END

	if &runtimepath !~# '/init.vimplug'

		if ! isdirectory(l:cache_init)
			silent !curl -fLo $DATA_PATH/plug/init.vimplug/autoload/plug.vim
				\ --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

			autocmd user_plugin_vimplug VimEnter * PlugInstall --sync | source $MYVIMRC
		endif

		execute 'set runtimepath+='.substitute(
			\ fnamemodify(l:cache_init, ':p') , '/$', '', '')
	endif

	let l:rc = s:parse_config_files()
	if empty(l:rc)
		call s:error('Empty plugin list')
		return
	endif

	call plug#begin(l:cache_repos)
	for plugin in l:rc
		call plug#(plugin['repo'], extend(plugin, {}, 'keep'))
	endfor
	call plug#end()
endfunction

function! s:parse_config_files()
	let l:merged = []
	try
		" Merge all lists of plugins together
		for l:cfg_file in s:config_paths
			let l:merged = extend(l:merged, s:load_config(l:cfg_file))
		endfor
	catch /.*/
		call s:error(
			\ 'Unable to read configuration files at ' . string(s:config_paths))
		echoerr v:exception
	endtry

	" If there's more than one config file source,
	" de-duplicate plugins by repo key.
	if len(s:config_paths) > 1
		call s:dedupe_plugins(l:merged)
	endif
	return l:merged
endfunction

function! s:dedupe_plugins(list)
	let l:list = reverse(a:list)
	let l:i = 0
	let l:seen = {}
	while i < len(l:list)
		let l:key = list[i]['repo']
		if l:key !=# '' && has_key(l:seen, l:key)
			call remove(l:list, i)
		else
			if l:key !=# ''
				let l:seen[l:key] = 1
			endif
			let l:i += 1
		endif
	endwhile
	return reverse(l:list)
endfunction

" General utilities, mainly for dealing with user configuration parsing
" ---

function! s:error(msg)
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[config/init] ' . l:mes | echohl None
	endfor
endfunction

function! s:debug(msg)
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[config/init] ' . l:mes | echohl None
	endfor
endfunction

function! s:load_config(filename)
	" Parse YAML/JSON config file
	if a:filename =~# '\.json$'
		" Parse JSON with built-in json_decode
		let l:json = readfile(a:filename)
		return has('nvim') ? json_decode(l:json) : json_decode(join(l:json))
	elseif a:filename =~# '\.ya\?ml$'
		" Parse YAML with common command-line utilities
		return s:load_yaml(a:filename)
	endif
	call s:error('Unknown config file format ' . a:filename)
	return ''
endfunction

function! s:str2list(expr)
	" Convert string to list
	return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction

" YAML related
" ---

let s:convert_tool = ''

function! s:load_yaml(filename)
	if empty(s:convert_tool)
		let s:convert_tool = s:find_yaml2json_method()
	endif

	if s:convert_tool ==# 'ruby'
		let l:cmd = "ruby -e 'require \"json\"; require \"yaml\"; ".
			\ "print JSON.generate YAML.load \$stdin.read'"
	elseif s:convert_tool ==# 'python'
		let l:cmd = "python -c 'import sys,yaml,json; y=yaml.safe_load(sys.stdin.read()); print(json.dumps(y))'"
	elseif s:convert_tool ==# 'yq'
		let l:cmd = 'yq r -j -'
	else
		let l:cmd = s:convert_tool
	endif

	try
		let l:raw = readfile(a:filename)
		return json_decode(system(l:cmd, l:raw))
	catch /.*/
		call s:error([
			\ string(v:exception),
			\ 'Error loading ' . a:filename,
			\ 'Caught: ' . string(v:exception),
			\ ])
	endtry
endfunction

function! s:find_yaml2json_method()
	if exists('*json_decode')
		" Try different tools to convert YAML into JSON:
		if executable('yj')
			" See https://github.com/sclevine/yj
			return 'yj'
		elseif executable('yq')
			" See https://github.com/mikefarah/yq
			return 'yq'
		elseif executable('yaml2json') && s:test_yaml2json()
			" See https://github.com/bronze1man/yaml2json
			return 'yaml2json'
		" Or, try ruby. Which is installed on every macOS by default
		" and has yaml built-in.
		elseif executable('ruby') && s:test_ruby_yaml()
			return 'ruby'
		" Or, fallback to use python3 and PyYAML
		elseif executable('python') && s:test_python_yaml()
			return 'python'
		endif
		call s:error([
			\ 'Unable to find a proper YAML parsing utility.',
			\ 'Please run: pip3 install --user PyYAML',
			\ ])
	else
		call s:error('"json_decode" unsupported. Upgrade to latest Neovim or Vim')
	endif
endfunction

function! s:test_yaml2json()
	" Test yaml2json capabilities
	try
		let result = system('yaml2json', "---\na: 1.5")
		if v:shell_error != 0
			return 0
		endif
		let result = json_decode(result)
		return result.a == 1.5
	catch
	endtry
	return 0
endfunction

function! s:test_ruby_yaml()
	" Test Ruby YAML capabilities
	call system("ruby -e 'require \"json\"; require \"yaml\"'")
	return v:shell_error == 0
endfunction

function! s:test_python_yaml()
	" Test Python YAML capabilities
	call system("python -c 'import sys,yaml,json'")
	return v:shell_error == 0
endfunction

call s:main()

" vim: set ts=2 sw=2 tw=80 noet :
