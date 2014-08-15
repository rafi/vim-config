" Vim syntax file
" Additions by mikegerwitz

syn keyword phpStructure namespace use contained
syn keyword phpConstant __DIR__ contained

" namespace separator
syn match phpParent "\\" contained

" 'define'-style keywords that can appear pretty much anywhere
" TODO: better way to do this; I'm not very familiar with vim syntax files
syn keyword phpFlexiDefine new function contained
syn cluster phpClInside add=phpFlexiDefine

hi link phpFlexiDefine Define

" spell checking in comments
if exists("php_parent_error_open")
  syn region  phpComment  start="/\*" end="\*/" contained contains=@Spell,phpTodo
else
  syn region  phpComment  start="/\*" end="\*/" contained contains=@Spell,phpTodo extend
endif
syn match phpComment  "#.\{-}\(?>\|$\)\@="  contained contains=@Spell,phpTodo
syn match phpComment  "//.\{-}\(?>\|$\)\@=" contained contains=@Spell,phpTodo

syn match phpCamelCase '\<[A-Z][a-z]\{-1,}\(\u\U\{-}\)\{-1,}\>' containedin=phpComment contains=@NoSpell transparent contained

" vim: ts=8 sts=2 sw=2 expandtab
