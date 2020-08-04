" Extend romainl/vim-qf
" ---
" See: https://github.com/romainl/vim-qf

let s:save_cpo = &cpoptions
set cpoptions&vim

setlocal nonumber norelativenumber
" setlocal linebreak
" setlocal cursorline
" setlocal nolist

silent! nunmap <buffer> p
nnoremap <silent><buffer> p    :call <SID>preview_file()<CR>
nnoremap <silent><buffer> q    :pclose!<CR>:quit<CR>
nnoremap <silent><buffer> <CR> <CR><C-w>p
nmap <silent><buffer> o  O
nmap <silent><buffer> sv v
nmap <silent><buffer> sg s
nmap <silent><buffer> st t

let b:undo_ftplugin .= " | execute 'nunmap <buffer> <CR>'"
	\ . " | execute 'nunmap <buffer> sv'"
	\ . " | execute 'nunmap <buffer> sg'"
	\ . " | execute 'nunmap <buffer> st'"
	\ . " | execute 'nunmap <buffer> q'"

function! s:preview_file()
	silent! wincmd P
	if &previewwindow
		pclose
		silent! wincmd p
		return
	endif

	let winwidth = &columns
	let cur_list = b:qf_isLoc == 1 ? getloclist('.') : getqflist()
	let cur_line = getline(line('.'))
	let cur_file = fnameescape(substitute(cur_line, '|.*$', '', ''))
	if cur_line =~# '|\d\+'
		let cur_pos  = substitute(cur_line, '^\(.\{-}|\)\(\d\+\)\(.*\)', '\2', '')
		execute 'vertical pedit! +' . cur_pos . ' ' . cur_file
	else
		execute 'vertical pedit! ' . cur_file
	endif
	wincmd P
	execute 'vert resize ' . (winwidth / 2)
	wincmd p
endfunction

let &cpoptions = s:save_cpo
