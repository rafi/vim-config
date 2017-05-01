
" neocomplete
" -----------

let g:neocomplete#disable_auto_complete = 0
let g:neocomplete#enable_auto_select = 0
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#enable_auto_close_preview = 1
let g:neocomplete#skip_auto_completion_time = ''
let g:neocomplete#max_list = 150

" Smart case and fuzziness
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case = 1
let g:neocomplete#enable_fuzzy_completion = 1
" let g:neocomplete#enable_refresh_always = 1

" Lengths of strings to start completion
let g:neocomplete#auto_completion_start_length = 2
let g:neocomplete#manual_completion_start_length = 0
let g:neocomplete#min_keyword_length = 3

" Selective feature disable
" ---

let g:neocomplete#disable_auto_select_buffer_name_pattern =
	\ '\[Command Line\]'

" Do not autocomplete/cache in sensitive file patterns
let g:neocomplete#sources#buffer#disabled_pattern =
	\ '\/private\/var\/\|\/shm\/\|\/tmp\/\|\.vault\.vim'

let g:neocomplete#lock_buffer_name_pattern =
	\ g:neocomplete#sources#buffer#disabled_pattern

" Keyword patterns completion
" ---

" Define a default keyword pattern
if ! exists('g:neocomplete#keyword_patterns')
	let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns._ = '\h\k*(\?'

" Enable omni-completion
" ---

if ! exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.coffee =
	\ '[[:alpha:]./"''$]\+'
let g:neocomplete#sources#omni#input_patterns.go =
	\ '[^.[:digit:] *\t]\.\w*'
"let g:neocomplete#sources#omni#input_patterns.c =
"	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
"let g:neocomplete#sources#omni#input_patterns.cpp =
"	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.ruby =
	\ '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.python =
	\ '[^. *\t]\.\w*\|\h\w*'

" Force omni-completion input patterns
" ---

if ! exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {}
endif

let g:neocomplete#force_omni_input_patterns.javascript =
	\ '[^. \t]\.\w*'
let g:neocomplete#force_omni_input_patterns.typescript =
	\ '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.php =
	\ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
"let g:neocomplete#force_omni_input_patterns.python =
"	\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" Alternative pattern: \ '\h\w*\|[^. \t]\.\w*'

call neocomplete#custom#source('_', 'converters',
	\ ['converter_add_paren', 'converter_remove_overlap',
	\  'converter_delimiter', 'converter_abbr'])

" Mappings
" --------

let g:neocomplete#fallback_mappings = [ "\<C-x>\<C-o>", "\<C-x>\<C-n>" ]

" Movement within 'ins-completion-menu'
imap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"
imap <expr><C-f>   pumvisible() ? "\<PageDown>" : "\<Right>"
imap <expr><C-b>   pumvisible() ? "\<PageUp>" : "\<Left>"
imap <expr><C-d>   pumvisible() ? "\<PageDown>" : "\<Right>"
imap <expr><C-u>   pumvisible() ? "\<PageUp>" : "\<Left>"

" <C-n>: neocomplete.
imap <expr> <C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
" <C-p>: keyword completion.
imap <expr> <C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"

" Special plugin key-mappings
"inoremap <expr><C-l>  neocomplete#mappings#complete_common_string()
inoremap <expr><C-l>  neocomplete#mappings#refresh()
inoremap <expr><C-g>   neocomplete#undo_completion()

" Start file completion TODO Not working all the time
imap <silent><expr> <C-x><C-f> neocomplete#start_manual_complete('file')

" <CR>: If popup menu visible, expand snippet or close popup with selection,
"       Otherwise, check if within empty pair and use delimitMate.
imap <silent><expr><CR> pumvisible() ?
	\ (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : "\<C-y>")
		\ : (delimitMate#WithinEmptyPair() ? "\<Plug>delimitMateCR" : "\<CR>")

" <Tab> completion:
" 1. If popup menu is visible, select and insert next item
" 2. Otherwise, if within a snippet, jump to next input
" 3. Otherwise, if preceding chars are whitespace, insert tab char
" 4. Otherwise, start manual autocomplete
imap <silent><expr><Tab> pumvisible() ? "\<C-n>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : neocomplete#start_manual_complete()))

smap <silent><expr><Tab> pumvisible() ? "\<C-n>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : neocomplete#start_manual_complete()))

inoremap <expr><S-Tab>  pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~? '\s'
endfunction "}}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
