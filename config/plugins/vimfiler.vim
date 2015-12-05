
" VimFiler
" --------

" Icons: │ ┃ ┆ ┇ ┊ ┋ ╎ ╏
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_restore_alternate_file = 1
let g:vimfiler_tree_indentation = 1
let g:vimfiler_tree_leaf_icon = '┆'
let g:vimfiler_tree_opened_icon = '▼'
let g:vimfiler_tree_closed_icon = '▷'
let g:vimfiler_file_icon = ' '
let g:vimfiler_readonly_file_icon = '⭤'
let g:vimfiler_marked_file_icon = '✓'
"let g:vimfiler_preview_action = 'auto_preview'
let g:vimfiler_ignore_pattern =
	\ '^\%(\.git\|\.idea\|\.DS_Store\|\.vagrant\|.stversions'
	\ .'\|node_modules\|.*\.pyc\)$'

if has('mac')
	let g:vimfiler_quick_look_command =
		\ '/Applications//Sublime\ Text.app/Contents/MacOS/Sublime\ Text'
else
	let g:vimfiler_quick_look_command = 'gloobus-preview'
endif

call vimfiler#custom#profile('default', 'context', {
	\  'safe': 0,
	\  'winwidth': 25,
	\  'explorer': 1,
	\  'auto_expand': 1,
	\  'no_quit': 1,
	\  'force_hide': 1,
	\  'parent': 0,
	\  'split': 1,
	\  'toggle': 1,
	\ })

" vim: set ts=2 sw=2 tw=80 noet :
