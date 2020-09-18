" Improved preview for lists
" ---

function! preview#open(file, line, column) abort
	" Create or close preview window
	silent! wincmd P
	if &previewwindow && expand('%') == a:file
		let cur_pos = getcurpos()
		" If the exact same file and numbers are used, close preview window
		if a:line == cur_pos[1] && (a:column == 0 || a:column == cur_pos[2])
			pclose!
			silent! wincmd p
			return
		endif
	else

		" Create read-only preview
		silent doautocmd User preview_open_pre
		execute 'silent! vertical pedit! +set\ nofoldenable ' . a:file
		noautocmd wincmd P
		let b:asyncomplete_enable = 0
		let b:sleuth_automatic = 0
		let b:cursorword = 0
		" local buffer settings
		setlocal bufhidden=delete
		" setlocal nomodifiable nobuflisted buftype=nofile
		" local window settings
		setlocal statusline= number conceallevel=0 nospell
		if exists('&signcolumn')
			setlocal signcolumn=no
		endif
		setlocal cursorline cursorcolumn colorcolumn=
		noautocmd execute 'vertical resize ' . (&columns / 2)
		silent doautocmd User preview_open_post
	endif

	if a:line > 1 || a:column > 1
		call cursor(a:line, a:column)

		" Align match be centered
		normal! zz
		if a:column > &sidescrolloff * 2
			normal! zs
			normal! zH
		endif
	endif

	" Move back to previous window, maintaining cursorline
	silent noautocmd wincmd p
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
