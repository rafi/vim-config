setlocal foldmethod=manual   " Using a plugin for php folds
setlocal formatoptions=qroct " Correct indentation after opening a phpdocblock
setlocal makeprg=php\ -l\ %  " Use php syntax check when doing :make
"setlocal iskeyword+=\\       " Add the namespace separator as a keyword

" Use errorformat for parsing PHP error output
"setlocal errorformat=%m\ in\ %f\ on\ line\ %l

" Key bindings
nnoremap <buffer> K :!zeal --query "php:<cword>"&<CR><CR>
