" Maintainer: rafi
" Author: https://github.com/klen/unite-radio.vim

let s:save_cpo = &cpo
set cpo&vim

" Options {{{
" -------
let s:stations = get(g:, 'unite_source_radio_stations', [
	\ [ '88fm',            'mms://s67wm.castup.net/990310006-52.wmv' ],
	\ [ '91fm ?',          'mms://213.8.143.171/91FM' ],
	\ [ '102fm Radio ?',   'rtmp://fms3.mediacast.co.il/liveradio/102.stream' ],
	\ [ 'Arutz 7',         'http://www.inn.co.il/static/a7radio.asx' ],
	\ [ 'Galei Tzahal',    'http://50.22.219.97:14959/;?1392189709172.mp3' ],
	\ [ 'Galgalatz ?',     'http://radio.glz.co.il:8000/galgalatz' ],
	\ [ 'Galatz ?',        'http://glz.msn.co.il/media/glz.asx' ],
	\ [ 'Kol HaCampus ?',  'mms://live3.mediacast.co.il/106fm' ],
	\ [ 'Kol HaMusica',    'mms://s67wm.castup.net/990310008-52.wmv' ],
	\ [ 'Reshet Alef ?',   'mms://s67wm.castup.net/990310002-52.wmv' ],
	\ [ 'Reshet Bet',      'mms://s4awm.castup.net/990310001-52.wmv' ],
	\ [ 'Reshet Gimel',    'mms://s4awm.castup.net/990310004-52.wmv' ],
	\ [ '103fm ?',         'http://switch3.castup.net/cunet/gm.asp?ai=546&ar=Live01' ],
	\ [ 'Radio Jerusalem', 'mms://212.150.243.29/101fm' ],
	\ [ 'Radio Haifa ?',   'rtmp://fms3.mediacast.co.il/liveradio/1075.stream' ],
	\ [ '100fm Radius ?',  'mms://213.8.143.171/100fm' ],
	\ [ 'Radio Oranim ?',  'http://radio.ilcast.com:8017/listen.pls' ],
	\ [ 'Radio Kol Hai',   'http://jradio.ilcast.com:8000/live' ],
	\ [ 'Galei Israel ?',  'mms://213.8.144.45/galeyisrael' ],
	\ [ 'Radio 2000 ?',    'http://jradio.ilcast.com:8030/listen.pls' ],
	\ [ 'Reshet Moreshet', 'http://kolbarama.media-line.co.il/kol-b-live' ],
\ ])

let s:play_cmd = get(g:, 'unite_source_radio_play_cmd', '')
let s:process = {}
let s:source = {
\ 'name': 'radio',
\ 'description': 'Radio stations',
\ 'hooks': {},
\ 'action_table': {},
\ 'syntax': 'uniteSource__Radio',
\ 'default_action' : 'execute'
\ }
" }}}

" Setup {{{
" -----

command! -nargs=? MPlay call unite#sources#radio#play(<q-args>)
command! MStop call unite#sources#radio#stop()
autocmd VimLeavePre * MStop

if ! s:play_cmd
	" Automatically detect available player
	if executable('mplayer')
		let s:play_cmd = 'mplayer -quiet -playlist'
	elseif executable('cvlc')
		let s:play_cmd = 'cvlc -Irc --quiet'
	elseif executable('/Applications/VLC.app/Contents/MacOS/VLC')
		let s:play_cmd = '/Applications/VLC.app/Contents/MacOS/VLC -Irc --quiet'
	else
		echoerr "Unable to find audio player (mplayer/vlc). See :help unite-radio"
	endif
endif

" Unite integration {{{
" -----------------

func! unite#sources#radio#define()
	return s:source
endfunc

func! s:source.gather_candidates(args, context) "{{{
	return map(copy(s:stations), "{
			\ 'word' : len(s:process) && s:process.url == v:val[1] ? '|P>'.v:val[0].'<P|' : v:val[0],
			\ 'url': v:val[1],
			\ 'cmd': len(v:val) > 2 ? v:val[2] : ''
	\ }")
endfunc "}}}

let s:source.action_table.execute = {
	\ 'description': 'Radio station',
	\ 'is_invalidate_cache' : 1,
	\ 'is_quit': 0,
	\ }

func! s:source.action_table.execute.func(candidate) "{{{
	call unite#sources#radio#play(a:candidate.url, a:candidate.cmd)
endfunc "}}}

func! s:source.hooks.on_syntax(args, context) "{{{
	syntax match uniteSource__Radio_Play  /|P>.*<P|/
			\  contained containedin=uniteSource__Radio
			\  contains
			\  	= uniteSource__Radio_PlayHiddenBegin
			\  	, uniteSource__Radio_PlayHiddenEnd

	syntax match uniteSource__Radio_PlayHiddenBegin '|P>' contained conceal
	syntax match uniteSource__Radio_PlayHiddenEnd   '<P|' contained conceal

	highlight uniteSource__Radio_Play guifg=#888888 ctermfg=Green
endfunc "}}}

func! s:source.hooks.on_post_filter(args, context) "{{{
	if len(s:process)
		call s:widemessage('Now Playing: ' . s:process.url)
	endif
endfunc "}}}

" }}}

func! unite#sources#radio#play(url, cmd) "{{{
	if ! (a:url =~ '(pls|m3u|asx)')
		let s:play_cmd = "mplayer -quiet"
	endif

	if a:cmd != ''
		let s:play_cmd = a:cmd
	endif

	call unite#sources#radio#stop()
	let s:process = vimproc#popen2(s:play_cmd.' '.a:url)
	let s:process.url = a:url
	call s:widemessage('Now Playing: ' . s:process.url)
endfunc "}}}

func! unite#sources#radio#stop() "{{{
	if len(s:process)
		call s:process.kill(9)
	endif
	let s:process = {}
endfunc "}}}

func! s:widemessage(msg) "{{{
	let x=&ruler
	let y=&showcmd
	set noruler noshowcmd
	redraw
	echohl Debug
	echo strpart(a:msg, 0, &columns-1)
	echohl none
	let &ruler=x
	let &showcmd=y
endfunc "}}}

let &cpo = s:save_cpo
unlet s:save_cpo
