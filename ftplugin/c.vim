" Compiler settings
"compiler clang
"let b:dispatch = 'clang %'
"setlocal makeprg=clang\ %

" General
setlocal foldmethod=syntax
setlocal nofoldenable
setlocal commentstring=//\ %s
setlocal textwidth=80
setlocal equalprg=astyle\ --mode=c
