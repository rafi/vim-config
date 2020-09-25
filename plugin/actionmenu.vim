" actionmenu
" ---
" Context-aware menu at your cursor
" Forked from: https://github.com/kizza/actionmenu.nvim

if exists('g:loaded_actionmenu') || ! has('nvim')
	finish
endif
let g:loaded_actionmenu = 1

command! -nargs=0 ActionMenu call s:actionmenu()

function! s:actionmenu()
	let l:cword = expand('<cword>')
	call actionmenu#open(s:build_menu(l:cword), function('s:apply_action'))
endfunction

function! s:apply_action(selected)
	if ! empty(get(a:selected, 'user_data'))
		execute a:selected['user_data']
	endif
endfunction

function! s:build_menu(cword)
	let l:items = []
	let l:filetype = &filetype

	if empty(a:cword)

		" Blank operations
		let l:items = extend(l:items, [
			\ { 'word': 'Select all', 'user_data': 'normal! ggVG' },
			\ { 'word': '-------' },
			\ ])

	else

		if l:filetype ==# 'python' || l:filetype ==# 'go'
			let l:items = extend(l:items, [
				\ { 'word': 'Declaration', 'user_data': 'LspDeclaration' },
				\ { 'word': 'Definition', 'user_data': 'LspDefinition' },
				\ { 'word': 'References…', 'user_data': 'LspReferences' },
				\ { 'word': 'Implementation', 'user_data': 'LspImplementation' },
				\ { 'word': 'TypeDefinition', 'user_data': 'LspTypeDefinition' },
				\ { 'word': 'TypeHierarchy', 'user_data': 'LspTypeHierarchy' },
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
		\ { 'word': 'Diagnostics', 'user_data': 'LspDocumentDiagnostics' },
		\ { 'word': 'Bookmark', 'user_data': 'normal mm' },
		\ { 'word': 'Git diff', 'user_data': 'Gina compare' },
		\ { 'word': 'Unsaved diff', 'user_data': 'DiffOrig' },
		\ { 'word': 'Open in browser', 'user_data': 'Gina browse' },
		\ ])

	return l:items
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
