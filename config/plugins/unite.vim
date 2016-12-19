
" Unite
" -----

" General {{{
let g:unite_enable_auto_select = 1
let g:unite_restore_alternate_file = 1
let g:unite_matcher_fuzzy_max_input_length = 25
let g:unite_kind_jump_list_after_jump_scroll = 50

call unite#filters#sorter_default#use(['sorter_rank'])

" }}}
" Source: rec(ursive) {{{
let g:unite_source_rec_unit = 3000
let g:unite_source_rec_min_cache_files = 200
let g:unite_source_rec_max_cache_files = 25000

" file_rec/async: Use the_silver_searcher or ack
if executable('ag')
	let g:unite_source_rec_async_command =
		\ [ 'ag', '--vimgrep', '--smart-case', '--hidden', '--follow', '-g', '' ]
elseif executable('ack')
	let g:unite_source_rec_async_command = [ 'ack', '-f', '--nofilter' ]
endif

" }}}
" Source: tag {{{
let g:unite_source_tag_max_kind_length = 4
let g:unite_source_tag_max_name_length = 30
let g:unite_source_tag_name_footer_length = 20
let g:unite_source_tag_max_fname_length = 35
let g:unite_source_tag_fname_footer_length = 25

" }}}
" Source: grep {{{
" Use the_silver_searcher or ack or default grep
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '--vimgrep --smart-case --hidden'
	let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
	let g:unite_source_grep_command = 'ack'
	let g:unite_source_grep_default_opts = '-i --noheading --nocolor -k -H'
	let g:unite_source_grep_recursive_opt = ''
endif

" }}}
" Contexts {{{

" Global default context

call unite#custom#profile('default', 'context', {
	\   'safe': 0,
	\   'start_insert': 1,
	\   'short_source_names': 1,
	\   'prompt_direction': 'top',
	\   'direction': 'botright',
	\   'winwidth': 40,
	\   'winheight': 15,
	\   'update_time': 500,
	\   'cursor_line_time': '0.10',
	\   'max_candidates': 100,
	\   'no_auto_resize': 1,
	\   'vertical_preview': 1,
	\   'hide_icon': 0,
	\   'candidate-icon': ' ',
	\   'marked_icon': '✓',
	\   'prompt' : 'λ: ',
	\ })

" Conveniently set settings globally per-source

call unite#custom#profile('source/source', 'context', {
	\   'vertical': 1,
	\ })

call unite#custom#profile('completion', 'context', {
	\   'winheight': 25,
	\   'no_here': 1
	\ })

" }}}
" vim: set ts=2 sw=2 tw=80 noet :
