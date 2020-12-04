" Session Management
" ---
"
" Behaviors:
" - Save active session when quitting vim completely
"
" Commands:
" - SessionSave [name]: Create and activate new session
" - SessionLoad [name]: Clear buffers and load selected session
" - SessionClose:       Save session and clear all buffers
" - SessionDetach:      Stop persisting session, leave buffers open
"
" If [name] is empty, the current working-directory is used.
"
" Options:
" - g:session_directory defaults to DATA_PATH/session (see config/vimrc)

if exists('g:loaded_sessionsplugin')
	finish
endif
let g:loaded_sessionsplugin = 1

" Options
" ---

let g:session_directory = get(g:, 'session_directory', $DATA_PATH . '/session')

" Commands
" ---

" Save and persist session
command! -nargs=? -complete=customlist,<SID>session_list SessionSave
	\ call s:session_save(<q-args>)

" Load and persist session
command! -nargs=? -complete=customlist,<SID>session_list SessionLoad
	\ call s:session_load(<q-args>)

" Close session, but leave buffers opened
command! SessionDetach call s:session_detach()

" Close session and all buffers
command! SessionClose call s:session_close()

" Save session on quit if one is loaded
augroup plugin_sessions
	autocmd!

	" If session is loaded, write session file on quit
	autocmd VimLeavePre * call s:session_save_current()

	" autocmd SessionLoadPost * ++once unsilent
	"	\ echomsg 'Loaded "' . fnamemodify(v:this_session, ':t:r') . '" session'
augroup END

" Private functions
" ---

function! s:session_save(name)
	if ! isdirectory(g:session_directory)
		call mkdir(g:session_directory, 'p')
	endif
	let file_name = empty(a:name) ? s:project_name() : a:name
	let file_path = g:session_directory . '/' . file_name . '.vim'
	execute 'mksession! ' . fnameescape(file_path)
	let v:this_session = file_path

	echohl MoreMsg
	echo 'Session `' . file_name . '` is now persistent'
	echohl None
endfunction

function! s:session_load(name)
	call s:session_save_current()

	let file_name = empty(a:name) ? s:project_name() : a:name
	let file_path = g:session_directory . '/' . file_name . '.vim'
	if filereadable(file_path)
		call s:buffers_wipeout()
		execute 'silent source ' . file_path
	else
		echohl ErrorMsg
		echomsg 'The session "' . file_path . '" doesn''t exist'
		echohl None
	endif
endfunction

function! s:session_close()
	if ! empty(v:this_session) && ! exists('g:SessionLoad')
		call s:session_save_current()
		call s:session_detach()
		call s:buffers_wipeout()
	endif
endfunction

function! s:session_save_current()
	if ! empty(v:this_session) && ! exists('g:SessionLoad')
		execute 'mksession! ' . fnameescape(v:this_session)
	endif
endfunction

function! s:session_detach()
	if ! empty(v:this_session) && ! exists('g:SessionLoad')
		let v:this_session = ''
		redrawtabline
		redrawstatus
	endif
endfunction

function! s:buffers_wipeout()
	noautocmd silent! %bwipeout!
endfunction

function! s:session_list(A, C, P)
	let glob_pattern = g:session_directory . '/' . fnameescape(a:A) . '*.vim'
	return map(split(glob(glob_pattern), '\n'), "fnamemodify(v:val, ':t:r')")
endfunction

function! s:project_name()
	let l:cwd = resolve(getcwd())
	let l:cwd = substitute(l:cwd, '^' . $HOME . '/', '', '')
	let l:cwd = fnamemodify(l:cwd, ':p:gs?/?_?')
	let l:cwd = substitute(l:cwd, '^\.', '', '')
	return l:cwd
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
