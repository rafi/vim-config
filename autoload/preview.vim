" Improved preview for lists
" ---

augroup qf_preview_plugin
	autocmd!
	autocmd QuickFixCmdPre * silent! pclose
augroup END

function! preview#open(file, line, column) abort
	let l:winid = bufwinnr('%')

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
		" silent doautocmd User preview_open_pre
		call s:_open_preview(a:file)
		" silent doautocmd User preview_open_post
	endif

	if a:line > 1 || a:column > 1
		call s:_center_position(a:line, a:column)
	endif

	" Move back to previous window, maintaining cursorline
	" silent noautocmd wincmd p
	execute 'silent noautocmd ' . l:winid . 'wincmd w'
endfunction

function s:_open_preview(file)
	" Create read-only preview
	let l:width = &columns / 2
	let l:cmd = 'silent! vertical pedit!'
	let l:bufcmd = '+set\ nofoldenable\ readonly|vertical\ resize\ ' . l:width
	execute l:cmd . ' ' . l:bufcmd . ' ' . a:file

	noautocmd wincmd P
	let b:asyncomplete_enable = 0
	let b:sleuth_automatic = 0
	let b:cursorword = 0
	" local buffer settings
	setlocal bufhidden=delete nobuflisted buftype=nofile
	" local window settings
	setlocal statusline= number conceallevel=0 nospell
	if exists('&signcolumn')
		setlocal signcolumn=no
	endif
	setlocal cursorline cursorcolumn colorcolumn=

	if exists('b:undo_ftplugin')
		let b:undo_ftplugin .= ' | '
	else
		let b:undo_ftplugin = ''
	endif
	let b:undo_ftplugin .= 'setlocal cursorline< cursorcolumn< colorcolumn<'
	let b:undo_ftplugin .= ' | setlocal number< conceallevel< nospell< statusline<'
	let b:undo_ftplugin .= ' | setlocal signcolumn< nofoldenable<'
	let b:undo_ftplugin .= ' | unlet b:sleuth_automatic b:cursorword b:asyncomplete_enable'
endfunction

function s:_center_position(line, column)
	" Move cursor position to specific line and column
	call cursor(a:line, a:column)

	" Move view so match is centered
	normal! zz
	if a:column > &sidescrolloff * 2
		normal! zs
		normal! zH
	endif
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
