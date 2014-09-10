"      .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.     .-.
" `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'   `._.'
"
" github.com/rafi vim config
" vim: set ts=2 sw=2 tw=80 noet :

" Runtime and Plugins {{{1
"------------------------------------------------------------------------------

" Skip initialization for vim-tiny/small
if !1 | finish | endif

function! s:source_rc(path)
  execute 'source' fnameescape(expand('$VIMPATH/config/'.a:path))
endfunction

" Respect XDG
if isdirectory($XDG_CONFIG_HOME.'/vim')
	let $VIMPATH=expand('$XDG_CONFIG_HOME/vim')
	let $VARPATH=expand('$XDG_CACHE_HOME/vim')
else
	let $VIMPATH=expand('~/.vim')
	let $VARPATH=expand('~/.cache/vim')
endif

call s:source_rc('init.vim')

call neobundle#begin(expand('$VARPATH/plugins'))
if neobundle#has_cache()
	NeoBundleLoadCache
else
	call s:source_rc('neobundle.vim')
	NeoBundleSaveCache
endif
call neobundle#end()

" Must be after plugins
filetype plugin indent on
syntax enable

" Plugin installation check
NeoBundleCheck

call s:source_rc('general.vim')
call s:source_rc('filetype.vim')
call s:source_rc('plugins.vim')
call s:source_rc('terminal.vim')
call s:source_rc('bindings.vim')
call s:source_rc('utils.vim')
call s:source_rc('colors.vim')

call neobundle#call_hook('on_source')
set secure

"-------8<---------------------------------------------------------------------
