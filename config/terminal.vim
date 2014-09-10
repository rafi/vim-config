
" URxvt & tmux fixes {{{1
"------------------------------------------------------------------------------

" Make the Ctrk+Tab work in console, see also .config/xorg/Xresources
map <Esc>[27;5;9~ <C-Tab>
map <Esc>[27;6;9~ <C-S-Tab>

" Under URxvt and Tmux, make Vim recognize xterm escape
" sequences for arrow keys combined with modifiers.
if &term =~ '^screen'
	" Ctrl+Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
	execute "set t_kP=\e[5;*~"
	execute "set t_kN=\e[6;*~"

	" Ctrl+Arrow keys http://unix.stackexchange.com/a/34723/64717
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"
endif

" Cursor Shape {{{2
" ------------
" For rxvt-unicode:
" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
if exists('$TMUX')
	let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>[3 q\<Esc>\\"
	let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>[0 q\<Esc>\\"
	execute 'silent !echo -e "\033kvim\033\\"'
else
	let &t_SI = "\<Esc>[3 q"
	let &t_EI = "\<Esc>[0 q"
endif
