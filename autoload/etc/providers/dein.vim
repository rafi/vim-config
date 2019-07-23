function! etc#providers#dein#_init(config_paths) abort
	let l:cache_path = g:etc#cache_path . '/dein'

	" Setup dein
	let g:dein#auto_recache = 1
	let g:dein#install_max_processes = 16
	let g:dein#install_progress_type = 'echo'
	let g:dein#enable_notification = 0
	let g:dein#install_log_filename = g:etc#cache_path . '/dein.log'

	" Add dein to vim's runtimepath
	if &runtimepath !~# '/dein.vim'
		let s:dein_dir = l:cache_path . '/repos/github.com/Shougo/dein.vim'
		" Clone dein if first-time setup
		if ! isdirectory(s:dein_dir)
			execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
			if v:shell_error
				call etc#util#error('dein installation has failed!')
				finish
			endif
		endif

		execute 'set runtimepath+='.substitute(
			\ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
	endif

	" Initialize dein.vim (package manager)
	if dein#load_state(l:cache_path)
		call dein#begin(l:cache_path, extend([expand('<sfile>')], a:config_paths))

		try
			let l:rc = etc#manager#parse_config_files(a:config_paths)
			if empty(l:rc)
				call etc#util#error('Empty plugin list')
			else
				for plugin in l:rc
					call dein#add(plugin['repo'], extend(plugin, {}, 'keep'))
				endfor
			endif
		catch /.*/
			echoerr v:exception
			echomsg 'Error loading plugins configuration file.'
			echoerr 'Please run: pip3 install --user PyYAML'
			echomsg 'Caught: ' v:exception
		endtry

		if isdirectory(g:etc#vim_path.'/dev')
			call dein#local(g:etc#vim_path.'/dev', {'frozen': 1, 'merged': 0})
		endif
		call dein#end()
		if ! g:dein#_is_sudo
			call dein#save_state()
		endif
		if dein#check_install()
			if ! has('nvim')
				set nomore
			endif
			call dein#install()
		endif
	endif

	filetype plugin indent on
	syntax enable

	" Trigger source events, only when vim is starting
	if has('vim_starting')
		call dein#call_hook('source')
		call dein#call_hook('post_source')
	endif
endfunction
