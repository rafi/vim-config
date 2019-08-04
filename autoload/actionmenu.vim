" actionmenu
" ---
" Forked from: https://github.com/kizza/actionmenu.nvim

if get(s:, 'loaded')
	finish
endif

let s:loaded = 1
let s:buffer = 0
let g:actionmenu#win = 0
let g:actionmenu#items = []

function! actionmenu#icon() abort
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
	let l:opts = get(a:, 1, 0)

	" Create the buffer
	if ! s:buffer
		let s:buffer = nvim_create_buf(0, 1)
		call nvim_buf_set_option(s:buffer, 'syntax', 'OFF')
	endif

	" Prepare the menu
	if type(l:opts['icon']) == type({})
		let l:icon = l:opts['icon']
	else
		let l:icon = actionmenu#icon()
	endif
	call nvim_buf_set_lines(s:buffer, 0, -1, v:true, [ l:icon['character'] ])
	let g:ActionMenuCallback = a:callback
	let g:actionmenu#items = a:items

	" Close the old window if opened
	call actionmenu#close()

	" Open the window
	let l:winhl = 'Normal:Pmenu,NormalNC:Pmenu'
	let l:opts = {
		\ 'focusable': v:false,
		\ 'width': 1,
		\ 'height': 1,
		\ 'relative': 'cursor',
		\ 'row': 0,
		\ 'col': 0
		\}

	let g:actionmenu#win = nvim_open_win(s:buffer, 1, l:opts)
	call nvim_win_set_option(g:actionmenu#win, 'foldenable', v:false)
	call nvim_win_set_option(g:actionmenu#win, 'wrap', v:true)
	call nvim_win_set_option(g:actionmenu#win, 'statusline', '')
	call nvim_win_set_option(g:actionmenu#win, 'number', v:false)
	call nvim_win_set_option(g:actionmenu#win, 'relativenumber', v:false)
	call nvim_win_set_option(g:actionmenu#win, 'cursorline', v:false)
	call nvim_win_set_option(g:actionmenu#win, 'winhl', l:winhl)

	" Setup the window
	setlocal filetype=actionmenu
	if ! empty(l:icon['foreground'])
		execute('hi ActionMenuContext ctermfg=' . l:icon['foreground'] . ' guifg=' . l:icon['foreground'])
		syn match ActionMenuContext '.'
	endif
endfunction

function! actionmenu#callback(index, item) abort
	call actionmenu#close()
	if type(g:ActionMenuCallback) == type('')
		execute('call ' . g:ActionMenuCallback . '(a:index, a:item)')
	else
		call g:ActionMenuCallback(a:index, a:item)
	endif
endfunction

function! actionmenu#close() abort
	if g:actionmenu#win
		execute('close')
		let g:actionmenu#win = 0
		doautocmd BufWinEnter
	endif
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
