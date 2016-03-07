let s:save_cpo = &cpo
set cpo&vim

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= ' | '
else
	let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setl modeline<'

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal iskeyword+=:,#
setlocal foldenable
setlocal foldmethod=marker
setlocal keywordprg=:help
setlocal formatoptions-=o
setlocal formatoptions-=r

" For gf
let &l:path = expand('$VIMPATH').','.join(map(split(&runtimepath, ','), 'v:val."/autoload"'), ',')
setlocal suffixesadd=.vim
setlocal includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')

" Append plugins' tags
execute 'setlocal tags+=$VARPATH/tags/'.g:TagabanaHash($VARPATH.'/dein/repos')

let &cpo = s:save_cpo
