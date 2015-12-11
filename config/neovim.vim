" Write history on idle
augroup MyAutoCmd
	autocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
augroup END

let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1
" let $NVIM_TUI_ENABLE_TRUE_COLOR = 1
