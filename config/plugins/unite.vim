
" Unite
" -----

" External Tools {{{
"
" The silver searcher. Disable .gitignore usage and search everything.
" Smart case, ignore vcs ignore files, search hidden, and plain format.
let s:ag_opts = [
	\ '--vimgrep', '--smart-case', '--skip-vcs-ignores', '--hidden',
	\ '--ignore', '.git', '--ignore', '.idea',
	\ '--ignore', 'bower_modules', '--ignore', 'node_modules'
	\ ]

" General {{{
let g:unite_kind_jump_list_after_jump_scroll = 50
let g:unite_enable_auto_select = 1

" }}}
" Sources {{{

" Source: rec(ursive) {{{
let g:unite_source_rec_unit = 3000
let g:unite_source_rec_min_cache_files = 400
let g:unite_source_rec_max_cache_files = 23000

" file_rec/async: Use the_silver_searcher or ack
if executable('ag')
	let g:unite_source_rec_async_command =
		\ [ 'ag', '--follow', '-g', '' ] + s:ag_opts
elseif executable('ack')
	let g:unite_source_rec_async_command = [ 'ack', '-f', '--nofilter' ]
endif

" }}}
" Source: tag {{{
let g:unite_source_tag_max_name_length = 50
let g:unite_source_tag_max_fname_length = 30

" }}}
" Source: history/yank {{{
let g:unite_source_history_yank_limit = 25

" }}}
" Source: mru {{{
let g:neomru#file_mru_limit = 500
let g:neomru#directory_mru_limit = 15

" }}}
" Source: grep {{{
let g:unite_source_grep_max_candidates = 400

" Use the_silver_searcher or ack or default grep
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = join(s:ag_opts)
	let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
	let g:unite_source_grep_command = 'ack'
	let g:unite_source_grep_default_opts = '-i --noheading --nocolor -k -H'
	let g:unite_source_grep_recursive_opt = ''
endif

" }}}
"}}}
" Contexts {{{

" Global default context
call unite#custom#profile('default', 'context', {
	\   'safe': 0,
	\   'start_insert': 1,
	\   'short_source_names': 1,
	\   'update_time': 500,
	\   'direction': 'topleft',
	\   'winwidth': 40,
	\   'winheight': 13,
	\   'no_auto_resize': 1,
	\   'vertical_preview': 1,
	\   'cursor_line_time': '0.10',
	\   'hide_icon': 0,
	\   'candidate-icon': ' ',
	\   'marked_icon': '✓',
	\   'prompt' : '⮀ '
	\ })

" Conveniently set settings globally per-source

call unite#custom#profile('register', 'context', {
	\ 'start_insert': 0,
	\ 'default_action': 'append'
	\ })

call unite#custom#profile('source/session', 'context', {
	\   'start_insert': 0,
	\   'winheight': 8
	\ })

call unite#custom#profile('source/source', 'context', {
	\   'vertical': 1,
	\   'winwidth': 80,
	\   'prompt_direction': 'top',
	\   'direction': 'botright',
	\ })

call unite#custom#profile('completion', 'context', {
	\   'winheight': 25,
	\   'prompt_direction': 'top',
	\   'direction': 'botright',
	\   'no_here': 1
	\ })

call unite#custom#profile('mpc', 'context', {
	\   'start_insert': 0,
	\   'quit': 1,
	\   'keep_focus': 1,
	\   'winheight': 20,
	\ })

call unite#custom#profile('source/outline', 'context', {
	\   'vertical': 1,
	\   'direction': 'botright',
	\   'prompt_direction': 'top',
	\   'start_insert': 0,
	\   'no_quit': 1,
	\   'auto_highlight': 0,
	\ })

call unite#custom#profile('location', 'context', {
	\   'no_quit': 1,
	\   'keep_focus': 1,
	\   'direction': 'botright',
	\   'prompt_direction': 'top',
	\ })

" General purpose profile for navigating and also for grep
call unite#custom#profile('navigate,source/grep', 'context', {
	\   'silent': 1,
	\   'start_insert': 0,
	\   'winheight': 20,
	\   'no_quit': 1,
	\   'keep_focus': 1,
	\   'direction': 'botright',
	\   'prompt_direction': 'top',
	\ })
" }}}
" Filters {{{
"call unite#custom#source(
"      \ 'buffer,file_rec,file_rec/async,file_rec/git', 'matchers',
"      \ ['converter_relative_word', 'matcher_fuzzy',
"      \  'matcher_project_ignore_files'])
"call unite#custom#source(
"      \ 'file_mru', 'matchers',
"      \ ['matcher_project_files', 'matcher_fuzzy',
"      \  'matcher_hide_hidden_files', 'matcher_hide_current_file'])
" call unite#custom#source(
"       \ 'file', 'matchers',
"       \ ['matcher_fuzzy', 'matcher_hide_hidden_files'])
"
call unite#custom#source(
  \ 'buffer,file_rec,file_rec/async,file_rec/git,neomru/file',
	\ 'matchers',
  \ ['converter_relative_word', 'matcher_fuzzy'])

call unite#custom#source(
  \ 'file_rec,file_rec/async,file_rec/git,file_mru,neomru/file',
	\ 'converters',
  \ ['converter_file_directory'])

call unite#filters#sorter_default#use(['sorter_rank'])
"call unite#filters#sorter_default#use(['sorter_length'])
"call unite#custom#source('tag', 'sorters', ['sorter_rank'])
" }}}

" vim: set ts=2 sw=2 tw=80 noet :
