
" Plugin Settings
"---------------------------------------------------------

if neobundle#tap('unite.vim') "{{{
	let g:unite_data_directory = $VARPATH."/unite"
	let g:unite_source_history_yank_enable = 1
	nnoremap [unite]  <Nop>
	xnoremap [unite]  <Nop>
	nmap     f [unite]
	xmap     f [unite]
	nnoremap <silent> [unite]r   :<C-u>UniteResume -no-start-insert -force-redraw<CR>
	nnoremap <silent> [unite]f   :<C-u>Unite file_rec/async<CR>
	nnoremap <silent> [unite]i   :<C-u>Unite file_rec/git<CR>
	nnoremap <silent> [unite]g   :<C-u>Unite grep:. -no-wrap<CR>
	nnoremap <silent> [unite]u   :<C-u>Unite source<CR>
	nnoremap <silent> [unite]t   :<C-u>Unite tag -silent<CR>
	nnoremap <silent> [unite]T   :<C-u>Unite tag/include -silent<CR>
	nnoremap <silent> [unite]l   :<C-u>Unite location_list<CR>
	nnoremap <silent> [unite]q   :<C-u>Unite quickfix<CR>
	nnoremap <silent> [unite]j   :<C-u>Unite change jump -profile-name=navigate<CR>
	nnoremap <silent> [unite]h   :<C-u>Unite -buffer-name=register -default-action=append register history/yank<CR>
	nnoremap <silent> [unite]s   :<C-u>Unite session<CR>
	nnoremap <silent> [unite]o   :<C-u>Unite outline<CR>
	nnoremap <silent> [unite]ma  :<C-u>Unite mapping -silent<CR>
	nnoremap <silent> [unite]me  :<C-u>Unite output:message -silent<CR>
	nnoremap <silent> <Leader>b  :<C-u>Unite buffer file_mru bookmark<CR>
	nnoremap <silent> <Leader>ta :<C-u>Unite tab<CR>
	" Open Unite with word under cursor or selection
	nnoremap <silent> <Leader>gf :UniteWithCursorWord file_rec/async -profile-name=navigate<CR>
	nnoremap <silent> <Leader>gg :UniteWithCursorWord grep:. -profile-name=navigate<CR>
	nnoremap <silent> <Leader>gt :UniteWithCursorWord tag -profile-name=navigate<CR>
	vnoremap <silent> <Leader>gt :<C-u>call VSetSearch('/')<CR>:execute 'Unite tag -profile-name=navigate -input='.strpart(@/,2)<CR>
	vnoremap <silent> <Leader>gg :<C-u>call VSetSearch('/')<CR>:execute 'Unite grep:. -profile-name=navigate -input='.strpart(@/,2)<CR>
	nnoremap <silent> [unite]k
		\ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique -silent
		\ jump_point file_point file_mru
		\ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec/async'`
		\ buffer_tab:- file file/new<CR>
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/unite.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vimfiler.vim') "{{{
	noremap <silent> <Leader>f :<C-u> execute 'VimFiler -explorer -winwidth=25 -split -toggle -buffer-name='.t:project_name<CR>
	" Open VimFiler with current file selected
	nnoremap <silent> fa  :<C-u>execute 'VimFiler -explorer -find -winwidth=25 -split -toggle -no-quit -buffer-name='.t:project_name<CR>
	let g:vimfiler_data_directory = $VARPATH.'/vimfiler'
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/vimfiler.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('deoplete.nvim') && has('nvim') "{{{
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/deoplete.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('neocomplete') && has('lua') "{{{
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#data_directory = $VARPATH.'/complete'
	let neobundle#hooks.on_source    = $VIMPATH.'/config/plugins/neocomplete.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('neosnippet.vim') "{{{
	let g:neosnippet#enable_snipmate_compatibility = 0
	let g:neosnippet#enable_preview = 1
	let g:neosnippet#disable_runtime_snippets = { '_': 1 }
	let g:neosnippet#data_directory  = $VARPATH.'/snippet'
	let g:neosnippet#snippets_directory =
				\$VIMPATH.'/snippets/rafi,'
				\.$VARPATH.'/plugins/neosnippet-snippets/neosnippets,'
				\.$VARPATH.'/plugins/mpvim/snippets,'
				\.$VARPATH.'/plugins/vim-ansible-yaml/snippets,'
				\.$VARPATH.'/plugins/vim-go/gosnippets/snippets'

	imap <expr><C-o> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"

	call neobundle#untap()
endif

"}}}
if neobundle#tap('neomru.vim') "{{{
	let g:neomru#file_mru_path = $VARPATH.'/unite/mru/file'
	let g:neomru#directory_mru_path  = $VARPATH.'/unite/mru/directory'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-winfix') "{{{
	let g:winfix_enable = 1
	let g:winfix_tabfocus = 1
	let g:winfix_resize = 1
	let g:winfix_winfocus = 1
	call neobundle#untap()
endif

"}}}
if neobundle#tap('echodoc.vim') "{{{
	let g:echodoc_enable_at_startup = 1
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-unite-issue') "{{{
	let g:unite_source_issue_file_dir = '~/docs/issues'
	let g:unite_source_issue_jira_priority_table = {
		\ 10000: '◡', 1: '⚡', 2: 'ᛏ', 3: '●', 4: '○', 5: '▽' }
	let g:unite_source_issue_jira_status_table = {
		\ 1: 'plan', 3: 'develop', 4: 'reopened', 5: 'resolved', 6: 'closed',
		\ 10000: 'feedback', 10001: 'stage-test', 10002: 'waiting',
		\ 10003: 'prod-test', 10004: 'pending', 10008: 'review' }
	let g:unite_source_issue_jira_type_table = {
		\ 1: 'bug', 2: 'feature', 3: 'task', 4: 'change', 5: 'sub-task',
		\ 6: 'epic', 7: 'story', 8: 'system', 9: 'sub-bug' }
	call neobundle#untap()
endif

"}}}
if neobundle#tap('matchit.zip') "{{{
	function! neobundle#hooks.on_post_source(bundle)
		silent! execute 'doautocmd Filetype' &filetype
	endfunction
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vinarise.vim') "{{{
	let g:vinarise_enable_auto_detect = 1
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-smartchr') "{{{
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/smartchr.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-operator-surround') "{{{
	nmap <silent>sa <Plug>(operator-surround-append)a
	nmap <silent>sd <Plug>(operator-surround-delete)a
	nmap <silent>sr <Plug>(operator-surround-replace)a
	nmap <silent>sc <Plug>(operator-surround-replace)a

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-operator-replace') "{{{
	map _ <Plug>(operator-replace)
	call neobundle#untap()
endif "}}}

"}}}
if neobundle#tap('concealedyank.vim') "{{{
	map Y <Plug>(operator-concealedyank)
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-textobj-user') "{{{
	omap ab <Plug>(textobj-multiblock-a)
	omap ib <Plug>(textobj-multiblock-i)
	xmap ab <Plug>(textobj-multiblock-a)
	xmap ib <Plug>(textobj-multiblock-i)

	call neobundle#untap()
endif

"}}}
if neobundle#tap('open-browser.vim') "{{{
	let g:openbrowser_no_default_menus = 1
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-bookmarks') "{{{
	let g:bookmark_auto_save_dir = $VARPATH.'/bookmarks'
	let g:bookmark_no_default_key_mappings = 1
	nnoremap <silent> <Plug>BookmarkShowAll :<C-u>BookmarkShowAll<CR>
	nnoremap <silent> <Plug>BookmarkNext :<C-u>BookmarkNext<CR>
	nnoremap <silent> <Plug>BookmarkPrev :<C-u>BookmarkPrev<CR>
	nnoremap <silent> <Plug>BookmarkToggle :<C-u>let b:bm_sync=0<CR>:<C-u>BookmarkToggle<CR>
	nnoremap <silent> <Plug>BookmarkAnnotate :<C-u>let b:bm_sync=0<CR>:<C-u>BookmarkAnnotate<CR>
	nmap ma <Plug>BookmarkShowAll
	nmap mn <Plug>BookmarkNext
	nmap mp <Plug>BookmarkPrev
	nmap mm <Plug>BookmarkToggle
	nmap mi <Plug>BookmarkAnnotate

	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/bookmarks.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('goyo.vim') "{{{
	nnoremap <Leader>G :Goyo<CR>
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/goyo.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-choosewin') "{{{
	nmap -         <Plug>(choosewin)
	nmap <Leader>- :<C-u>ChooseWinSwap<CR>

	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/choosewin.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-smalls') "{{{
	nmap <Nul>  <Plug>(smalls)
	let cli_table_custom = {
			\ "\<C-g>": 'do_cancel',
			\ "\<C-j>": 'do_jump',
			\ }
	call smalls#keyboard#cli#extend_table(cli_table_custom)
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-session') "{{{
	let g:session_directory = $VARPATH.'/session'
	let g:session_default_overwrite = 1
	let g:session_autosave = 'no'
	let g:session_autoload = 'no'
	let g:session_persist_colors = 0
	let g:session_menu = 0
	call neobundle#untap()
endif

"}}}
if neobundle#tap('jedi-vim') "{{{
	autocmd FileType python setlocal omnifunc=jedi#completions completeopt=menuone,longest,preview
	let g:jedi#completions_enabled = 0
	let g:jedi#auto_vim_configuration = 0
"	let g:jedi#force_py_version = 3
	call neobundle#untap()
endif

"}}}
if neobundle#tap('phpcomplete.vim') "{{{
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/phpcomplete.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('phpfolding.vim') "{{{
	let g:DisableAutoPHPFolding = 1  " Do not fold automatically
	call neobundle#untap()
endif

"}}}
if neobundle#tap('pdv') "{{{
	let g:pdv_template_dir = $VIMPATH.'/snippets/phpdoc'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-gitgutter') "{{{
	nmap <Leader>hj <Plug>GitGutterNextHunk
	nmap <Leader>hk <Plug>GitGutterPrevHunk
	nmap <Leader>hs <Plug>GitGutterStageHunk
	nmap <Leader>hr <Plug>GitGutterRevertHunk
	nmap <Leader>hp <Plug>GitGutterPreviewHunk
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/gitgutter.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('syntastic') "{{{
	let g:syntastic_mode_map = { 'mode': 'passive' }
	let g:syntastic_always_populate_loc_list = 1
	let g:syntastic_error_symbol = "✗"
	let g:syntastic_warning_symbol = "⚠"
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/syntastic.vim'
	nnoremap <silent> <leader>sy :<C-u>call <SID>syntax_check_toggle()<CR>

	let s:syntax_check_enable = 0
	function! s:syntax_check_toggle()
		if s:syntax_check_enable
			augroup auto-syntastic
				autocmd!
			augroup END
			augroup! auto-syntastic
			let s:syntax_check_enable = 0
			unlet! b:tinyline_syntastic
		else
			augroup auto-syntastic
				autocmd!
				autocmd BufWritePost *.c,*.cpp,*.hs,*.php,*.py,*.sh,*.coffee,*.css,*.go,*.html,*.js,*.json,*.less,*.pl,*.rb,*.sass,*.scss,*.vim,*.xml,*.yaml,*.zsh call <SID>syntax_check()
			augroup END
			let s:syntax_check_enable = 1
			call s:syntax_check()
			let loclist = get(b:, 'syntastic_loclist', {})
			if ! empty(loclist) && ! loclist.isEmpty()
				Unite location_list
			endif
		endif
	endfunction

	function! s:syntax_check()
		SyntasticCheck
		unlet! b:tinyline_syntastic
	endfunction
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-go') "{{{
	" vim-go, do not mess with my neosnippet config!
	let g:go_loaded_gosnippets = 1
	let g:go_snippet_engine = "neosnippet"
	call neobundle#untap()
endif

"}}}
if neobundle#tap('delimitMate') "{{{
	let delimitMate_expand_cr = 1
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-markdown') "{{{
	let g:vim_markdown_initial_foldlevel = 5
	let g:vim_markdown_frontmatter = 1
	call neobundle#untap()
endif

" }}}
if neobundle#tap('vim-mustache-handlebars') "{{{
	function! neobundle#hooks.on_post_source(bundle)
		doautocmd BufRead *.mustache, *.hogan, *.hulk, *.hjs, *.handlebars, *.hbs
	endfunction
	call neobundle#untap()
endif

" }}}
if neobundle#tap('vim-ansible-yaml') "{{{
	function! neobundle#hooks.on_post_source(bundle)
		doautocmd BufRead *.yml
	endfunction
	call neobundle#untap()
endif

" }}}
if neobundle#tap('vim-fugitive') "{{{
	function! neobundle#hooks.on_post_source(bundle)
		doautoall fugitive BufNewFile
	endfunction
	" ga gs gd gD gc gb gp gB gbd
	nnoremap <silent> <leader>ga :Git add %:p<CR>
	nnoremap <silent> <leader>gs :Gstatus<CR>
	nnoremap <silent> <leader>gd :Gdiff<CR>
	nnoremap <silent> <leader>gD :Gdiffoff<CR>
	nnoremap <silent> <leader>gc :Gcommit<CR>
	nnoremap <silent> <leader>gb :Gblame<CR>
	nnoremap <silent> <leader>gp :Git push<CR>
	nnoremap <silent> <leader>gB :Gbrowse<CR>
	nnoremap <silent> <leader>gbd :Gbrowse<CR>
	call neobundle#untap()
endif

"}}}
if neobundle#tap('gitv') "{{{
	let g:Gitv_DoNotMapCtrlKey = 1  " Do not map ctrl keys
	nnoremap <silent> <leader>gl :Gitv --all<CR>
	call neobundle#untap()
endif

"}}}
if neobundle#tap('gundo.vim') "{{{
	nnoremap <Leader>gu  :GundoToggle<CR>
	call neobundle#untap()
endif

"}}}
if neobundle#tap('indentLine') "{{{
	let g:indentLine_enabled = 1
	let g:indentLine_char = '⋮'
"	let g:indentLine_char = '┊'
	let g:indentLine_faster = 1
	let g:indentLine_color_term = 239
	let g:indentLine_color_gui = '#A4E57E'

	nmap <silent><Leader>i :<C-u>IndentLinesToggle<CR>
	call neobundle#untap()
endif

"}}}
if neobundle#tap('incsearch.vim') "{{{
	map /  <Plug>(incsearch-forward)
	map ?  <Plug>(incsearch-backward)
	map g/ <Plug>(incsearch-stay)

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-colorpicker') "{{{
	nmap <Leader>co :ColorPicker<CR>
	call neobundle#untap()
endif

" }}}
if neobundle#tap('quickrun.vim') "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
  call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-ref') "{{{
	function! neobundle#hooks.on_source(bundle)
		let g:ref_cache_dir = expand('$VARPATH/ref')
		let g:ref_use_vimproc = 1
		let g:ref_lynx_use_cache = 1
		let g:ref_lynx_start_linenumber = 0
		let g:ref_lynx_hide_url_number = 0
	endfunction

	call neobundle#untap()
endif

"}}}
if neobundle#tap('dictionary.vim') "{{{
	nnoremap <silent> <Leader>? :<C-u>Dictionary -no-duplicate<CR>
"	let g:dictionary_executable_path = '~/.local/bin/'

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-dotoo') "{{{
	let g:dotoo#agenda#files = [ '~/docs/todo/*.dotoo' ]
	let g:dotoo#capture#refile = expand('~/docs/todo/refile.dotoo')
	let g:dotoo#time#time_ago_short = 0
	let g:dotoo#capture#clock = 1

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vimwiki') "{{{
	let wiki = {}
	let wiki.diary_header = 'Rafi''s Diary'
	let wiki.diary_link_fmt = '%Y-%m/%d'
	let wiki.path = '~/docs/wiki/'
	let wiki.path_html = '~/docs/wiki/html/'
	let wiki.syntax = 'markdown'
	let wiki.ext = '.md'
	let g:vimwiki_list = [ wiki ]

	nnoremap <silent> <Leader>W :<C-u>VimwikiIndex<CR>

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-online-thesaurus') "{{{
	let g:online_thesaurus_map_keys = 0
	nnoremap <silent> <Leader>K :<C-u>OnlineThesaurusCurrentWord<CR>

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-closebuffer') "{{{
	map <C-q> <Plug>(closebuffer)

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-cursorword') "{{{
	augroup cursorword-filetype
		autocmd!
		autocmd FileType qf,vimfiler,vimshell,thumbnail,vimcalc,quickrun,github-dashboard
			\ let b:cursorword = 0
	augroup END

	call neobundle#untap()
endif

"}}}

" vim: set ts=2 sw=2 tw=80 noet :
