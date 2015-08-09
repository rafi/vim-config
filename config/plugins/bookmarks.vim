
" vim-bookmarks
" -------------
let g:bookmark_auto_save = 0
let g:bookmark_save_per_working_dir = 0
let g:bookmark_manage_per_buffer = 0
let g:bookmark_sign = '⚐'                  " Bookmark sign
let g:bookmark_annotation_sign = '⌦'       " Annonation sign

" Ensure that bookmarks directory exists
if ! isdirectory(g:bookmark_auto_save_dir)
	call mkdir(g:bookmark_auto_save_dir, 'p')
endif

augroup AutoManageBookmarks
	autocmd!
	autocmd BufEnter * call s:maybe_load_bookmarks()
	autocmd BufLeave * call s:maybe_save_bookmarks()
	autocmd VimLeave * if bm#total_count() > 0
		\ | call BookmarkSave(s:bookmark_file(), 1)
		\ | endif
augroup END

function! s:maybe_load_bookmarks()
	if ! exists('b:bm_loaded')
		let b:bm_loaded = 1
		let b:bm_sync = 1
		let b:bm_file = expand('<afile>:p')
		if b:bm_file !=# ''
			call BookmarkLoad(s:bookmark_file(), 0, 1)
		endif
	endif
endfunction

function! s:maybe_save_bookmarks()
	if exists('b:bm_sync')
		if ! b:bm_sync && b:bm_file !=# '' && bm#total_count() > 0
			call BookmarkSave(s:bookmark_file(), 1)
			let b:bm_sync = 1
		endif
	endif
endfunction

function! s:bookmark_file()
	if exists('t:project_dir')
		let b:bookmark_file = s:hash_dir(t:project_dir)
	elseif ! exists('b:bookmark_file')
		let b:bookmark_file = s:hash_dir(getcwd())
	endif
	let b:bookmark_file = g:bookmark_auto_save_dir.'/'.b:bookmark_file

	return b:bookmark_file
endfunction

" Store project's bookmarks in a central directory
function! s:hash_dir(path)
	" Hash the project directory
	" Credits: https://github.com/Shougo
	if len(a:path) < 150
		" Just replacing directory separators if path is
		" less than 150 characters.
		let hash = substitute(substitute(
					\ a:path, ':', '=-', 'g'), '[/\\\ ]', '=+', 'g')
	elseif executable('sha256sum')
		" Use SHA256 for long paths. Use the command line executable and not Vim's
		" internal sha256() function to stay compatible with the bash 'ctags' hook
		" script that generates these files.
		let hash = substitute(
					\ system("printf '".a:path."' | sha256sum"),
					\ '\s\+\-.*$', '', '')
	else
		" Simple hash when sha256sum isn't available
		let sum = 0
		for i in range(len(a:path))
			let sum += char2nr(a:path[i]) * (i + 1)
		endfor
		let hash = printf('%x', sum)
	endif

	return hash
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
