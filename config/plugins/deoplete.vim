" deoplete for nvim
" ---

" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', 'deoplete.log')<CR>
" call deoplete#custom#source('tern', 'debug_enabled', 1)<CR>

" General settings " {{{
" ---

call deoplete#custom#option({
	\ 'auto_refresh_delay': 10,
	\ 'camel_case': v:true,
	\ 'skip_multibyte': v:true,
	\ 'prev_completion_mode': 'none',
	\ 'min_pattern_length': 1,
	\ 'max_list': 10000,
	\ 'skip_chars': ['(', ')', '<', '>'],
	\ })
	"\ 'prev_completion_mode': 'filter',

let g:deoplete#sources#jedi#statement_length = 30
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#short_types = 1

let g:deoplete#sources#ternjs#filetypes = [
	\ 'jsx',
	\ 'javascript.jsx',
	\ 'vue',
	\ 'javascript'
	\ ]

let g:deoplete#sources#ternjs#timeout = 3
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#docs = 1

" }}}
" Limit Sources " {{{
" ---

" let g:deoplete#sources = get(g:, 'deoplete#sources', {})
" let g:deoplete#sources.go = ['vim-go']
" let g:deoplete#sources.javascript = ['file', 'ternjs']
" let g:deoplete#sources.jsx = ['file', 'ternjs']

" let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
" let g:deoplete#ignore_sources.html = ['syntax']
" let g:deoplete#ignore_sources.python = ['syntax']
" let g:deoplete#ignore_sources.php = ['omni']

" call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

" }}}
" Omni functions and patterns " {{{
" ---
" let g:deoplete#omni#functions = get(g:, 'deoplete#omni#functions', {})
" let g:deoplete#omni#functions.css = 'csscomplete#CompleteCSS'
" let g:deoplete#omni#functions.html = 'htmlcomplete#CompleteTags'
" let g:deoplete#omni#functions.markdown = 'htmlcomplete#CompleteTags'
" let g:deoplete#omni#functions.javascript =
" 	\ [ 'tern#Complete', 'jspc#omni', 'javascriptcomplete#CompleteJS' ]

let g:deoplete#omni_patterns = get(g:, 'deoplete#omni_patterns', {})
call deoplete#custom#option('omni_patterns', {
\ 'complete_method': 'omnifunc',
\ 'terraform': '[^ *\t"{=$]\w*',
\})
" let g:deoplete#omni_patterns.terraform = '[^ *\t"{=$]\w*'
" let g:deoplete#omni_patterns.html = '<[^>]*'
" let g:deoplete#omni_patterns.javascript = '[^. *\t]\.\w*'
" let g:deoplete#omni_patterns.javascript = '[^. \t]\.\%\(\h\w*\)\?'
" let g:deoplete#omni_patterns.php =
" 	\ '\w+|[^. \t]->\w*|\w+::\w*'
	" \ '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

" let g:deoplete#omni#input_patterns = get(g:, 'deoplete#omni#input_patterns', {})
" let g:deoplete#omni#input_patterns.xml = '<[^>]*'
" let g:deoplete#omni#input_patterns.md = '<[^>]*'
" let g:deoplete#omni#input_patterns.css  = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
" let g:deoplete#omni#input_patterns.scss = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
" let g:deoplete#omni#input_patterns.sass = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
" let g:deoplete#omni#input_patterns.javascript = '[^. *\t]\.\w*'
" let g:deoplete#omni#input_patterns.python = ''
" let g:deoplete#omni#input_patterns.php = '\w+|[^. \t]->\w*|\w+::\w*'

" }}}
" Ranking and Marks " {{{
" Default rank is 100, higher is better.
call deoplete#custom#source('omni',          'mark', '<omni>')
call deoplete#custom#source('flow',          'mark', '<flow>')
call deoplete#custom#source('padawan',       'mark', '<php>')
call deoplete#custom#source('tern',          'mark', '<tern>')
call deoplete#custom#source('go',            'mark', '<go>')
call deoplete#custom#source('jedi',          'mark', '<jedi>')
call deoplete#custom#source('vim',           'mark', '<vim>')
call deoplete#custom#source('neosnippet',    'mark', '<snip>')
call deoplete#custom#source('tag',           'mark', '<tag>')
call deoplete#custom#source('around',        'mark', '<around>')
call deoplete#custom#source('buffer',        'mark', '<buf>')
call deoplete#custom#source('tmux-complete', 'mark', '<tmux>')
call deoplete#custom#source('syntax',        'mark', '<syntax>')
call deoplete#custom#source('member',        'mark', '<member>')

call deoplete#custom#source('padawan',       'rank', 660)
call deoplete#custom#source('go',            'rank', 650)
call deoplete#custom#source('vim',           'rank', 640)
call deoplete#custom#source('flow',          'rank', 630)
call deoplete#custom#source('TernJS',        'rank', 620)
call deoplete#custom#source('jedi',          'rank', 610)
call deoplete#custom#source('omni',          'rank', 600)
call deoplete#custom#source('neosnippet',    'rank', 510)
call deoplete#custom#source('member',        'rank', 500)
call deoplete#custom#source('file_include',  'rank', 420)
call deoplete#custom#source('file',          'rank', 410)
call deoplete#custom#source('tag',           'rank', 400)
call deoplete#custom#source('around',        'rank', 330)
call deoplete#custom#source('buffer',        'rank', 320)
call deoplete#custom#source('dictionary',    'rank', 310)
call deoplete#custom#source('tmux-complete', 'rank', 300)
call deoplete#custom#source('syntax',        'rank', 50)

" }}}
" Matchers and Converters " {{{
" ---

" Default sorters: ['sorter/rank']
" Default matchers: ['matcher/length', 'matcher/fuzzy']

call deoplete#custom#source('_', 'matchers',
	\ ['matcher_fuzzy', 'matcher_length'])

call deoplete#custom#source('_', 'converters', [
	\ 'converter_remove_paren',
	\ 'converter_remove_overlap',
	\ 'matcher_length',
	\ 'converter_truncate_abbr',
	\ 'converter_truncate_menu',
	\ 'converter_auto_delimiter',
	\ ])

" }}}
" Key-mappings and Events " {{{
" ---

autocmd MyAutoCmd CompleteDone * silent! pclose!

" Movement within 'ins-completion-menu'
imap <expr><C-j>   pumvisible() ? "\<Down>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<Up>" : "\<C-k>"

" Scroll pages in menu
inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
imap     <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>"
imap     <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"

" Undo completion
" inoremap <expr><C-g> deoplete#undo_completion()

" Redraw candidates
inoremap <expr><C-g> deoplete#refresh()
inoremap <expr><C-e> deoplete#cancel_popup()
inoremap <silent><expr><C-l> deoplete#complete_common_string()

" <CR>: If popup menu visible, expand snippet or close popup with selection,
"       Otherwise, check if within empty pair and use delimitMate.
inoremap <silent><expr><CR> pumvisible() ? deoplete#close_popup()
	\ : (delimitMate#WithinEmptyPair() ? "\<C-R>=delimitMate#ExpandReturn()\<CR>" : "\<CR>")

" <Tab> completion:
" 1. If popup menu is visible, select and insert next item
" 2. Otherwise, if within a snippet, jump to next input
" 3. Otherwise, if preceding chars are whitespace, insert tab char
" 4. Otherwise, start manual autocomplete
imap <silent><expr><Tab> pumvisible() ? "\<Down>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : deoplete#manual_complete()))

smap <silent><expr><Tab> pumvisible() ? "\<Down>"
	\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : deoplete#manual_complete()))

inoremap <expr><S-Tab>  pumvisible() ? "\<Up>" : "\<C-h>"

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~ '\s'
endfunction "}}}
" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
