"      .-.     .-.     .-.     .-.     .-.     .-.     .-.
" `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
"
" github.com/rafi vim config
" vim: set ts=2 sw=2 tw=80 noet :

" Runtime and Plugins
"---------------------------------------------------------

" Skip initialization for vim-tiny/small
if 0 | endif

if &compatible
	set nocompatible
endif

" Respect XDG
if isdirectory($XDG_CONFIG_HOME.'/vim')
	let $VIMPATH=expand('$XDG_CONFIG_HOME/vim')
	let $VARPATH=expand('$XDG_CACHE_HOME/vim')
else
	let $VIMPATH=expand('~/.vim')
	let $VARPATH=expand('~/.cache/vim')
endif

function! s:source_file(path)
	execute 'source' fnameescape($VIMPATH.'/config/'.a:path)
endfunction

" Initialize base requirements
call s:source_file('init.vim')

" NeoBundle start plugins {{{
call neobundle#begin(expand('$VARPATH/plugins'))
if neobundle#load_cache()
	NeoBundleFetch 'Shougo/neobundle.vim'
	call s:source_file('neobundle.vim')
	NeoBundleFetch 'rafi/awesome-vim-colorschemes', {
		\ 'directory': 'colorschemes' }
	call neobundle#local($VARPATH.'/plugins/colorschemes', {})
	NeoBundleSaveCache
endif
call neobundle#local(expand('$VIMPATH/dev'), {})
call s:source_file('plugins.vim')
call neobundle#end()
" }}}

" Must be after plugins
filetype plugin indent on
syntax enable

" Plugin installation check
if ! has('vim_starting')
	NeoBundleCheck
endif

" Loading configuration modules {{{
call s:source_file('general.vim')
call s:source_file('filetype.vim')
call s:source_file('terminal.vim')
call s:source_file('utils.vim')
call s:source_file('colors.vim')
call s:source_file('bindings.vim')
" }}}

call neobundle#call_hook('on_source')
set secure
