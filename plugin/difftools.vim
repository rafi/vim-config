" Improve diff behavior
" ---
"
" Behaviors:
" - Update diff comparison once leaving insert mode
"
" Commands:
" - DiffOrig: Show diff of unsaved changes

if exists('g:loaded_difftools')
	finish
endif
let g:loaded_difftools = 1

augroup plugin_difftools
	autocmd!
	autocmd InsertLeave * if &l:diff | diffupdate | endif
	autocmd BufWinLeave __diff call s:close_diff()
augroup END

function! s:open_diff()
	" Open diff window and start comparison
	let l:bnr = bufnr('%')
	call setwinvar(winnr(), 'diff_origin', l:bnr)
	vertical new __diff
	let l:diff_bnr = bufnr('%')
	nnoremap <buffer><silent> q :quit<CR>
	setlocal buftype=nofile bufhidden=wipe
	r ++edit #
	0d_
	diffthis
	setlocal readonly
	wincmd p
	let b:diff_bnr = l:diff_bnr
	nnoremap <buffer><silent> q :execute bufwinnr(b:diff_bnr) . 'q'<CR>
	diffthis
endfunction

function! s:close_diff()
	" Close diff window, switch to original window and disable diff
	" Credits: https://github.com/chemzqm/vim-easygit
	let wnr = +bufwinnr(+expand('<abuf>'))
	let val = getwinvar(wnr, 'diff_origin')
	if ! len(val) | return | endif
	for i in range(1, winnr('$'))
		if i == wnr | continue | endif
		if len(getwinvar(i, 'diff_origin'))
			return
		endif
	endfor
	let wnr = bufwinnr(val)
	if wnr > 0
		execute wnr . 'wincmd w'
		diffoff
	endif
endfunction

" Display diff of unsaved changes
command! -nargs=0 DiffOrig call s:open_diff()

" vim: set ts=2 sw=2 tw=80 noet :
