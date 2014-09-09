
" neocomplete
" -----------
if ! has('lua')
	finish
endif

let g:neocomplete#max_list = 100
let g:neocomplete#disable_auto_complete = 0
let g:neocomplete#force_overwrite_completefunc = 1

" Use CursorHoldI to delay popup by miliseconds
"let g:neocomplete#enable_cursor_hold_i = 1
"let g:neocomplete#cursor_hold_i_time   = 200

" Smart case and no fuzziness, disabling heavy operations
let g:neocomplete#enable_smart_case       = 1
let g:neocomplete#enable_camel_case       = 1
let g:neocomplete#enable_fuzzy_completion = 1
let g:neocomplete#enable_refresh_always   = 0
let g:neocomplete#enable_prefetch         = 1

" Minimum char completion lengths
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#auto_completion_start_length      = 2
let g:neocomplete#manual_completion_start_length    = 0
let g:neocomplete#min_keyword_length                = 3

let g:neocomplete#enable_auto_select = 0
let g:neocomplete#enable_auto_delimiter = 0
let g:neocomplete#disable_auto_select_buffer_name_pattern =
      \ '\[Command Line\]'

" TODO: Find out what da' heck this is
"let g:neocomplete#lock_buffer_name_pattern       = '\*ku\*'

" Define a default keyword pattern
if ! exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
" \h\w* = head of word is a word characters
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Enable heavy omni completion
if ! exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

" Omni-completion input patterns per-language:
let g:neocomplete#sources#omni#input_patterns.php =
	\ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.go = '[^.[:digit:] *\t]\.\w*'
"let g:neocomplete#sources#omni#input_patterns.go = '\h\w*'
"let g:neocomplete#sources#omni#input_patterns.ruby =
"	\ '[^. *\t]\.\w*\|\h\w*::\w*'
"let g:neocomplete#sources#omni#input_patterns.c =
"	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
"let g:neocomplete#sources#omni#input_patterns.cpp =
"	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

if ! exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.javascript = '[^. \t]\.\w*'
