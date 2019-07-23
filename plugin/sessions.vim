
" Session Management
" ---

let g:session_directory = $VARPATH.'/session'

" Save and persist session
command! -nargs=? -complete=customlist,<SID>session_list SessionSave
	\ call s:session_save(<q-args>)

" Load and persist session
command! -nargs=? -complete=customlist,<SID>session_list SessionLoad
	\ call s:session_load(<q-args>)

" Save session on quit if one is loaded
augroup SessionAutoSave
	autocmd!
	" If session is loaded, write session file on quit
	autocmd VimLeavePre *
		\ if ! empty(v:this_session) && ! exists('g:SessionLoad')
		\ |   execute 'mksession! ' . fnameescape(v:this_session)
		\ | endif
augroup END

function! s:session_save(name) abort
	if ! isdirectory(g:session_directory)
		call mkdir(g:session_directory, 'p')
	endif
	let file_name = empty(a:name) ? s:project_name() : a:name
	let file_path = g:session_directory.'/'.file_name.'.vim'
	execute 'mksession! '.fnameescape(file_path)
	let v:this_session = file_path

	echohl MoreMsg
	echo 'Session `'.file_name.'` is now persistent'
	echohl None
endfunction

function! s:session_load(name) abort
	let file_name = empty(a:name) ? s:project_name() : a:name
	let file_path = g:session_directory.'/'.file_name.'.vim'

	if ! empty(v:this_session) && ! exists('g:SessionLoad')
		\ |   execute 'mksession! '.fnameescape(v:this_session)
		\ | endif

	if filereadable(file_path)
		noautocmd silent! %bwipeout!
		execute 'silent! source '.file_path
		echomsg 'Loaded "'.file_path.'" session'
	else
		echohl ErrorMsg
		echomsg 'The session "'.file_path.'" doesn''t exist'
		echohl None
	endif
endfunction

function! s:session_list(A, C, P)
	return map(
		\ split(glob(g:session_directory.'/*.vim'), '\n'),
		\ "fnamemodify(v:val, ':t:r')"
		\ )
endfunction

function! s:project_name()
	let l:cwd = resolve(getcwd())
	let l:cwd = substitute(l:cwd, '^'.$HOME.'/', '', '')
	let l:cwd = fnamemodify(l:cwd, ':p:gs?/?_?')
	let l:cwd = substitute(l:cwd, '^\.', '', '')
	return l:cwd
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
