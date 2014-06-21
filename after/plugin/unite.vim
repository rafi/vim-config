
" Unite
" -----
let g:unite_kind_jump_list_after_jump_scroll=0
let g:unite_kind_file_vertical_preview=1
let g:unite_source_history_yank_enable=1
let g:unite_source_rec_min_cache_files=1000
let g:unite_source_rec_max_cache_files=5000
let g:unite_source_file_mru_long_limit = 6000
let g:unite_source_file_mru_limit = 500
let g:unite_source_directory_mru_long_limit = 6000
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup --column'
let g:unite_source_grep_recursive_opt = ''
" For unite-outline until it doesn't use this deprecated variable:
let g:unite_data_directory="~/.cache/unite"
let g:unite_abbr_highlight = "Normal"

call unite#custom#profile('default', 'context', {
	\   'update_time': 5,
	\   'cursor_line_time': 1,
	\   'winheight': 15,
	\   'winwidth': 25,
	\   'direction': 'botright',
	\   'cursor_line_highlight': 'CursorLine',
	\   'candidate_icon': '-',
	\   'marked_icon': '+',
	\   'prompt' : '» '
	\ })
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#profile('files', 'filters', 'sorter_rank')
call unite#custom#alias('directory', 'tabopen', 'tabvimfiler')
call unite#custom#source(
	\ 'file_rec,file_rec/async,file_rec/git,file_mru,file,buffer,grep',
	\ 'ignore_pattern', join([
	\ 'tags', '\.swp', '\.swo', '\~$',
	\ '\.git/', '\.svn/', '\.hg/',
	\ '\.ropeproject/',
	\ 'node_modules/', 'vendor/', 'log/', 'logs/', 'cache/', 'tmp/', 'obj/',
	\ '/vendor/gems/', '/vendor/cache/', '\.bundle/', '\.sass-cache/',
	\ '/tmp/cache/assets/.*/sprockets/', '/tmp/cache/assets/.*/sass/',
	\ '\.pyc$', '\.class$', '\.jar$',
	\ '\.jpg$', '\.jpeg$', '\.bmp$', '\.png$', '\.gif$',
	\ '\.o$', '\.out$', '\.obj$', '\.rbc$', '\.rbo$', '\.gem$',
	\ '\.zip$', '\.tar\.gz$', '\.tar\.bz2$', '\.rar$', '\.tar\.xz$',
	\ '\.doc$', '\.docx$',
	\ 'target/',
	\ ], '\|'))

autocmd FileType unite call s:unite_settings()

function! s:unite_settings()
	imap <silent><buffer> <C-j> <Plug>(unite_select_next_line)
	imap <silent><buffer> <C-k> <Plug>(unite_select_previous_line)
	nmap <silent><buffer><expr> <C-v> unite#do_action('split')
	nmap <silent><buffer><expr> <C-s> unite#do_action('vsplit')
	nmap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
	nmap <buffer> <ESC> <Plug>(unite_exit)
	imap <buffer>  jj   <Plug>(unite_insert_leave)

	let unite = unite#get_current_unite()
	if unite.profile_name ==# '^search'
		nnoremap <silent><buffer><expr> r unite#do_action('replace')
	else
		nnoremap <silent><buffer><expr> r unite#do_action('rename')
	endif
endfunction
