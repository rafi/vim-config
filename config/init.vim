" Use spacebar instead of '\'.
" It is not mapped with respect well unless I set it before setting for plug in.
" Use <Leader> in global plugin.
let g:mapleader = ' '
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = ' '

" Release keymappings for plug-in.
"nnoremap <Space> <Nop>
"xnoremap <Space> <Nop>

if ! isdirectory(expand($VARPATH))
	" Create the cache dir and the undo dir, too
	call mkdir(expand('$VARPATH/undo'), 'p')
endif

" Set augroup
augroup MyAutoCmd
	autocmd!
augroup END

if filereadable(expand('$VIMPATH/.vault.vim'))
	execute 'source' expand('$VIMPATH/.vault.vim')
endif

let s:plugins_dir = expand('$VARPATH/plugins')

if has('vim_starting')
	set nocompatible

	if isdirectory($XDG_CONFIG_HOME.'/vim')
		" Respect XDG
		let $MYVIMRC='$XDG_CONFIG_HOME/vim/vimrc'
		set runtimepath=$VIMPATH,$VIM/vimfiles,$VIMRUNTIME
		set runtimepath+=$VIM/vimfiles/after,$VIMPATH/after
	endif

	" Load NeoBundle for package management
	if &runtimepath !~ '/neobundle.vim'
		if ! isdirectory(s:plugins_dir.'/neobundle.vim')
			" Clone NeoBundle if not found
			execute printf('!git clone %s://github.com/Shougo/neobundle.vim.git',
						\ (exists('$http_proxy') ? 'https' : 'git'))
						\ s:plugins_dir.'/neobundle.vim'
		endif

		execute 'set runtimepath^='.s:plugins_dir.'/neobundle.vim'
	endif
endif

" Disable default plugins

" Disable menu.vim
if has('gui_running')
  set guioptions=Mc
endif

if !&verbose
	" Disable GetLatestVimPlugin.vim
	let g:loaded_getscriptPlugin = 1
endif

let g:loaded_netrwPlugin = 1
"let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1
