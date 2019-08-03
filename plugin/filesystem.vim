" Helpers for dealing with the filesystem
" ---
"
" Behaviors:
" - Before writing file ensure directories exist

if exists('g:loaded_filesystemplugin')
	finish
endif
let g:loaded_filesystemplugin = 1

augroup plugin_filesystem
	autocmd!
	autocmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)
augroup END

function! s:mkdir(dir, force) abort
	" Credits: https://github.com/Shougo/shougo-s-github
	if ! isdirectory(a:dir) && empty(&l:buftype) &&
			\ (a:force || input(printf('"%s" does not exist. Create? [y/N]',
			\              a:dir)) =~? '^y\%[es]$')
		call mkdir(a:dir, 'p')
	endif
endfunction
