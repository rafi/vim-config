
" Theme
" -----

" Enable 256 color terminal
set t_Co=256

" Enable true color (only in Neovim, but not in urxvt)
if has('nvim') && $TERM !~# '^rxvt' && exists('+termguicolors')
	set termguicolors
	if &term =~# 'tmux-256color'
		let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
		let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	endif
endif

function! s:theme_reload(name)
	let theme_path = $VIMPATH.'/themes/'.a:name.'.vim'
	if filereadable(theme_path)
		execute 'source' fnameescape(theme_path)
	endif
endfunction

autocmd MyAutoCmd ColorScheme * call s:theme_reload(g:theme_name)

let g:theme_name = 'rafi-2016'
set background=dark
colorscheme hybrid

" vim: set ts=2 sw=2 tw=80 noet :
