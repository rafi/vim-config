
" neocomplete
" -----------
let g:neocomplete#enable_smart_case                 = 1
let g:neocomplete#enable_fuzzy_completion           = 0
let g:neocomplete#enable_refresh_always             = 1
let g:neocomplete#enable_prefetch                   = 1
let g:neocomplete#auto_completion_start_length      = 2
let g:neocomplete#sources#syntax#min_keyword_length = 4
let g:neocomplete#lock_buffer_name_pattern          = '\*ku\*'

" Define keyword
if !exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Enable heavy omni completion
if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.php =
	\ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
"let g:neocomplete#sources#omni#input_patterns.c =
"	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
"let g:neocomplete#sources#omni#input_patterns.cpp =
"	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
