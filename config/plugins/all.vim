
" Plugin Settings
"---------------------------------------------------------

if dein#tap('denite.nvim') "{{{
	nnoremap <silent> [Tools]r  :<C-u>Denite -resume<CR>
	nnoremap <silent> [Tools]f  :<C-u>Denite file_rec<CR>
	nnoremap <silent> [Tools]d  :<C-u>Denite directory_rec -default-action=cd<CR>
	nnoremap <silent> [Tools]b  :<C-u>Denite buffer file_old -default-action=switch<CR>
	nnoremap <silent> [Tools]l  :<C-u>Denite location_list -buffer-name=list<CR>
	nnoremap <silent> [Tools]q  :<C-u>Denite quickfix -buffer-name=list<CR>
	nnoremap <silent> [Tools]n  :<C-u>Denite dein -no-quit<CR>
	nnoremap <silent> [Tools]g  :<C-u>Denite grep -buffer-name=grep<CR>
	nnoremap <silent> [Tools]j  :<C-u>Denite file_point<CR>
	nnoremap <silent> [Tools]k  :<C-u>Denite mark -buffer-name=list<CR>
	nnoremap <silent> [Tools]s  :<C-u>Denite session<CR>
	nnoremap <silent> [Tools]mu :<C-u>Denite mpc -buffer-name=mpc<CR>
	nnoremap <silent> [Tools]/  :<C-u>Denite line<CR>
	nnoremap <silent> [Tools]*  :<C-u>DeniteCursorWord line<CR>

	" Open Denite with word under cursor or selection
	nnoremap <silent> <Leader>gf :DeniteCursorWord file_rec<CR>
	nnoremap <silent> <Leader>gg
		\ :Denite -buffer-name=grep grep:::<C-R>=expand('<cword>')<CR><CR>
	vnoremap <silent> <Leader>gg
		\ :<C-u>call VSetSearch('/')<CR>:execute 'Denite -buffer-name=grep grep:::'.@/<CR><CR>
endif

" }}}
if dein#tap('tagbar') "{{{
	nnoremap <silent> <Leader>o   :<C-u>TagbarOpenAutoClose<CR>

	" Also use h/l to open/close folds
	let g:tagbar_map_closefold = ['h', '-', 'zc']
	let g:tagbar_map_openfold = ['l', '+', 'zo']
endif

"}}}
if dein#tap('nerdtree') "{{{
	let g:NERDTreeMapOpenSplit = 'sv'
	let g:NERDTreeMapOpenVSplit = 'sg'
	let g:NERDTreeMapOpenInTab = 'st'

	cnoreabbrev E NERDTreeToggle
	nnoremap <silent> [Tools]e :<C-u>NERDTreeToggle<CR>
	nnoremap <silent> [Tools]a :<C-u>NERDTreeFind<CR>

	autocmd MyAutoCmd FileType nerdtree call s:nerdtree_settings()
	function! s:nerdtree_settings() abort
		set expandtab " To enable vim-indent-guides
		nmap <buffer> N  :<C-u>call NERDTreeAddNode()<CR>
	endfunction
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
"if dein#tap('vim-bookmarks') "{{{
"	let g:bookmark_auto_save_dir = $VARPATH.'/bookmarks'
"	nnoremap <silent> <Plug>BookmarkShowAll :<C-u>BookmarkShowAll<CR>
"	nnoremap <silent> <Plug>BookmarkNext :<C-u>BookmarkNext<CR>
"	nnoremap <silent> <Plug>BookmarkPrev :<C-u>BookmarkPrev<CR>
"	nnoremap <silent> <Plug>BookmarkToggle :<C-u>let b:bm_sync=0<CR>:<C-u>BookmarkToggle<CR>
"	nnoremap <silent> <Plug>BookmarkAnnotate :<C-u>let b:bm_sync=0<CR>:<C-u>BookmarkAnnotate<CR>
"	nmap ma <Plug>BookmarkShowAll
"	nmap mn <Plug>BookmarkNext
"	nmap mp <Plug>BookmarkPrev
"	nmap mm <Plug>BookmarkToggle
"	nmap mi <Plug>BookmarkAnnotate
"endif

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
if dein#tap('python_match.vim') "{{{
	nmap <buffer> {{ [%
	nmap <buffer> }} ]%
endif

"}}}
if dein#tap('tabman.vim') "{{{
	nmap <silent> <Leader>ta <Plug>Tabman
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
	nmap <Leader>- :<C-u>ChooseWinSwapStay<CR>
endif

"}}}
if dein#tap('jedi-vim') "{{{
	let g:jedi#completions_command = ''
	let g:jedi#documentation_command = 'K'
	let g:jedi#use_splits_not_buffers = 'right'
	let g:jedi#goto_command = '<C-]>'
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
if dein#tap('phpcomplete-extended') "{{{
	autocmd MyAutoCmd FileType php
		\   nmap <silent> <unique> K <Plug>(phpcomplete-extended-doc)
		\ | nmap <silent> <unique> <C-]> <Plug>(phpcomplete-extended-goto)
		\ | nmap <silent> <unique> <Leader>a <Plug>(phpcomplete-extended-add-use)
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
if dein#tap('undotree') "{{{
	nnoremap <Leader>gu :UndotreeToggle<CR>
endif

"}}}
if dein#tap('vim-leader-guide') "{{{
	nmap  <Leader>ll  <Plug>leaderguide-global
	nmap  <Leader>lb  <Plug>leaderguide-buffer
	nnoremap  <Leader>l<Space>  :<C-u>LeaderGuide ';'<CR>
endif

"}}}
if dein#tap('vim-online-thesaurus') "{{{
	nnoremap <silent> <Leader>K :<C-u>OnlineThesaurusCurrentWord<CR>
	nnoremap <silent> <Leader>? :<C-u>Thesaurus<CR>
endif

"}}}
if dein#tap('vim-asterisk') "{{{
	map *   <Plug>(asterisk-g*)
	map g*  <Plug>(asterisk-*)
	map #   <Plug>(asterisk-g#)
	map g#  <Plug>(asterisk-#)

	map z*  <Plug>(asterisk-z*)
	map gz* <Plug>(asterisk-gz*)
	map z#  <Plug>(asterisk-z#)
	map gz# <Plug>(asterisk-gz#)
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
	omap <silent> a, <Plug>SidewaysArgumentTextobjA
	xmap <silent> a, <Plug>SidewaysArgumentTextobjA
	omap <silent> i, <Plug>SidewaysArgumentTextobjI
	xmap <silent> i, <Plug>SidewaysArgumentTextobjI
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
if dein#tap('vim-commentary') "{{{
	xmap <Leader>v  <Plug>Commentary
	nmap <Leader>v  <Plug>CommentaryLine
	xmap gc  <Plug>Commentary
	nmap gc  <Plug>Commentary
	omap gc  <Plug>Commentary
	nmap gcc <Plug>CommentaryLine
	nmap cgc <Plug>ChangeCommentary
	nmap gcu <Plug>Commentary<Plug>Commentary
endif

"}}}
if dein#tap('vim-textobj-multiblock') "{{{
	omap <silent> ab <Plug>(textobj-multiblock-a)
	omap <silent> ib <Plug>(textobj-multiblock-i)
	xmap <silent> ab <Plug>(textobj-multiblock-a)
	xmap <silent> ib <Plug>(textobj-multiblock-i)
endif

"}}}
if dein#tap('vim-textobj-function') "{{{
	omap <silent> af <Plug>(textobj-function-a)
	omap <silent> if <Plug>(textobj-function-i)
	xmap <silent> af <Plug>(textobj-function-a)
	xmap <silent> if <Plug>(textobj-function-i)
endif
"}}}

" vim: set ts=2 sw=2 tw=80 noet :
