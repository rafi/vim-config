" actionmenu
" ---
" Context-aware menu at your cursor
" Forked from: https://github.com/kizza/actionmenu.nvim

if exists('g:loaded_actionmenu') || ! has('nvim')
	finish
endif
let g:loaded_actionmenu = 1

" Default icon for the actionmenu (see nerdfonts.com)
let g:actionmenu_icon = { 'character': '', 'foreground': 'yellow' }

command! -nargs=0 ActionMenu call s:actionmenu()

function! s:actionmenu()
	let l:cword = expand('<cword>')
	call actionmenu#open(s:build_menu(l:cword), function('s:apply_action'))
endfunction

function! s:apply_action(timer_id)
	let [l:index, l:item] = g:actionmenu#selected
	if ! empty(get(l:item, 'user_data'))
		execute l:item['user_data']
	endif
endfunction

function! s:build_menu(cword)
	let l:items = []
	let l:filetype = &filetype

	if empty(a:cword)

		" Blank operations
		if l:filetype ==# 'go'
			let l:items = extend(l:items, [
				\ { 'word': 'If err', 'user_data': 'GoIfErr' },
				\ { 'word': 'Vet', 'user_data': 'GoVet' },
				\ { 'word': 'Run', 'user_data': 'GoRun' },
				\ ])
		endif

		let l:items = extend(l:items, [
			\ { 'word': 'Select all', 'user_data': 'normal! ggVG' },
			\ { 'word': '-------' },
			\ ])

	else

		" Filetype operations
		if l:filetype ==# 'python'
			let l:items = extend(l:items, [
				\ { 'word': 'Definition', 'user_data': 'call jedi#goto()' },
				\ { 'word': 'References…', 'user_data': 'call jedi#usages()' },
				\ { 'word': '--------' },
				\ ])
		elseif l:filetype ==# 'go'
			let l:items = extend(l:items, [
				\ { 'word': 'Callees…', 'user_data': 'GoCallees' },
				\ { 'word': 'Callers…', 'user_data': 'GoCallers' },
				\ { 'word': 'Definition', 'user_data': 'GoDef' },
				\ { 'word': 'Describe…', 'user_data': 'GoDescribe' },
				\ { 'word': 'Implements…', 'user_data': 'GoImplements' },
				\ { 'word': 'Info', 'user_data': 'GoInfo' },
				\ { 'word': 'Referrers…', 'user_data': 'GoReferrers' },
				\ { 'word': '--------' },
				\ ])
		elseif l:filetype ==# 'javascsript' || l:filetype ==# 'jsx'
			let l:items = extend(l:items, [
				\ { 'word': 'Definition', 'user_data': 'TernDefSplit' },
				\ { 'word': 'References…', 'user_data': 'TernRefs' },
				\ { 'word': '--------' },
				\ ])
		endif

		" Word operations
		let l:items = extend(l:items, [
			\ { 'word': 'Find symbol…', 'user_data': 'DeniteCursorWord tag:include -no-start-filter' },
			\ { 'word': 'Paste from…', 'user_data': 'Denite neoyank -default-action=replace -no-start-filter' },
			\ { 'word': 'Grep…', 'user_data': 'DeniteCursorWord grep -no-start-filter' },
			\ { 'word': '-------' },
			\ ])
	endif

	" File operations
	let l:items = extend(l:items, [
		\ { 'word': 'Lint', 'user_data': 'Neomake' },
		\ { 'word': 'Bookmark', 'user_data': 'BookmarkToggle' },
		\ { 'word': 'Git diff', 'user_data': 'Gina compare' },
		\ { 'word': 'Unsaved diff', 'user_data': 'DiffOrig' },
		\ { 'word': 'Open in browser', 'user_data': 'OpenSCM' },
		\ ])

	return l:items
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
