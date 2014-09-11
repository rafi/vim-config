
" Theme & Colors {{{1
"------------------------------------------------------------------------------

" Theme {{{2
" -----
set t_Co=256
set background=dark
colorscheme hybrid

" Custom Colors {{{2
" -------------

" General GUI {{{3
" No bold in gvim's error messages
highlight ErrorMsg     gui=NONE
" Whitespace
highlight SpecialKey   ctermfg=235  guifg=#30302c
" YAML scalar
highlight yamlScalar   ctermfg=250  guifg=#a8a897
" Last search highlighting and quickfix's current line
highlight Search       ctermfg=183  ctermbg=237
" Brakets and pairs
highlight MatchParen   ctermfg=220  ctermbg=237
" Markdown headers
highlight link htmlH1 Statement
" Mode message (insert, visual, etc)
highlight ModeMsg      ctermfg=240
" Visual mode selection
highlight Visual       ctermbg=236

" Popup menu {{{3
highlight Pmenu       ctermfg=245 ctermbg=235
highlight PmenuSel    ctermfg=236 ctermbg=248
highlight PmenuSbar   ctermbg=235
highlight PmenuThumb  ctermbg=238

" Tabline {{{3
highlight TabLineFill      ctermfg=236 guifg=#303030
highlight TabLine          ctermfg=236 ctermbg=243 guifg=#303030 guibg=#767676
highlight TabLineSel       ctermfg=241 ctermbg=234 guifg=#626262 guibg=#1C1C1C gui=NONE
highlight TabLineSelRe     ctermfg=234 ctermbg=236 guifg=#1C1C1C guibg=#303030
highlight TabLineProject   ctermfg=252 ctermbg=238 guifg=#D0D0D0 guibg=#444444
highlight TabLineProjectRe ctermfg=238 ctermbg=236 guifg=#444444 guibg=#303030
highlight TabLineA         ctermfg=235 ctermbg=234 guifg=#262626 guibg=#1C1C1C

" Unite {{{3
highlight uniteInputPrompt            ctermfg=237
highlight uniteCandidateMarker        ctermfg=143
highlight uniteCandidateInputKeyword  ctermfg=12

" Grep {{{3
highlight link uniteSource__Grep        Directory
highlight link uniteSource__GrepLineNr  qfLineNr
highlight uniteSource__GrepLine         ctermfg=245 guifg=#808070
highlight uniteSource__GrepFile         ctermfg=4   guifg=#8197bf
highlight uniteSource__GrepSeparator    ctermfg=5   guifg=#f0a0c0
highlight uniteSource__GrepPattern      ctermfg=1   guifg=#cf6a4c

" Quickfix {{{3
highlight UniteQuickFixWarning              ctermfg=1
highlight uniteSource__QuickFix             ctermfg=8
highlight uniteSource__QuickFix_Bold        ctermfg=249
highlight link uniteSource__QuickFix_File   Directory
highlight link uniteSource__QuickFix_LineNr qfLineNr

" VimFiler {{{3
highlight vimfilerNormalFile  ctermfg=245 guifg=#808070
highlight vimfilerClosedFile  ctermfg=249 guifg=#a8a897
highlight vimfilerOpenedFile  ctermfg=254 guifg=#e8e8d3
highlight vimfilerNonMark     ctermfg=239 guifg=#4e4e43
highlight vimfilerLeaf        ctermfg=235 guifg=#30302c

" Signify {{{3
highlight SignifySignAdd    ctermfg=2 guifg=#6D9B37
highlight SignifySignDelete ctermfg=1 guifg=#D370A3
highlight SignifySignChange ctermfg=3 guifg=#B58858

" }}}
