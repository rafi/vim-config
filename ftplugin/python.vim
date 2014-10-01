setlocal softtabstop=4
setlocal shiftwidth=4
setlocal smarttab
setlocal expandtab
setlocal nosmartindent
setlocal foldmethod=indent

setlocal cindent
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal previewheight=4
setlocal errorformat=%f:%l:%c:\ %m
setlocal errorformat+=%f:%l:\ %m
setlocal makeprg=flake8\ %
