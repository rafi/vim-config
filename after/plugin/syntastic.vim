
" Syntastic
" ---------
let g:syntastic_check_on_open   = 0
let g:syntastic_enable_signs    = 1
let g:syntastic_enable_balloons = 1
let g:syntastic_auto_loc_list   = 2

" Checkers
let g:syntastic_php_checkers        = [ 'php' ]
let g:syntastic_javascript_checkers = [ 'jshint' ]
let g:syntastic_html_checkers       = [ 'tidy', 'jshint' ]
