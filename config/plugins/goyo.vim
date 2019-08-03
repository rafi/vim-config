
" Goyo
" ----

" s:goyo_enter() "{{{
" Disable visual candy in Goyo mode
function! s:goyo_enter()
	if has('gui_running')
		" Gui fullscreen
		set fullscreen
		set background=light
		set linespace=7
	elseif exists('$TMUX')
		" Hide tmux status
		silent !tmux set status off
	endif

	" Activate Limelight
	let s:stl = &l:statusline
	let &l:statusline = ''
	Limelight
endfunction

" }}}
" s:goyo_leave() "{{{
" Enable visuals when leaving Goyo mode
function! s:goyo_leave()
	if has('gui_running')
		" Gui exit fullscreen
		set nofullscreen
		set background=dark
		set linespace=0
	elseif exists('$TMUX')
		" Show tmux status
		silent !tmux set status on
	endif

	" De-activate Limelight
	let &l:statusline = s:stl
	unlet s:stl
	Limelight!
endfunction
" }}}

" Goyo Commands {{{
augroup user_plugin_goyo
	autocmd!
	autocmd! User GoyoEnter
	autocmd! User GoyoLeave
	autocmd  User GoyoEnter nested call <SID>goyo_enter()
	autocmd  User GoyoLeave nested call <SID>goyo_leave()
augroup END
" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
