" deoplete
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

" Deoplete Jedi (python) settings
let g:deoplete#sources#jedi#statement_length = 30
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#short_types = 1

" Deoplete TernJS settings
let g:deoplete#sources#ternjs#filetypes = [
	\ 'jsx',
	\ 'javascript',
	\ 'javascript.jsx',
	\ 'vue',
	\ ]

let g:deoplete#sources#ternjs#timeout = 3
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#docs = 1

" }}}
" Limit Sources " {{{
" ---

" }}}
" Omni functions and patterns " {{{
" ---
if ! exists('g:context_filetype#same_filetypes')
	let g:context_filetype#filetypes = {}
endif

let g:context_filetype#filetypes.svelte = [
	\   { 'filetype': 'css', 'start': '<style>', 'end': '</style>' },
	\ ]

call deoplete#custom#var('omni', 'functions', {
	\   'css': [ 'csscomplete#CompleteCSS' ]
	\ })

call deoplete#custom#option('omni_patterns', {
	\ 'go': '[^. *\t]\.\w*',
	\})

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
	\ [ 'matcher_fuzzy', 'matcher_length' ])

call deoplete#custom#source('denite', 'matchers',
	\ ['matcher_full_fuzzy', 'matcher_length'])

call deoplete#custom#source('_', 'converters', [
	\   'converter_remove_overlap',
	\   'matcher_length',
	\   'converter_truncate_abbr',
	\   'converter_truncate_menu',
	\ ])

call deoplete#custom#source('denite', 'matchers',
	\ ['matcher_full_fuzzy', 'matcher_length'])

" }}}
" Key-mappings and Events " {{{
" ---
augroup user_plugin_deoplete
	autocmd!
	autocmd CompleteDone * silent! pclose!
augroup END

" Close popup first, if Escape is pressed
" imap <expr><Esc> pumvisible() ? deoplete#close_popup() : "\<Esc>"

" Movement within 'ins-completion-menu'
imap <expr><C-j>   pumvisible() ? "\<Down>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<Up>" : "\<C-k>"

" Scroll pages in completion-menu
inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
imap     <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>"
imap     <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"

" Redraw candidates
inoremap <expr><C-g> deoplete#undo_completion()
" inoremap <expr><C-g> deoplete#manual_complete()
inoremap <expr><C-e> deoplete#cancel_popup()
inoremap <silent><expr><C-l> deoplete#complete_common_string()

" <CR>: If popup menu visible, close popup with selection.
"       Otherwise, check if within empty pair and use delimitMate.
inoremap <silent><expr><CR> pumvisible() ? deoplete#close_popup()
	\ : (get(b:, 'delimitMate_enabled') && delimitMate#WithinEmptyPair() ?
	\   "\<C-R>=delimitMate#ExpandReturn()\<CR>" : "\<CR>")

" <Tab> completion:
" 1. If popup menu is visible, select and insert next item
" 2. Otherwise, if within a snippet, jump to next input
" 3. Otherwise, if preceding chars are whitespace, insert tab char
" 4. Otherwise, start manual autocomplete
imap <silent><expr><Tab>
	\ neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : (pumvisible() ? "\<Down>"
	\ : deoplete#manual_complete()))

smap <silent><expr><Tab>
	\ neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
	\ : (pumvisible() ? "\<Down>"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : deoplete#manual_complete()))

inoremap <expr><S-Tab>
	\ <SID>is_whitespace() ? "\<C-h>"
	\ : pumvisible() ? "\<Up>" : "\<C-h>"

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~# '\s'
endfunction "}}}
" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
