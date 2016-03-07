
" rafi-2015 - hybrid custom
" ----------------------------

" gVim Appearance {{{
if has('gui_running')
	set guifont=PragmataPro:h17
	set noantialias
endif

" }}}
" UI elements {{{
set showbreak=↪
set fillchars=vert:│,fold:─
set listchars=tab:\⋮\ ,extends:⟫,precedes:⟪,nbsp:.,trail:·

" }}}
" Plugin: VimFiler icons {{{
let g:vimfiler_tree_indentation = 1
let g:vimfiler_tree_leaf_icon = '┆'
let g:vimfiler_tree_opened_icon = '▼'
let g:vimfiler_tree_closed_icon = '▷'
let g:vimfiler_file_icon = ' '
let g:vimfiler_readonly_file_icon = '⭤'
let g:vimfiler_marked_file_icon = '✓'

"}}}
" Plugin: GitGutter icons {{{
let g:gitgutter_sign_added = '▎'
let g:gitgutter_sign_modified = '▎'
let g:gitgutter_sign_removed = '▏'
let g:gitgutter_sign_removed_first_line = '▔'
let g:gitgutter_sign_modified_removed = '▋'

"}}}
" Plugin: Indent-Guides icons {{{
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 1
let g:indent_guides_auto_colors = 0

"}}}
" General GUI {{{
highlight! link ExtraWhitespace  SpellBad
highlight! link WarningMsg  Comment
highlight! Error      term=NONE cterm=NONE

" }}}
" Popup menu {{{
"highlight Pmenu       ctermfg=245 ctermbg=235
"highlight PmenuSel    ctermfg=236 ctermbg=248
"highlight PmenuSbar   ctermbg=235
"highlight PmenuThumb  ctermbg=238

" }}}
" HTML and Markdown {{{
"highlight link yamlScalar  Normal
"highlight link htmlH1      Statement
"highlight htmlItalic  ctermfg=230 cterm=NONE term=NONE

" }}}
" Plugin: vim-gitgutter {{{
highlight GitGutterAdd ctermfg=22 guifg=#006000 ctermbg=NONE
highlight GitGutterChange ctermfg=58 guifg=#5F6000 ctermbg=NONE
highlight GitGutterDelete ctermfg=52 guifg=#600000 ctermbg=NONE
highlight GitGutterChangeDelete ctermfg=52 guifg=#600000 ctermbg=NONE

" }}}
" Plugin: unite.vim {{{
highlight link uniteInputPrompt   Question

" Unite grep
"highlight link uniteSource__Grep           Normal
"highlight link uniteCandidateInputKeyword  Function
"highlight uniteSource__GrepLineNr       ctermfg=240 guifg=#808070
"highlight uniteSource__GrepLine         ctermfg=245 guifg=#808070
"highlight uniteSource__GrepFile         ctermfg=4   guifg=#8197bf
"highlight uniteSource__GrepSeparator    ctermfg=5   guifg=#f0a0c0
"highlight uniteSource__GrepPattern      ctermfg=1   guifg=#cf6a4c

" }}}
" Plugin: unite-quickfix {{{
"highlight UniteQuickFixWarning              ctermfg=1
"highlight uniteSource__QuickFix             ctermfg=8
"highlight uniteSource__QuickFix_Bold        ctermfg=249
"highlight link uniteSource__QuickFix_File   Directory
"highlight link uniteSource__QuickFix_LineNr qfLineNr

" }}}
" Plugin: vimfiler.vim {{{
highlight vimfilerNonMark     ctermfg=132 guifg=#B05E87
highlight vimfilerLeaf        ctermfg=238 guifg=#444444
highlight vimfilerClosedFile  ctermfg=246 guifg=#949494
highlight link vimfilerOpenedFile  Normal
highlight link vimfilerNormalFile  Comment
highlight link vimfilerMarkedFile  Type

" }}}
" Plugin: vim-indent-guides {{{
highlight IndentGuidesOdd  guibg=#262626 ctermbg=235
highlight IndentGuidesEven guibg=#303030 ctermbg=236

" }}}
" Plugin: vim-operator-flashy {{{
highlight link Flashy Todo

" }}}
" vim: set ts=2 sw=0 tw=80 noet :
