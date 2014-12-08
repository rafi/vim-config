
" vim-bookmarks
" -------------
let g:bookmark_auto_save = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_sign = '⚐'                  " Bookmark sign
let g:bookmark_annotation_sign = '⌦'       " Annonation sign

highlight BookmarkSign            ctermfg=12 guifg=#4EA9D7
highlight BookmarkAnnotationSign  ctermfg=11 guifg=#EACF49

if ! exists('g:bookmark_auto_save_dir')
	let g:bookmark_auto_save_dir = '~/.vim-bookmarks'
endif

" Ensure that bookmarks directory exists
if ! isdirectory(g:bookmark_auto_save_dir)
	call mkdir(g:bookmark_auto_save_dir, 'p')
endif

" Store project's bookmarks in a central directory
function! g:BMWorkDirFileLocation()
	" Hash the project directory
	" Credits: https://github.com/Shougo
	let cwd = getcwd()
	if len(cwd) < 150
		" Just replacing directory separators if path is
		" less than 150 characters.
		let hash = substitute(substitute(
					\ cwd, ':', '=-', 'g'), '[/\\\ ]', '=+', 'g')
	elseif executable('sha256sum')
		" Use SHA256 for long paths. Use the command line executable and not Vim's
		" internal sha256() function to stay compatible with the bash 'ctags' hook
		" script that generates these files.
		let hash = substitute(
					\ system("printf '".cwd."' | sha256sum"),
					\ '\s\+\-.*$', '', '')
	else
		" Simple hash when sha256sum isn't available
		let sum = 0
		for i in range(len(cwd))
			let sum += char2nr(cwd[i]) * (i + 1)
		endfor
		let hash = printf('%x', sum)
	endif

	return g:bookmark_auto_save_dir.'/'.hash
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
