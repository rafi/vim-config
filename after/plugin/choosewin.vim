
" ChooseWin
" ---------

let g:choosewin_overlay_enable = 1           " use overlay feature
let g:choosewin_overlay_clear_multibyte = 1  " workaround

let g:choosewin_color_overlay = {
			\ 'gui': ['DodgerBlue3', 'DodgerBlue3' ],
			\ 'cterm': [ 248, 248 ]
			\ }

let g:choosewin_color_overlay_current = {
			\ 'gui': ['firebrick1', 'firebrick1' ],
			\ 'cterm': [ 235, 235 ]
			\ }

let g:choosewin_blink_on_land      = 0 " don't blink on landing
let g:choosewin_statusline_replace = 0 " don't replace statusline
let g:choosewin_tabline_replace    = 0 " don't replace tabline
