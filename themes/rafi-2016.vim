
" rafi-2016 - hybrid custom
" =========================

" gVim Appearance {{{
" ---------------------------------------------------------
if has('gui_running')
	set guifont=Monaco:h14
"	set guifont=PragmataPro:h14
"	set noantialias
endif
" }}}

" UI elements {{{
" ---------------------------------------------------------
set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·
" }}}

" Tabline {{{
" ---------------------------------------------------------
" TabLineFill: Tab pages line, where there are no labels
hi TabLineFill ctermfg=234 ctermbg=236 guifg=#1C1C1C guibg=#303030 cterm=NONE gui=NONE
" TabLine: Not-active tab page label
hi TabLine     ctermfg=243 ctermbg=236 guifg=#767676 guibg=#303030 cterm=NONE gui=NONE
" TabLineSel: Active tab page label
hi TabLineSel  ctermfg=241 ctermbg=234 guifg=#626262 guibg=#1C1C1C cterm=NONE gui=NONE
" Custom
highlight TabLineSelShade  ctermfg=235 ctermbg=234 guifg=#262626 guibg=#1C1C1C
highlight TabLineAlt       ctermfg=252 ctermbg=238 guifg=#D0D0D0 guibg=#444444
highlight TabLineAltShade  ctermfg=238 ctermbg=236 guifg=#444444 guibg=#303030

function! Tabline() abort "{{{
	" Active project tab
	let s:tabline =
		\ '%#TabLineAlt# %{block#project()} '.
		\ '%#TabLineAltShade#▛'.
		\ '%#TabLineFill#  '

	let nr = tabpagenr()
	for i in range(tabpagenr('$'))
		if i + 1 == nr
			" Active tab
			let s:tabline .=
				\ '%#TabLineSelShade#░%#TabLineSel#'.
				\ '%'.(i+1).'T%{block#label('.(i+1).', "▛", "N/A")} '.
				\ '%#TabLineFill#▞ '
		else
			" Normal tab
			let s:tabline .=
				\ '%#TabLine# '.
				\ '%'.(i+1).'T%{block#label('.(i+1).', "▛", "N/A")} '.
				\ '▘ '
		endif
	endfor
	" Empty space and session indicator
	let s:tabline .=
		\ '%#TabLineFill#%T%=%#TabLine#%{block#session("['.fnamemodify(v:this_session, ':t:r').']")}'
	return s:tabline
endfunction "}}}

let &tabline='%!Tabline()'
" }}}

" Statusline {{{
let s:stl  = " %7*%{&paste ? '=' : ''}%*"         " Paste symbol
let s:stl .= "%4*%{&readonly ? '' : '#'}%*"       " Modifide symbol
let s:stl .= '%6*%{block#mode()}'                 " Readonly symbol
let s:stl .= '%*%n'                               " Buffer number
let s:stl .= "%6*%{block#modified('+')}%0*"       " Write symbol
let s:stl .= ' %1*%{block#filename()}%*'          " Filename
let s:stl .= ' %<'                                " Truncate here
let s:stl .= '%( %{block#branch()} %)'           " Git branch name
let s:stl .= '%(/ %{anzu#search_status()} %)'     " Search position
let s:stl .= "%4*%(%{block#trails('WS:%s')} %)"  " Whitespace
let s:stl .= '%(%{block#syntax()} %)%*'           " syntax check
let s:stl .= '%='                                 " Align to right
let s:stl .= '%{block#format()} %4*%*'           " File format
let s:stl .= '%( %{&fenc} %)'                     " File encoding
let s:stl .= '%4*%*%( %{&ft} %)'                 " File type
let s:stl .= '%3*%2* %l/%2c%4p%% %*'             " Line and column

" Non-active Statusline {{{
let s:stl_nc = " %{block#mode('', 'Z')}%n"    " Readonly & buffer
let s:stl_nc .= "%6*%{block#modified('+')}%*"  " Write symbol
let s:stl_nc .= ' %{block#filename()}'         " Relative supername
let s:stl_nc .= '%='                           " Align to right
let s:stl_nc .= '%{&ft} '                      " File type
" }}}

" Highlights: Statusline {{{
highlight StatusLine   ctermfg=236 ctermbg=248 guifg=#30302c guibg=#a8a897
highlight StatusLineNC ctermfg=236 ctermbg=242 guifg=#30302c guibg=#666656

" Filepath color
highlight User1 guifg=#D7D7BC guibg=#30302c ctermfg=251 ctermbg=236
" Line and column information
highlight User2 guifg=#a8a897 guibg=#4e4e43 ctermfg=248 ctermbg=239
" Line and column corner arrow
highlight User3 guifg=#4e4e43 guibg=#30302c ctermfg=239 ctermbg=236
" Buffer # symbol and whitespace or syntax errors
highlight User4 guifg=#666656 guibg=#30302c ctermfg=242 ctermbg=236
" Write symbol
highlight User6 guifg=#cf6a4c guibg=#30302c ctermfg=167 ctermbg=236
" Paste symbol
highlight User7 guifg=#99ad6a guibg=#30302c ctermfg=107 ctermbg=236
" Syntax and whitespace
highlight User8 guifg=#ffb964 guibg=#30302c ctermfg=215 ctermbg=236
" }}}

" Toggle Statusline {{{
augroup statusline
	autocmd!
	autocmd WinEnter,FileType,BufWinEnter,BufReadPost *
		\ if &filetype !~? 'denite\|unite\|vimfiler\|tagbar\|undotree\|gundo\|diff'
	  \ | let &l:statusline = s:stl
		\ | endif
	autocmd WinLeave *
		\ if &filetype !~? 'denite\|unite\|vimfiler\|tagbar\|undotree\|gundo\|diff'
	  \ | let &l:statusline = s:stl_nc
		\ | endif
augroup END "}}}

" }}}

" Highlights: General GUI {{{
" ---------------------------------------------------------
highlight! Error  term=NONE cterm=NONE
highlight! link mkdLineBreak      NONE
highlight! link pythonSpaceError  NONE
highlight! link pythonIndentError NONE
highlight! link WarningMsg  Comment
highlight! link ExtraWhitespace  SpellBad
" }}}

" Plugin: VimFiler icons {{{
" ---------------------------------------------------------
let g:vimfiler_tree_indentation = 1
let g:vimfiler_tree_leaf_icon = '┆'
let g:vimfiler_tree_opened_icon = '▼'
let g:vimfiler_tree_closed_icon = '▷'
let g:vimfiler_file_icon = ' '
let g:vimfiler_readonly_file_icon = '🔧'
let g:vimfiler_marked_file_icon = '✓'
"}}}

" Plugin: Neomake icons {{{
" ---------------------------------------------------------
let g:neomake_error_sign = {'text': '✖', 'texthl': 'ErrorMsg'}
let g:neomake_warning_sign = {'text': '▷', 'texthl': 'WarningMsg'}
let g:neomake_message_sign = {'text': '▣', 'texthl': 'NeomakeMessageSign'}
let g:neomake_info_sign = {'text': 'ℹ', 'texthl': 'NeomakeInfoSign'}
"}}}

" Plugin: GitGutter icons {{{
" ---------------------------------------------------------
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▋'
"}}}

" Plugin: Indent-Guides icons {{{
" ---------------------------------------------------------
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 0
"}}}

" Plugin: vim-gitgutter {{{
" ---------------------------------------------------------
highlight GitGutterAdd ctermfg=22 guifg=#006000 ctermbg=NONE
highlight GitGutterChange ctermfg=58 guifg=#5F6000 ctermbg=NONE
highlight GitGutterDelete ctermfg=52 guifg=#600000 ctermbg=NONE
highlight GitGutterChangeDelete ctermfg=52 guifg=#600000 ctermbg=NONE
" }}}

" Plugin: denite {{{
" ---------------------------------------------------------
"highlight deniteSource_base
highlight deniteMatched ctermfg=243 guifg=#999999
highlight deniteMatchedChar ctermfg=221 guifg=#f0c674
highlight link deniteGrepInput Constant
"highlight deniteSourceLine_file_mru
" }}}

" Plugin: unite.vim {{{
" ---------------------------------------------------------
highlight link uniteInputPrompt Question
" }}}

" Plugin: vimfiler.vim {{{
" ---------------------------------------------------------
highlight vimfilerNonMark     ctermfg=132 guifg=#B05E87
highlight vimfilerLeaf        ctermfg=238 guifg=#444444
highlight vimfilerClosedFile  ctermfg=246 guifg=#949494
highlight link vimfilerOpenedFile  Normal
highlight link vimfilerNormalFile  Comment
highlight link vimfilerMarkedFile  Type
" }}}

" Plugin: vim-indent-guides {{{
" ---------------------------------------------------------
highlight IndentGuidesOdd  guibg=#262626 ctermbg=235
highlight IndentGuidesEven guibg=#303030 ctermbg=236
" }}}

" Plugin: vim-operator-flashy {{{
" ---------------------------------------------------------
highlight link Flashy Todo
" }}}

" Plugin: vim-choosewin {{{
" ---------------------------------------------------------
"	let g:choosewin_label = 'FGHJKLZXCVBNM'
let g:choosewin_overlay_enable = 1
let g:choosewin_statusline_replace = 1
let g:choosewin_overlay_clear_multibyte = 0
let g:choosewin_blink_on_land = 0
"	let g:choosewin_overlay_shade = 1

let g:choosewin_color_label = {
	\ 'cterm': [ 236, 2 ], 'gui': [ '#555555', '#000000' ] }
let g:choosewin_color_label_current = {
	\ 'cterm': [ 234, 220 ], 'gui': [ '#333333', '#000000' ] }
let g:choosewin_color_other = {
	\ 'cterm': [ 235, 235 ], 'gui': [ '#333333' ] }
let g:choosewin_color_overlay = {
	\ 'cterm': [ 2, 10 ], 'gui': [ '#88A2A4' ] }
let g:choosewin_color_overlay_current = {
	\ 'cterm': [ 72, 64 ], 'gui': [ '#7BB292' ] }
" }}}

" vim: set ts=2 sw=0 tw=80 noet :
