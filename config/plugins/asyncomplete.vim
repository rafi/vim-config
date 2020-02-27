" :h asyncomplete
" ---
" Problems? https://github.com/prabirshrestha/asyncomplete.vim/issues

" Debugging:
" let g:asyncomplete_log_file = expand('~/asyncomplete.log')
" let g:lsp_log_file = expand('~/vim-lsp.log')

" Smart completion-menu selection behavior:
" 1) Insert new-line if nothing selected
" 2) Otherwise, insert and expand selected snippet (via UltiSnips)
" 3) Otherwise, insert selected completion item
" 4) If completion-menu is closed, try to expand empty pairs (via DelimitMate)
function s:smart_carriage_return()
	if pumvisible()
		let l:info = complete_info()

		" Detect non-selection and insert new-line
		if get(l:info, 'selected', -1) == -1
			return "\<C-y>\<CR>"
		endif
		" Detect snippet and expand (via UltiSnips)
		if exists('g:UltiSnipsEditSplit')
			let l:menu = get(get(l:info['items'], l:info['selected'], {}), 'menu')
			if len(l:menu) > 0 && stridx(l:menu, 'Snips: ') == 0
				return "\<C-y>\<C-R>=UltiSnips#ExpandSnippet()\<CR>"
			endif
		endif
		" Otherwise, when pum is visible, insert selected completion
		return "\<C-y>"
	endif

	" Expand empty pairs (via delimitMate)
	if get(b:, 'delimitMate_enabled') && delimitMate#WithinEmptyPair()
		return "\<C-R>=delimitMate#ExpandReturn()\<CR>"
	endif

	" Propagate a carriage-return
	return "\<CR>"
endfunction

" Smart selection
inoremap <silent> <CR> <C-R>=<SID>smart_carriage_return()<CR>

" Force completion pop-up display
imap <C-Space> <Plug>(asyncomplete_force_refresh)

" Navigation
inoremap <expr><silent> <Tab>   pumvisible() ? "\<Down>" : (<SID>is_whitespace() ? "\<Tab>" : asyncomplete#force_refresh())
inoremap <expr><silent> <S-Tab> pumvisible() ? "\<Up>"   : (<SID>is_whitespace() ? "\<C-h>" : asyncomplete#force_refresh())

inoremap <expr> <C-j>   pumvisible() ? "\<Down>" : "\<C-j>"
inoremap <expr> <C-k>   pumvisible() ? "\<Up>"   : "\<C-k>"
inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>" : "\<C-d>"
inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>"   : "\<C-u>"

" Menu control
inoremap <expr> <C-y> pumvisible() ? asyncomplete#close_popup() : "\<C-y>"
inoremap <expr> <C-e> pumvisible() ? asyncomplete#cancel_popup() : "\<C-e>"

function! s:is_whitespace()
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~# '\s'
endfunction

" Pre-processors
" ---

" DISABLED: Auto-complete popup doesn't show after dot e.g. "class."
" function! s:sort_by_priority_preprocessor(options, matches) abort
" 	let l:items = []
" 	for [l:source_name, l:matches] in items(a:matches)
" 		for l:item in l:matches['items']
" 			if stridx(l:item['word'], a:options['base']) == 0
" 				let l:item['priority'] =
"					\ get(asyncomplete#get_source_info(l:source_name), 'priority', 1)
" 				call add(l:items, l:item)
" 			endif
" 		endfor
" 	endfor
" 	let l:items = sort(l:items, {a, b -> b['priority'] - a['priority']})
" 	call asyncomplete#preprocess_complete(a:options, l:items)
" endfunction
"
" let g:asyncomplete_preprocessor = [function('s:sort_by_priority_preprocessor')]

" vim: set ts=2 sw=2 tw=80 noet :
