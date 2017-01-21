
" Plugin Settings
"---------------------------------------------------------

if dein#tap('denite.nvim') "{{{
	nnoremap <silent> [unite]r  :<C-u>Denite -resume<CR>
	nnoremap <silent> [unite]f  :<C-u>Denite file_rec<CR>
	nnoremap <silent> [unite]d  :<C-u>Denite directory_rec -default-action=cd<CR>
	nnoremap <silent> [unite]b  :<C-u>Denite buffer file_old<CR>
	nnoremap <silent> [unite]l  :<C-u>Denite location_list -buffer-name=list<CR>
	nnoremap <silent> [unite]q  :<C-u>Denite quickfix -buffer-name=list<CR>
	nnoremap <silent> [unite]n  :<C-u>Denite dein -no-quit<CR>
	nnoremap <silent> [unite]g  :<C-u>Denite grep -buffer-name=grep<CR>
	nnoremap <silent> [unite]j  :<C-u>Denite file_point<CR>
	nnoremap <silent> [unite]k  :<C-u>Denite mark -buffer-name=list<CR>
	nnoremap <silent> [unite]s  :<C-u>Denite session<CR>
	nnoremap <silent> [unite]mu :<C-u>Denite mpc -buffer-name=mpc<CR>
	nnoremap <silent> [unite]/  :<C-u>Denite line<CR>
	nnoremap <silent> [unite]*  :<C-u>DeniteCursorWord line<CR>

	" Open Unite with word under cursor or selection
	nnoremap <silent> <Leader>gf :DeniteCursorWord file_rec<CR>
	nnoremap <silent> <Leader>gg :DeniteCursorWord grep -buffer-name=grep<CR><CR>
	vnoremap <silent> <Leader>gg
		\ :<C-u>call VSetSearch('/')<CR>:execute 'Denite grep -buffer-name=grep -input='.@/<CR><CR>
endif

" }}}
if dein#tap('tagbar') "{{{
	let g:tagbar_iconchars = ['▷', '◢']

	let g:tagbar_map_openfold = ['l', '+', 'zo']
	let g:tagbar_map_closefold = ['h', '-', 'zc']

	nnoremap <silent> <Leader>o   :<C-u>TagbarOpenAutoClose<CR>
endif

" }}}
if dein#tap('unite.vim') "{{{
	nnoremap <silent> [unite]ma  :<C-u>Unite mapping -silent<CR>
	nnoremap <silent> [unite]mt  :<C-u>Unite tab -select=`tabpagenr()-1`<CR>

	" Unite window mappings {{{
	autocmd MyAutoCmd FileType unite call s:unite_settings()
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

		nnoremap <silent><buffer> gr  :<C-u>Denite grep:<C-R>=<SID>selected()<CR> -buffer-name=grep<CR>
		nnoremap <silent><buffer> gf  :<C-u>Denite file_rec:<C-R>=<SID>selected()<CR><CR>
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
	smap <silent>L          <Plug>(neosnippet_jump_or_expand)
	xmap <silent>L          <Plug>(neosnippet_expand_target)
endif

"}}}
if dein#tap('emmet-vim') "{{{
	autocmd MyAutoCmd FileType html,css,jsx,javascript,javascript.jsx
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
if dein#tap('vim-indent-guides') "{{{
	nmap <silent><Leader>ti :<C-u>IndentGuidesToggle<CR>
endif

"}}}
if dein#tap('vim-markology') "{{{
	noremap <silent> mm :MarkologyPlaceMark<CR>
	noremap <silent> mp :MarkologyPrevLocalMarkPos<CR>
	noremap <silent> mn :MarkologyNextLocalMarkPos<CR>
	noremap <silent> m- :MarkologyClearMark<CR>
	noremap <silent> m/ :MarkologyLocationList<CR>
endif

"}}}
if dein#tap('committia.vim') "{{{
	let g:committia_hooks = {}
	function! g:committia_hooks.edit_open(info)
		imap <buffer><C-d> <Plug>(committia-scroll-diff-down-half)
		imap <buffer><C-u> <Plug>(committia-scroll-diff-up-half)

		setlocal winminheight=1 winheight=1
		resize 10
		startinsert
	endfunction
endif

"}}}
if dein#tap('goyo.vim') "{{{
	nnoremap <Leader>G :Goyo<CR>
endif

"}}}
if dein#tap('vim-peekaboo') "{{{
	nnoremap <buffer> <silent> " :<c-u>call peekaboo#peek(v:count1, 'quote',  0)<cr>
	xnoremap <buffer> <silent> " :<c-u>call peekaboo#peek(v:count1, 'quote',  1)<cr>
	nnoremap <buffer> <silent> @ :<c-u>call peekaboo#peek(v:count1, 'replay', 0)<cr>
	inoremap <buffer> <silent> <c-r> <c-o>:call peekaboo#peek(1, 'ctrl-r',  0)<cr>
endif

"}}}
if dein#tap('vimwiki') "{{{
	nnoremap <silent> <Leader>W :<C-u>VimwikiIndex<CR>
endif

"}}}
if dein#tap('vim-choosewin') "{{{
	nmap -         <Plug>(choosewin)
	nmap <Leader>- :<C-u>ChooseWinSwap<CR>
endif

"}}}
if dein#tap('jedi-vim') "{{{
	let g:jedi#completions_command = ''
	let g:jedi#documentation_command = 'K'
	let g:jedi#use_splits_not_buffers = 'right'
	let g:jedi#goto_command = '<leader>d'
	let g:jedi#goto_assignments_command = '<leader>g'
	let g:jedi#rename_command = '<Leader>r'
	let g:jedi#usages_command = '<Leader>n'
endif

"}}}
if dein#tap('vim-gitgutter') "{{{
	nmap <Leader>hj <Plug>GitGutterNextHunk
	nmap <Leader>hk <Plug>GitGutterPrevHunk
	nmap <Leader>hs <Plug>GitGutterStageHunk
	nmap <Leader>hr <Plug>GitGutterUndoHunk
	nmap <Leader>hp <Plug>GitGutterPreviewHunk
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
if dein#tap('caw.vim') "{{{
	nmap gc <Plug>(caw:prefix)
	xmap gc <Plug>(caw:prefix)
	nmap <Leader>V <Plug>(caw:tildepos:toggle)
	xmap <Leader>V <Plug>(caw:tildepos:toggle)
	nmap <Leader>v <Plug>(caw:zeropos:toggle)
	xmap <Leader>v <Plug>(caw:zeropos:toggle)
endif

"}}}
if dein#tap('undotree') "{{{
	nnoremap <Leader>gu :UndotreeToggle<CR>
endif

"}}}
if dein#tap('dictionary.vim') "{{{
	nnoremap <silent> <Leader>? :<C-u>Dictionary -no-duplicate<CR>
endif

"}}}
if dein#tap('vim-online-thesaurus') "{{{
	nnoremap <silent> <Leader>K :<C-u>OnlineThesaurusCurrentWord<CR>
endif

"}}}
if dein#tap('vim-anzu') "{{{
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
if dein#tap('dsf.vim') "{{{
	nmap dsf <Plug>DsfDelete
	nmap csf <Plug>DsfChange
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
