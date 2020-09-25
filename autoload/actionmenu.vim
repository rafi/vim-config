" actionmenu
" ---
" Context-aware menu at your cursor
" Forked from: https://github.com/kizza/actionmenu.nvim

" Menu items
let g:actionmenu#items = []

" Current menu selection
let g:actionmenu#selected = 0

" Private variables
let s:buffer = 0
let s:window = 0

function! actionmenu#open(items, callback, ...) abort
	" Open the context-menu with a:items and a:callback for selected item action.

	if empty(a:items)
		return
	endif

	" Close the old window if opened
	call actionmenu#close()

	" Create the buffer
	if ! s:buffer
		let s:buffer = nvim_create_buf(0, 1)
		call nvim_buf_set_option(s:buffer, 'syntax', 'OFF')
	endif
	call nvim_buf_set_option(s:buffer, 'modifiable', v:true)
	call nvim_buf_set_option(s:buffer, 'completefunc', 'actionmenu#complete')
	" call nvim_buf_set_lines(s:buffer, 0, -1, v:true, [ '' ])

	" Persist menu items and callback function
	let g:actionmenu#items = a:items
	let s:callback = a:callback

	" Process user hooks
	doautocmd <nomodeline> User action_menu_open_pre

	" Open the window
	let l:opts = {
		\ 'relative': 'cursor',
		\ 'focusable': v:false,
		\ 'width': 1,
		\ 'height': 1,
		\ 'row': 0,
		\ 'col': 0,
		\ 'style': 'minimal',
		\}

	let s:window = nvim_open_win(s:buffer, 1, l:opts)
	call nvim_win_set_option(s:window, 'foldenable', v:false)
	call nvim_win_set_option(s:window, 'wrap', v:false)
	call nvim_win_set_option(s:window, 'statusline', '')
	call nvim_win_set_option(s:window, 'sidescrolloff', 0)
	call nvim_win_set_option(s:window, 'listchars', '')
	if exists('&winblend')
		call nvim_win_set_option(s:window, 'winblend', 100)
	endif

	" Setup the window
	call nvim_buf_set_option(s:buffer, 'filetype', 'actionmenu')

	" Menu mappings and events
	call s:attach_events()

	" startinsert  TODO: nvim cursor relative is off
	call nvim_input("i\<C-x>\<C-u>")
endfunction

function! s:attach_events() abort
	mapclear <buffer>
	imapclear <buffer>
	inoremap <silent><nowait><buffer><expr> <CR> <SID>select_item()
	" imap     <nowait><buffer> <C-y> <CR>
	" imap     <nowait><buffer> <C-e> <Esc>

	" Navigate in menu
	inoremap <nowait><buffer> <Up>    <C-p>
	inoremap <nowait><buffer> <Down>  <C-n>
	inoremap <nowait><buffer> k       <C-p>
	inoremap <nowait><buffer> j       <C-n>
	inoremap <nowait><buffer> h       <C-p>
	inoremap <nowait><buffer> l       <C-n>
	inoremap <nowait><buffer> <Space> <C-n>
	inoremap <nowait><buffer> <C-k>   <C-p>
	inoremap <nowait><buffer> <C-j>   <C-n>
	inoremap <nowait><buffer> <S-Tab> <C-p>
	inoremap <nowait><buffer> <Tab>   <C-n>

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
endfunction

function! s:select_item() abort
	if pumvisible()
		if ! empty(v:completed_item)
			let g:actionmenu#selected = copy(v:completed_item)
		endif
		" Close pum and leave insert
		return "\<C-y>\<Esc>"
	endif
	" Leave insert mode
	return "\<Esc>"
endfunction

function! s:on_insert_leave() abort
	call actionmenu#close()
	let l:index = -1
	if type(g:actionmenu#selected) == type({})
		let l:index = get(g:actionmenu#selected, 'user_data', -1)
	endif
	let l:data = l:index > -1 ? g:actionmenu#items[l:index] : {}
	let g:actionmenu#items = []
	let g:actionmenu#selected = 0
	call actionmenu#callback(l:index, l:data)
	unlet! s:callback
	doautocmd <nomodeline> User action_menu_open_post
endfunction

" Pum completion function
function! actionmenu#complete(findstart, base) abort
	if a:findstart
		return 1
	else
		return map(copy(g:actionmenu#items), {
			\ index, item -> s:pum_parse_item(item, index) })
	endif
endfunction

function! s:pum_parse_item(item, index) abort
	if type(a:item) == type('')
		return { 'word': a:item, 'user_data': a:index }
	else
		return { 'word': a:item['word'], 'user_data': a:index }
	endif
endfunction

function! actionmenu#callback(index, item) abort
	" doautocmd <nomodeline> BufWinEnter
	if empty(s:callback)
		return
	endif
	if a:index >= 0 && ! empty(a:item) && type(a:item) != type('')
		call s:callback(a:item)
	endif
endfunction

function! actionmenu#close() abort
	if s:window
		call nvim_win_close(s:window, v:false)
		let s:window = 0
		let s:buffer = 0
	endif
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
