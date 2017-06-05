
" Session Management
" ---

let g:session_directory = $VARPATH.'/session'

" Save and persist session
command! -nargs=? -complete=customlist,<SID>session_complete SessionSave
	\ call s:session_save(<q-args>)

" Load and persist session
command! -nargs=? -complete=customlist,<SID>session_complete SessionLoad
	\ call s:session_load(<q-args>)

" Save session on quit if one is loaded
augroup sessionsave
	autocmd!
	" If session is loaded, write session file on quit
	autocmd VimLeavePre *
		\ if ! empty(v:this_session) && ! exists('g:SessionLoad')
		\ |   execute 'mksession! '.fnameescape(v:this_session)
		\ | endif
augroup END

function! s:session_save(name) abort
	if ! isdirectory(g:session_directory)
		call mkdir(g:session_directory, 'p')
	endif
	let file_name = empty(a:name) ? badge#project() : a:name
	let file_path = g:session_directory.'/'.file_name.'.vim'
	execute 'mksession! '.fnameescape(file_path)
	let v:this_session = file_path

	echohl MoreMsg
	echo 'Session `'.file_name.'` is now persistent'
	echohl None
endfunction

function! s:session_load(name) abort
	let file_path = g:session_directory.'/'.a:name.'.vim'

	if ! empty(v:this_session) && ! exists('g:SessionLoad')
		\ |   execute 'mksession! '.fnameescape(v:this_session)
		\ | endif

	noautocmd silent! %bwipeout!
	execute 'silent! source '.file_path
endfunction

function! s:session_complete(A, C, P)
	return map(
		\ split(glob(g:session_directory.'/*.vim'), '\n'),
		\ "fnamemodify(v:val, ':t:r')"
		\ )
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
