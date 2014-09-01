" ZoomWin:	Brief-like ability to zoom into/out-of a window
" Author:	Charles Campbell
"			original version by Ron Aaron
" Date:		Mar 27, 2014
" Version:	25n	ASTRO-ONLY
" History: see :help zoomwin-history {{{1
" GetLatestVimScripts: 508 1 :AutoInstall: ZoomWin.vim

" ---------------------------------------------------------------------
" Load Once: {{{1
if &cp || exists("g:loaded_ZoomWinPlugin")
 finish
endif
if v:version < 702
 echohl WarningMsg
 echo "***warning*** this version of ZoomWin needs vim 7.2"
 echohl Normal
 finish
endif
let s:keepcpo              = &cpo
let g:loaded_ZoomWinPlugin = "v25n"
set cpo&vim
"DechoTabOn

" ---------------------------------------------------------------------
"  Public Interface: {{{1
if !hasmapto("<Plug>ZoomWin")
 nmap <unique> <c-w>o  <Plug>ZoomWin
endif
nnoremap <silent> <Plug>ZoomWin :sil call ZoomWin#ZoomWin()<CR>
com! ZoomWin sil call ZoomWin#ZoomWin()

au VimLeave * call ZoomWin#CleanupSessionFile()

" ---------------------------------------------------------------------
" ZoomWin: toggles between a single-window and a multi-window layout {{{1
"          The original version was by Ron Aaron.
"          This function provides compatibility with previous versions.
fun! ZoomWin()
  call ZoomWin#ZoomWin()
endfun

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" ---------------------------------------------------------------------
"  Modelines: {{{1
" vim: ts=4 fdm=marker
