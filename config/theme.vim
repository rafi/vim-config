
" Theme {{{
" -----

" Enable 256 color terminal
set t_Co=256

" Automatic theme loading when colorscheme changes.
let g:theme_name = 'rafi-2016'
let g:theme_path = $VIMPATH.'/themes/'.g:theme_name.'.vim'

autocmd MyAutoCmd ColorScheme * if filereadable(g:theme_path)
	\ |   silent! execute 'source' fnameescape(g:theme_path)
	\ | endif

" Set 'hybrid' dark color-scheme
set background=dark
colorscheme hybrid

" }}}

" vim: set ts=2 sw=2 tw=80 noet :
