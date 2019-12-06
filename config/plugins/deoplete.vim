" :h deoplete
" ---
" Problems? https://github.com/Shougo/deoplete.nvim/issues

" For debugging:
" call deoplete#custom#option('profile', v:true)
" call deoplete#enable_logging('DEBUG', 'deoplete.log')<CR>
" call deoplete#custom#source('tern', 'debug_enabled', 1)<CR>

" General settings " {{{
" ---
call deoplete#custom#option({
	\ 'max_list': 10000,
	\ 'min_pattern_length': 1,
	\ 'auto_preview': v:true,
	\ 'smart_case': v:true,
	\ 'skip_multibyte': v:true,
	\ 'skip_chars': ['(', ')', '<', '>'],
	\ })

" Deoplete Jedi (python) settings
let g:deoplete#sources#jedi#statement_length = 30
let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#short_types = 1

" Deoplete TernJS settings
let g:deoplete#sources#ternjs#filetypes = [
	\ 'jsx',
	\ 'javascript',
	\ 'javascriptreact',
	\ 'vue',
	\ ]

let g:deoplete#sources#ternjs#timeout = 3
let g:deoplete#sources#ternjs#types = 1
let g:deoplete#sources#ternjs#docs = 1

" }}}
" Limit Sources " {{{
" ---
let g:deoplete#sources = get(g:, 'deoplete#sources', {})
let g:deoplete#sources['denite-filter'] = ['denite']

" }}}
" Omni functions and patterns " {{{
" ---
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

" call deoplete#custom#source('_', 'converters', [
"	\   'converter_remove_overlap',
"	\   'matcher_length',
"	\   'converter_truncate_abbr',
"	\   'converter_truncate_info',
"	\   'converter_truncate_menu',
"	\ ])

call deoplete#custom#source('denite', 'matchers',
	\ ['matcher_full_fuzzy', 'matcher_length'])

" }}}
" Key-mappings and Events " {{{
" ---
augroup user_plugin_deoplete
	autocmd!
	autocmd CompleteDone * silent! pclose!
augroup END

" Close popup first, if Escape is pressed, and don't leave insert mode
" inoremap <expr><Esc> pumvisible() ? deoplete#close_popup() : "\<Esc>"

" Movement within 'ins-completion-menu'
inoremap <expr><C-j>   pumvisible() ? "\<Down>" : "\<C-j>"
inoremap <expr><C-k>   pumvisible() ? "\<Up>" : "\<C-k>"

" Scroll pages in completion-menu
inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
inoremap <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>"
inoremap <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"

" Redraw candidates
inoremap <expr><C-g> deoplete#undo_completion()
inoremap <expr><C-e> deoplete#cancel_popup()
inoremap <silent><expr><C-l> deoplete#complete_common_string()

" <CR>: If popup menu visible, close popup with selection. But insert CR
"       if no selection has been made. If no popup visible, check if cursor
"       within empty pair and use delimitMate (If available).
inoremap <silent><expr><CR> <SID>smart_carriage_return()

function s:smart_carriage_return()
	if pumvisible()
		call deoplete#handler#_skip_next_completion()
		if get(complete_info(), 'selected', -1) == -1
			" Close pum and insert new-line
			return "\<C-y>\<CR>"
		endif
		" Insert selected completion
		return "\<C-y>"
	endif

	if get(b:, 'delimitMate_enabled') && delimitMate#WithinEmptyPair()
		return "\<C-R>=delimitMate#ExpandReturn()\<CR>"
	endif
	return "\<CR>"
endfunction

" <Tab> completion:
" 1. If popup menu is visible, select and insert next item
" 2. Otherwise, if within a snippet, jump to next input
" 3. Otherwise, if preceding chars are whitespace, insert tab char
" 4. Otherwise, open completion pop-up
imap <silent><expr><Tab>     <SID>smart_complete()
smap <silent><expr><Tab>     <SID>smart_complete()
imap <silent><expr><C-Space> <SID>smart_complete()
smap <silent><expr><C-Space> <SID>smart_complete()

function! s:smart_complete()
	return pumvisible() ? "\<Down>"
		\ : (neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)"
		\ : (<SID>is_whitespace() ? "\<Tab>"
		\ : deoplete#manual_complete()))
endfunction

inoremap <expr><S-Tab>
	\ <SID>is_whitespace() ? "\<C-h>"
	\ : pumvisible() ? "\<Up>" : "\<C-h>"

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~# '\s'
endfunction "}}}
" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
