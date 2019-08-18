" vim-etc - configuration and plugin-manager manager :)
" ---
" Maintainer: Rafael Bodill
" See: github.com/rafi/vim-config
"
" Plugin-manager agnostic initialization and user configuration parsing

" Initializes global vim-etc options
let g:etc#package_manager = get(g:, 'etc#package_manager', 'dein')

let g:etc#vim_path =
	\ get(g:, 'etc#vimpath',
	\   exists('*stdpath') ? stdpath('config') :
	\   ! empty($MYVIMRC) ? fnamemodify(expand($MYVIMRC), ':h') :
	\   ! empty($VIMCONFIG) ? expand($VIMCONFIG) :
	\   ! empty($VIM_PATH) ? expand($VIM_PATH) :
	\   expand('$HOME/.vim')
	\ )

let g:etc#cache_path =
	\ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache').'/vim')

let g:etc#config_paths = get(g:, 'etc#config_paths', [
	\ 'config/plugins.yaml',
	\ 'config/local.plugins.yaml',
	\ 'usr/vimrc.yaml',
	\ 'usr/vimrc.json',
	\ 'vimrc.yaml',
	\ 'vimrc.json',
	\ ])

function! etc#init() abort
	if empty(g:etc#package_manager) || g:etc#package_manager ==# 'none'
		return
	endif

	let l:config_paths = map(
		\   copy(g:etc#config_paths),
		\   'g:etc#vim_path ."/". v:val'
		\ )
	call filter(l:config_paths, 'filereadable(v:val)')

	call etc#providers#{g:etc#package_manager}#_init(l:config_paths)
endfunction

function! etc#_parse_config_files(config_paths) abort
	let l:merged = []
	try
		" Merge all lists of plugins together (see g:etc#config_paths)
		for l:cfg_file in a:config_paths
			let l:merged = extend(l:merged, etc#util#load_config(l:cfg_file))
		endfor
	catch /.*/
		call etc#util#error(
			\ 'Unable to read configuration files at '.string(a:config_paths))
		echoerr v:exception
		echomsg 'Error parsing user configuration file(s).'
		echoerr 'Please run: pip3 install --user PyYAML'
		echomsg 'Caught: ' v:exception
	endtry

	" If there's more than one config file source,
	" de-duplicate plugins by repo key.
	if len(a:config_paths) > 1
		call s:dedupe_plugins(l:merged)
	endif
	return l:merged
endfunction

function! s:dedupe_plugins(list) abort
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
