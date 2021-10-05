if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=//\ %s

" Set 'formatoptions' to break comment lines but not other lines,
" " and insert the comment leader when hitting <CR> or using "o".
setlocal formatoptions-=t formatoptions+=croql

setlocal suffixesadd+=.re,.rei

let b:ale_fixers = ['prettier']
