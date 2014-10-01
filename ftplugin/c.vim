if has('win32') || has('win64')
	set path+=C:/gcc/i386-pc-mingw32/include
else
	set path+=/usr/local/include;/usr/include
endif

" Compiler settings
compiler clang
setlocal makeprg=clang\ %

" General
setlocal foldmethod=syntax
setlocal nofoldenable
setlocal commentstring=//\ %s
setlocal textwidth=80
setlocal equalprg=astyle\ --mode=c
