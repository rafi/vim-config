
" hybrid custom
" ===

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
highlight! UserBorder         ctermfg=254 guifg=#525865
highlight! UserSelectionCaret ctermfg=139 guifg=#B294BB ctermbg=97 guibg=#4D2238
highlight! UserSelectionBackground                      ctermbg=97 guibg=#4D2238
" #ACAFAE  #2C3237
" #2a2e36  #525865
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
highlight IncSearch guifg=#222222 guibg=#99ad6a cterm=NONE gui=NONE
highlight NonText cterm=NONE ctermfg=NONE
highlight! link jsFutureKeys PreProc
highlight! WarningMsg  ctermfg=100 guifg=#CCC566
highlight! link QuickFixLine WildMenu
highlight! link lspReference Visual

" if has('nvim') || has('patch-7.4.2218')
" 	highlight EndOfBuffer gui=NONE guifg=#303030
" endif

if has('nvim')
	highlight TermCursor    gui=NONE guibg=#cc22a0
	highlight TermCursorNC  gui=NONE guibg=#666666
	" highlight NormalNC      gui=NONE guibg=#2c2c2c guifg=#bfbfbf
endif

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
" hi! link mkdListItemLine Normal
" hi! link mkdFootnotes mkdFootnote
" hi! link mkdLink markdownLinkText
" hi! link mkdURL markdownUrl
" hi! link mkdInlineURL mkdURL
" hi! link mkdID Identifier
" hi! link mkdLinkDef mkdLink
" hi! link mkdLinkDefTarget mkdURL
" hi! link mkdLinkTitle mkdInlineURL
" hi! link mkdDelimiter Keyword

" simrat39/symbols-outline.nvim
highlight! FocusedSymbol ctermbg=236 guibg=#2D3C42 cterm=NONE gui=NONE

" See: https://github.com/itchyny/vim-parenmatch
let g:parenmatch_highlight = 0
highlight! ParenMatch ctermbg=236 guibg=#494D2A cterm=underline gui=underline

" See: https://github.com/dominikduda/vim_current_word
highlight! CurrentWord ctermbg=236 guibg=#2D3C42 cterm=NONE gui=NONE
highlight! CurrentWordTwins ctermbg=235 guibg=#252A3D cterm=NONE gui=NONE
" highlight! CurrentWord ctermbg=60 guibg=#2D3C42 cterm=NONE gui=NONE
" highlight! CurrentWordTwins ctermbg=237 guibg=#2B2A22 cterm=NONE gui=NONE
" highlight! MatchParen  ctermfg=NONE guifg=NONE ctermbg=236 guibg=#2d3c42
" highlight! ParenMatch  ctermfg=NONE guifg=NONE ctermbg=236 guibg=#494d2A
" }}}

" Plugin: IndentGuides {{{
" ---
" highlight! IndentGuidesOdd  guifg=#292B2D guibg=#232527
" highlight! IndentGuidesEven guifg=#232527 guibg=#292B2D
" }}}

" Plugin: IndentBlankline {{{
" ---
highlight! IndentBlanklineChar cterm=nocombine gui=nocombine guibg=#232527
highlight! IndentBlanklineCharOdd cterm=nocombine gui=nocombine guibg=#292B2D
" highlight! IndentBlanklineSpaceChar cterm=nocombine gui=nocombine guifg=#373b41
" highlight! IndentBlanklineSpaceCharBlankline cterm=nocombine gui=nocombine guifg=#373b41
" highlight! IndentBlanklineContextChar cterm=nocombine ctermbg=110 gui=nocombine guibg=#81a2be
" }}}

" Plugin: Telescope {{{
" ---
highlight! clear WildMenu
highlight! link WildMenu UserSelectionBackground
highlight! link TelescopeSelection WildMenu
highlight! link TelescopeSelectionCaret UserSelectionCaret
highlight! link TelescopeBorder UserBorder
highlight! link TelescopePromptBorder UserBorder
highlight! link TelescopeResultsBorder UserBorder
highlight! link TelescopePreviewBorder UserBorder
" }}}

" Plugin: Fern {{{
" ---
highlight! FernGitStatusBracket  ctermfg=234 ctermbg=NONE guifg=bg guibg=NONE
highlight! FernGitStatusIndex    ctermfg=10  guifg=#A3D572
highlight! FernGitStatusWorktree ctermfg=1   guifg=#D370A3
highlight! link FernSpinner Identifier
" }}}

" Plugin: Bqf {{{
" ---
" hi default link BqfPreviewFloat Normal
highlight! BqfPreviewBorder guifg=#525865
highlight! link BqfPreviewCursor TermCursor
highlight! default link BqfPreviewRange TermCursorNC
" hi default BqfSign ctermfg=14 guifg=Cyan
" }}}

" Plugin: gitsigns {{{
" ---
" highlight! SignColumn ctermbg=234 guibg=#1c1c1c
highlight! GitSignsAdd ctermfg=22 guifg=#008500 ctermbg=234 guibg=#1c1c1c
highlight! GitSignsChange ctermfg=58 guifg=#808200 ctermbg=234 guibg=#1c1c1c
highlight! GitSignsDelete ctermfg=52 guifg=#800000 ctermbg=234 guibg=#1c1c1c
" }}}

" Plugin: vim-highlightedyank {{{
" ---
highlight! link HighlightedyankRegion DiffText
" }}}

" Plugin: vim-shot-f {{{
" ---
highlight! ShotFGraph ctermbg=236 guibg=#3A4F3E
highlight! link ShotFBlank SpellBad
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
