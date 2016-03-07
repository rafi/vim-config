
" Theme {{{
" -----

" Automatic theme loading when colorscheme changes.
autocmd MyAutoCmd ColorScheme * if filereadable(g:theme_path)
	\ |   silent! execute 'source' fnameescape(g:theme_path)
	\ | endif

" base16 themes - Access colors present in 256 colorspace
let g:base16colorspace = 256
let g:base16_shell_path = $VARPATH.'/plugins/base16-shell/'

set t_Co=256
set background=dark

let g:theme_name = 'rafi-2015'
let g:theme_path = $VIMPATH.'/theme/'.g:theme_name.'.vim'

colorscheme hybrid

" }}}

" vim: set ts=2 sw=2 tw=80 noet :
