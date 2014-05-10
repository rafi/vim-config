" Tab settings
setlocal cindent
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
setlocal previewheight=4
setlocal errorformat=%f:%l:%c:\ %m
setlocal errorformat+=%f:%l:\ %m
setlocal makeprg=flake8\ %
let b:dispatch = "flake8 %"
let b:vcm_tab_complete = "omni"
