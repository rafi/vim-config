" vim-etc configuration manager
" ---
" Maintainer: Rafael Bodill
" See: github.com/rafi/vim-config

function! etc#manager#select(vendor_name) abort
	let g:etc#package_manager = a:vendor_name
endfunction

function! etc#manager#init() abort
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

function! etc#manager#parse_config_files(config_paths) abort
	for l:cfg_file in a:config_paths
		if filereadable(l:cfg_file)
			return etc#util#load_config(l:cfg_file)
		endif
	endfor

	call etc#util#error(
		\ 'Unable to read configuration files at '.string(a:config_paths))
endfunction
