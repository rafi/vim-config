
" Plugin Settings
"---------------------------------------------------------

if dein#tap('denite.nvim') "{{{
	nnoremap <silent> [unite]/ :<C-u>Denite line<CR>
	nnoremap <silent> [unite]* :<C-u>DeniteCursorWord line<CR>
	nnoremap <silent> [unite]r  :<C-u>Denite -resume<CR>
	nnoremap <silent> [unite]f  :<C-u>Denite file_rec<CR>
	nnoremap <silent> [unite]d  :<C-u>Denite directory_rec -default-action=cd<CR>
	nnoremap <silent> [unite]b  :<C-u>Denite buffer file_mru<CR>
	nnoremap <silent> [unite]n  :<C-u>Denite dein<CR>
	nnoremap <silent> [unite]g  :<C-u>Denite grep<CR>
	nnoremap <silent> [unite]j  :<C-u>Denite file_point<CR>
	nnoremap <silent> [unite]h  :<C-u>Denite neoyank -default-action=cd<CR>

	" Open Unite with word under cursor or selection
	nnoremap <silent> <Leader>gf :DeniteCursorWord file_rec<CR>
	nnoremap <silent> <Leader>gg :DeniteCursorWord grep<CR><CR>
	vnoremap <silent> <Leader>gg
		\ :<C-u>call VSetSearch('/')<CR>:execute 'Denite grep -input='.@/<CR><CR>
endif

" }}}
if dein#tap('unite.vim') "{{{
	nnoremap <silent> [unite]u   :<C-u>Unite source<CR>
	nnoremap <silent> [unite]t   :<C-u>Unite tag -start-insert<CR>
	nnoremap <silent> [unite]T   :<C-u>Unite tag/include<CR>
	nnoremap <silent> [unite]l   :<C-u>Unite location_list<CR>
	nnoremap <silent> [unite]q   :<C-u>Unite quickfix<CR>
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
	nnoremap <silent> <Leader>gt :UniteWithCursorWord tag -start-insert<CR>
	vnoremap <silent> <Leader>gt :<C-u>call VSetSearch('/')<CR>:execute 'Unite tag -input='.@/<CR>

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
		silent! nunmap <buffer> gf
		silent! nunmap <buffer> -

		nnoremap <silent><buffer> gr  :<C-u>Unite grep:<C-R>=<SID>selected()<CR><CR>
		nnoremap <silent><buffer> gf  :<C-u>Unite file_rec/`has('nvim') ? 'neovim' : 'async'`:<C-R>=<SID>selected()<CR><CR>
		nnoremap <silent><buffer> gd  :<C-u>call <SID>change_vim_current_dir()<CR>
		nnoremap <silent><buffer><expr> sg  vimfiler#do_action('vsplit')
		nnoremap <silent><buffer><expr> sv  vimfiler#do_action('split')
		nnoremap <silent><buffer><expr> st  vimfiler#do_action('tabswitch')
		nmap <buffer> gx     <Plug>(vimfiler_execute_vimfiler_associated)
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

	" Changes the directory for all buffers in a tab
	function! s:change_vim_current_dir() "{{{
		let selected = s:selected(1)
		let b:vimfiler.current_dir = selected
		execute 'windo lcd '.fnameescape(selected)
		execute 'wincmd w'
		call vimfiler#force_redraw_screen()
		echo 'Changed local buffer working directory to `'.selected.'`'
	endfunction "}}}
endif

"}}}
if dein#tap('neosnippet.vim') "{{{
	imap <expr><C-o> neosnippet#expandable_or_jumpable()
		\ ? "\<Plug>(neosnippet_expand_or_jump)" : "\<ESC>o"
	xmap <silent><C-s>      <Plug>(neosnippet_register_oneshot_snippet)
	imap <silent><C-Space>  <Plug>(neosnippet_start_unite_snippet)
"	smap <silent>L     <Plug>(neosnippet_jump_or_expand)
"	xmap <silent>L     <Plug>(neosnippet_expand_target)
	echomsg
endif

"}}}
if dein#tap('emmet-vim') "{{{
	autocmd MyAutoCmd FileType html,css,jsx,javascript.jsx
		\ EmmetInstall
		\ | imap <buffer> <C-Return> <Plug>(emmet-expand-abbr)
endif

"}}}
if dein#tap('vim-operator-surround') "{{{
	map <silent>sa <Plug>(operator-surround-append)
	map <silent>sd <Plug>(operator-surround-delete)
	map <silent>sr <Plug>(operator-surround-replace)
	nmap <silent>saa <Plug>(operator-surround-append)<Plug>(textobj-multiblock-i)
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
	let g:committia_min_window_width = 70
	let g:committia_hooks = {}
	function! g:committia_hooks.edit_open(info)
		if a:info.vcs ==# 'git' && getline(1) ==# ''
			resize 4
			startinsert
		end
		imap <buffer><C-d> <Plug>(committia-scroll-diff-down-half)
		imap <buffer><C-u> <Plug>(committia-scroll-diff-up-half)
	endfunction
endif

"}}}
if dein#tap('vim-signature') "{{{
	let g:SignatureMarkTextHLDynamic = 1
	let g:SignatureMarkerTextHLDynamic = 1
	let g:SignaturePurgeConfirmation = 1
	let g:SignatureForceRemoveGlobal = 0
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
if dein#tap('vim-peekaboo') "{{{
	nnoremap <buffer> <silent> " :<c-u>call peekaboo#peek(v:count1, 'quote',  0)<cr>
	xnoremap <buffer> <silent> " :<c-u>call peekaboo#peek(v:count1, 'quote',  1)<cr>
	nnoremap <buffer> <silent> @ :<c-u>call peekaboo#peek(v:count1, 'replay', 0)<cr>
	inoremap <buffer> <silent> <c-r> <c-o>:call peekaboo#peek(1, 'ctrl-r',  0)<cr>
endif

"}}}
if dein#tap('vim-choosewin') "{{{
	nmap -         <Plug>(choosewin)
	nmap <Leader>- :<C-u>ChooseWinSwap<CR>
endif

"}}}
if dein#tap('jedi-vim') "{{{
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
		autocmd MyAutoCmd FileType python
			\ if has('python') || has('python3') |
			\   setlocal omnifunc=jedi#completions |
			\ else |
			\   setlocal omnifunc= |
			\ endif
	endif
endif

"}}}
if dein#tap('javascript-libraries-syntax.vim') "{{{
	let g:used_javascript_libs = 'jquery,flux,underscore,backbone,react'
endif

"}}}
if dein#tap('vim-gitgutter') "{{{
"	let g:gitgutter_realtime = 1
"	let g:gitgutter_eager = 0
	let g:gitgutter_map_keys = 0
	let g:gitgutter_sh = $SHELL

	nmap <Leader>hj <Plug>GitGutterNextHunk
	nmap <Leader>hk <Plug>GitGutterPrevHunk
	nmap <Leader>hs <Plug>GitGutterStageHunk
	nmap <Leader>hr <Plug>GitGutterUndoHunk
	nmap <Leader>hp <Plug>GitGutterPreviewHunk
endif

"}}}
if dein#tap('neomake') "{{{
	autocmd MyAutoCmd BufWritePost * call <SID>neomake_custom()
	function! s:neomake_custom()
		let filetypes = [
			\   'ansible', 'python', 'php', 'ruby', 'vim', 'go', 'sh',
			\   'javascript', 'javascript.jsx', 'json', 'css', 'yaml',
			\   'markdown', 'html'
			\ ]

		if empty(&buftype) && index(filetypes, &filetype) > -1
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
endif

"}}}
if dein#tap('vim-markdown') "{{{
	let g:vim_markdown_initial_foldlevel = 5
	let g:vim_markdown_new_list_item_indent = 2
	let g:vim_markdown_frontmatter = 1
	let g:vim_markdown_conceal = 0
endif

"}}}
if dein#tap('vim-gfm-syntax') "{{{
	let g:gfm_syntax_enable_always = 0
	let g:gfm_syntax_enable_filetypes = ['markdown']
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
if dein#tap('vim-findent') "{{{
	augroup findent
		autocmd!
		autocmd BufRead *.js*,*.html,*.css,.tern*
			\ call s:setupFindent()
	augroup END

	function! s:setupFindent()
		execute 'Findent! --no-warnings'
		if &expandtab
			IndentGuidesEnable
		else
			IndentGuidesDisable
		endif
	endfunction
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
if dein#tap('vim-anzu') "{{{
	let g:anzu_status_format = 'match %i of %l'

	nmap n n<Plug>(anzu-update-search-status)
	nmap N N<Plug>(anzu-update-search-status)
	nmap <silent> <Leader>cc :<C-u>call anzu#clear_search_status()<CR>
	autocmd MyAutoCmd CursorHold * call anzu#clear_search_status()
endif

"}}}
if dein#tap('vim-asterisk') "{{{
	map *   <Plug>(asterisk-g*)<Plug>(anzu-update-search-status)
	map g*  <Plug>(asterisk-*)<Plug>(anzu-update-search-status)
	map #   <Plug>(asterisk-g#)<Plug>(anzu-update-search-status)
	map g#  <Plug>(asterisk-#)<Plug>(anzu-update-search-status)

	map z*  <Plug>(asterisk-z*)<Plug>(anzu-update-search-status)
	map gz* <Plug>(asterisk-gz*)<Plug>(anzu-update-search-status)
	map z#  <Plug>(asterisk-z#)<Plug>(anzu-update-search-status)
	map gz# <Plug>(asterisk-gz#)<Plug>(anzu-update-search-status)
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
	xmap <silent> e <Plug>CamelCaseMotion_e
	omap <silent> e <Plug>CamelCaseMotion_e
	nmap <silent> w <Plug>CamelCaseMotion_w
	xmap <silent> w <Plug>CamelCaseMotion_w
	omap <silent> w <Plug>CamelCaseMotion_w
	nmap <silent> b <Plug>CamelCaseMotion_b
	xmap <silent> b <Plug>CamelCaseMotion_b
	omap <silent> b <Plug>CamelCaseMotion_b
endif

"}}}
if dein#tap('vim-textobj-multiblock') "{{{
	omap ab <Plug>(textobj-multiblock-a)
	omap ib <Plug>(textobj-multiblock-i)
	xmap ab <Plug>(textobj-multiblock-a)
	xmap ib <Plug>(textobj-multiblock-i)
endif

"}}}
if dein#tap('vim-textobj-function') "{{{
	omap af <Plug>(textobj-function-a)
	omap if <Plug>(textobj-function-i)
	xmap af <Plug>(textobj-function-a)
	xmap if <Plug>(textobj-function-i)
endif
"}}}

" vim: set ts=2 sw=2 tw=80 noet :
