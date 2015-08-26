
" VimFiler
" --------

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_enable_clipboard = 0
let g:vimfiler_restore_alternate_file = 1
let g:vimfiler_tree_indentation = 1
let g:vimfiler_tree_leaf_icon = "⋮"
let g:vimfiler_tree_opened_icon = "▼"
let g:vimfiler_tree_closed_icon = "▷"
let g:vimfiler_file_icon = ' '
let g:vimfiler_readonly_file_icon = "⭤"
let g:vimfiler_marked_file_icon = '✓'
let g:vimfiler_preview_action = 'auto_preview'
let g:vimfiler_ignore_pattern =
	\ '^\%(\.git\|\.idea\|\.DS_Store\|\.vagrant\|node_modules\|.*\.pyc\)$'

if has('mac')
	let g:vimfiler_quick_look_command = 'qlmanage -p'
else
	let g:vimfiler_quick_look_command = 'gloobus-preview'
endif

call vimfiler#custom#profile('default', 'context', {
	\  'safe': 0,
	\  'winwidth': 25,
	\  'explorer': 1,
	\  'auto_expand': 1,
	\  'no_quit': 1,
	\  'parent': 0,
	\  'split': 1,
	\  'toggle': 1,
	\ })

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings()
	setlocal nonumber

	nunmap <buffer> <Space>
	nunmap <buffer> <C-l>
	nunmap <buffer> <C-j>
	nunmap <buffer> E

	nnoremap <silent><buffer><expr> sg  vimfiler#do_switch_action('vsplit')
	nnoremap <silent><buffer><expr> sv  vimfiler#do_switch_action('split')
	nmap <buffer> '      <Plug>(vimfiler_toggle_mark_current_line)
	nmap <buffer> p      <Plug>(vimfiler_preview_file)
	nmap <buffer> i      <Plug>(vimfiler_switch_to_history_directory)
	nmap <buffer> <Tab>  <Plug>(vimfiler_switch_to_other_window)
	nmap <buffer> <C-r>  <Plug>(vimfiler_redraw_screen)
	nmap <buffer> <C-q>  <Plug>(vimfiler_quick_look)
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
