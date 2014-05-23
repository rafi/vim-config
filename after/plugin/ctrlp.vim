
" CtrlP
" -----
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'    " search anything by default (files, buffers, MRU)
let g:ctrlp_max_height = 20       " maxiumum height of match window
let g:ctrlp_switch_buffer = 'Et'
let g:ctrlp_mruf_max=50           " number of recently opened files
let g:ctrlp_max_files=0           " do not limit the number of files to scan
let g:ctrlp_max_history = 20
let g:ctrlp_lazy_update = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)\/|node_modules|vendor\/bundle$'
let g:ctrlp_buftag_types = {
	\ 'go':       '--language-force=go --golang-types=ftv',
	\ 'coffee':   '--language-force=coffee --coffee-types=cmfvf',
	\ 'markdown': '--language-force=markdown --markdown-types=hik'
	\ }
