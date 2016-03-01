
" Vim Initialization
" ------------------

" Global Mappings "{{{
" Use spacebar instead of '\' as leader. Require before loading plugins.
let g:mapleader="\<Space>"
let g:maplocalleader=','

" Release keymappings for plug-in.
nnoremap <Space>  <Nop>
xnoremap <Space>  <Nop>
nnoremap ,        <Nop>
xnoremap ,        <Nop>

" }}}
" Ensure cache directory "{{{
if ! isdirectory(expand($VARPATH))
	" Create missing dirs i.e. cache/{undo,backup}
	call mkdir(expand('$VARPATH/undo'), 'p')
	call mkdir(expand('$VARPATH/backup'))
endif

" }}}
" Set augroup "{{{
augroup MyAutoCmd
	autocmd!
augroup END

" }}}
" Load vault settings "{{{
if filereadable(expand('$VIMPATH/.vault.vim'))
	execute 'source' expand('$VIMPATH/.vault.vim')
endif

" }}}
" Respect XDG specification {{{
if isdirectory($XDG_CONFIG_HOME.'/vim')
	let $MYVIMRC=expand('$XDG_CONFIG_HOME/vim/config/vimrc')
	if has('nvim')
		" For Neovim, use .config/vim instead of .config/nvim
		set runtimepath-=$XDG_CONFIG_HOME/nvim
		set runtimepath^=$XDG_CONFIG_HOME/vim
	else
		set runtimepath-=~/.vim
		set runtimepath^=$VIMPATH
		set runtimepath-=~/.vim/after
		set runtimepath+=$VIMPATH/after
	endif
endif

" }}}
" Setup dein {{{
if &runtimepath !~# '/dein.vim'
	let s:dein_dir = expand('$VARPATH/dein').'/repos/github.com/Shougo/dein.vim'
	if !isdirectory(s:dein_dir)
		execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
	endif

	execute 'set runtimepath^='.fnamemodify(s:dein_dir, ':p')
endif

" }}}
" Load less plugins while SSHing to remote machines {{{
if len($SSH_CLIENT)
	let $VIM_MINIMAL = 1
endif

" }}}
" Disable default plugins "{{{

" Disable menu.vim
if has('gui_running')
  set guioptions=Mc
endif

" Disable pre-bundled plugins
let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwFileHandlers = 1
let g:loaded_netrwSettings = 1
let g:loaded_rrhelper = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
let g:loaded_gzip = 1
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
