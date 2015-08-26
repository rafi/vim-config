
" neocomplete
" -----------

let g:neocomplete#disable_auto_complete = 0
let g:neocomplete#enable_auto_close_preview = 1
let g:neocomplete#enable_auto_select = 1
let g:neocomplete#enable_auto_delimiter = 1
let g:neocomplete#skip_auto_completion_time = ''
let g:neocomplete#max_list = 150

" Smart case and fuzziness
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#enable_camel_case = 1
let g:neocomplete#enable_fuzzy_completion = 1

" Lengths of strings to start completion
let g:neocomplete#auto_completion_start_length = 2
let g:neocomplete#manual_completion_start_length = 0
let g:neocomplete#min_keyword_length = 3

" Use CursorHoldI to delay popup by miliseconds
"let g:neocomplete#enable_cursor_hold_i = 1
"let g:neocomplete#cursor_hold_i_time = 400

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
" \h\w* = head of word is a word characters
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Enable omni-completion
" ---

if ! exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif

let g:neocomplete#sources#omni#input_patterns.javascript =
	\ '[[:alpha:]./"''$]\+'
let g:neocomplete#sources#omni#input_patterns.coffee =
	\ '[[:alpha:]./"''$]\+'
let g:neocomplete#sources#omni#input_patterns.php =
	\ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.go =
	\ '[^.[:digit:] *\t]\.\w*'
"let g:neocomplete#sources#omni#input_patterns.c =
"	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
"let g:neocomplete#sources#omni#input_patterns.cpp =
"	\ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
let g:neocomplete#sources#omni#input_patterns.ruby =
	\ '[^. *\t]\.\w*\|\h\w*::'

" Force omni-completion input patterns
" ---

if ! exists('g:neocomplete#force_omni_input_patterns')
	let g:neocomplete#force_omni_input_patterns = {}
endif

let g:neocomplete#force_omni_input_patterns.javascript =
	\ '[^. \t]\.\w*'
let g:neocomplete#force_omni_input_patterns.typescript =
	\ '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.python =
	\ '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'
" Alternative pattern: \ '\h\w*\|[^. \t]\.\w*'

" Mappings
" --------

let g:neocomplete#fallback_mappings = ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]

" Movement within 'ins-completion-menu'
inoremap <expr><C-j>   "\<Down>"
inoremap <expr><C-k>   "\<Up>"
inoremap <expr><C-f>   pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b>   pumvisible() ? "\<PageUp>" : "\<Left>"
imap     <expr><C-d>   pumvisible() ? "\<PageDown>" : "\<C-d>"
imap     <expr><C-u>   pumvisible() ? "\<PageUp>" : "\<C-u>"

" Special plugin key-mappings
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <expr><C-g> neocomplete#undo_completion()

" <C+Space> unite completion
imap <Nul>  <Plug>(neocomplete_start_unite_complete)

" <C-y>, <C-e>: Close popup, close popup and cancel selection
inoremap <expr><C-y> pumvisible() ? neocomplete#close_popup() : "\<C-r>"
inoremap <expr><C-e> pumvisible() ? neocomplete#cancel_popup() : "\<End>"

" <CR>: If popup menu visible, expand snippet or close popup with selection,
"       Otherwise, check if within empty pair and use delimitMate.
imap <expr><silent><CR> pumvisible() ?
	\ (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : neocomplete#close_popup())
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
		\ : (delimitMate#WithinEmptyPair() ? "\<Plug>delimitMateCR" : "\<CR>"))

" <Tab> completion:
" 1. If popup menu is visible, select and insert next item
" 2. Otherwise, if preceding chars are whitespace, insert tab char
" 3. Otherwise, if preceding word is a snippet, expand it
" 4. Otherwise, start manual autocomplete
imap <expr><silent><Tab> pumvisible() ? "\<Down>"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
	\ : neocomplete#start_manual_complete()))

smap <expr><Tab> pumvisible() ? "\<Down>"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
	\ : neocomplete#start_manual_complete()))

imap <expr><S-Tab> pumvisible() ? "\<Up>"
	\ : (<SID>is_whitespace() ? "\<BS>"
	\ : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
	\ : neocomplete#start_manual_complete()))

function! s:is_whitespace()
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~ '\s'
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
