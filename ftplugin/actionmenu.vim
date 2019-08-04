" actionmenu
" ---
" Forked from: https://github.com/kizza/actionmenu.nvim

" Style the buffer every time
setlocal sidescrolloff=0 scrolloff=0 nowrap
setlocal signcolumn=no listchars= showbreak=
let b:cursorword = 0

" Only load ftplugin once
if get(s:, 'loaded')
	" Subsequent times, just open pum
	call actionmenu#open_pum()
	finish
endif
let s:loaded = 1

" Current menu selection
let s:selected_item = 0

" Trigger InsertEnter only the first time menu loads.
" This is to allow any lazy-loading insert mode plugins beforehand.
doautocmd <nomodeline> InsertEnter

function! actionmenu#open_pum()
	call feedkeys("i\<C-x>\<C-u>")
	silent! autocmd! deoplete *
	silent! autocmd! neosnippet *
endfunction

function! actionmenu#select_item()
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

function! actionmenu#on_insert_leave()
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

function! actionmenu#pum_parse_item(item, index) abort
	if type(a:item) == type('')
		return { 'word': a:item, 'user_data': a:index }
	else
		return { 'word': a:item['word'], 'user_data': a:index }
	endif
endfunction

" Menu mappings
mapclear <buffer>
inoremap <silent><buffer><expr> <CR> actionmenu#select_item()
imap <buffer> <C-y> <CR>
imap <buffer> <C-e> <Esc>

" Navigate in menu
inoremap <buffer> <Up>    <C-p>
inoremap <buffer> <Down>  <C-n>
inoremap <buffer> k       <C-p>
inoremap <buffer> j       <C-n>
imap     <buffer> <C-k>   <C-p>
imap     <buffer> <C-j>   <C-n>
inoremap <buffer> <S-Tab> <C-p>
imap     <buffer> <Tab>   <C-n>

" Scroll pages in menu
inoremap <buffer> <C-b>  <PageUp>
inoremap <buffer> <C-f>  <PageDown>
imap     <buffer> <C-u>  <PageUp>
imap     <buffer> <C-d>  <PageDown>

" Events
augroup actionmenu
	autocmd!
	autocmd InsertLeave <buffer> call actionmenu#on_insert_leave()
augroup END

" Pum completion function
function! actionmenu#complete_func(findstart, base)
	if a:findstart
		return 1
	else
		return map(copy(g:actionmenu#items), {
			\ index, item -> actionmenu#pum_parse_item(item, index) })
	endif
endfunction

" Set the pum completion function
setlocal completefunc=actionmenu#complete_func
setlocal completeopt+=menuone
setlocal completeopt+=noinsert

" Open the pum immediately
call actionmenu#open_pum()
