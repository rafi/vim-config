
" hybrid custom
" ===

" gVim Appearance {{{
" ---
if has('gui_running')
	set guifont=PragmataPro:h16
	set guioptions=Mc
	" set noantialias
endif
" }}}

" Terminal colors {{{
" ---
let g:terminal_color_0 = '#2a2a2a'
let g:terminal_color_1 = '#d370a3'
let g:terminal_color_2 = '#6d9e3f'
let g:terminal_color_3 = '#b58858'
let g:terminal_color_4 = '#6095c5'
let g:terminal_color_5 = '#ac7bde'
let g:terminal_color_6 = '#3ba275'
let g:terminal_color_7 = '#ffffff'
let g:terminal_color_8 = '#686868'
let g:terminal_color_9 = '#ffa7da'
let g:terminal_color_10 = '#a3d572'
let g:terminal_color_11 = '#efbd8b'
let g:terminal_color_12 = '#98cbfe'
let g:terminal_color_13 = '#e5b0ff'
let g:terminal_color_14 = '#75daa9'
let g:terminal_color_15 = '#cfcfcf'
" }}}

" Tabline {{{
" ---
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

" Highlights: General GUI {{{
" ---
" :h slow-terminal  " gui=NONE guifg=NONE
highlight NonText cterm=NONE ctermfg=NONE
highlight! link jsFutureKeys PreProc
highlight! WarningMsg  ctermfg=100 guifg=#CCC566

highlight! link vimFunc Function
highlight! link vimFunction Function
highlight! link vimUserFunc PreProc

highlight! link htmlBold String
highlight! link htmlItalic Type
highlight! link markdownH1 Title
highlight! link htmlH1 markdownH1
highlight! link htmlH2 markdownH1
highlight! link htmlH3 markdownH1
highlight! link htmlH4 markdownH1
highlight! link htmlH5 markdownH1
highlight! link htmlH6 markdownH1
highlight! link htmlSpecialChar SpecialChar
highlight! link htmlTag Keyword
highlight! link htmlTagN Identifier
highlight! link htmlEndTag Statement

highlight! link VimwikiHeaderChar markdownHeadingDelimiter
highlight! link VimwikiHR Keyword
highlight! link VimwikiList markdownListMarker

hi! link mkdBold htmlBold
hi! link mkdItalic htmlItalic
" hi! link mkdString Keyword
" hi! link mkdCodeStart mkdCode
" hi! link mkdCodeEnd mkdCode
" hi! link mkdBlockquote Comment
" hi! link mkdListItem Keyword
hi! link mkdListItemLine Normal
" hi! link mkdFootnotes mkdFootnote
" hi! link mkdLink markdownLinkText
" hi! link mkdURL markdownUrl
" hi! link mkdInlineURL mkdURL
" hi! link mkdID Identifier
" hi! link mkdLinkDef mkdLink
" hi! link mkdLinkDefTarget mkdURL
" hi! link mkdLinkTitle mkdInlineURL
" hi! link mkdDelimiter Keyword

" See: https://github.com/itchyny/vim-parenmatch
let g:parenmatch_highlight = 0
highlight! ParenMatch ctermbg=236 guibg=#494D2A cterm=underline gui=underline

" See: https://github.com/dominikduda/vim_current_word
highlight! CurrentWord ctermbg=236 guibg=#2D3C42 cterm=NONE gui=NONE
highlight! CurrentWordTwins ctermbg=235 guibg=#252A3D cterm=NONE gui=NONE
" highlight! CurrentWord ctermbg=60 guibg=#2D3C42 cterm=NONE gui=NONE
" highlight! CurrentWordTwins ctermbg=237 guibg=#2B2A22 cterm=NONE gui=NONE

" highlight! link MatchParen  Visual
" highlight! MatchParen  ctermfg=NONE guifg=NONE ctermbg=236 guibg=#2d3c42
" highlight! ParenMatch  ctermfg=NONE guifg=NONE ctermbg=236 guibg=#494d2A

" highlight! Error  term=NONE cterm=NONE
" highlight! link WarningMsg  Comment
" highlight! link pythonSpaceError  NONE
" highlight! link pythonIndentError NONE
" highlight! link mkdLineBreak      NONE
" }}}

" Plugin: Defx icons and highlights {{{
" ---
highlight! defxSelected             ctermbg=97 guibg=#36202b
highlight Defx_filename_3_Modified  ctermfg=1  guifg=#D370A3
highlight Defx_filename_3_Staged    ctermfg=10 guifg=#A3D572
highlight Defx_filename_3_Ignored   ctermfg=8  guifg=#404660
highlight link Defx_filename_3_root_marker Comment

highlight def link Defx_filename_3_Untracked Comment
highlight def link Defx_filename_3_Unknown Comment
highlight def link Defx_filename_3_Renamed Title
highlight def link Defx_filename_3_Unmerged Label
" highlight Defx_git_Deleted   ctermfg=13 guifg=#b294bb
" }}}

" Plugin: Ale {{{
" ---
highlight! ALEErrorSign ctermfg=167 guifg=#fb4934
highlight! ALEWarningSign ctermfg=214 guifg=#fabd2f
highlight! ALEInfoSign ctermfg=109 guifg=#83a598
" highlight! ALEStyleErrorSign
" highlight! ALEStyleWarningSign
" }}}

" Plugin: Neomake icons {{{
" ---
" let g:neomake_error_sign = {'text': '✘', 'texthl': 'ErrorMsg'}
" let g:neomake_warning_sign = {'text': '✚', 'texthl': 'WarningSyntax'}
" let g:neomake_message_sign = {'text': '♯', 'texthl': 'NeomakeMessageSign'}
" let g:neomake_info_sign = {'text': '⋆', 'texthl': 'NeomakeInfoSign'}
" highlight! clear WarningSyntax
" highlight! WarningSyntax ctermfg=58 guifg=#7d7629
"}}}

" Plugin: vim-gitgutter {{{
" ---
highlight! GitGutterAdd ctermfg=22 guifg=#008500 ctermbg=234 guibg=#1c1c1c
highlight! GitGutterChange ctermfg=58 guifg=#808200 ctermbg=234 guibg=#1c1c1c
highlight! GitGutterDelete ctermfg=52 guifg=#800000 ctermbg=234 guibg=#1c1c1c
highlight! GitGutterChangeDelete ctermfg=52 guifg=#800000 ctermbg=234 guibg=#1c1c1c
" }}}

" Plugin: denite {{{
" ---
highlight! clear WildMenu
highlight! WildMenu ctermbg=97 guibg=#82395F
highlight! link deniteSelectedLine Statement
highlight! link deniteMatchedChar Function
highlight! link deniteMatchedRange Underlined
highlight! link deniteMode Comment
highlight! link deniteSource_QuickfixPosition qfLineNr
highlight! link deniteSource__LocationListPosition qfLineNr
highlight! link deniteSource__LocationListError Constant
highlight! link deniteSource__LocationListWarning PreProc
" }}}

" Plugin: vim-highlightedyank {{{
" ---
highlight! link HighlightedyankRegion DiffText
" }}}

" Plugin: vim-signature {{{
highlight! SignatureMarkText    ctermfg=11 guifg=#756207 ctermbg=234 guibg=#1c1c1c
highlight! SignatureMarkerText  ctermfg=12 guifg=#4EA9D7 ctermbg=234 guibg=#1c1c1c
" }}}

" Plugin: vim-choosewin {{{
" ---
let g:choosewin_color_label = {
	\ 'cterm': [  75, 233 ], 'gui': [ '#7f99cd', '#000000' ] }
let g:choosewin_color_label_current = {
	\ 'cterm': [ 228, 233 ], 'gui': [ '#D7D17C', '#000000' ] }
let g:choosewin_color_other = {
	\ 'cterm': [ 235, 235 ], 'gui': [ '#232323', '#000000' ] }
" }}}

" vim: set foldmethod=marker ts=2 sw=0 tw=80 noet :
