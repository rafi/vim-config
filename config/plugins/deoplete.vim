" deoplete for nvim
" ---

" General settings " {{{
" ---
autocmd MyAutoCmd CompleteDone * pclose!

" let g:deoplete#auto_complete_delay = 200
" let g:deoplete#auto_refresh_delay = 200
let g:deoplete#enable_refresh_always = 0
let g:deoplete#enable_camel_case = 1
let g:deoplete#max_abbr_width = 35
let g:deoplete#max_menu_width = 20
let g:deoplete#skip_chars = ['(', ')', '<', '>']
let g:deoplete#tag#cache_limit_size = 800000
let g:deoplete#file#enable_buffer_path = 1

call deoplete#custom#set('_', 'min_pattern_length', 1)
" call deoplete#custom#set('_', 'disabled_syntaxes', ['Comment', 'String'])

let g:deoplete#sources = get(g:, 'deoplete#sources', {})
let g:deoplete#sources.go = ['vim-go']
" let g:deoplete#sources.javascript = ['file', 'ternjs']
" let g:deoplete#sources.jsx = ['file', 'ternjs']

let g:deoplete#sources#jedi#statement_length = 1
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#short_types = 1

let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
" let g:deoplete#ignore_sources.html = ['syntax']
let g:deoplete#ignore_sources.python = ['syntax']

let g:deoplete#member#prefix_patterns = get(g:, 'deoplete#member#prefix_patterns', {})
let g:deoplete#member#prefix_patterns.javascript = ['\.']

" let g:deoplete#keyword_patterns = {}
" let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'

" }}}
" Omni functions and patterns " {{{
" ---
let g:deoplete#omni#functions = get(g:, 'deoplete#omni#functions', {})
let g:deoplete#omni#functions.php = 'phpcomplete_extended#CompletePHP'
let g:deoplete#omni#functions.css = 'csscomplete#CompleteCSS'
let g:deoplete#omni#functions.html = 'htmlcomplete#CompleteTags'
let g:deoplete#omni#functions.markdown = 'htmlcomplete#CompleteTags'
" let g:deoplete#omni#functions.javascript =
"	\ [ 'jspc#omni', 'javascriptcomplete#CompleteJS' ]

let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})
let g:deoplete#omni_patterns.html = '<[^>]*'
" let g:deoplete#omni_patterns.javascript = '[^. *\t]\.\w*'
" let g:deoplete#omni_patterns.javascript = '[^. \t]\.\%\(\h\w*\)\?'
" let g:deoplete#omni_patterns.php =
"	\ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

let g:deoplete#omni#input_patterns = get(g:, 'deoplete#omni#input_patterns', {})
let g:deoplete#omni#input_patterns.xml = '<[^>]*'
let g:deoplete#omni#input_patterns.md = '<[^>]*'
let g:deoplete#omni#input_patterns.css  = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni#input_patterns.scss = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni#input_patterns.sass = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni#input_patterns.python = ''
let g:deoplete#omni#input_patterns.javascript = ''
let g:deoplete#omni#input_patterns.php = '\w+|[^. \t]->\w*|\w+::\w*'

" }}}
" Ranking and Marks " {{{
" Default rank is 100, higher is better.
call deoplete#custom#set('buffer',        'mark', 'ℬ')
call deoplete#custom#set('tag',           'mark', '⌦')
call deoplete#custom#set('omni',          'mark', '⌾')
call deoplete#custom#set('ternjs',        'mark', '⌁')
call deoplete#custom#set('jedi',          'mark', '⌁')
call deoplete#custom#set('neosnippet',    'mark', '⌘')
call deoplete#custom#set('around',        'mark', '⮀')
call deoplete#custom#set('syntax',        'mark', '♯')
call deoplete#custom#set('tmux-complete', 'mark', '⊶')

call deoplete#custom#set('jedi',          'rank', 610)
call deoplete#custom#set('omni',          'rank', 600)
call deoplete#custom#set('neosnippet',    'rank', 520)
call deoplete#custom#set('vim',           'rank', 510)
call deoplete#custom#set('member',        'rank', 500)
call deoplete#custom#set('file_include',  'rank', 420)
call deoplete#custom#set('file',          'rank', 410)
call deoplete#custom#set('tag',           'rank', 400)
call deoplete#custom#set('around',        'rank', 330)
call deoplete#custom#set('buffer',        'rank', 320)
call deoplete#custom#set('dictionary',    'rank', 310)
call deoplete#custom#set('tmux-complete', 'rank', 300)
call deoplete#custom#set('syntax',        'rank', 200)

" }}}
" Matchers and Converters " {{{
" ---

" Default sorters: ['sorter_rank']
" Default matchers: ['matcher_length', 'matcher_fuzzy']

call deoplete#custom#set('_', 'converters', [
	\ 'converter_remove_paren',
	\ 'converter_remove_overlap',
	\ 'converter_truncate_abbr',
	\ 'converter_truncate_menu',
	\ 'converter_auto_delimiter',
	\ ])

" }}}
" Key-mappings " {{{
" ---

" Movement within 'ins-completion-menu'
imap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"

" Scroll pages in menu
inoremap <expr><C-f> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<Right>"
inoremap <expr><C-b> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<Left>"
imap     <expr><C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
imap     <expr><C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

" Undo completion
inoremap <expr><C-g> deoplete#undo_completion()

" Redraw candidates
inoremap <expr><C-l> deoplete#refresh()

" <C-h>, <BS>: close popup and delete backword char.
"inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
"inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"

" <CR>: If popup menu visible, expand snippet or close popup with selection,
"       Otherwise, check if within empty pair and use delimitMate.
imap <silent><expr><CR> pumvisible() ?
	\ (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : deoplete#close_popup())
		\ : (delimitMate#WithinEmptyPair() ? "\<Plug>delimitMateCR" : "\<CR>")

" <Tab> completion:
" 1. If popup menu is visible, select and insert next item
" 2. Otherwise, if within a snippet, jump to next input
" 3. Otherwise, if preceding chars are whitespace, insert tab char
" 4. Otherwise, start manual autocomplete
imap <silent><expr><Tab> pumvisible() ? "\<C-n>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : deoplete#manual_complete()))

smap <silent><expr><Tab> pumvisible() ? "\<C-n>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : deoplete#manual_complete()))

inoremap <expr><S-Tab>  pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~? '\s'
endfunction "}}}
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
