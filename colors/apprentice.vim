" 'apprentice.vim' -- Vim color scheme.
" Maintainer:   Romain Lafourcade (romainlafourcade@gmail.com)
" Essentially a streamlining and conversion to X11 colors of
" 'sorcerer' by Jeet Sukumaran (jeetsukumaran@gmailcom)

set background=dark

hi clear

if exists('syntax_on')
  syntax reset

endif

let colors_name = 'apprentice'

if &t_Co >= 256 || has('gui_running')
  hi Normal           ctermbg=235  ctermfg=250  guibg=#262626 guifg=#bcbcbc cterm=NONE           gui=NONE
  hi Comment          ctermbg=NONE ctermfg=240  guibg=NONE    guifg=#585858 cterm=NONE           gui=NONE
  hi Constant         ctermbg=NONE ctermfg=208  guibg=NONE    guifg=#ff8700 cterm=NONE           gui=NONE
  hi Error            ctermbg=131  ctermfg=235  guibg=#af5f5f guifg=#262626 cterm=NONE           gui=NONE
  hi Identifier       ctermbg=NONE ctermfg=103  guibg=NONE    guifg=#5f87af cterm=NONE           gui=NONE
  hi Ignore           ctermbg=NONE ctermfg=235  guibg=NONE    guifg=#262626 cterm=NONE           gui=NONE
  hi PreProc          ctermbg=NONE ctermfg=66   guibg=NONE    guifg=#5f8787 cterm=NONE           gui=NONE
  hi Special          ctermbg=NONE ctermfg=65   guibg=NONE    guifg=#5f875f cterm=NONE           gui=NONE
  hi Statement        ctermbg=NONE ctermfg=110  guibg=NONE    guifg=#8fafd7 cterm=NONE           gui=NONE
  hi String           ctermbg=NONE ctermfg=108  guibg=NONE    guifg=#87af87 cterm=NONE           gui=NONE
  hi Todo             ctermbg=NONE ctermfg=NONE guibg=NONE    guifg=NONE    cterm=reverse        gui=reverse
  hi Type             ctermbg=NONE ctermfg=103  guibg=NONE    guifg=#8787af cterm=NONE           gui=NONE
  hi Underlined       ctermbg=NONE ctermfg=66   guibg=NONE    guifg=#5f8787 cterm=underline      gui=underline

  hi LineNr           ctermbg=234  ctermfg=240  guibg=#1c1c1c guifg=#585858 cterm=NONE           gui=NONE
  hi NonText          ctermbg=NONE ctermfg=240  guibg=NONE    guifg=#585858 cterm=NONE           gui=NONE

  hi Pmenu            ctermbg=238  ctermfg=250  guibg=#444444 guifg=#bcbcbc cterm=NONE           gui=NONE
  hi PmenuSbar        ctermbg=240  ctermfg=NONE guibg=#585858 guifg=NONE    cterm=NONE           gui=NONE
  hi PmenuSel         ctermbg=66   ctermfg=235  guibg=#5f8787 guifg=#262626 cterm=NONE           gui=NONE
  hi PmenuThumb       ctermbg=66   ctermfg=66   guibg=#5f8787 guifg=#5f8787 cterm=NONE           gui=NONE

  hi ErrorMsg         ctermbg=131  ctermfg=235  guibg=#af5f5f guifg=#262626 cterm=NONE           gui=NONE
  hi ModeMsg          ctermbg=108  ctermfg=235  guibg=#87af87 guifg=#262626 cterm=NONE           gui=NONE
  hi MoreMsg          ctermbg=NONE ctermfg=66   guibg=NONE    guifg=#5f8787 cterm=NONE           gui=NONE
  hi Question         ctermbg=NONE ctermfg=108  guibg=NONE    guifg=#87af87 cterm=NONE           gui=NONE
  hi WarningMsg       ctermbg=NONE ctermfg=131  guibg=NONE    guifg=#af5f5f cterm=NONE           gui=NONE

  hi TabLine          ctermbg=234  ctermfg=240  guibg=#1c1c1c guifg=#585858 cterm=NONE           gui=NONE
  hi TabLineFill      ctermbg=234  ctermfg=234  guibg=#1c1c1c guifg=#1c1c1c cterm=NONE           gui=reverse
  hi TabLineSel       ctermbg=236  ctermfg=73   guibg=#303030 guifg=#5fafaf cterm=NONE           gui=NONE

  hi Cursor           ctermbg=242  ctermfg=NONE guibg=#6c6c6c guifg=NONE    cterm=NONE           gui=NONE
  hi CursorColumn     ctermbg=236  ctermfg=NONE guibg=#303030 guifg=NONE    cterm=NONE           gui=NONE
  hi CursorLine       ctermbg=236  ctermfg=NONE guibg=#303030 guifg=NONE    cterm=NONE           gui=NONE
  hi CursorLineNr     ctermbg=236  ctermfg=73   guibg=#303030 guifg=#5fafaf cterm=NONE           gui=NONE

  hi helpLeadBlank    ctermbg=NONE ctermfg=NONE guibg=NONE    guifg=NONE    cterm=NONE           gui=NONE
  hi helpNormal       ctermbg=NONE ctermfg=NONE guibg=NONE    guifg=NONE    cterm=NONE           gui=NONE

  hi StatusLine       ctermbg=101  ctermfg=235  guibg=#87875f guifg=#262626 cterm=NONE           gui=NONE
  hi StatusLineNC     ctermbg=242  ctermfg=235  guibg=#6c6c6c guifg=#262626 cterm=NONE           gui=italic

  hi Visual           ctermbg=110  ctermfg=235  guibg=#8fafd7 guifg=#262626 cterm=NONE           gui=NONE
  hi VisualNOS        ctermbg=NONE ctermfg=NONE guibg=NONE    guifg=NONE    cterm=bold,underline gui=bold,underline

  hi FoldColumn       ctermbg=240  ctermfg=250  guibg=#585858 guifg=#bcbcbc cterm=NONE           gui=NONE
  hi Folded           ctermbg=240  ctermfg=250  guibg=#585858 guifg=#bcbcbc cterm=NONE           gui=NONE

  hi VertSplit        ctermbg=242  ctermfg=242  guibg=#6c6c6c guifg=#6c6c6c cterm=NONE           gui=NONE
  hi WildMenu         ctermbg=110  ctermfg=235  guibg=#8fafd7 guifg=#262626 cterm=bold           gui=bold

  hi Function         ctermbg=NONE ctermfg=229  guibg=NONE    guifg=#ffffaf cterm=NONE           gui=NONE
  hi SpecialKey       ctermbg=NONE ctermfg=240  guibg=NONE    guifg=#585858 cterm=NONE           gui=NONE
  hi Title            ctermbg=NONE ctermfg=231  guibg=NONE    guifg=#ffffff cterm=bold           gui=NONE

  hi DiffAdd          ctermbg=108  ctermfg=235  guibg=#87af87 guifg=#262626 cterm=NONE           gui=NONE
  hi DiffChange       ctermbg=60   ctermfg=235  guibg=#5f5f87 guifg=#262626 cterm=NONE           gui=NONE
  hi DiffDelete       ctermbg=131  ctermfg=235  guibg=#af5f5f guifg=#262626 cterm=NONE           gui=NONE
  hi DiffText         ctermbg=103  ctermfg=235  guibg=#8787af guifg=#262626 cterm=NONE           gui=NONE

  hi IncSearch        ctermbg=131  ctermfg=235  guibg=#af5f5f guifg=#262626 cterm=NONE           gui=NONE
  hi Search           ctermbg=108  ctermfg=235  guibg=#87af87 guifg=#262626 cterm=NONE           gui=NONE

  hi Directory        ctermbg=NONE ctermfg=73   guibg=NONE    guifg=#5fafaf cterm=NONE           gui=NONE
  hi MatchParen       ctermbg=NONE ctermfg=229  guibg=NONE    guifg=#ffffaf cterm=bold           gui=NONE

  hi SpellBad         ctermbg=NONE ctermfg=131  guibg=NONE    guifg=NONE    cterm=undercurl      gui=undercurl guisp=#af5f5f
  hi SpellCap         ctermbg=NONE ctermfg=73   guibg=NONE    guifg=NONE    cterm=undercurl      gui=undercurl guisp=#5fafaf
  hi SpellLocal       ctermbg=NONE ctermfg=65   guibg=NONE    guifg=NONE    cterm=undercurl      gui=undercurl guisp=#5f875f
  hi SpellRare        ctermbg=NONE ctermfg=208  guibg=NONE    guifg=NONE    cterm=undercurl      gui=undercurl guisp=#ff8700

  hi ColorColumn      ctermbg=131  ctermfg=NONE guibg=#af5f5f guifg=NONE    cterm=NONE           gui=NONE
  hi SignColumn       ctermbg=238  ctermfg=235  guibg=#444444 guifg=#262626 cterm=NONE           gui=NONE

else
  hi Normal           ctermbg=NONE        ctermfg=LightGrey   cterm=NONE
  hi Boolean          ctermbg=NONE        ctermfg=DarkYellow  cterm=NONE
  hi Comment          ctermbg=NONE        ctermfg=DarkBlue    cterm=NONE
  hi Constant         ctermbg=NONE        ctermfg=DarkYellow  cterm=NONE
  hi Function         ctermbg=NONE        ctermfg=Yellow      cterm=NONE
  hi Identifier       ctermbg=NONE        ctermfg=Blue        cterm=NONE
  hi PreProc          ctermbg=NONE        ctermfg=DarkCyan    cterm=NONE
  hi Special          ctermbg=NONE        ctermfg=DarkGreen   cterm=NONE
  hi Statement        ctermbg=NONE        ctermfg=DarkCyan    cterm=NONE
  hi String           ctermbg=NONE        ctermfg=DarkGreen   cterm=NONE
  hi Todo             ctermbg=NONE        ctermfg=NONE        cterm=reverse
  hi Type             ctermbg=NONE        ctermfg=DarkMagenta cterm=NONE

  hi Error            ctermbg=Red         ctermfg=White       cterm=NONE
  hi Ignore           ctermbg=NONE        ctermfg=NONE        cterm=NONE
  hi Underlined       ctermbg=NONE        ctermfg=Cyan        cterm=underline

  hi LineNr           ctermbg=NONE        ctermfg=DarkBlue    cterm=NONE
  hi NonText          ctermbg=NONE        ctermfg=DarkBlue    cterm=NONE

  hi Pmenu            ctermbg=NONE        ctermfg=White       cterm=NONE
  hi PmenuSbar        ctermbg=White       ctermfg=NONE        cterm=NONE
  hi PmenuSel         ctermbg=Green       ctermfg=Black       cterm=NONE
  hi PmenuThumb       ctermbg=Green       ctermfg=NONE        cterm=NONE

  hi ErrorMsg         ctermbg=NONE        ctermfg=Red         cterm=NONE
  hi ModeMsg          ctermbg=NONE        ctermfg=Green       cterm=NONE
  hi MoreMsg          ctermbg=NONE        ctermfg=Cyan        cterm=NONE
  hi Question         ctermbg=NONE        ctermfg=Green       cterm=NONE
  hi WarningMsg       ctermbg=NONE        ctermfg=Red         cterm=NONE

  hi TabLine          ctermbg=DarkBlue    ctermfg=Black       cterm=NONE
  hi TabLineFill      ctermbg=DarkBlue    ctermfg=DarkBlue    cterm=NONE
  hi TabLineSel       ctermbg=Cyan        ctermfg=Black       cterm=NONE

  hi Cursor           ctermbg=NONE        ctermfg=NONE        cterm=NONE
  hi CursorLine       ctermbg=NONE        ctermfg=NONE        cterm=underline
  hi CursorLineNr     ctermbg=NONE        ctermfg=White       cterm=underline

  hi helpLeadBlank    ctermbg=NONE        ctermfg=NONE        cterm=NONE
  hi helpNormal       ctermbg=NONE        ctermfg=NONE        cterm=NONE

  hi StatusLine       ctermbg=Cyan        ctermfg=Black       cterm=NONE
  hi StatusLineNC     ctermbg=Blue        ctermfg=Black       cterm=NONE

  hi Visual           ctermbg=White       ctermfg=Black       cterm=NONE
  hi VisualNOS        ctermbg=NONE        ctermfg=NONE        cterm=bold,underline

  hi FoldColumn       ctermbg=DarkRed     ctermfg=White       cterm=NONE
  hi Folded           ctermbg=DarkRed     ctermfg=White       cterm=NONE

  hi VertSplit        ctermbg=DarkCyan    ctermfg=DarkCyan    cterm=NONE
  hi WildMenu         ctermbg=Yellow      ctermfg=Black       cterm=NONE

  hi Function         ctermbg=NONE        ctermfg=Yellow      cterm=NONE
  hi SpecialKey       ctermbg=NONE        ctermfg=DarkMagenta cterm=NONE
  hi Title            ctermbg=NONE        ctermfg=White       cterm=bold

  hi DiffAdd          ctermbg=DarkGreen   ctermfg=Black       cterm=NONE
  hi DiffChange       ctermbg=Blue        ctermfg=Black       cterm=NONE
  hi DiffDelete       ctermbg=DarkRed     ctermfg=Black       cterm=NONE
  hi DiffText         ctermbg=Cyan        ctermfg=Black       cterm=NONE

  hi IncSearch        ctermbg=DarkRed     ctermfg=Black       cterm=NONE
  hi Search           ctermbg=Green       ctermfg=Black       cterm=NONE

  hi Directory        ctermbg=NONE        ctermfg=Cyan        cterm=NONE

  hi SpellBad         ctermbg=NONE        ctermfg=Red         cterm=undercurl
  hi SpellCap         ctermbg=NONE        ctermfg=Cyan        cterm=undercurl
  hi SpellLocal       ctermbg=NONE        ctermfg=Green       cterm=undercurl
  hi SpellRare        ctermbg=NONE        ctermfg=Magenta     cterm=undercurl

  hi ColorColumn      ctermbg=DarkRed     ctermfg=NONE        cterm=NONE
  hi SignColumn       ctermbg=DarkMagenta ctermfg=Black       cterm=NONE

endif

hi link Boolean            Constant
hi link Character          Constant
hi link Conceal            Normal
hi link Conditional        Statement
hi link Debug              Special
hi link Define             PreProc
hi link Delimiter          Special
hi link Exception          Statement
hi link Float              Number
hi link HelpCommand        Statement
hi link HelpExample        Statement
hi link Include            PreProc
hi link Keyword            Statement
hi link Label              Statement
hi link Macro              PreProc
hi link Number             Constant
hi link Operator           Statement
hi link PreCondit          PreProc
hi link Repeat             Statement
hi link SpecialChar        Special
hi link SpecialComment     Special
hi link StorageClass       Type
hi link Structure          Type
hi link Tag                Special
hi link Typedef            Type

hi link htmlEndTag         htmlTagName
hi link htmlLink           String
hi link htmlSpecialTagName htmlTagName
hi link htmlTag            htmlTagName

hi link diffBDiffer        WarningMsg
hi link diffCommon         WarningMsg
hi link diffDiffer         WarningMsg
hi link diffIdentical      WarningMsg
hi link diffIsA            WarningMsg
hi link diffNoEOL          WarningMsg
hi link diffOnly           WarningMsg
