" Unix Help
" ---
" Open man pages for gitconfig, tmux, and sh files
"
" Behaviors:
" - If one of the supported filetypes is loaded, map K to open help window
"
" Options:
" - g:unixhelp_open_with_tmux enable to use tmux splits for help windows

if exists('g:loaded_unixhelp')
	finish
endif
let g:loaded_unixhelp = 1

let g:unixhelp_open_with_tmux = get(g:, 'unixhelp_open_with_tmux', 0)

augroup plugin_unixhelp
	autocmd!
	autocmd FileType gitconfig,tmux,sh nnoremap <silent><buffer> K
		\ :<C-u>call <SID>open_man(&filetype, expand('<cword>'))<CR>
augroup END

function! s:open_man(ft, search_word)
	let l:mapping = {
		\   'gitconfig': 'git-config',
		\ }

	let l:ft = a:ft
	if has_key(l:mapping, l:ft)
		let l:ft = l:mapping[l:ft]
	endif

	if empty(l:ft)
		echoerr 'Sorry, no help supported for "' . l:ft . '" filetypes.'
		return
	endif

	let l:cmd = 'man ' . l:ft
	if g:unixhelp_open_with_tmux && ! empty('$TMUX')
		call s:man_tmux(l:cmd, a:search_word)
	else
		call s:man_preview(l:cmd, a:search_word)
	endif
endfunction

" Open file-explorer split with tmux
function! s:man_tmux(str, word)
	if empty('$TMUX')
		return
	endif
	let l:cmd = 'MANPAGER="less --pattern='.shellescape(a:word, 1).'" '.a:str
	silent execute '!tmux split-window -p 30 '.shellescape(l:cmd, 1)
endfunction

function! s:man_preview(str, word)
	silent! wincmd P
	if ! &previewwindow
		noautocmd execute 'bo' &previewheight 'new'
		set previewwindow
		silent! wincmd P
	else
		execute 'resize' &previewheight
	endif
	setlocal buftype=nofile bufhidden=delete noswapfile
	setlocal noreadonly modifiable
	execute '%delete_'

	silent execute '%!MANPAGER=cat '.a:str

	setlocal readonly filetype=man
	nnoremap <silent><buffer> q :<C-u>set nopvw<CR>:<C-u>bdelete!<CR>
	" normal! gg
	" silent! execute 'normal! /'.a:word."\<CR>"
	" let @/ = a:word
	" noautocmd wincmd p
	call feedkeys('/'.a:word."\<CR>", 'nt')
endfunction
