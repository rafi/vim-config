" vim-etc configuration manager
" ---
" Maintainer: Rafael Bodill
" See: github.com/rafi/vim-config

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
	\ 'usr/vimrc.yaml',
	\ 'usr/vimrc.json',
	\ 'vimrc.yaml',
	\ 'vimrc.json',
	\ 'config/plugins.yaml',
	\ 'config/local.plugins.yaml',
	\ ])
