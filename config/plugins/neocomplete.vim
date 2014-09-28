
" neocomplete
" -----------

let g:neocomplete#max_list = 30
let g:neocomplete#disable_auto_complete = 0
let g:neocomplete#force_overwrite_completefunc = 0

" Use CursorHoldI to delay popup by miliseconds
"let g:neocomplete#enable_cursor_hold_i = 1
"let g:neocomplete#cursor_hold_i_time   = 200

" Smart case and no fuzziness, disabling heavy operations
let g:neocomplete#enable_smart_case       = 1
let g:neocomplete#enable_camel_case       = 1
let g:neocomplete#enable_fuzzy_completion = 0
let g:neocomplete#enable_refresh_always   = 0
let g:neocomplete#enable_prefetch         = 1

" Minimum char completion lengths
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#auto_completion_start_length      = 2
let g:neocomplete#manual_completion_start_length    = 2
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

" Mappings {{{1
" --------

let g:neocomplete#fallback_mappings = ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]

" Movement within 'ins-completion-menu'
inoremap <expr><C-j>   "\<Down>"
inoremap <expr><C-k>   "\<Up>"
inoremap <expr><C-f>   pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b>   pumvisible() ? "\<PageUp>" : "\<Left>"
imap <expr><S-Tab> pumvisible() ? "\<C-p>"
	\ : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
	\ : "\<S-Tab>")

" <BS>: Close popup and delete preceding char
inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
" <C-y>, <C-e>: Close popup, close popup and cancel selection
inoremap <expr><C-y> pumvisible() ? neocomplete#close_popup() : "\<C-r>"
inoremap <expr><C-e> pumvisible() ? neocomplete#cancel_popup() : "\<End>"
" <C-h>, <C-l>: Undo completion, complete common characters
inoremap <expr><C-h> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

" <CR>: If popup menu visible, expand snippet or close popup with selection.
imap <expr><silent><CR> pumvisible() ?
	\ (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : neocomplete#close_popup())
	\ : "\<CR>"

" <C+Space> unite completion
" How weird is that <C-Space> in some(?) terminals is <Nul>?!
imap <Nul>  <Plug>(neocomplete_start_unite_complete)

" <Tab> completion:
" 1. If popup menu is visible, select and insert next item
" 2. Otherwise, if preceding chars are whitespace, insert tab char
" 3. Otherwise, if preceding word is a snippet, expand it
" 4. Otherwise, start manual autocomplete
imap <expr><Tab> pumvisible() ? "\<C-n>"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
	\ : neocomplete#start_manual_complete()))

smap <expr><Tab> pumvisible() ? "\<C-n>"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : (neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)"
	\ : neocomplete#start_manual_complete()))

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}

" TODO: Not working
"imap     <expr><C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
"inoremap <expr><C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
"imap     <expr><C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
"inoremap <expr><C-x><C-f> neocomplete#start_manual_complete('file')

"}}}
