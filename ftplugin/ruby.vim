let s:save_cpo = &cpo
set cpo&vim

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= ' | '
else
	let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setl modeline<'

setlocal shiftwidth=2 softtabstop=2 tabstop=2

let &cpo = s:save_cpo
