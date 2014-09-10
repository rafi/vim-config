
" Plugin Settings {{{1
"------------------------------------------------------------------------------

if neobundle#tap('unite.vim') "{{{
	let g:unite_source_history_yank_enable = 1
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/unite.vim'
	call neobundle#untap()
endif "}}}

if neobundle#tap('vimfiler.vim') "{{{
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/vimfiler.vim'
	call neobundle#untap()
endif "}}}

if neobundle#tap('neocomplete') "{{{
	let g:neocomplete#enable_at_startup = 1
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/neocomplete.vim'
	call neobundle#untap()
endif "}}}

if neobundle#tap('neosnippet.vim') "{{{
	let g:neosnippet#enable_snipmate_compatibility = 0
	let g:neosnippet#disable_runtime_snippets = { '_': 1 }
	call neobundle#untap()
endif "}}}

if neobundle#tap('echodoc.vim') "{{{
	let g:echodoc_enable_at_startup = 1
	call neobundle#untap()
endif "}}}

if neobundle#tap('vinarise.vim') "{{{
	let g:vinarise_enable_auto_detect = 1
	call neobundle#untap()
endif "}}}

if neobundle#tap('vim-bookmarks') "{{{
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/bookmarks.vim'
	call neobundle#untap()
endif "}}}

if neobundle#tap('vim-choosewin') "{{{
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/choosewin.vim'
	call neobundle#untap()
endif "}}}

if neobundle#tap('phpcomplete.vim') "{{{
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/phpcomplete.vim'
	call neobundle#untap()
endif "}}}

if neobundle#tap('phpfolding.vim') "{{{
	let g:DisableAutoPHPFolding = 1  " Do not fold automatically
	call neobundle#untap()
endif "}}}

if neobundle#tap('signify') "{{{
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/signify.vim'
	call neobundle#untap()
endif "}}}

if neobundle#tap('syntastic') "{{{
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_error_symbol = '⚠'
	let g:syntastic_warning_symbol = ''
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/syntastic.vim'
	call neobundle#untap()
endif "}}}

if neobundle#tap('tagbar') "{{{
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/tagbar.vim'
	call neobundle#untap()
endif "}}}

if neobundle#tap('vim-go') "{{{
	" vim-go, do not mess with my neosnippet config!
	let g:go_loaded_gosnippets = 1
	let g:go_snippet_engine = "neosnippet"
	call neobundle#untap()
endif "}}}

if neobundle#tap('delimitMate') "{{{
	let delimitMate_expand_cr = 1
	call neobundle#untap()
endif "}}}

if neobundle#tap('vim-markdown') "{{{
	let g:vim_markdown_initial_foldlevel = 5  " Don't start all folded
	call neobundle#untap()
endif "}}}

if neobundle#tap('gitv') "{{{
	let g:Gitv_DoNotMapCtrlKey = 1  " Do not map ctrl keys
	call neobundle#untap()
endif "}}}

if neobundle#tap('emmet-vim') "{{{
	let g:use_emmet_complete_tag = 1
	let g:user_emmet_leader_key = '<C-z>'
	let g:user_emmet_mode = 'i'
	let g:user_emmet_install_global = 0
	call neobundle#untap()
endif "}}}
