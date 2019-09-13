" Theme
" ---
"
" Autoloads theme according to user selected colorschemes

function! s:theme_init()
	" Load cached colorscheme or hybrid by default
	let l:default = 'hybrid'
	let l:cache = s:theme_cache_file()
	if ! exists('g:colors_name')
		set background=dark
		let l:scheme = filereadable(l:cache) ? readfile(l:cache)[0] : l:default
		silent! execute 'colorscheme' l:scheme
	endif
endfunction

function! s:theme_autoload()
	if exists('g:colors_name')
		let theme_path = $VIM_PATH . '/themes/' . g:colors_name . '.vim'
		if filereadable(theme_path)
			execute 'source' fnameescape(theme_path)
		endif
		" Persist theme
		call writefile([g:colors_name], s:theme_cache_file())
	endif
endfunction

function! s:theme_cache_file()
	return $DATA_PATH . '/theme.txt'
endfunction

function! s:theme_cached_scheme(default)
	let l:cache_file = s:theme_cache_file()
	return filereadable(l:cache_file) ? readfile(l:cache_file)[0] : a:default
endfunction

function! s:theme_cleanup()
	if ! exists('g:colors_name')
		return
	endif
	highlight clear
endfunction

augroup user_theme
	autocmd!
	autocmd ColorScheme * call s:theme_autoload()
	if has('patch-8.0.1781') || has('nvim-0.3.2')
		autocmd ColorSchemePre * call s:theme_cleanup()
	endif
augroup END

call s:theme_init()

" vim: set ts=2 sw=2 tw=80 noet :
