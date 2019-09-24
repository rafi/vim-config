" actionmenu
" ---
" Forked from: https://github.com/kizza/actionmenu.nvim

if get(s:, 'loaded')
	finish
endif

let s:loaded = 1
let s:buffer = 0
let s:window = 0
let g:actionmenu#items = []
let g:actionmenu#selected = []

function! actionmenu#icon_default() abort
	let l:icon = get(g:, 'actionmenu#icon', '')
	if empty(l:icon)
		" Current character and its foreground
		let l:icon = {
			\ 'character': strcharpart(strpart(getline('.'), col('.') - 1), 0, 1),
			\ 'foreground': synIDattr(synID(line('.'), col('.'), 1), 'fg')
			\ }
	endif
	return l:icon
endfunction

function! actionmenu#open(items, callback, ...) abort
	let g:actionmenu#items = a:items
	let g:actionmenu#selected = []
	let s:callback = a:callback
	let l:opts = get(a:, 1, 0)

	" Close the old window if opened
	call actionmenu#close()

	" Prepare the menu
	if type(l:opts['icon']) == type({})
		let l:icon = l:opts['icon']
	else
		let l:icon = actionmenu#icon_default()
	endif
	if ! s:buffer
		let s:buffer = nvim_create_buf(0, 1)
		call nvim_buf_set_option(s:buffer, 'syntax', 'OFF')
	endif
	call nvim_buf_set_option(s:buffer, 'modifiable', v:true)
	call nvim_buf_set_lines(s:buffer, 0, -1, v:true, [ l:icon['character'] ])

	" Open the window
	let l:opts = {
		\ 'relative': 'cursor',
		\ 'focusable': v:false,
		\ 'width': 1,
		\ 'height': 1,
		\ 'row': 0,
		\ 'col': 0
		\}

	let s:window = nvim_open_win(s:buffer, 1, l:opts)
	call nvim_win_set_option(s:window, 'foldenable', v:false)
	call nvim_win_set_option(s:window, 'wrap', v:true)
	call nvim_win_set_option(s:window, 'statusline', '')
	call nvim_win_set_option(s:window, 'number', v:false)
	call nvim_win_set_option(s:window, 'relativenumber', v:false)
	call nvim_win_set_option(s:window, 'cursorline', v:false)
	call nvim_win_set_option(s:window, 'winhl', 'Normal:Pmenu,NormalNC:Pmenu')

	" Setup the window
	setlocal filetype=actionmenu
	if ! empty(l:icon['foreground'])
		execute('hi ActionMenuContext ctermfg=' . l:icon['foreground'] . ' guifg=' . l:icon['foreground'])
		syn match ActionMenuContext '.'
	endif
endfunction

function! actionmenu#callback(index, item) abort
	doautocmd <nomodeline> BufWinEnter
	if empty(s:callback)
		return
	endif
	if a:index >= 0 && ! empty(a:item) && type(a:item) != type('')
		call timer_start(1, s:callback)
	endif
	unlet s:callback
endfunction

function! actionmenu#close() abort
	if s:window
		call nvim_win_close(s:window, v:false)
		" execute('close')
		let s:window = 0
	endif
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
