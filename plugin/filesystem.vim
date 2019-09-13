" Helpers for dealing with the filesystem
" ---
"
" Behaviors:
" - Before writing file ensure directories exist
"
" Commands:
" - GitOpenDirty: Open all dirty files in repository

if exists('g:loaded_filesystemplugin')
	finish
endif
let g:loaded_filesystemplugin = 1

augroup plugin_filesystem
	autocmd!
	autocmd BufWritePre * call s:mkdir(expand('<afile>:p:h'), v:cmdbang)
augroup END

function! s:mkdir(dir, force)
	" Credits: https://github.com/Shougo/shougo-s-github
	if ! isdirectory(a:dir) && empty(&l:buftype) &&
			\ (a:force || input(printf('"%s" does not exist. Create? [y/N]',
			\              a:dir)) =~? '^y\%[es]$')
		call mkdir(a:dir, 'p')
	endif
endfunction

command! -nargs=0 GitOpenDirty call s:git_open_dirty()

" Open a split for each dirty file in git
function! s:git_open_dirty()
	silent only " Close all windows, unless they're modified
	let status =
		\ system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
	let filenames = split(status, "\n")
	if ! empty(filenames)
		exec 'edit ' . filenames[0]
		for filename in filenames[1:]
			exec 'sp ' . filename
		endfor
	endif
endfunction
