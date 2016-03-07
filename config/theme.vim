
" Theme {{{
" -----

set t_Co=256
set background=dark
colorscheme hybrid
let g:theme_name = 'rafi-2015'

" base16 themes - Access colors present in 256 colorspace
let g:base16colorspace = 256
let g:base16_shell_path = $VARPATH.'/plugins/base16-shell/'

" Theme loader. Uses current selected colorscheme name as base.
function! g:SetCustomTheme()
	let l:path = $VIMPATH.'/theme/'.g:theme_name.'.vim'
	if filereadable(l:path)
		silent! execute 'source' fnameescape(l:path)
	endif
endfunction

" Automatic theme loading when colorscheme changes.
autocmd MyAutoCmd ColorScheme * call g:SetCustomTheme()
call g:SetCustomTheme()
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
