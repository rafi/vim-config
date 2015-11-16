
" Plugin Settings
"---------------------------------------------------------

if neobundle#tap('unite.vim') "{{{
	let g:unite_data_directory = $VARPATH.'/unite'
	let g:unite_source_history_yank_enable = 1
	nnoremap <silent> [unite]r   :<C-u>UniteResume -no-start-insert -force-redraw<CR>
	nnoremap <silent> [unite]b   :<C-u>Unite buffer file_mru bookmark<CR>
	nnoremap <silent> [unite]f   :<C-u>Unite file_rec/async<CR>
	nnoremap <silent> [unite]i   :<C-u>Unite file_rec/git<CR>
	nnoremap <silent> [unite]g   :<C-u>Unite grep:.<CR>
	nnoremap <silent> [unite]u   :<C-u>Unite source<CR>
	nnoremap <silent> [unite]t   :<C-u>Unite tag<CR>
	nnoremap <silent> [unite]T   :<C-u>Unite tag/include<CR>
	nnoremap <silent> [unite]l   :<C-u>Unite -profile-name=location location_list<CR>
	nnoremap <silent> [unite]L   :<C-u>Unite line<CR>
	nnoremap <silent> [unite]q   :<C-u>Unite -profile-name=location quickfix<CR>
	nnoremap <silent> [unite]j   :<C-u>Unite -profile-name=navigate change jump<CR>
	nnoremap <silent> [unite]h   :<C-u>Unite -buffer-name=register register history/yank<CR>
	nnoremap <silent> [unite]s   :<C-u>Unite session<CR>
	nnoremap <silent> [unite]o   :<C-u>Unite outline<CR>
	nnoremap <silent> [unite]ma  :<C-u>Unite mapping -silent<CR>
	nnoremap <silent> [unite]mk  :<C-u>Unite mark<CR>
	nnoremap <silent> [unite]mt  :<C-u>Unite -auto-resize -select=`tabpagenr()-1` tab<CR>
	nnoremap <silent> [unite]mu  :<C-u>Unite -profile-name=mpc mpc/menu<CR>
	nnoremap <silent> [unite]k
		\ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique -silent
		\ -no-short-source-names jump_point file_point file_mru
		\ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec/async'`
		\ buffer_tab:- file file/new<CR>

	" Open Unite with word under cursor or selection
	nnoremap <silent> <Leader>gf :UniteWithCursorWord file_rec/async -profile-name=navigate<CR>
	nnoremap <silent> <Leader>gg :UniteWithCursorWord grep:. -profile-name=navigate<CR>
	nnoremap <silent> <Leader>gt :UniteWithCursorWord tag -profile-name=navigate<CR>
	vnoremap <silent> <Leader>gt :<C-u>call VSetSearch('/')<CR>:execute 'Unite tag -profile-name=navigate -input='.@/<CR>
	vnoremap <silent> <Leader>gg :<C-u>call VSetSearch('/')<CR>:execute 'Unite grep:. -profile-name=navigate -input='.@/<CR>

	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/unite.vim'

	function! neobundle#hooks.on_post_source(bundle)
		autocmd MyAutoCmd FileType unite call s:unite_settings()
		autocmd MyAutoCmd BufEnter *
		\  if empty(&buftype) && &ft != 'go'
		\|   nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
		\| endif
	endfunction

	" Unite bindings
	function! s:unite_settings() "{{{
		silent! nunmap <buffer> <Space>
		silent! nunmap <buffer> <C-h>
		silent! nunmap <buffer> <C-k>
		silent! nunmap <buffer> <C-l>
		silent! nunmap <buffer> <C-r>
		nmap <silent><buffer> <C-r> <Plug>(unite_redraw)
		imap <silent><buffer> <C-j> <Plug>(unite_select_next_line)
		imap <silent><buffer> <C-k> <Plug>(unite_select_previous_line)
		nmap <silent><buffer> '     <Plug>(unite_toggle_mark_current_candidate)
		nmap <silent><buffer> e     <Plug>(unite_do_default_action)
		nmap <silent><buffer><expr> sv unite#do_action('split')
		nmap <silent><buffer><expr> sg unite#do_action('vsplit')
		nmap <silent><buffer><expr> st unite#do_action('tabopen')
		nnoremap <silent><buffer> <Tab>  <C-w>w
		nmap <buffer> q             <Plug>(unite_exit)
		imap <buffer> jj            <Plug>(unite_insert_leave)
		imap <buffer> <Tab>         <Plug>(unite_complete)
		nmap <buffer> <C-z>         <Plug>(unite_toggle_transpose_window)
		imap <buffer> <C-z>         <Plug>(unite_toggle_transpose_window)
		nmap <buffer> <C-w>         <Plug>(unite_delete_backward_path)
		nmap <buffer> <C-g>         <Plug>(unite_print_candidate)
		nmap <buffer> x             <Plug>(unite_quick_match_jump)

		let unite = unite#get_current_unite()
		if unite.profile_name ==# '^search'
			nnoremap <silent><buffer><expr> r unite#do_action('replace')
		else
			nnoremap <silent><buffer><expr> r unite#do_action('rename')
		endif
	endfunction "}}}

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vimfiler.vim') "{{{
	nnoremap <silent> [unite]e        :<C-u>execute 'VimFiler -force-hide -winwidth=25 -buffer-name='.t:project_name<CR>
	nnoremap <silent> [unite]a        :<C-u>execute 'VimFiler -find -force-hide -winwidth=25 -buffer-name='.t:project_name<CR>
	let g:vimfiler_data_directory = $VARPATH.'/vimfiler'
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/vimfiler.vim'

	function! neobundle#hooks.on_post_source(bundle)
		autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
	endfunction

	function! s:vimfiler_settings() "{{{
		setlocal nonumber norelativenumber

		nunmap <buffer> <Space>
		nunmap <buffer> <C-l>
		nunmap <buffer> <C-j>
		nunmap <buffer> gr
		nunmap <buffer> -

		nnoremap <silent><buffer> gr  :<C-u>Unite grep:<C-R>=<SID>selected()<CR><CR>
		nnoremap <silent><buffer> gf  :<C-u>Unite file_rec/async:<C-R>=<SID>selected()<CR><CR>
		nnoremap <silent><buffer> gc  :<C-u>call <SID>change_vim_current_dir()<CR>
		nnoremap <silent><buffer><expr> sg  vimfiler#do_action('vsplit')
		nnoremap <silent><buffer><expr> sv  vimfiler#do_action('split')
		nmap <buffer> '      <Plug>(vimfiler_toggle_mark_current_line)
		nmap <buffer> v      <Plug>(vimfiler_quick_look)
		nmap <buffer> p      <Plug>(vimfiler_preview_file)
		nmap <buffer> V      <Plug>(vimfiler_clear_mark_all_lines)
		nmap <buffer> i      <Plug>(vimfiler_switch_to_history_directory)
		nmap <buffer> <Tab>  <Plug>(vimfiler_switch_to_other_window)
		nmap <buffer> <C-r>  <Plug>(vimfiler_redraw_screen)
	endfunction "}}}

	function! s:selected(...) " {{{
		" Returns selected items, or current cursor directory position
		" Provide an argument to limit results with an integer.
		let marked_files = vimfiler#get_escaped_marked_files(b:vimfiler)
		if empty(marked_files)
			let file_dir = vimfiler#get_file_directory()
			if empty(file_dir)
				return '.'
			endif
			call add(marked_files, file_dir)
		endif
		if a:0 > 0
			let marked_files = marked_files[: a:1]
		endif
		return join(marked_files, "\n")
	endfunction "}}}

	function! s:change_vim_current_dir() "{{{
		let selected = s:selected(1)
		let windows = unite#helper#get_choose_windows()
		if ! empty(windows)
			let winnr = unite#helper#choose_window()
			execute winnr.'wincmd w'
			execute 'lcd '.fnameescape(selected)
		endif

	endfunction "}}}

	call neobundle#untap()
endif

"}}}
if neobundle#tap('deoplete.nvim') && has('nvim') "{{{
	let g:deoplete#enable_at_startup = 1
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
				\$VIMPATH.'/snippet,'
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
if neobundle#tap('vim-operator-surround') "{{{
	map <silent>sa <Plug>(operator-surround-append)
	map <silent>sd <Plug>(operator-surround-delete)
	map <silent>sr <Plug>(operator-surround-replace)
	nmap <silent>sdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
	nmap <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-operator-replace') "{{{
	xmap p <Plug>(operator-replace)
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-niceblock') "{{{
	xmap I  <Plug>(niceblock-I)
	xmap A  <Plug>(niceblock-A)

	call neobundle#untap()
endif

"}}}
if neobundle#tap('accelerated-jk') "{{{
	nmap <silent>j <Plug>(accelerated_jk_gj)
	nmap <silent>k <Plug>(accelerated_jk_gk)

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-textobj-multiblock') "{{{
	omap ab <Plug>(textobj-multiblock-a)
	omap ib <Plug>(textobj-multiblock-i)
	xmap ab <Plug>(textobj-multiblock-a)
	xmap ib <Plug>(textobj-multiblock-i)
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-signature') "{{{
	let g:SignatureMarkTextHLDynamic = 1
	let g:SignatureMarkerTextHLDynamic = 1

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

	let g:choosewin_label = 'FGHJKLZXCVBNM'
	let g:choosewin_overlay_enable     = 1
	let g:choosewin_statusline_replace = 1
	let g:choosewin_tabline_replace    = 1
	let g:choosewin_label_padding      = 3
	let g:choosewin_blink_on_land      = 0

	let g:choosewin_color_label = {
		\ 'cterm': [ 236, 2 ], 'gui': [ '#555555', '#000000' ] }
	let g:choosewin_color_label_current = {
		\ 'cterm': [ 234, 220 ], 'gui': [ '#333333', '#000000' ] }
	let g:choosewin_color_other = {
		\ 'cterm': [ 235, 235 ], 'gui': [ '#333333' ] }
	let g:choosewin_color_overlay = {
		\ 'cterm': [ 2, 10 ], 'gui': [ '#88A2A4' ] }
	let g:choosewin_color_overlay_current = {
		\ 'cterm': [ 72, 64 ], 'gui': [ '#7BB292' ] }

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-session') "{{{
	nmap <Leader>se :<C-u>SaveSession<CR>
	nmap <Leader>os :<C-u>OpenSession last<CR>

	let g:session_directory = $VARPATH.'/session'
	let g:session_default_name = 'last'
	let g:session_default_overwrite = 1
	let g:session_verbose_messages = 0
	let g:session_autosave = 'no'
	let g:session_autoload = 'no'
	let g:session_persist_colors = 0
	let g:session_menu = 0
	call neobundle#untap()
endif

"}}}
if neobundle#tap('jedi-vim') "{{{
	autocmd MyAutoCmd FileType python
		\ if has('python') || has('python3') |
		\   setlocal omnifunc=jedi#completions |
		\ else |
		\   setlocal omnifunc= |
		\ endif
	setlocal completeopt=menuone,longest,preview
	let g:jedi#completions_enabled = 0
	let g:jedi#auto_vim_configuration = 0
	let g:jedi#smart_auto_mappings = 0
	let g:jedi#use_splits_not_buffers = 'left'
	let g:jedi#completions_command = ''
	let g:jedi#goto_command = '<leader>d'
	let g:jedi#goto_assignments_command = '<leader>a'
	let g:jedi#documentation_command = 'K'
	let g:jedi#rename_command = '<leader>r'
	let g:jedi#usages_command = '<leader>n'
	let g:jedi#popup_on_dot = 0
	let g:jedi#max_doc_height = 40
	let g:jedi#show_call_signatures = 1
	let g:jedi#show_call_signatures_delay = 1000
	call neobundle#untap()
endif

"}}}
if neobundle#tap('phpcomplete.vim') "{{{
	augroup phpSyntaxOverride
		autocmd!
		autocmd FileType php hi! def link phpDocTags phpDefine
	augroup END
	call neobundle#untap()
endif

"}}}
if neobundle#tap('phpfolding.vim') "{{{
	let g:DisableAutoPHPFolding = 1
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-gitgutter') "{{{
	let g:gitgutter_realtime = 1
	let g:gitgutter_eager = 0
	let g:gitgutter_map_keys = 0
	let g:gitgutter_sign_added = '▎'
	let g:gitgutter_sign_modified = '▎'
	let g:gitgutter_sign_removed = '▏'
	let g:gitgutter_sign_removed_first_line = '▔'
	let g:gitgutter_sign_modified_removed = '▋'

	nmap <Leader>hj <Plug>GitGutterNextHunk
	nmap <Leader>hk <Plug>GitGutterPrevHunk
	nmap <Leader>hs <Plug>GitGutterStageHunk
	nmap <Leader>hr <Plug>GitGutterRevertHunk
	nmap <Leader>hp <Plug>GitGutterPreviewHunk

	call neobundle#untap()
endif

"}}}
if neobundle#tap('neomake') "{{{
let g:neomake_verbose = 1
	autocmd MyAutoCmd BufWritePost * call <SID>neomake_custom()
	function! s:neomake_custom()
		let filetypes = [
			\   'python', 'php', 'ruby', 'vim', 'go', 'sh',
			\   'html', 'javascript', 'css', 'yaml'
			\ ]

		if empty(&buftype) && index(filetypes, &ft) > -1
			Neomake
		endif
	endfunction
	let neobundle#hooks.on_source = $VIMPATH.'/config/plugins/neomake.vim'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-go') "{{{
	autocmd MyAutoCmd FileType go
		\   nmap <C-]> <Plug>(go-def)
		\ | nmap <Leader>god  <Plug>(go-describe)
		\ | nmap <Leader>goc  <Plug>(go-callees)
		\ | nmap <Leader>goC  <Plug>(go-callers)
		\ | nmap <Leader>goi  <Plug>(go-info)
		\ | nmap <Leader>gom  <Plug>(go-implements)
		\ | nmap <Leader>gos  <Plug>(go-callstack)
		\ | nmap <Leader>goe  <Plug>(go-referrers)
		\ | nmap <Leader>gor  <Plug>(go-run)
		\ | nmap <Leader>gov  <Plug>(go-vet)

	let g:go_def_mapping_enabled = 0

	" vim-go, do not mess with my neosnippet config!
	let g:go_loaded_gosnippets = 1
	let g:go_snippet_engine = 'neosnippet'

	let g:go_highlight_extra_types = 1
	let g:go_highlight_operators = 1
	let g:go_highlight_functions = 1
	let g:go_highlight_methods = 1
	let g:go_highlight_structs = 1
	let g:go_highlight_build_constraints = 1

	call neobundle#untap()
endif

"}}}
if neobundle#tap('delimitMate') "{{{
	let g:delimitMate_expand_cr = 1
	function! neobundle#hooks.on_post_source(bundle)
		silent! iunmap <buffer> <C-g>g
	endfunction
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-markdown') "{{{
	let g:vim_markdown_initial_foldlevel = 5
	let g:vim_markdown_frontmatter = 1
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-jinja') "{{{
	let g:htmljinja_disable_detection = 0
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-gita') "{{{
	nnoremap <silent> <leader>gs :<C-u>Gita status<CR>
	nnoremap <silent> <leader>gd :<C-u>Gita diff<CR>
	nnoremap <silent> <leader>gc :<C-u>Gita commit<CR>
	nnoremap <silent> <leader>gb :<C-u>Gita blame<CR>
	nnoremap <silent> <leader>gB :<C-u>Gita browse<CR>
	nnoremap <silent> <leader>gp :<C-u>Gita push<CR>
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-gista') "{{{
	let g:gista#directory = $VARPATH.'/gista/'
	call neobundle#untap()
endif

"}}}
if neobundle#tap('undotree') "{{{
	nnoremap <Leader>gu  :UndotreeToggle<CR>
	call neobundle#untap()
endif

"}}}
if neobundle#tap('caw.vim') "{{{
	autocmd MyAutoCmd FileType * call s:init_caw()
	function! s:init_caw()
		if ! &l:modifiable
			silent! nunmap <buffer> gc
			silent! xunmap <buffer> gc
			silent! nunmap <buffer> gcc
			silent! xunmap <buffer> gcc
			silent! nunmap <buffer> gcv
			silent! xunmap <buffer> gcv
		else
			nmap <buffer> gc <Plug>(caw:prefix)
			xmap <buffer> gc <Plug>(caw:prefix)
			nmap <buffer> gcc <Plug>(caw:wrap:toggle)
			xmap <buffer> gcc <Plug>(caw:wrap:toggle)
			nmap <buffer> gcv <Plug>(caw:I:toggle)
			xmap <buffer> gcv <Plug>(caw:I:toggle)
		endif
	endfunction

	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-indent-guides') "{{{
	let g:indent_guides_enable_on_vim_startup = 0
	let g:indent_guides_guide_size = 1
	let g:indent_guides_start_level = 2
	let g:indent_guides_exclude_filetypes = ['help', 'unite', 'vimfiler']
	let g:indent_guides_default_mapping = 0
	let g:indent_guides_auto_colors = 0
	let g:indent_guides_indent_levels = 10

	nmap <silent><Leader>i :<C-u>IndentGuidesToggle<CR>
	autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd  guibg=#333   ctermbg=235
	autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven guibg=#333 ctermbg=235

	function! neobundle#hooks.on_post_source(bundle)
		autocmd MyAutoCmd BufRead * if &ft == 'python'
			\ |   IndentGuidesEnable
			\ | else
			\ |   IndentGuidesDisable
			\ | endif
	endfunction
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-asterisk') "{{{
	map *   <Plug>(asterisk-*)
	map #   <Plug>(asterisk-#)
	map g*  <Plug>(asterisk-g*)
	map g#  <Plug>(asterisk-g#)
	map z*  <Plug>(asterisk-z*)
	map gz* <Plug>(asterisk-gz*)
	map z#  <Plug>(asterisk-z#)
	map gz# <Plug>(asterisk-gz#)
	call neobundle#untap()
endif

"}}}
if neobundle#tap('incsearch.vim') "{{{
	let g:incsearch#auto_nohlsearch = 1

	map /  <Plug>(incsearch-forward)
	map ?  <Plug>(incsearch-backward)
	map g/ <Plug>(incsearch-stay)
	map n  <Plug>(incsearch-nohl-n)
	map N  <Plug>(incsearch-nohl-N)
	call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-expand-region') "{{{
  xmap v <Plug>(expand_region_expand)
  xmap V <Plug>(expand_region_shrink)

  call neobundle#untap()
endif

"}}}
if neobundle#tap('vim-quickrun') "{{{
  nmap <silent> <Leader>r <Plug>(quickrun)
  call neobundle#untap()
endif

"}}}
if neobundle#tap('dictionary.vim') "{{{
	nnoremap <silent> <Leader>? :<C-u>Dictionary -no-duplicate<CR>

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
