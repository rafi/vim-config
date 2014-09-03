
" Unite
" -----
if ! has('lua')
	finish
endif

" General {{{1
let g:unite_kind_jump_list_after_jump_scroll = 50
let g:unite_kind_file_vertical_preview = 1

" The silver searcher adheres to .gitignore
let s:ag_opts = '-i --nocolor --nogroup --hidden '.
		\ '--ignore ".git" '.
		\ '--ignore "*.ttf" '.
		\ '--ignore "*.png" '.
		\ '--ignore "*.jpg" '.
		\ '--ignore "*.gif"'

" Sources {{{1

" Source: Recursive {{{2
let g:unite_source_rec_unit = 3000
let g:unite_source_rec_min_cache_files = 400
let g:unite_source_rec_max_cache_files = 23000

" file_rec/async: Use the_silver_searcher or ack
if executable('ag')
	let g:unite_source_rec_async_command = 'ag --follow '.s:ag_opts.' -g ""'
elseif executable('ack')
	let g:unite_source_rec_async_command = 'ack -f --nofilter'
endif

" Source: tag {{{2
let g:unite_source_tag_max_name_length = 50
let g:unite_source_tag_max_fname_length = 30

" Source: history/yank {{{2
let g:unite_source_history_yank_limit = 25

" Source: MRU {{{2
let g:neomru#file_mru_limit = 500
let g:neomru#directory_mru_limit = 15

" Source: Grep {{{2
let g:unite_source_grep_max_candidates = 200

" grep: Use the_silver_searcher or ack
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '--line-numbers '.s:ag_opts
	let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
	let g:unite_source_grep_command = 'ack'
	let g:unite_source_grep_default_opts = '-i --noheading --nocolor -k -H'
	let g:unite_source_grep_recursive_opt = ''
endif

" Contexts {{{1

" Global default context
call unite#custom#profile('default', 'context', {
	\   'start_insert': 1,
	\   'max_candidates': 0,
	\   'update_time': 500,
	\   'winheight': 35,
	\   'winwidth': 80,
	\   'direction': 'topleft',
	\   'no_auto_resize': 1,
	\   'prompt_direction': 'top',
	\   'cursor_line_highlight': 'CursorLine',
	\   'cursor_line_time': '0.0',
	\   'candidate_icon': '-',
	\   'marked_icon': '+',
	\   'prompt' : '▷ '
	\ })

" Conveniently set settings globally per-source
call unite#custom#profile(
	\  'source/history/yank,source/session,source/register',
	\  'context', { 'start_insert': 0 },
	\ )

call unite#custom#profile('source/source', 'context', {
	\   'vertical': 1,
	\   'direction': 'botright',
	\ })

call unite#custom#profile('source/tag,source/tag/include,source/mapping,source/output', 'context', {
	\   'silent': 1,
	\ })

call unite#custom#profile('completion', 'context', {
	\   'winheight': 25,
	\   'direction': 'botright',
	\   'prompt_direction': 'top',
	\   'no_here': 1
	\ })

call unite#custom#profile('source/quickfix,source/location_list', 'context', {
	\   'winheight': 13,
	\   'direction': 'botright',
	\   'start_insert': 0,
	\   'keep_focus': 1,
	\   'no_quit': 1,
	\ })

call unite#custom#profile('source/outline', 'context', {
	\   'vertical': 1,
	\   'direction': 'botright',
	\   'no_focus': 1,
	\   'start_insert': 0,
	\   'keep_focus': 1,
	\   'no_quit': 1,
	\ })

" General purpose profile for navigating and also for grep
call unite#custom#profile('navigate,source/grep', 'context', {
	\   'silent': 1,
	\   'auto_preview': 0,
	\   'start_insert': 0,
	\   'keep_focus': 1,
	\   'no_quit': 1,
	\ })

" Converters {{{1

" Source output converters
"call unite#custom#source('buffer', 'converters', [ 'converter_file_directory' ])
"call unite#custom_source('quickfix', 'converters', 'converter_quickfix_highlight')
"call unite#custom_source('location_list', 'converters', 'converter_quickfix_highlight')

" Filters {{{1

" Enable for fuzzy matching:
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"call unite#filters#sorter_default#use(['sorter_rank'])

"}}}
