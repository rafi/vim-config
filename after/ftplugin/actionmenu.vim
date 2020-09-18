" actionmenu
" ---
" Context-aware menu at your cursor
" Forked from: https://github.com/kizza/actionmenu.nvim

" Style the buffer every time
setlocal sidescrolloff=0 scrolloff=0 nowrap
setlocal signcolumn=no listchars= showbreak=
" let b:cursorword = 0

" Only load ftplugin once
if get(s:, 'loaded')
	" Subsequent times, just open pum
	call s:open_pum()
	finish
endif
let s:loaded = 1

" Current menu selection
let s:selected_item = 0

" Trigger InsertEnter only the first time menu loads.
" This is to allow any lazy-loading insert mode plugins beforehand.
doautocmd <nomodeline> InsertEnter

function! s:open_pum()
	call feedkeys("i\<C-x>\<C-u>")
endfunction

function! s:select_item()
	if pumvisible()
		if ! empty(v:completed_item)
			let s:selected_item = copy(v:completed_item)
		endif
		" Close pum and leave insert
		return "\<C-y>\<Esc>"
	endif
	" Leave insert mode
	return "\<Esc>"
endfunction

function! s:on_insert_leave()
	call actionmenu#close()
	let l:index = -1
	if type(s:selected_item) == type({})
		let l:index = s:selected_item['user_data']
	endif
	if l:index ==# ''
		let l:index = -1
	endif
	let l:data = l:index > -1 ? g:actionmenu#items[l:index] : {}
	let s:selected_item = 0
	let g:actionmenu#items = []
	let g:actionmenu#selected = [l:index, l:data]
	call actionmenu#callback(l:index, l:data)
endfunction

" Menu mappings
mapclear <buffer>
imapclear <buffer>

inoremap <silent><nowait><buffer><expr> <CR> <SID>select_item()
imap     <nowait><buffer> <C-y> <CR>
imap     <nowait><buffer> <C-e> <Esc>

" Navigate in menu
inoremap <nowait><buffer> <Up>    <C-p>
inoremap <nowait><buffer> <Down>  <C-n>
inoremap <nowait><buffer> k       <C-p>
inoremap <nowait><buffer> j       <C-n>
imap     <nowait><buffer> <C-k>   <C-p>
imap     <nowait><buffer> <C-j>   <C-n>
inoremap <nowait><buffer> <S-Tab> <C-p>
imap     <nowait><buffer> <Tab>   <C-n>

" Scroll pages in menu
inoremap <nowait><buffer> <C-b>  <PageUp>
inoremap <nowait><buffer> <C-f>  <PageDown>
imap     <nowait><buffer> <C-u>  <PageUp>
imap     <nowait><buffer> <C-d>  <PageDown>

" Events
augroup actionmenu
	autocmd!
	autocmd InsertLeave <buffer> call <SID>on_insert_leave()
augroup END

" Set the pum completion function
setlocal completefunc=actionmenu#complete_func
setlocal completeopt+=menuone
setlocal completeopt+=noinsert

" Open the pum immediately
call s:open_pum()
