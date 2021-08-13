" Plugin Keyboard-Mappings
" ---

if dein#tap('fern.vim')
	nnoremap <LocalLeader>e <cmd>Fern -toggle -drawer .<CR>
	nnoremap <LocalLeader>a <cmd>Fern -reveal=% -drawer .<CR>
endif

if dein#tap('symbols-outline.nvim')
	nnoremap <Leader>o <cmd>SymbolsOutline<CR>
endif

if dein#tap('vim-vsnip')
	imap <expr><C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
	smap <expr><C-l> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
endif

if dein#tap('emmet-vim')
	autocmd user_events FileType html,css,vue,javascript,javascriptreact,svelte
		\ EmmetInstall
"		\ | imap <silent><buffer> <C-y> <Plug>(emmet-expand-abbr)
endif

if dein#tap('vim-sandwich')
	nmap <silent> sa <Plug>(operator-sandwich-add)
	xmap <silent> sa <Plug>(operator-sandwich-add)
	omap <silent> sa <Plug>(operator-sandwich-g@)
	nmap <silent> sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
	xmap <silent> sd <Plug>(operator-sandwich-delete)
	nmap <silent> sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
	xmap <silent> sr <Plug>(operator-sandwich-replace)
	nmap <silent> sdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
	nmap <silent> srb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
	omap ir <Plug>(textobj-sandwich-auto-i)
	xmap ir <Plug>(textobj-sandwich-auto-i)
	omap ab <Plug>(textobj-sandwich-auto-a)
	xmap ab <Plug>(textobj-sandwich-auto-a)
	omap is <Plug>(textobj-sandwich-query-i)
	xmap is <Plug>(textobj-sandwich-query-i)
	omap as <Plug>(textobj-sandwich-query-a)
	xmap as <Plug>(textobj-sandwich-query-a)
endif

if dein#tap('vim-niceblock')
	silent! xmap I  <Plug>(niceblock-I)
	silent! xmap gI <Plug>(niceblock-gI)
	silent! xmap A  <Plug>(niceblock-A)
endif

if dein#tap('accelerated-jk')
	nmap <silent> j <Plug>(accelerated_jk_gj)
	nmap <silent> k <Plug>(accelerated_jk_gk)
endif

if dein#tap('vim-edgemotion')
	map gj <Plug>(edgemotion-j)
	map gk <Plug>(edgemotion-k)
	xmap gj <Plug>(edgemotion-j)
	xmap gk <Plug>(edgemotion-k)
endif

if dein#tap('vim-quickhl')
	nmap <Leader>mt <Plug>(quickhl-manual-this)
	xmap <Leader>mt <Plug>(quickhl-manual-this)
endif

if dein#tap('vim-sidemenu')
	nmap <Leader>l <Plug>(sidemenu)
	xmap <Leader>l <Plug>(sidemenu-visual)
endif

if dein#tap('vim-indent-guides')
	nmap <Leader>ti <cmd>IndentGuidesToggle<CR>
endif

if dein#tap('vim-signature')
	let g:SignatureIncludeMarks = 'abcdefghijkloqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
	let g:SignatureMap = {
		\ 'Leader':            'm',
		\ 'ListBufferMarks':   'm/',
		\ 'ListBufferMarkers': 'm?',
		\ 'PlaceNextMark':     'm,',
		\ 'ToggleMarkAtLine':  'mm',
		\ 'PurgeMarksAtLine':  'm-',
		\ 'DeleteMark':        'dm',
		\ 'PurgeMarks':        'm<Space>',
		\ 'PurgeMarkers':      'm<BS>',
		\ 'GotoNextLineAlpha': "']",
		\ 'GotoPrevLineAlpha': "'[",
		\ 'GotoNextSpotAlpha': '`]',
		\ 'GotoPrevSpotAlpha': '`[',
		\ 'GotoNextLineByPos': "]'",
		\ 'GotoPrevLineByPos': "['",
		\ 'GotoNextSpotByPos': 'mn',
		\ 'GotoPrevSpotByPos': 'mp',
		\ 'GotoNextMarker':    ']-',
		\ 'GotoPrevMarker':    '[-',
		\ 'GotoNextMarkerAny': ']=',
		\ 'GotoPrevMarkerAny': '[=',
		\ }
endif

if dein#tap('nvim-bqf')
	nmap <Leader>q <cmd>lua require('user').qflist.toggle()<CR>
endif

if dein#tap('goto-preview')
	nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
	nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
	nnoremap gpc <cmd>lua require('goto-preview').close_all_win()<CR>
endif

if dein#tap('committia.vim')
	let g:committia_hooks = {}
	function! g:committia_hooks.edit_open(info)
		setlocal winminheight=1 winheight=10
		resize 10
		imap <buffer><C-d> <Plug>(committia-scroll-diff-down-half)
		imap <buffer><C-u> <Plug>(committia-scroll-diff-up-half)
		imap <buffer><C-f> <Plug>(committia-scroll-diff-down-page)
		imap <buffer><C-b> <Plug>(committia-scroll-diff-up-page)
		imap <buffer><C-j> <Plug>(committia-scroll-diff-down)
		imap <buffer><C-k> <Plug>(committia-scroll-diff-up)
	endfunction
endif

if dein#tap('vim-shot-f')
	nmap f  <Plug>(shot-f-f)
	nmap F  <Plug>(shot-f-F)
	nmap t  <Plug>(shot-f-t)
	nmap T  <Plug>(shot-f-T)
	xmap f  <Plug>(shot-f-f)
	xmap F  <Plug>(shot-f-F)
	xmap t  <Plug>(shot-f-t)
	xmap T  <Plug>(shot-f-T)
	omap f  <Plug>(shot-f-f)
	omap F  <Plug>(shot-f-F)
	omap t  <Plug>(shot-f-t)
	omap T  <Plug>(shot-f-T)
endif

if dein#tap('todo-comments.nvim')
	nnoremap <LocalLeader>d <cmd>TodoTelescope<CR>
endif

if dein#tap('trouble.nvim')
	nnoremap <leader>e <cmd>TroubleToggle lsp_document_diagnostics<CR>
	nnoremap <leader>r <cmd>TroubleToggle lsp_workspace_diagnostics<CR>
	nnoremap <leader>xq <cmd>TroubleToggle quickfix<CR>
	nnoremap <leader>xl <cmd>TroubleToggle loclist<CR>
	nnoremap ]t <cmd>lua require("trouble").next({skip_groups = true, jump = true})<CR>
	nnoremap [t <cmd>lua require("trouble").previous({skip_groups = true, jump = true})<CR>
	nnoremap gR <cmd>TroubleToggle lsp_references<CR>
endif

if dein#tap('diffview.nvim')
	nnoremap <Leader>gv <cmd>DiffviewOpen<CR>
endif

if dein#tap('vimwiki')
	nnoremap <Leader>W <cmd>VimwikiIndex<CR>
endif

if dein#tap('vim-choosewin')
	nmap -         <Plug>(choosewin)
	nmap <Leader>- <cmd>ChooseWinSwapStay<CR>
endif

if dein#tap('neogit')
	nnoremap <Leader>mg <cmd>Neogit<CR>
endif

if dein#tap('gina.vim')
	nnoremap <silent> <leader>ga <cmd>Gina add %:p<CR>
	nnoremap <silent> <leader>gd <cmd>Gina compare<CR>
	nnoremap <silent> <leader>gc <cmd>Gina commit<CR>
	nnoremap <silent> <leader>gb <cmd>Gina blame --width=40<CR>
	nnoremap <silent> <leader>gs <cmd>Gina status -s<CR>
	nnoremap <silent> <leader>gl <cmd>Gina log --graph --all<CR>
	nnoremap <silent> <leader>gF <cmd>Gina! fetch<CR>
	" nnoremap <silent> <leader>gp <cmd>Gina! push<CR>
	nnoremap <silent> <leader>go <cmd>,Gina browse :<CR>
	xnoremap <silent> <leader>go :Gina browse :<CR>
endif

if dein#tap('zen-mode.nvim')
	nnoremap <silent> <Leader>z <cmd>ZenMode<CR>
endif

if dein#tap('rest.nvim')
	nmap <silent> ,ht <Plug>RestNvim
endif

if dein#tap('any-jump.vim')
	" Normal mode: Jump to definition under cursor
	nnoremap <silent> <leader>ii <cmd>AnyJump<CR>

	" Visual mode: jump to selected text in visual mode
	xnoremap <silent> <leader>ii <cmd>AnyJumpVisual<CR>

	" Normal mode: open previous opened file (after jump)
	nnoremap <silent> <leader>ib <cmd>AnyJumpBack<CR>

	" Normal mode: open last closed search window again
	nnoremap <silent> <leader>il <cmd>AnyJumpLastResults<CR>
endif

if dein#tap('undotree')
	nnoremap <Leader>gu <cmd>UndotreeToggle<CR>
endif

if dein#tap('thesaurus_query.vim')
	nnoremap <silent> <Leader>K <cmd>ThesaurusQueryReplaceCurrentWord<CR>
endif

if dein#tap('vim-asterisk')
	map *   <Plug>(asterisk-g*)
	map g*  <Plug>(asterisk-*)
	map #   <Plug>(asterisk-g#)
	map g#  <Plug>(asterisk-#)

	map z*  <Plug>(asterisk-z*)
	map gz* <Plug>(asterisk-gz*)
	map z#  <Plug>(asterisk-z#)
	map gz# <Plug>(asterisk-gz#)
endif

if dein#tap('sideways.vim')
	nnoremap <silent> <, <cmd>SidewaysLeft<CR>
	nnoremap <silent> >, <cmd>SidewaysRight<CR>
	nnoremap <silent> [, <cmd>SidewaysJumpLeft<CR>
	nnoremap <silent> ], <cmd>SidewaysJumpRight<CR>
	omap <silent> a, <Plug>SidewaysArgumentTextobjA
	xmap <silent> a, <Plug>SidewaysArgumentTextobjA
	omap <silent> i, <Plug>SidewaysArgumentTextobjI
	xmap <silent> i, <Plug>SidewaysArgumentTextobjI
endif

if dein#tap('splitjoin.vim')
	nmap sj <cmd>SplitjoinJoin<CR>
	nmap sk <cmd>SplitjoinSplit<CR>
endif

if dein#tap('linediff.vim')
	xnoremap <Leader>mdf :Linediff<CR>
	xnoremap <Leader>mda :LinediffAdd<CR>
	nnoremap <Leader>mds <cmd>LinediffShow<CR>
	nnoremap <Leader>mdr <cmd>LinediffReset<CR>
endif

if dein#tap('dsf.vim')
	nmap dsf <Plug>DsfDelete
	nmap csf <Plug>DsfChange
endif

if dein#tap('caw.vim')
	function! InitCaw() abort
		if &l:modifiable && &buftype ==# '' && &filetype !=# 'gitrebase'
			xmap <buffer> <Leader>V <Plug>(caw:wrap:toggle)
			nmap <buffer> <Leader>V <Plug>(caw:wrap:toggle)
			xmap <buffer> <Leader>v <Plug>(caw:hatpos:toggle)
			nmap <buffer> <Leader>v <Plug>(caw:hatpos:toggle)
			nmap <buffer> gc <Plug>(caw:prefix)
			xmap <buffer> gc <Plug>(caw:prefix)
			nmap <buffer> gcc <Plug>(caw:hatpos:toggle)
			xmap <buffer> gcc <Plug>(caw:hatpos:toggle)
		else
			silent! nunmap <buffer> <Leader>V
			silent! xunmap <buffer> <Leader>V
			silent! nunmap <buffer> <Leader>v
			silent! xunmap <buffer> <Leader>v
			silent! nunmap <buffer> gc
			silent! xunmap <buffer> gc
			silent! nunmap <buffer> gcc
			silent! xunmap <buffer> gcc
		endif
	endfunction
	autocmd user_events FileType * call InitCaw()
	call InitCaw()
endif

" vim: set ts=2 sw=2 tw=80 noet :
