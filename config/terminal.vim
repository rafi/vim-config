" Vim Only Terminal Tweaks: Colors, cursor shape, and tmux
"---------------------------------------------------------

" Paste
" Credits: https://github.com/Shougo/shougo-s-github
" ---
let &t_ti .= "\e[?2004h"
let &t_te .= "\e[?2004l"
let &pastetoggle = "\e[201~"

function! s:XTermPasteBegin(ret) abort
	setlocal paste
	return a:ret
endfunction

noremap  <special> <expr> <Esc>[200~ <SID>XTermPasteBegin('0i')
inoremap <special> <expr> <Esc>[200~ <SID>XTermPasteBegin('')
cnoremap <special> <Esc>[200~ <nop>
cnoremap <special> <Esc>[201~ <nop>

" Mouse settings
" ---
if has('mouse')
	if has('mouse_sgr')
		set ttymouse=sgr
	else
		set ttymouse=xterm2
	endif
endif

" Cursor-shape
" Credits: https://github.com/wincent/terminus
" ---
" Detect terminal
let s:tmux = exists('$TMUX')
let s:iterm = exists('$ITERM_PROFILE') || exists('$ITERM_SESSION_ID')
let s:iterm2 = s:iterm && exists('$TERM_PROGRAM_VERSION') &&
	\ match($TERM_PROGRAM_VERSION, '\v^[2-9]\.') == 0
let s:konsole = exists('$KONSOLE_DBUS_SESSION') ||
	\ exists('$KONSOLE_PROFILE_NAME')

" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
let s:normal_shape = 0
let s:insert_shape = 5
let s:replace_shape = 3
if s:iterm2
	let s:start_insert = "\<Esc>]1337;CursorShape=" . s:insert_shape . "\x7"
	let s:start_replace = "\<Esc>]1337;CursorShape=" . s:replace_shape . "\x7"
	let s:end_insert = "\<Esc>]1337;CursorShape=" . s:normal_shape . "\x7"
elseif s:iterm || s:konsole
	let s:start_insert = "\<Esc>]50;CursorShape=" . s:insert_shape . "\x7"
	let s:start_replace = "\<Esc>]50;CursorShape=" . s:replace_shape . "\x7"
	let s:end_insert = "\<Esc>]50;CursorShape=" . s:normal_shape . "\x7"
else
	let s:cursor_shape_to_vte_shape = {1: 6, 2: 4, 0: 2, 5: 6, 3: 4}
	let s:insert_shape = s:cursor_shape_to_vte_shape[s:insert_shape]
	let s:replace_shape = s:cursor_shape_to_vte_shape[s:replace_shape]
	let s:normal_shape = s:cursor_shape_to_vte_shape[s:normal_shape]
	let s:start_insert = "\<Esc>[" . s:insert_shape . ' q'
	let s:start_replace = "\<Esc>[" . s:replace_shape . ' q'
	let s:end_insert = "\<Esc>[" . s:normal_shape . ' q'
endif

function! s:tmux_wrap(string)
	if strlen(a:string) == 0 | return '' | end
	let l:tmux_begin = "\<Esc>Ptmux;"
	let l:tmux_end = "\<Esc>\\"
	let l:parsed = substitute(a:string, "\<Esc>", "\<Esc>\<Esc>", 'g')
	return l:tmux_begin.l:parsed.l:tmux_end
endfunction

if s:tmux
	let s:start_insert = s:tmux_wrap(s:start_insert)
	let s:start_replace = s:tmux_wrap(s:start_replace)
	let s:end_insert = s:tmux_wrap(s:end_insert)
endif

let &t_SI = s:start_insert
if v:version > 704 || v:version == 704 && has('patch687')
	let &t_SR = s:start_replace
end
let &t_EI = s:end_insert

" Tmux specific settings
" ---
if s:tmux
	set ttyfast

	" Set Vim-specific sequences for RGB colors
	" Fixes 'termguicolors' usage in tmux
	" :h xterm-true-color
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

	" Assigns some xterm(1)-style keys to escape sequences passed by tmux
	" when 'xterm-keys' is set to 'on'.  Inspired by an example given by
	" Chris Johnsen at https://stackoverflow.com/a/15471820
	" Credits: Mark Oteiza
	" Documentation: help:xterm-modifier-keys man:tmux(1)
	execute "set <xUp>=\e[1;*A"
	execute "set <xDown>=\e[1;*B"
	execute "set <xRight>=\e[1;*C"
	execute "set <xLeft>=\e[1;*D"

	execute "set <xHome>=\e[1;*H"
	execute "set <xEnd>=\e[1;*F"

	execute "set <Insert>=\e[2;*~"
	execute "set <Delete>=\e[3;*~"
	execute "set <PageUp>=\e[5;*~"
	execute "set <PageDown>=\e[6;*~"

	execute "set <xF1>=\e[1;*P"
	execute "set <xF2>=\e[1;*Q"
	execute "set <xF3>=\e[1;*R"
	execute "set <xF4>=\e[1;*S"

	execute "set <F5>=\e[15;*~"
	execute "set <F6>=\e[17;*~"
	execute "set <F7>=\e[18;*~"
	execute "set <F8>=\e[19;*~"
	execute "set <F9>=\e[20;*~"
	execute "set <F10>=\e[21;*~"
	execute "set <F11>=\e[23;*~"
	execute "set <F12>=\e[24;*~"
endif

" vim: set ts=2 sw=2 tw=80 noet :
