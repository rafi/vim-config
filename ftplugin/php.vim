setlocal formatoptions=qroct " Correct indentation after opening a phpdocblock
setlocal makeprg=php\ -l\ %  " Use php syntax check when doing :make
"setlocal iskeyword+=\\       " Add the namespace separator as a keyword
"setlocal path+=/usr/share/pear

" Use errorformat for parsing PHP error output
setlocal errorformat=%m\ in\ %f\ on\ line\ %l

" Key bindings
"nnoremap <buffer> zM :<C-u>EnableFastPHPFolds<CR>zM
nnoremap <buffer> K :!zeal --query "php:<cword>"&<CR><CR>
nnoremap <silent><buffer> <Leader>d :call pdv#DocumentCurrentLine()<CR>
