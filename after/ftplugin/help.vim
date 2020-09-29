" Snippets from vim-help
" Credits: https://github.com/dahu/vim-help

let s:save_cpo = &cpoptions
set cpoptions&vim

let b:undo_ftplugin .= ' | setlocal spell< list< hidden< iskeyword<'
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
	\ . " | execute 'nunmap <buffer> q'"

setlocal nospell
setlocal nolist
setlocal nohidden
setlocal iskeyword+=:
setlocal iskeyword+=#
setlocal iskeyword+=-

" Count tab page windows
function! s:count_windows()
	let l:count = 0
	let l:tabnr = tabpagenr()
	try
		let l:windows = gettabinfo(l:tabnr)[0].windows
		for l:win in l:windows
			if getwinvar(l:win, '&filetype') !~# '^\(clap\|defx\|denite\|vista\)'
				let l:count += 1
			endif
		endfor
	catch
		" Fallback
		let l:count = tabpagewinnr(l:tabnr, '$')
	endtry
	return l:count
endfunction

if s:count_windows() - 1 > 1
	wincmd K
else
	wincmd L
endif

" Exit help window with 'q'
nnoremap <silent><buffer> q :quit<CR>

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
nmap <buffer> <leader>j :cnext<CR>
nmap <buffer> <leader>k :cprev<CR>

let &cpoptions = s:save_cpo
