let s:save_cpo = &cpoptions
set cpoptions&vim

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= ' | '
else
	let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setl modeline< iskeyword< keywordprg< suffixesadd< includeexpr< path<'

setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal keywordprg=:help
" setlocal foldmethod=indent
" setlocal conceallevel=0

" For gf
let &l:path = join(map(split(&runtimepath, ','), 'v:val."/autoload"'), ',')
setlocal suffixesadd=.vim
setlocal includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')

let &cpoptions = s:save_cpo
