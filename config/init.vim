
if ! isdirectory(expand($VARPATH))
	" Create the cache dir and the undo dir, too
	call mkdir(expand('$VARPATH/undo'), 'p')
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
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_vimballPlugin = 1
