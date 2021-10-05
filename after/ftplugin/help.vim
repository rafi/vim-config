" Snippets from vim-help
" Credits: https://github.com/dahu/vim-help

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:setup_buffer()
	if exists('b:undo_ftplugin')
		let b:undo_ftplugin .= ' | '
	else
		let b:undo_ftplugin = ''
	endif
	let b:undo_ftplugin .= 'setlocal spell< list< hidden< iskeyword<'
		\ . " | execute 'nunmap <buffer> <CR>'"
		\ . " | execute 'nunmap <buffer> <BS>'"
		\ . " | execute 'nunmap <buffer> o'"
		\ . " | execute 'nunmap <buffer> O'"
		\ . " | execute 'nunmap <buffer> f'"
		\ . " | execute 'nunmap <buffer> F'"
		\ . " | execute 'nunmap <buffer> t'"
		\ . " | execute 'nunmap <buffer> T'"
		\ . " | execute 'nunmap <buffer> <leader>j'"
		\ . " | execute 'nunmap <buffer> <leader>k'"
		\ . " | execute 'nunmap <buffer> <Leader>o'"
		\ . " | execute 'nunmap <buffer> q'"

	setlocal nospell
	setlocal nolist
	setlocal nohidden
	setlocal iskeyword+=:
	setlocal iskeyword+=#
	setlocal iskeyword+=-

	if s:count_windows() > 2
		wincmd K
	else
		wincmd L
	endif

	" Exit help window with 'q'
	nnoremap <buffer> q <cmd>quit<CR>

	" Jump to links with enter
	nmap <buffer> <CR> <C-]>

	" Jump back with backspace
	nmap <buffer> <BS> <C-T>

	" Skip to next option link
	nmap <buffer> o /'[a-z]\{2,\}'<CR>

	" Skip to previous option link
	nmap <buffer> O ?'[a-z]\{2,\}'<CR>

	" Skip to next subject link
	nmap <buffer><nowait> f /\|\S\+\|<CR>l

	" Skip to previous subject link
	nmap <buffer> F h?\|\S\+\|<CR>l

	" Skip to next tag (subject anchor)
	nmap <buffer> t /\*\S\+\*<CR>l

	" Skip to previous tag (subject anchor)
	nmap <buffer> T h?\*\S\+\*<CR>l

	" Skip to next/prev quickfix list entry (from a helpgrep)
	nmap <buffer> <leader>j <cmd>cnext<CR>
	nmap <buffer> <leader>k <cmd>cprev<CR>

	" See hare/nvim/runtime/ftplugin/help.vim
	nmap <buffer> <Leader>o gO
endfunction

" Count tab page windows
function! s:count_windows()
	let l:count = 0
	let l:tabnr = tabpagenr()
	try
		let l:windows = gettabinfo(l:tabnr)[0].windows
		for l:win in l:windows
			if empty(getbufvar(winbufnr(l:win), '&buftype'))
				let l:count += 1
			endif
		endfor
	catch
		" Fallback
		let l:count = tabpagewinnr(l:tabnr, '$')
	endtry
	return l:count
endfunction

" Setup only when viewing help pages
if &buftype ==# 'help'
	call s:setup_buffer()
endif

let &cpoptions = s:save_cpo
