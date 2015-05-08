
" Theme & Colors
"---------------------------------------------------------

" Theme {{{
" -----
set t_Co=256
set background=dark

" Don't override colorscheme.
if ! exists('g:colors_name')
	colorscheme hybrid
endif

" Custom Colors
" -------------

" General GUI {{{
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

" }}}
" Markdown/HTML {{{
highlight htmlItalic  ctermfg=230 cterm=NONE term=NONE

" }}}
" Popup menu {{{
highlight Pmenu       ctermfg=245 ctermbg=235
highlight PmenuSel    ctermfg=236 ctermbg=248
highlight PmenuSbar   ctermbg=235
highlight PmenuThumb  ctermbg=238

" }}}
" Unite {{{
highlight uniteInputPrompt            ctermfg=237
highlight uniteCandidateMarker        ctermfg=143
highlight uniteCandidateInputKeyword  ctermfg=12

" }}}
" Grep {{{
highlight link uniteSource__Grep        Directory
highlight link uniteSource__GrepLineNr  qfLineNr
highlight uniteSource__GrepLine         ctermfg=245 guifg=#808070
highlight uniteSource__GrepFile         ctermfg=4   guifg=#8197bf
highlight uniteSource__GrepSeparator    ctermfg=5   guifg=#f0a0c0
highlight uniteSource__GrepPattern      ctermfg=1   guifg=#cf6a4c

" }}}
" Quickfix {{{
highlight UniteQuickFixWarning              ctermfg=1
highlight uniteSource__QuickFix             ctermfg=8
highlight uniteSource__QuickFix_Bold        ctermfg=249
highlight link uniteSource__QuickFix_File   Directory
highlight link uniteSource__QuickFix_LineNr qfLineNr

" }}}
" VimFiler {{{
highlight vimfilerNormalFile  ctermfg=245 guifg=#808070
highlight vimfilerClosedFile  ctermfg=249 guifg=#a8a897
highlight vimfilerOpenedFile  ctermfg=254 guifg=#e8e8d3
highlight vimfilerNonMark     ctermfg=239 guifg=#4e4e43
highlight vimfilerLeaf        ctermfg=235 guifg=#30302c

" }}}

" vim: set ts=2 sw=2 tw=80 noet :
