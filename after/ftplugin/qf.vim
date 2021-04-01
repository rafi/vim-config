" Extend romainl/vim-qf
" ---
" See Also: https://github.com/romainl/vim-qf

let s:save_cpo = &cpoptions
set cpoptions&vim

" Local window settings
setlocal cursorline colorcolumn=

if exists('&signcolumn')
	setlocal signcolumn=yes
endif

if ! exists(':Lfilter')
	try
		packadd cfilter
	endtry
endif

if ! exists('b:qf_isLoc')
	" Are we in a location list or a quickfix list?
	let b:qf_isLoc = ! empty(getloclist(0))
endif

" Is this redundant?
" let &l:statusline="%t%{exists('w:quickfix_title') ? ' '.w:quickfix_title : ''} %=%-15(%l,%L%V%) %P"

silent! nunmap <buffer> <CR>
silent! nunmap <buffer> p
silent! nunmap <buffer> q
silent! nunmap <buffer> s

nnoremap <silent><buffer><expr> <CR> ":pclose!\<CR>\<CR>" .
	\ (b:qf_isLoc == 1 ? ':lclose' : ':cclose') . "\<CR>"

nnoremap <silent><buffer> <Esc>  :pclose!<CR>:quit<CR>
nnoremap <silent><buffer> o      :pclose!<CR><CR>:noautocmd wincmd b<CR>

if get(g:, 'enable_universal_quit_mapping', 1)
	nnoremap <silent><buffer> q      :pclose!<CR>:quit<CR>
endif
nnoremap <silent><buffer> p      :call <SID>preview_file()<CR>
nnoremap <silent><buffer> K      :echo getline(line('.'))<CR>
nnoremap <silent><buffer> dd     :<C-u>Reject<CR>
nnoremap <silent><buffer> <C-r>  :<C-u>Restore<CR>
nnoremap <silent><buffer> R      :<C-u>Restore<CR>

nnoremap <buffer> O      :<C-u>ListLists<CR>
nnoremap <buffer> <C-s>  :<C-u>SaveList<Space>
nnoremap <buffer> S      :<C-u>SaveList<Space>
nnoremap <buffer> <C-o>  :<C-u>LoadList<Space>

nnoremap <silent><buffer> sg :pclose!<CR><C-w><CR><C-w>L<C-w>=
nnoremap <silent><buffer> sv :pclose!<CR><C-w><CR><C-w>=
nnoremap <silent><buffer> st :pclose!<CR><C-w><CR><C-w>T

nmap <buffer> <Tab>    <Plug>(qf_newer)
nmap <buffer> <S-Tab>  <Plug>(qf_older)
nmap <buffer> gj       <Plug>(qf_next_file)
nmap <buffer> gk       <Plug>(qf_previous_file)

if exists(':Lfilter')
	nnoremap <buffer><expr> i
		\ (b:qf_isLoc == 1 ? ':L' : ':C') . "filter\<Space>//\<Left>"
	nnoremap <buffer><expr> r
		\ (b:qf_isLoc == 1 ? ':L' : ':C'). "filter!\<Space>//\<Left>"
else
	nnoremap <buffer> i :<C-u>Keep<Space>
endif

" let s:ns = nvim_create_namespace('hlgrep')

if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= ' | '
else
	let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .=
	\ 'setl cursorline< colorcolumn< signcolumn<'
	\ . " | execute 'nunmap <buffer> <CR>'"
	\ . " | execute 'nunmap <buffer> <Esc>'"
	\ . " | execute 'nunmap <buffer> q'"
	\ . " | execute 'nunmap <buffer> p'"
	\ . " | execute 'nunmap <buffer> K'"
	\ . " | execute 'nunmap <buffer> <C-r>'"
	\ . " | execute 'nunmap <buffer> R'"
	\ . " | execute 'nunmap <buffer> O'"
	\ . " | execute 'nunmap <buffer> <C-s>'"
	\ . " | execute 'nunmap <buffer> S'"
	\ . " | execute 'nunmap <buffer> <C-o>'"
	\ . " | execute 'nunmap <buffer> i'"
	\ . " | execute 'nunmap <buffer> o'"
	\ . " | execute 'nunmap <buffer> sg'"
	\ . " | execute 'nunmap <buffer> sv'"
	\ . " | execute 'nunmap <buffer> st'"
	\ . " | execute 'nunmap <buffer> <Tab>'"
	\ . " | execute 'nunmap <buffer> <S-Tab>'"
	\ . " | execute 'nunmap <buffer> gj'"
	\ . " | execute 'nunmap <buffer> gk'"

function! s:get_entry()
	" Find the file, line number and column of current entry
	let l:raw = getline(line('.'))
	let l:file = fnameescape(substitute(l:raw, '|.*$', '', ''))
	let l:pos = substitute(l:raw, '^.\{-}|\(.\{-}|\).*$', '\1', '')
	let l:line = 1
	let l:column = 1
	if l:pos =~# '^\d\+'
		let l:line  = substitute(l:pos, '^\(\d\+\).*$', '\1', '')
		if l:pos =~# ' col \d\+|'
			let l:column = substitute(l:pos, '^\d\+ col \(\d\+\).*$', '\1', '')
		endif
	endif

	return [ l:file, l:line, l:column ]
endfunction

function! s:preview_file()
	let [ l:file, l:line, l:column ] = s:get_entry()
	call preview#open(l:file, l:line, l:column)
endfunction

let &cpoptions = s:save_cpo
