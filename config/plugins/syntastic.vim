
" Syntastic
" ---------
let g:syntastic_check_on_open      = 1
let g:syntastic_check_on_wq        = 1
let g:syntastic_enable_signs       = 1
let g:syntastic_enable_balloons    = 0
let g:syntastic_auto_loc_list      = 2
let g:syntastic_aggregate_errors   = 1
let g:syntastic_echo_current_error = 1

" Checkers
let g:syntastic_php_checkers        = [ 'php' ]
let g:syntastic_javascript_checkers = [ 'jshint' ]
let g:syntastic_html_checkers       = [ 'tidy', 'jshint' ]
let g:syntastic_python_checkers     = [ 'python2', 'pylint', 'flake8' ]

let g:syntastic_html_tidy_ignore_errors = [
	\  '<html> attribute "lang" lacks value',
	\  '<a> attribute "href" lacks value',
	\  'trimming empty <span>',
	\  'trimming empty <h1>'
	\ ]

"let g:syntastic_filetype_map = { "mustache": "handlebars" }
"let g:syntastic_filetype_map = { "html.mustache": "handlebars" }

"let g:syntastic_html_tidy_quiet_messages = { "level" : "warnings" }
"let g:syntastic_html_tidy_ignore_errors = [
"	\  'plain text isn''t allowed in <head> elements',
"	\  '<base> escaping malformed URI reference',
"	\  'discarding unexpected <body>',
"	\  '<script> escaping malformed URI reference',
"	\  '</head> isn''t allowed in <body> elements'
"	\ ]

" Debugging
"let g:syntastic_debug = 1
"let g:syntastic_debug_file = '~/syntastic.log'

" vim: set ts=2 sw=2 tw=80 noet :
