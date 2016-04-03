
" Theme {{{
" -----

set t_Co=256
set background=dark

let g:theme_name = 'rafi-2016'
let g:theme_path = $VIMPATH.'/themes/'.g:theme_name.'.vim'

" Automatic theme loading when colorscheme changes.
autocmd MyAutoCmd ColorScheme * if filereadable(g:theme_path)
	\ |   silent! execute 'source' fnameescape(g:theme_path)
	\ | endif

colorscheme hybrid

" }}}

" vim: set ts=2 sw=2 tw=80 noet :
