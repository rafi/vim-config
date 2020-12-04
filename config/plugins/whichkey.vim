" which-key
" ---

augroup user_events
	autocmd! FileType which_key
	autocmd  FileType which_key set laststatus=0 noshowmode noruler
		\| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

let g:which_key_hspace = 3

call which_key#register('<Space>', "g:which_key_map")

let g:which_key_map = {
	\ 'name': 'rafi vim',
	\ '-': 'swap window select',
	\ '?': 'open dictionary',
	\ 'a': 'open structure',
	\ 'b': 'find in structure',
	\ 'd': 'duplicate line',
	\ 'e': 'open diagnostics',
	\ 'f': 'filter in-place',
	\ 'G': 'distraction-free',
	\ 'h': 'show highlight',
	\ 'j': 'move line down',
	\ 'k': 'move line up',
	\ 'K': 'thesaurus',
	\ 'l': 'open side-menu',
	\ 'N': 'alternate backwards',
	\ 'n': 'alternate forwards',
	\ 'S': 'source vim line',
	\ 'V': 'comment wrap toggle',
	\ 'v': 'comment toggle',
	\ 'W': 'open wiki',
	\ 'w': 'save',
	\ 'Y': 'yank relative path',
	\ 'y': 'yank absolute path',
	\ }

let g:which_key_map['c'] = {
	\ 'name': '+misc',
	\ 'd': 'change current window directory',
	\ 'n': 'change current word in a repeatable manner (forwards)',
	\ 'N': 'change current word in a repeatable manner (backwards)',
	\ 'p': 'duplicate paragraph',
	\ 'w': 'strip trailing whitespace',
	\ }

let g:which_key_map['g'] = {
	\ 'name': '+find',
	\ }

let g:which_key_map['i'] = {
	\ 'name': '+jump',
	\ }

let g:which_key_map['m'] = {
	\ 'name': '+misc2',
	\ }

let g:which_key_map['r'] = {
	\ 'name': '+iron',
	\ }

let g:which_key_map['s'] = {
	\ 'name': '+session',
	\ 'l': ' load project session',
	\ 'e': ' save project session',
	\ }

let g:which_key_map['t'] = {
	\ 'name': '+toggle',
	\ 'h': ' toggle search highlight',
	\ 'i': ' toggle indent',
	\ 'l': ' toggle hidden chars',
	\ 'n': ' toggle line numbers',
	\ 's': ' toggle spell',
	\ 'w': ' toggle wrap',
	\ }

" vim: set ts=2 sw=2 tw=80 noet :
