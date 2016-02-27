
" rafi-2015 - hybrid custom
" ----------------------------

" UI elements "{{{
set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·

" }}}
" VimFiler icons {{{
if dein#tap('vimfiler.vim')
	" Icons: │ ┃ ┆ ┇ ┊ ┋ ╎ ╏
	let g:vimfiler_tree_indentation = 1
	let g:vimfiler_tree_leaf_icon = '┆'
	let g:vimfiler_tree_opened_icon = '▼'
	let g:vimfiler_tree_closed_icon = '▷'
	let g:vimfiler_file_icon = ' '
	let g:vimfiler_readonly_file_icon = '⭤'
	let g:vimfiler_marked_file_icon = '✓'
endif

"}}}
" GitGutter icons {{{
if dein#tap('vim-gitgutter')
	let g:gitgutter_sign_added = '▎'
	let g:gitgutter_sign_modified = '▎'
	let g:gitgutter_sign_removed = '▏'
	let g:gitgutter_sign_removed_first_line = '▔'
	let g:gitgutter_sign_modified_removed = '▋'
endif

"}}}
" Indent-Guides icons {{{
if dein#tap('vim-indent-guides')
	let g:indent_guides_guide_size = 1
	let g:indent_guides_start_level = 1
	let g:indent_guides_auto_colors = 0
endif
"}}}

" vim: set ts=2 sw=0 tw=80 noet :
