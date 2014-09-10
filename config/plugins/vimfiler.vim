
" VimFiler
" --------

let g:vimfiler_tree_leaf_icon = "⋮"
let g:vimfiler_tree_opened_icon = "▼"
let g:vimfiler_tree_closed_icon = "▷"
let g:vimfiler_readonly_file_icon = "⭤"
let g:vimfiler_quick_look_command = 'gloobus-preview'
let g:vimfiler_ignore_pattern = '^\%(.git\|.idea\|.DS_Store\)$'

call vimfiler#custom#profile('default', 'context', {
\   'safe': 0,
\   'explorer': 1,
\   'auto_expand': 1
\ })
