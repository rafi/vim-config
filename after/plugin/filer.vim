
" VimFiler
" --------
let g:vimfiler_safe_mode_by_default=0
let g:vimfiler_as_default_explorer=1
let g:vimfiler_tree_leaf_icon = "|"
let g:vimfiler_tree_opened_icon = "○"
let g:vimfiler_tree_closed_icon = "●"
let g:vimfiler_readonly_file_icon = "§"
let g:vimfiler_quick_look_command = 'gloobus-preview'
let g:vimfiler_ignore_pattern = '^\%(.git\|.DS_Store\)$'

autocmd FileType vimfiler nunmap <buffer> <C-l>
autocmd FileType vimfiler nunmap <buffer> <C-j>
autocmd FileType vimfiler nmap <buffer> ' <Plug>(vimfiler_toggle_mark_current_line)
autocmd FileType vimfiler nmap <buffer> <C-q> <Plug>(vimfiler_quick_look)
autocmd FileType vimfiler nmap <buffer> <C-w> <Plug>(vimfiler_switch_to_history_directory)
"autocmd FileType vimfiler nmap <buffer> <CR> <Plug>(vimfiler_edit_file)
"autocmd FileType vimfiler nnoremap <buffer> <C-r> <Plug>(vimfiler_redraw_screen)
