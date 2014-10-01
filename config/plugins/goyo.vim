
" Goyo
" ----

function! s:goyo_enter()
	" Disable statusline and tabs
	TinyLine!
	TinyTabs!

	if has('gui_running')
		" Gui fullscreen
		set fullscreen
		set background=light
		set linespace=7
	elseif exists('$TMUX')
		" Hide tmux status
		silent !tmux set status off
	endif
	" Disable ZoomWin
	delcommand ZoomWin
	delcommand <Plug>ZoomWin

	" Activate Limelight
	Limelight
endfunction

function! s:goyo_leave()
	" Enable statusline and tabs
	TinyLine
	TinyTabs

	if has('gui_running')
		" Gui exit fullscreen
		set nofullscreen
		set background=dark
		set linespace=0
	elseif exists('$TMUX')
		" Show tmux status
		silent !tmux set status on
	endif

	" Enable ZoomWin
	command! ZoomWin call ZoomWin()
	command! <Plug>ZoomWin call ZoomWin()

	" De-activate Limelight
	Limelight!
endfunction

autocmd! User GoyoEnter
autocmd! User GoyoLeave
autocmd  User GoyoEnter nested call <SID>goyo_enter()
autocmd  User GoyoLeave nested call <SID>goyo_leave()
