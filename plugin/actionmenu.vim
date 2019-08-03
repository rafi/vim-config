" actionmenu
" ---
" Context-aware menu at your cursor

if exists('g:loaded_actionmenu') || ! has('nvim')
	finish
endif
let g:loaded_actionmenu = 1

" Default icon for the actionmenu (see nerdfonts.com)
let g:actionmenu#icon = { 'character': '', 'foreground': 'yellow' }

command! -nargs=0 ActionMenu call s:actionmenu()

function! s:actionmenu()
	let l:cword = expand('<cword>')
	call actionmenu#open(s:build_menu(l:cword), function('<SID>apply_action'))
endfunction

function! s:apply_action(index, item)
	if type(a:item) == type('')
		echoerr 'Invalid selection:' a:item
		return
	elseif a:index < 0 || empty(a:item) || empty(get(a:item, 'abbr'))
		return
	endif

	if a:item['abbr'] ==# 'normal'
		execute 'normal' a:item['user_data']
	elseif a:item['abbr'] ==# 'command'
		execute a:item['user_data']
	elseif a:item['abbr'] ==# 'call'
		execute 'call ' . a:item['user_data']
	elseif a:item['abbr'] ==# 'feedkeys'
		call feedkeys(':'.a:item['user_data'])
	else
		echoerr 'Unknown type selection:' a:item['abbr']
	endif
endfunction

function! s:build_menu(cword)
	let l:items = []
	let l:filetype = &filetype

	if empty(a:cword)

		" Blank operations
		if l:filetype ==# 'go'
			let l:items = extend(l:items, [
				\ { 'word': 'If err', 'abbr': 'command', 'user_data': 'GoIfErr' },
				\ { 'word': 'Vet', 'abbr': 'command', 'user_data': 'GoVet' },
				\ { 'word': 'Run', 'abbr': 'command', 'user_data': 'GoRun' },
				\ ])
		endif

		let l:items = extend(l:items, [
			\ { 'word': 'Select all', 'abbr': 'normal', 'user_data': 'ggVG' },
			\ { 'word': '-------' },
			\ ])

	else

		" Filetype operations
		if l:filetype ==# 'python'
			let l:items = extend(l:items, [
				\ { 'word': 'Definition', 'abbr': 'call', 'user_data': 'jedi#goto()' },
				\ { 'word': 'References…', 'abbr': 'call', 'user_data': 'jedi#usages()' },
				\ { 'word': '--------' },
				\ ])
		elseif l:filetype ==# 'go'
			let l:items = extend(l:items, [
				\ { 'word': 'Callees…', 'abbr': 'command', 'user_data': 'GoCallees' },
				\ { 'word': 'Callers…', 'abbr': 'command', 'user_data': 'GoCallers' },
				\ { 'word': 'Definition', 'abbr': 'command', 'user_data': 'GoDef' },
				\ { 'word': 'Describe…', 'abbr': 'command', 'user_data': 'GoDescribe' },
				\ { 'word': 'Implements…', 'abbr': 'command', 'user_data': 'GoImplements' },
				\ { 'word': 'Info', 'abbr': 'command', 'user_data': 'GoInfo' },
				\ { 'word': 'Referrers…', 'abbr': 'command', 'user_data': 'GoReferrers' },
				\ { 'word': '--------' },
				\ ])
		elseif l:filetype ==# 'javascsript' || l:filetype ==# 'jsx'
			let l:items = extend(l:items, [
				\ { 'word': 'Definition', 'abbr': 'command', 'user_data': 'TernDefSplit' },
				\ { 'word': 'References…', 'abbr': 'command', 'user_data': 'TernRefs' },
				\ { 'word': '--------' },
				\ ])
		endif

		" Word operations
		let l:items = extend(l:items, [
			\ { 'word': 'Find symbol…', 'abbr': 'command', 'user_data': 'DeniteCursorWord tag:include -no-start-filter' },
			\ { 'word': 'Paste from…', 'abbr': 'command', 'user_data': 'Denite register -default-action=replace -no-start-filter' },
			\ { 'word': 'Grep…', 'abbr': 'command', 'user_data': 'DeniteCursorWord grep -no-start-filter' },
			\ { 'word': '-------' },
			\ ])
	endif

	" File operations
	let l:items = extend(l:items, [
		\ { 'word': 'Lint', 'abbr': 'command', 'user_data': 'Neomake' },
		\ { 'word': 'Git diff', 'abbr': 'command', 'user_data': 'GdiffThis' },
		\ { 'word': 'Unsaved diff', 'abbr': 'command', 'user_data': 'DiffOrig' },
		\ { 'word': 'Bookmark', 'abbr': 'command', 'user_data': 'BookmarkToggle' },
		\ ])

	return l:items
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
