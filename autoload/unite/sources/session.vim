"=============================================================================
" FILE: session.vim
" DESCRIPTION: Forked to support xolox/vim-session
" MAINTAINER: Rafael Bodill <justrafi at gmail dot com>
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
"          Jason Housley <HousleyJK@gmail.com>
" Last Modified: 16 Sep 2014
" License: MIT license
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

" Variables  "{{{
call unite#util#set_default('g:unite_source_session_allow_rename_locked',
	\ 0)
"}}}
"
function! unite#sources#session#define() "{{{
	return [ s:source, s:source_new ]
endfunction "}}}

function! unite#sources#session#_save(filename, ...) "{{{
	if unite#util#is_cmdwin()
		return
	endif

	if ! isdirectory(g:session_directory)
		call mkdir(g:session_directory, 'p')
	endif

	let filename = s:get_session_path(a:filename)

	execute 'SaveSession!' filename
endfunction "}}}

function! unite#sources#session#_load(filename) "{{{
	if unite#util#is_cmdwin()
		return
	endif

	let filename = s:get_session_path(a:filename)
	execute 'OpenSession' filename
endfunction "}}}

function! unite#sources#session#_complete(arglead, cmdline, cursorpos) "{{{
	let directory = xolox#misc#path#absolute(g:session_directory)
	let sessions = split(glob(directory.'/*'.g:session_extension), '\n')
"	let sessions = xolox#session#complete_names_with_suggestions('', 0, 0)
	return filter(sessions, 'stridx(v:val, a:arglead) == 0')
endfunction "}}}

let s:source = {
	\  'name': 'session',
	\  'description': 'candidates from session list',
	\  'default_action': 'load',
	\  'alias_table': { 'edit' : 'open' },
	\  'action_table': {}
	\ }

function! s:source.gather_candidates(args, context) "{{{
	let directory = xolox#misc#path#absolute(g:session_directory)
	let sessions = split(glob(directory.'/*'.g:session_extension), '\n')

	let candidates = map(copy(sessions), "{
		\  'word': xolox#session#path_to_name(v:val),
		\  'kind': 'file',
		\  'action__path': v:val,
		\  'action__directory': unite#util#path2directory(v:val)
		\ }")

	return candidates
endfunction "}}}

" New session only source

let s:source_new = {
	\  'name': 'session/new',
	\  'description': 'session candidates from input',
	\  'default_action': 'save',
	\  'action_table': {}
	\ }

function! s:source_new.change_candidates(args, context) "{{{
	let input = substitute(substitute(
		\ a:context.input, '\\ ', ' ', 'g'), '^\a\+:\zs\*/', '/', '')

	if input == ''
		return []
	endif

	" Return new session candidate
	return [{ 'word': input, 'abbr': '[new session] ' . input, 'action__path': input }] +
		\ s:source.gather_candidates(a:args, a:context)
endfunction "}}}

" Actions "{{{
let s:source.action_table.load = {
	\  'description': 'load this session',
	\ }

function! s:source.action_table.load.func(candidate) "{{{
	call unite#sources#session#_load(a:candidate.word)
endfunction "}}}

let s:source.action_table.delete = {
	\  'description': 'delete from session list',
	\  'is_invalidate_cache': 1,
	\  'is_quit': 0,
	\  'is_selectable': 1
	\ }

function! s:source.action_table.delete.func(candidates) "{{{
	for candidate in a:candidates
		if input('Really delete session file: '
				\ . candidate.action__path . '? ') =~? 'y\%[es]'
			execute 'DeleteSession' candidate.word
		endif
	endfor
endfunction "}}}

let s:source.action_table.rename = {
	\  'description': 'rename session name',
	\  'is_invalidate_cache': 1,
	\  'is_quit': 0,
	\  'is_selectable': 1
	\ }

function! s:source.action_table.rename.func(candidates) "{{{
	let current_session = xolox#session#find_current_session()
	let rename_locked = g:unite_source_session_allow_rename_locked
	for candidate in a:candidates
		if rename_locked || current_session != candidate.word
			let session_name = input(printf(
				\ 'New session name: %s -> ', candidate.word), candidate.word)
			if session_name != '' && session_name !=# candidate.word
				let new_name = g:session_directory.'/'.session_name.g:session_extension
				call rename(candidate.action__path, new_name)
				" Rename also lock file
				if filereadable(candidate.action__path.'.lock')
					" TODO: Change vim-session current session
					call rename(candidate.action__path.'.lock', new_name.'.lock')
				endif
			endif
		else
			call unite#print_source_error(
				\ [ 'The session "'.candidate.word.'" is locked.' ], 'session')
		endif
	endfor
endfunction "}}}

let s:source.action_table.save = {
	\  'description': 'save current session as candidate',
	\  'is_invalidate_cache': 1,
	\  'is_selectable': 1
	\ }

function! s:source.action_table.save.func(candidates) "{{{
	for candidate in a:candidates
		if input('Really save the current session as: '
				\ . candidate.word . '? ') =~? 'y\%[es]'
			call unite#sources#session#_save(candidate.word)
		endif
	endfor
endfunction "}}}

let s:source_new.action_table.save = s:source.action_table.save

function! s:source_new.action_table.save.func(candidates) "{{{
	let current_tab = tabpagenr()
	tabdo windo if &ft  == 'vimfiler' | bd | endif
	execute 'tabnext '.current_tab
	for candidate in a:candidates
		" Second argument means check if exists
		call unite#sources#session#_save(candidate.word, 1)
	endfor
endfunction "}}}

"}}}

function! s:get_session_path(filename)
	let filename = a:filename
	if filename == ''
		let filename = g:session_default_name
	endif
	if filename == ''
		let filename = v:this_session
	endif

	return filename
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
