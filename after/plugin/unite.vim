
" Unite
" -----
let g:unite_kind_jump_list_after_jump_scroll = 0
let g:unite_kind_file_vertical_preview = 1
let g:unite_source_rec_min_cache_files = 900
let g:unite_source_rec_max_cache_files = 10000
let g:unite_source_file_mru_long_limit = 1000
let g:unite_source_file_mru_limit = 500
let g:unite_source_directory_mru_long_limit = 1000
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup --column -S'
let g:unite_source_grep_recursive_opt = ''
let g:unite_source_tag_max_name_length = 50
let g:unite_source_tag_max_fname_length = 30
let g:unite_source_rec_async_command = 'ag --nogroup --nocolor --column --hidden ' .
   \ '--ignore ".git" ' .
   \ '--ignore ".idea" ' .
   \ '--ignore "vendor/" ' .
   \ '--ignore "cache/" ' .
   \ '--ignore "logs/" ' .
   \ '--ignore "templates/page/*/*.mustache" ' .
   \ '--ignore "*.ttf" ' .
   \ '--ignore "*.png" ' .
   \ '--ignore "*.jpg" ' .
   \ '--ignore "*.gif" -g ""'

" For unite-outline until it doesn't use these deprecated variables:
let g:unite_abbr_highlight = "Normal"

call unite#custom#profile('default', 'context', {
	\   'start_insert': 1,
	\   'max_candidates': 300,
	\   'update_time': 500,
	\   'winheight': 35,
	\   'winwidth': 35,
	\   'direction': 'topleft',
	\   'prompt_direction': 'top',
	\   'cursor_line_highlight': 'CursorLine',
	\   'cursor_line_time': '0.0',
	\   'candidate_icon': '-',
	\   'marked_icon': '+',
	\   'prompt' : '▷ '
	\ })

" For unite-quickfix, highlighting the type of error
call unite#custom_source('quickfix', 'converters', 'converter_quickfix_highlight')
call unite#custom_source('location_list', 'converters', 'converter_quickfix_highlight')

" Enable for fuzzy matching:
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"call unite#filters#sorter_default#use(['sorter_rank'])
