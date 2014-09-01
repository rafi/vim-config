
" vim-bookmarks
" -------------
let g:bookmark_auto_save = 1
let g:bookmark_save_per_working_dir = 1
let g:bookmark_sign = '✓'                  " Bookmarks: Bookmark sign
let g:bookmark_annotation_sign = '⌦'       " Bookmarks: Annonation sign

" Finds the Git super-project directory.
function! g:BMWorkDirFileLocation()
	let filename = 'bookmarks'
	let location = ''
	if isdirectory('.git')
		" Current work dir is git's work tree
		let location = getcwd().'/.git'
	else
		" Look upwards (at parents) for a directory named '.git'
		let location = finddir('.git', '.;')
	endif
	if len(location) > 0
		return location.'/'.filename
	else
		return getcwd().'/.'.filename
	endif
endfunction
