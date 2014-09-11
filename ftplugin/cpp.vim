if has('win32') || has('win64')
	set path+=C:/gcc/include/c++/4.5.0;C:/gcc/i386-pc-mingw32/include
else
	set path+=/usr/local/include;/usr/include
endif

compiler clang
let b:dispatch = 'clang++ %'
setlocal makeprg="clang++"
