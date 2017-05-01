
" rafi-2015 - hybrid custom
" =========================

" gVim Appearance {{{
" ---------------------------------------------------------
if has('gui_running')
	set guifont=PragmataPro:h17
	set noantialias
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
hi TabLine          ctermfg=236 ctermbg=243 guifg=#303030 guibg=#767676
hi TabLineFill      ctermfg=236 guifg=#303030
hi TabLineSel       ctermfg=241 ctermbg=234 guifg=#626262 guibg=#1C1C1C gui=NONE
hi TabLineSelShade  ctermfg=235 ctermbg=234 guifg=#262626 guibg=#1C1C1C
hi TabLineAlt       ctermfg=234 ctermbg=236 guifg=#1C1C1C guibg=#303030
hi TabLineSel2      ctermfg=252 ctermbg=238 guifg=#D0D0D0 guibg=#444444
hi TabLineSel2Shade ctermfg=238 ctermbg=236 guifg=#444444 guibg=#303030

function! Tabline() abort "{{{
	let s:tabline =
		\ '%#TabLineSel2# %{badge#project()} '.
		\ '%#TabLineSel2Shade#⮀'.
		\ '%#TabLine#  '

	let nr = tabpagenr()
	for i in range(tabpagenr('$'))
		if i + 1 == nr
			let s:tabline .=
				\ '%#TabLineSelShade#░%#TabLineSel#'.
				\ '%'.(i+1).'T%{badge#label('.(i+1).', "⮀")} '.
				\ '%#TabLineAlt#⮀ '
		else
			let s:tabline .=
				\ '%#TabLine# '.
				\ '%'.(i+1).'T%{badge#label('.(i+1).', "⮀")} '.
				\ ' '
		endif
	endfor
	let s:tabline .=
		\ '%#TabLineFill#%T%=%#TabLine#%{badge#session("[S]")}'
	return s:tabline
endfunction "}}}

let &tabline='%!Tabline()'
" }}}

" Statusline {{{
" ------------------------------------------=--------------------=------------
"               Gibberish                   | What da heck?      | Example
" ------------------------------------------+--------------------+------------
let s:stl =" %7*%{&paste?'=':''}%*"        "| Paste symbol       | =
let s:stl.="%4*%{&ro?'':'#'}%*"            "| Modifiable symbol  | #
let s:stl.='%6*%{badge#mode()}'            "| Readonly symbol    | 
let s:stl.='%*%n'                          "| Buffer number      | 3
let s:stl.='%6*%{badge#modified()}%0*'     "| Write symbol       | +
let s:stl.=' %1*%{badge#filename()}%*'     "| Relative supername | cor/app.js
let s:stl.=' %<'                           "| Truncate here      |
let s:stl.='%( %{badge#branch()} %)'      "| Git branch name    |  master
let s:stl.='%4*%(%{badge#trails()} %)'     "| Space and indent   | trail34
let s:stl.='%(%{badge#syntax()} %)%*'      "| syntax error/warn  | E:1W:1
let s:stl.='%='                            "| Align to right     |
let s:stl.='%{badge#format()} %4*%*'      "| File format        | unix 
let s:stl.='%( %{&fenc} %)'                "| File encoding      | utf-8
let s:stl.='%4*%*%( %{&ft} %)'            "| File type          |  python
let s:stl.='%3*%2* %l/%2c%4p%% %*'        "| Line and column    | 69:77/ 90%
" ------------------------------------------'--------------------'------------

" Non-active Statusline {{{
" ------------------------------------------+--------------------+------------
let s:stl_nc = " %{&paste?'=':''}"         "| Paste symbol       | =
let s:stl_nc.= '%{badge#mode()}%n'         "| Readonly & buffer  | 7
let s:stl_nc.= '%6*%{badge#modified()}%*'  "| Write symbol       | +
let s:stl_nc.= ' %{badge#filename()}'      "| Relative supername | src/main.py
let s:stl_nc.= '%='                        "| Align to right     |
let s:stl_nc.= '%{&ft} '                   "| File type          | python
" ------------------------------------------'--------------------'---------}}}

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
	autocmd WinEnter,FileType,BufWinEnter,BufReadPost * let &l:statusline = s:stl
	autocmd WinLeave * let &l:statusline = s:stl_nc
augroup END "}}}

" }}}

" Highlights: General GUI {{{
" ---------------------------------------------------------
highlight! Error  term=NONE cterm=NONE
highlight! link ExtraWhitespace  SpellBad
highlight! link WarningMsg  Comment
" }}}

" Highlights: Popup menu {{{
" ---------------------------------------------------------
"highlight Pmenu       ctermfg=245 ctermbg=235
"highlight PmenuSel    ctermfg=236 ctermbg=248
"highlight PmenuSbar   ctermbg=235
"highlight PmenuThumb  ctermbg=238
" }}}

" Highlights: Markdown {{{
" ---------------------------------------------------------
"highlight link yamlScalar  Normal
"highlight link htmlH1      Statement
"highlight htmlItalic  ctermfg=230 cterm=NONE term=NONE
" }}}

" Plugin: VimFiler icons {{{
" ---------------------------------------------------------
let g:vimfiler_tree_indentation = 1
let g:vimfiler_tree_leaf_icon = '┆'
let g:vimfiler_tree_opened_icon = '▼'
let g:vimfiler_tree_closed_icon = '▷'
let g:vimfiler_file_icon = ' '
let g:vimfiler_readonly_file_icon = '⭤'
let g:vimfiler_marked_file_icon = '✓'
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

" Plugin: unite.vim {{{
" ---------------------------------------------------------
highlight link uniteInputPrompt   Question

" Grep
"highlight link uniteSource__Grep           Normal
"highlight link uniteCandidateInputKeyword  Function
"highlight uniteSource__GrepLineNr       ctermfg=240 guifg=#808070
"highlight uniteSource__GrepLine         ctermfg=245 guifg=#808070
"highlight uniteSource__GrepFile         ctermfg=4   guifg=#8197bf
"highlight uniteSource__GrepSeparator    ctermfg=5   guifg=#f0a0c0
"highlight uniteSource__GrepPattern      ctermfg=1   guifg=#cf6a4c
" }}}

" Plugin: unite-quickfix {{{
" ---------------------------------------------------------
"highlight UniteQuickFixWarning              ctermfg=1
"highlight uniteSource__QuickFix             ctermfg=8
"highlight uniteSource__QuickFix_Bold        ctermfg=249
"highlight link uniteSource__QuickFix_File   Directory
"highlight link uniteSource__QuickFix_LineNr qfLineNr
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

" vim: set foldmethod=marker ts=2 sw=0 tw=80 noet :
