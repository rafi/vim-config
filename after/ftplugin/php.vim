if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

" Turn conceal off as it causes horrible lag during scrolling in PHP files
set conceallevel=0
