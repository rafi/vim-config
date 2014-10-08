setlocal expandtab
setlocal smarttab
setlocal nosmartindent
setlocal foldmethod=indent
setlocal previewheight=4

setlocal cindent
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal errorformat=%f:%l:%c:\ %m
setlocal errorformat+=%f:%l:\ %m
setlocal makeprg=flake8\ %
