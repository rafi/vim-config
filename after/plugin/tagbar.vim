
" Tagbar
" ------
let g:tagbar_compact = 1
let g:tagbar_type_php = {
    \ 'ctagsbin'  : 'ctags',
    \ 'ctagsargs' : '--fields=+aimS -f -',
    \ 'kinds'     : [
        \ 'd:Constants:0:0',
        \ 'v:Variables:0:0',
        \ 'f:Functions:1',
        \ 'i:Interfaces:0',
        \ 'c:Classes:0',
        \ 'p:Properties:0:0',
        \ 'm:Methods:1',
        \ 'n:Namespaces:0',
        \ 't:Traits:0',
    \ ],
    \ 'sro'        : '::',
    \ 'kind2scope' : {
        \ 'c' : 'class',
        \ 'm' : 'method',
        \ 'f' : 'function',
        \ 'i' : 'interface',
        \ 'n' : 'namespace',
        \ 't' : 'trait',
    \ },
    \ 'scope2kind' : {
        \ 'class'     : 'c',
        \ 'method'    : 'm',
        \ 'function'  : 'f',
        \ 'interface' : 'i',
        \ 'namespace' : 'n',
        \ 'trait'     : 't',
    \ }
\ }
let g:tagbar_type_markdown = {
	\ 'ctagstype' : 'markdown',
	\ 'kinds' : [
		\ 'h:Heading_L1',
		\ 'i:Heading_L2',
		\ 'k:Heading_L3'
	\ ]
\ }
let g:tagbar_type_snippets = {
	\ 'ctagstype' : 'snippets',
	\ 'kinds' : [
		\ 's:snippets',
	\ ]
\ }
let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
