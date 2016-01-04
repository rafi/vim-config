
" rafi-2015 - hybrid custom
" -------------------------

" gVim Appearance {{{
" ---------------
if has('gui_running')
	set guifont=PragmataPro:h17
	set noantialias
endif

" }}}
" General GUI {{{
" Whitespace
highlight SpecialKey   ctermfg=237  guifg=#30302c
" Last search highlighting and quickfix's current line
highlight Search       ctermfg=183  ctermbg=237
" Visual mode selection
highlight Visual       ctermbg=236
" YAML scalar
highlight yamlScalar   ctermfg=250  guifg=#a8a897

" }}}
" Markdown/HTML {{{
highlight link htmlH1 Statement
highlight htmlItalic  ctermfg=230 cterm=NONE term=NONE

" }}}
" GitGutter {{{
highlight GitGutterAdd ctermfg=22
highlight GitGutterChange ctermfg=94
highlight GitGutterDelete ctermfg=52
highlight GitGutterChangeDelete ctermfg=52

" }}}
" Popup menu {{{
highlight Pmenu       ctermfg=245 ctermbg=235
highlight PmenuSel    ctermfg=236 ctermbg=248
highlight PmenuSbar   ctermbg=235
highlight PmenuThumb  ctermbg=238

" }}}
" Errors {{{
" No bold in gvim's error messages
highlight ErrorMsg  gui=NONE
highlight Error     term=NONE cterm=NONE

highlight BadWhitespace ctermfg=darkred ctermbg=black guifg=#382424 guibg=black

" }}}
" Unite {{{
highlight uniteInputPrompt ctermfg=237

" }}}
" Unite Grep {{{
highlight link uniteSource__Grep           Normal
highlight link uniteCandidateInputKeyword  Function
highlight uniteSource__GrepLineNr       ctermfg=240 guifg=#808070
highlight uniteSource__GrepLine         ctermfg=245 guifg=#808070
highlight uniteSource__GrepFile         ctermfg=4   guifg=#8197bf
highlight uniteSource__GrepSeparator    ctermfg=5   guifg=#f0a0c0
highlight uniteSource__GrepPattern      ctermfg=1   guifg=#cf6a4c

" }}}
" Unite Quickfix {{{
highlight UniteQuickFixWarning              ctermfg=1
highlight uniteSource__QuickFix             ctermfg=8
highlight uniteSource__QuickFix_Bold        ctermfg=249
highlight link uniteSource__QuickFix_File   Directory
highlight link uniteSource__QuickFix_LineNr qfLineNr

" }}}
" VimFiler {{{
highlight vimfilerNonMark     ctermfg=132 guifg=#4e4e43
highlight vimfilerLeaf        ctermfg=238 guifg=#30302c
highlight vimfilerNormalFile  ctermfg=243 guifg=#808070
highlight vimfilerMarkedFile  ctermfg=173
highlight vimfilerOpenedFile  ctermfg=250 guifg=#e8e8d3
highlight vimfilerClosedFile  ctermfg=246 guifg=#a8a897

" }}}
" vim-indent-guides "{{{
highlight IndentGuidesOdd  guibg=#333333 ctermbg=235
highlight IndentGuidesEven guibg=#333333 ctermbg=235

" }}}
" Plugin: vim-operator-flashy {{{
highlight Flashy ctermfg=190 ctermbg=232 guifg=#D6FF00 guibg=#080808

" }}}
