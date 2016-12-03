
" Session Management
"---------------------------------------------------------

let g:session_directory = $VARPATH.'/session'

" Save and persist session
command! -bar -complete=file -nargs=? SessionSave
	\ call s:session_save(<q-args>)

" Save session on quit if one is loaded
augroup sessionsave
	autocmd!
	" If session is loaded, write session file on quit
	autocmd VimLeavePre *
		\ if ! empty(v:this_session) && ! exists('g:SessionLoad')
		\ |   execute 'mksession! '.fnameescape(v:this_session)
		\ | endif
augroup END

function! s:session_save(file) abort
	if ! isdirectory(g:session_directory)
		call mkdir(g:session_directory, 'p')
	endif
	let file_name = empty(a:file) ? block#project() : a:file
	let file_path = g:session_directory.'/'.file_name.'.vim'
	execute 'mksession! '.fnameescape(file_path)
	echo 'Tracking session in '.fnamemodify(file_path, ':~:.')
	let v:this_session = file_path
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
