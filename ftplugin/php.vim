setlocal foldmethod=manual   " Using a plugin for php folds
setlocal formatoptions=qroct " Correct indentation after opening a phpdocblock
setlocal makeprg=php\ -l\ %  " Use php syntax check when doing :make
"setlocal iskeyword+=\\       " Add the namespace separator as a keyword

" Use errorformat for parsing PHP error output
setlocal errorformat=%m\ in\ %f\ on\ line\ %l

" Key bindings
nnoremap <buffer> zM :<C-u>EnableFastPHPFolds<CR>zM
nnoremap <buffer> K :!zeal --query "php:<cword>"&<CR><CR>
nnoremap <silent><buffer> <Leader>d :call pdv#DocumentCurrentLine()<CR>

" Fix matchpairs for PHP (for matchit.vim plugin)
" Credits: https://github.com/spf13/PIV
if exists("loaded_matchit")
	let b:match_skip = 's:comment\|string'
	let b:match_words = '<?\(php\)\?:?>,\<switch\>:\<endswitch\>,' .
			\ '\<if\>:\<elseif\>:\<else\>:\<endif\>,' .
			\ '\<while\>:\<endwhile\>,\<do\>:\<while\>,' .
			\ '\<for\>:\<endfor\>,\<foreach\>:\<endforeach\>' .
			\ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
			\ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
			\ '<\@<=\([^/?][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,' .
			\ '<:>,(:),{:},[:]'
endif
