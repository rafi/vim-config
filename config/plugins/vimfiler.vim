
" VimFiler
" --------

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_enable_clipboard = 0
let g:vimfiler_tree_leaf_icon = "⋮"
let g:vimfiler_tree_opened_icon = "▼"
let g:vimfiler_tree_closed_icon = "▷"
let g:vimfiler_readonly_file_icon = "⭤"
let g:vimfiler_quick_look_command = 'gloobus-preview'
let g:vimfiler_ignore_pattern =
	\ '^\%(\.git\|\.idea\|\.DS_Store\|\.vagrant\|node_modules\)$'

call vimfiler#custom#profile('default', 'context', {
	\  'safe': 0,
	\  'explorer': 1,
	\  'auto_expand': 1,
	\  'no_quit': 1
	\ })

autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
function! s:vimfiler_settings()
	setlocal winfixwidth
	setlocal nonumber

	nunmap <buffer> <C-l>
	nunmap <buffer> <C-j>
	nunmap <buffer> E

	nnoremap <silent><buffer><expr> sg  vimfiler#do_switch_action('vsplit')
	nnoremap <silent><buffer><expr> sv  vimfiler#do_switch_action('split')
	nmap <buffer> p      <Plug>(vimfiler_preview_file)
	nmap <buffer> i      <Plug>(vimfiler_switch_to_history_directory)
	nmap <buffer> <C-r>  <Plug>(vimfiler_redraw_screen)
	nmap <buffer> <C-q>  <Plug>(vimfiler_quick_look)
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
