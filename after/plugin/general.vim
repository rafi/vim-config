
" VimFiler
" --------
let g:vimfiler_safe_mode_by_default=0
let g:vimfiler_as_default_explorer=1
let g:unite_split_rule="botright"
let g:unite_cursor_line_highlight='CursorLine'
autocmd FileType vimfiler nunmap <buffer> <C-l>
autocmd FileType vimfiler nmap <buffer> <CR> <Plug>(vimfiler_edit_file)

" Markdown
" --------
let g:vim_markdown_initial_foldlevel=5

" Syntastic
" ---------
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_enable_balloons = 1
let g:syntastic_auto_loc_list=1
let g:syntastic_php_checkers = ['php']
