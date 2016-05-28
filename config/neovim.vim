" Write history on idle
augroup MyAutoCmd
	autocmd CursorHold * if exists(':rshada') | rshada | wshada | endif
augroup END

" Search and use environments specifically made for Neovim.
if isdirectory($VARPATH.'/venv/neovim2')
	let g:python_host_prog = $VARPATH.'/venv/neovim2/bin/python'
endif
if isdirectory($VARPATH.'/venv/neovim3')
	let g:python3_host_prog = $VARPATH.'/venv/neovim3/bin/python'
endif

let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 1

" Enable true color
if exists('+termguicolors')
	set termguicolors
endif
