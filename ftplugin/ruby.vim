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
setlocal tabstop=2
let b:dispatch = 'ruby -c %'

let &cpo = s:save_cpo
