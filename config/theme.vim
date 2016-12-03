
" Theme
" -----

" Enable 256 color terminal
set t_Co=256

" Enable true color (only in Neovim, but not in urxvt)
if has('nvim') && $TERM !~# '^rxvt'  && exists('+termguicolors')
	set termguicolors
endif

function! s:theme_reload(name) abort
	let theme_path = $VIMPATH.'/themes/'.a:name.'.vim'
	if filereadable(theme_path)
		execute 'source' fnameescape(theme_path)
	endif
endfunction

" Automatic theme loading when colorscheme changes.
autocmd MyAutoCmd ColorScheme * call s:theme_reload(g:theme_name)

let g:theme_name = 'rafi-2016'
set background=dark
colorscheme hybrid

" vim: set ts=2 sw=2 tw=80 noet :
