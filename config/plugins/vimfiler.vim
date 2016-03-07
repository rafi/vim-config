
" VimFiler
" --------

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_restore_alternate_file = 1
"let g:vimfiler_preview_action = 'auto_preview'

let g:vimfiler_ignore_pattern =
	\ '^\%(\.git\|\.idea\|\.DS_Store\|\.vagrant\|\.stversions\|\.tmp'
	\ .'\|node_modules\|.*\.pyc\|.*\.egg-info\|__pycache__\)$'

if has('mac')
	let g:vimfiler_quick_look_command =
		\ '/Applications//Sublime\ Text.app/Contents/MacOS/Sublime\ Text'
else
	let g:vimfiler_quick_look_command = 'gloobus-preview'
endif

call vimfiler#custom#profile('default', 'context', {
	\  'safe': 0,
	\  'explorer': 1,
	\  'winwidth': 25,
	\  'split': 1,
	\  'direction': 'topleft',
	\  'auto_expand': 1,
	\  'no_quit': 1,
	\  'force_hide': 1,
	\  'parent': 0,
	\  'toggle': 1,
	\ })

" vim: set ts=2 sw=2 tw=80 noet :
