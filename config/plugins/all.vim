
" Plugin Settings
"---------------------------------------------------------

if dein#tap('unite.vim') "{{{
	let g:unite_data_directory = $VARPATH.'/unite'
	let g:neoyank#file = g:unite_data_directory.'/history_yank'

	nnoremap <silent> [unite]r   :<C-u>UniteResume -no-start-insert -force-redraw<CR>
	nnoremap <silent> [unite]b   :<C-u>Unite buffer file_mru bookmark<CR>
	nnoremap <silent> [unite]f   :<C-u>Unite file_rec/`has('nvim') ? 'neovim' : 'async'`<CR>
	nnoremap <silent> [unite]g   :<C-u>Unite grep:.<CR>
	nnoremap <silent> [unite]u   :<C-u>Unite source<CR>
	nnoremap <silent> [unite]t   :<C-u>Unite tag -start-insert<CR>
	nnoremap <silent> [unite]T   :<C-u>Unite tag/include<CR>
	nnoremap <silent> [unite]l   :<C-u>Unite location_list<CR>
	nnoremap <silent> [unite]L   :<C-u>Unite line<CR>
	nnoremap <silent> [unite]q   :<C-u>Unite quickfix<CR>
	nnoremap <silent> [unite]j   :<C-u>Unite -profile-name=navigate change jump<CR>
	nnoremap <silent> [unite]h   :<C-u>Unite -buffer-name=register register history/yank<CR>
	nnoremap <silent> [unite]s   :<C-u>Unite session<CR>
	nnoremap <silent> [unite]o   :<C-u>Unite outline<CR>
	nnoremap <silent> [unite]ma  :<C-u>Unite mapping -silent<CR>
	nnoremap <silent> [unite]mk  :<C-u>Unite mark<CR>
	nnoremap <silent> [unite]mt  :<C-u>Unite -select=`tabpagenr()-1` tab<CR>
	nnoremap <silent> [unite]mu  :<C-u>Unite -profile-name=mpc mpc/menu<CR>
	nnoremap <silent> [unite]k
		\ :<C-u>Unite -buffer-name=files -no-split -multi-line -unique -silent
		\ -no-short-source-names jump_point file_point file_mru file_rec/async
		\ buffer_tab:- file file/new<CR>

	" Open Unite with word under cursor or selection
	nnoremap <silent> <Leader>gf :UniteWithCursorWord file_rec/`has('nvim') ? 'neovim' : 'async'` -profile-name=navigate<CR>
	nnoremap <silent> <Leader>gg :UniteWithCursorWord grep:.<CR>
	nnoremap <silent> <Leader>gt :UniteWithCursorWord tag -start-insert<CR>
	vnoremap <silent> <Leader>gt :<C-u>call VSetSearch('/')<CR>:execute 'Unite tag -input='.@/<CR>
	vnoremap <silent> <Leader>gg :<C-u>call VSetSearch('/')<CR>:execute 'Unite grep:. -input='.@/<CR>

	autocmd MyAutoCmd BufEnter *
		\  if empty(&buftype) && &ft != 'go'
		\|   nnoremap <buffer> <C-]> :<C-u>UniteWithCursorWord -immediately tag<CR>
		\| endif

	autocmd MyAutoCmd FileType unite call s:unite_settings()

	" Unite bindings
	function! s:unite_settings() abort "{{{
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
endif

"}}}
if dein#tap('vimfiler.vim') "{{{
	let g:vimfiler_data_directory = $VARPATH.'/vimfiler'

	nnoremap <silent> [unite]e        :<C-u>execute
		\ 'VimFiler -winwidth=25 -direction=topleft -buffer-name='.block#project()<CR>
	nnoremap <silent> [unite]a        :<C-u>execute
		\ 'VimFiler -find -winwidth=25 -direction=topleft -buffer-name='.block#project()<CR>

	autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()

	function! s:vimfiler_settings() abort "{{{
		setlocal nonumber norelativenumber

		silent! nunmap <buffer> <Space>
		silent! nunmap <buffer> <C-l>
		silent! nunmap <buffer> <C-j>
		silent! nunmap <buffer> gr
		silent! nunmap <buffer> gs
		silent! nunmap <buffer> -

		nnoremap <silent><buffer> gr  :<C-u>Unite grep:<C-R>=<SID>selected()<CR><CR>
		nnoremap <silent><buffer> gf  :<C-u>Unite file_rec/`has('nvim') ? 'neovim' : 'async'`:<C-R>=<SID>selected()<CR><CR>
		nnoremap <silent><buffer> gs  :<C-u>call <SID>change_vim_current_dir()<CR>
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

	" Returns selected items, or current cursor directory position
	" Provide an argument to limit results with an integer.
	function! s:selected(...) " {{{
		let marked = map(vimfiler#get_marked_files(b:vimfiler), 'v:val.action__path')
		if empty(marked)
			let file_dir = vimfiler#get_file_directory()
			call add(marked, empty(file_dir) ? '.' : file_dir)
		endif
		if a:0 > 0
			let marked = marked[: a:1]
		endif
		return join(marked, "\n")
	endfunction "}}}

	function! s:change_vim_current_dir() "{{{
		let selected = s:selected(1)
		let windows = unite#helper#get_choose_windows()
		if ! empty(windows)
			let winnr = unite#helper#choose_window()
			execute winnr.'wincmd w'
			execute 'lcd '.fnameescape(selected)
			echo 'Changed local buffer working directory to `'.selected.'`'
		endif
	endfunction "}}}
endif

"}}}
if dein#tap('deoplete-jedi') && has('nvim') "{{{
	autocmd MyAutoCmd FileType python setlocal omnifunc=
endif

"}}}
if dein#tap('neocomplete') && has('lua') "{{{
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#data_directory = $VARPATH.'/complete'
endif

"}}}
if dein#tap('neosnippet.vim') "{{{
	let g:neosnippet#enable_snipmate_compatibility = 0
	let g:neosnippet#enable_preview = 1
	let g:neosnippet#enable_completed_snippet = 1
	let g:neosnippet#enable_complete_done = 1
	let g:neosnippet#expand_word_boundary = 1
	let g:neosnippet#disable_runtime_snippets = { '_': 1 }
	let g:neosnippet#data_directory  = $VARPATH.'/snippets'
	let g:neosnippet#snippets_directory =
				\$VIMPATH.'/snippets,'
				\.dein#get('neosnippet-snippets').path.'/neosnippets,'
				\.dein#get('mpvim').path.'/snippets,'
				\.dein#get('vim-ansible-yaml').path.'/snippets,'
				\.dein#get('vim-go').path.'/gosnippets/snippets'

	imap <expr><C-o> neosnippet#expandable_or_jumpable()
		\ ? "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
	xmap <silent><C-s>      <Plug>(neosnippet_register_oneshot_snippet)
	imap <silent><C-Space>  <Plug>(neosnippet_start_unite_snippet)
endif

"}}}
if dein#tap('neomru.vim') "{{{
	let g:neomru#file_mru_path = $VARPATH.'/unite/mru/file'
	let g:neomru#directory_mru_path  = $VARPATH.'/unite/mru/directory'
endif

"}}}
if dein#tap('tmux-complete.vim') "{{{
	let g:tmuxcomplete#trigger = ''
endif

"}}}
if dein#tap('echodoc.vim') "{{{
	let g:echodoc_enable_at_startup = 1
endif

"}}}
if dein#tap('vim-unite-issue') "{{{
	let g:unite_source_issue_file_dir = '~/docs/issues'
	let g:unite_source_issue_jira_priority_table = {
		\ 2: 'ᛏ', 3: '●', 4: '▽', 5: '◡', 6: '○', 7: '⚡'}
endif

"}}}
if dein#tap('mpc') "{{{
	let g:unite_mpc_random_tracks = 50
endif

"}}}
if dein#tap('vim-operator-surround') "{{{
	map <silent>sa <Plug>(operator-surround-append)
	map <silent>sd <Plug>(operator-surround-delete)
	map <silent>sr <Plug>(operator-surround-replace)
	nmap <silent>sdd <Plug>(operator-surround-delete)<Plug>(textobj-multiblock-a)
	nmap <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
endif

"}}}
if dein#tap('vim-operator-replace') "{{{
	xmap p <Plug>(operator-replace)
endif

"}}}
if dein#tap('vim-operator-flashy') "{{{
	map y <Plug>(operator-flashy)
	nmap Y <Plug>(operator-flashy)$
endif

"}}}
if dein#tap('vim-niceblock') "{{{
	xmap I  <Plug>(niceblock-I)
	xmap A  <Plug>(niceblock-A)
endif

"}}}
if dein#tap('accelerated-jk') "{{{
	nmap <silent>j <Plug>(accelerated_jk_gj)
	nmap <silent>k <Plug>(accelerated_jk_gk)
endif

"}}}
if dein#tap('committia.vim') "{{{
	let g:committia_min_window_width = 80
	let g:committia_hooks = {}
	function! g:committia_hooks.edit_open(info)
		setlocal spell

		" If no commit message, start with insert mode
		if a:info.vcs ==# 'git' && getline(1) ==# ''
			resize 4
			startinsert
		end

		" Scroll the diff window from insert mode
		" Map <C-n> and <C-p>
		imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
		imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
	endfunction
endif

"}}}
if dein#tap('vim-textobj-multiblock') "{{{
	omap ab <Plug>(textobj-multiblock-a)
	omap ib <Plug>(textobj-multiblock-i)
	xmap ab <Plug>(textobj-multiblock-a)
	xmap ib <Plug>(textobj-multiblock-i)
endif

"}}}
if dein#tap('vim-signature') "{{{
	let g:SignatureMarkTextHLDynamic = 1
	let g:SignatureMarkerTextHLDynamic = 1
	let g:SignaturePurgeConfirmation = 1
	let g:SignatureDeleteConfirmation = 1
	let g:signature_set_location_list_convenience_maps = 0
	let g:SignatureMap = {
		\ 'ListBufferMarks':   'm/',
		\ 'ListBufferMarkers': 'm?',
		\ 'Leader':            'm',
		\ 'PlaceNextMark':     'm,',
		\ 'ToggleMarkAtLine':  'm.',
		\ 'PurgeMarksAtLine':  'm-',
		\ 'DeleteMark':        'dm',
		\ 'PurgeMarks':        'm<Space>',
		\ 'PurgeMarkers':      'm<BS>',
		\ 'GotoNextSpotAlpha': 'mn',
		\ 'GotoPrevSpotAlpha': 'mp',
		\ 'GotoNextMarkerAny': 'mj',
		\ 'GotoPrevMarkerAny': 'mk',
		\ 'GotoNextMarker': '',
		\ 'GotoPrevMarker': '',
		\ 'GotoNextLineAlpha': '',
		\ 'GotoPrevLineAlpha': '',
		\ 'GotoNextSpotByPos': '',
		\ 'GotoPrevSpotByPos': '',
		\ 'GotoNextLineByPos': '',
		\ 'GotoPrevLineByPos': ''
		\ }
endif

"}}}
if dein#tap('goyo.vim') "{{{
	nnoremap <Leader>G :Goyo<CR>
endif

"}}}
if dein#tap('vim-choosewin') "{{{
	nmap -         <Plug>(choosewin)
	nmap <Leader>- :<C-u>ChooseWinSwap<CR>

	let g:choosewin_label = 'FGHJKLZXCVBNM'
	let g:choosewin_overlay_enable = 1
	let g:choosewin_statusline_replace = 1
	let g:choosewin_tabline_replace = 1
	let g:choosewin_label_padding = 3
	let g:choosewin_blink_on_land = 0

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
endif

"}}}
if dein#tap('jedi-vim') "{{{
	let g:jedi#force_py_version = 3
	let g:jedi#completions_enabled = 0
	let g:jedi#auto_vim_configuration = 0
	let g:jedi#smart_auto_mappings = 0
	let g:jedi#show_call_signatures = 0
	let g:jedi#use_tag_stack = 0
	let g:jedi#popup_select_first = 0
	let g:jedi#popup_on_dot = 0
	let g:jedi#max_doc_height = 45
	let g:jedi#use_splits_not_buffers = 'right'
	let g:jedi#completions_command = ''
	let g:jedi#goto_command = '<leader>d'
	let g:jedi#goto_assignments_command = '<leader>a'
	let g:jedi#documentation_command = 'K'
	let g:jedi#rename_command = '<leader>r'
	let g:jedi#usages_command = '<leader>n'

	if ! has('nvim')
		setlocal completeopt=menuone,longest
		autocmd MyAutoCmd FileType python
			\ if has('python') || has('python3') |
			\   setlocal omnifunc=jedi#completions |
			\ else |
			\   setlocal omnifunc= |
			\ endif
	endif
endif

"}}}
if dein#tap('tern_for_vim') "{{{
	autocmd MyAutoCmd FileType javascript setlocal omnifunc=tern#Complete
	let g:tern_show_signature_in_pum = 1
endif

"}}}
if dein#tap('vim-gitgutter') "{{{
"	let g:gitgutter_realtime = 1
"	let g:gitgutter_eager = 0
	let g:gitgutter_map_keys = 0

	nmap <Leader>hj <Plug>GitGutterNextHunk
	nmap <Leader>hk <Plug>GitGutterPrevHunk
	nmap <Leader>hs <Plug>GitGutterStageHunk
	nmap <Leader>hr <Plug>GitGutterUndoHunk
	nmap <Leader>hp <Plug>GitGutterPreviewHunk
endif

"}}}
if dein#tap('neomake') "{{{
	let g:neomake_verbose = 0
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
endif

"}}}
if dein#tap('vim-go') "{{{
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
	" SLOW:
"	let g:go_highlight_functions = 1
"	let g:go_highlight_methods = 1
"	let g:go_highlight_structs = 1
"	let g:go_highlight_build_constraints = 1
endif

"}}}
if dein#tap('neopairs.vim') "{{{
	let g:neopairs#enable = 0
endif

"}}}
if dein#tap('vim-markdown') "{{{
	let g:vim_markdown_initial_foldlevel = 5
	let g:vim_markdown_frontmatter = 1
endif

"}}}
if dein#tap('vim-jinja') "{{{
	let g:htmljinja_disable_detection = 0
endif

"}}}
if dein#tap('vim-gita') "{{{
	nnoremap <silent> <leader>gs :<C-u>Gita status<CR>
	nnoremap <silent> <leader>gc :<C-u>Gita commit<CR>
	nnoremap <silent> <leader>ga :<C-u>Gita commit --amend<CR>
	nnoremap <silent> <leader>gd :<C-u>Gita diff<CR>
	nnoremap <silent> <leader>gb :<C-u>Gita browse<CR>
	nnoremap <silent> <leader>gl :<C-u>Gita blame<CR>
	nnoremap <silent> <leader>gp :<C-u>Gita push<CR>

	autocmd MyAutoCmd FileType gita-status
		\ silent! nunmap <buffer> <C-L> |
		\ nmap <buffer> <C-R> <Plug>(gita-common-redraw) |
		\ nmap <buffer> cc    <Plug>(gita-commit-open) |
		\ nmap <buffer> cA    <Plug>(gita-commit-open-amend) |
		\ nmap <buffer> dg    <Plug>(gita-diff-right) |
		\ nmap <buffer> sg    <Plug>(gita-edit-right)
endif

"}}}
if dein#tap('vim-gista') "{{{
	let g:gista#client#cache_dir = $VARPATH.'/gista/'
endif

"}}}
if dein#tap('undotree') "{{{
	nnoremap <Leader>gu  :UndotreeToggle<CR>
endif

"}}}
if dein#tap('caw.vim') "{{{
	let g:caw_zeropos_sp = ''
	let g:caw_zeropos_sp_right = ''
	let g:caw_hatpos_sp = ''
	let g:caw_hatpos_skip_blank_line = 1
	let g:caw_dollarpos_sp_right = ''
	let g:caw_dollarpos_skip_blank_line = 1
	let g:caw_box_sp_right = ''
	autocmd MyAutoCmd FileType * call s:init_caw()
	function! s:init_caw()
		if ! &l:modifiable
			silent! nunmap <buffer> gc
			silent! xunmap <buffer> gc
			silent! nunmap <buffer> <Leader>v
			silent! xunmap <buffer> <Leader>v
			silent! nunmap <buffer> <Leader>V
			silent! xunmap <buffer> <Leader>V
		else
			nmap <buffer> gc <Plug>(caw:prefix)
			xmap <buffer> gc <Plug>(caw:prefix)
			nmap <buffer> <Leader>V <Plug>(caw:tildepos:toggle)
			xmap <buffer> <Leader>V <Plug>(caw:tildepos:toggle)
			nmap <buffer> <Leader>v <Plug>(caw:zeropos:toggle)
			xmap <buffer> <Leader>v <Plug>(caw:zeropos:toggle)
		endif
	endfunction
endif

"}}}
if dein#tap('vim-indent-guides') "{{{
	let g:indent_guides_enable_on_vim_startup = 0
	let g:indent_guides_exclude_filetypes = ['help', 'unite', 'vimfiler']
	let g:indent_guides_default_mapping = 0
	let g:indent_guides_indent_levels = 15

	nmap <silent><Leader>i :<C-u>IndentGuidesToggle<CR>

	" Automatically toggle indent guides for all file-types
	autocmd MyAutoCmd BufEnter *
		\ if ! has('vim_starting') && ! empty(&l:filetype)
		\ |   if g:indent_guides_autocmds_enabled == 0 && &expandtab
		\ |     IndentGuidesEnable
		\ |   elseif g:indent_guides_autocmds_enabled == 1 && ! &expandtab
		\ |     IndentGuidesDisable
		\ |   endif
		\ | endif
endif

"}}}
if dein#tap('vim-asterisk') "{{{
	map *   <Plug>(asterisk-*)
	map #   <Plug>(asterisk-#)
	map g*  <Plug>(asterisk-g*)
	map g#  <Plug>(asterisk-g#)
	map z*  <Plug>(asterisk-z*)
	map gz* <Plug>(asterisk-gz*)
	map z#  <Plug>(asterisk-z#)
	map gz# <Plug>(asterisk-gz#)
endif

"}}}
if dein#tap('incsearch.vim') "{{{
	let g:incsearch#auto_nohlsearch = 1

	map /  <Plug>(incsearch-forward)
	map ?  <Plug>(incsearch-backward)
	map g/ <Plug>(incsearch-stay)
	map n  <Plug>(incsearch-nohl-n)
	map N  <Plug>(incsearch-nohl-N)
endif

"}}}
if dein#tap('dictionary.vim') "{{{
	nnoremap <silent> <Leader>? :<C-u>Dictionary -no-duplicate<CR>
endif

"}}}
if dein#tap('vimwiki') "{{{
	let wiki = {}
	let wiki.diary_header = 'Rafi''s Diary'
	let wiki.diary_link_fmt = '%Y-%m/%d'
	let wiki.path = '~/docs/wiki/'
	let wiki.path_html = '~/docs/wiki/html/'
	let wiki.syntax = 'markdown'
	let wiki.ext = '.md'
	let g:vimwiki_list = [ wiki ]

	nnoremap <silent> <Leader>W :<C-u>VimwikiIndex<CR>
endif

"}}}
if dein#tap('vim-online-thesaurus') "{{{
	let g:online_thesaurus_map_keys = 0
	nnoremap <silent> <Leader>K :<C-u>OnlineThesaurusCurrentWord<CR>
endif

"}}}
if dein#tap('vim-cursorword') "{{{
	augroup cursorword-filetype
		autocmd!
		autocmd FileType qf,vimfiler,vimshell,thumbnail,vimcalc,quickrun,github-dashboard
			\ let b:cursorword = 0
	augroup END
endif

"}}}
if dein#tap('sideways.vim') "{{{
	nnoremap <silent> m" :SidewaysJumpLeft<CR>
	nnoremap <silent> m' :SidewaysJumpRight<CR>
	omap a, <Plug>SidewaysArgumentTextobjA
	xmap a, <Plug>SidewaysArgumentTextobjA
	omap i, <Plug>SidewaysArgumentTextobjI
	xmap i, <Plug>SidewaysArgumentTextobjI
endif

"}}}
if dein#tap('CamelCaseMotion') "{{{
	nmap <silent> e <Plug>CamelCaseMotion_e
	nmap <silent> w <Plug>CamelCaseMotion_w
	xmap <silent> w <Plug>CamelCaseMotion_w
	omap <silent> W <Plug>CamelCaseMotion_w
	nmap <silent> b <Plug>CamelCaseMotion_b
	xmap <silent> b <Plug>CamelCaseMotion_b
	omap <silent> B <Plug>CamelCaseMotion_b
endif

"}}}

" vim: set ts=2 sw=2 tw=80 noet :
