" vim-lsp
" ---

" Apply settings for languages that registered LSP
function! s:on_lsp_buffer_enabled() abort
	if empty(globpath(&rtp, 'autoload/lsp.vim'))
		finish
	endif
	setlocal omnifunc=lsp#complete

	if exists('+tagfunc')
		setlocal tagfunc=lsp#tagfunc
	endif

	" Folds are really slow
	" setlocal foldmethod=expr
	"	\ foldexpr=lsp#ui#vim#folding#foldexpr()
	"	\ foldtext=lsp#ui#vim#folding#foldtext()

	" Prefer native help with vim files
	if &filetype != 'vim'
		nmap <silent><buffer> K  <Plug>(lsp-hover)
	endif

	nmap <silent><buffer> gr     <Plug>(lsp-references)
	nmap <silent><buffer> gi     <Plug>(lsp-peek-implementation)
	nmap <silent><buffer> gy     <Plug>(lsp-peek-type-definition)
	nmap <silent><buffer> <C-]>  <Plug>(lsp-definition)
	nmap <silent><buffer> g<C-]> <Plug>(lsp-peek-definition)
	nmap <silent><buffer> gd     <Plug>(lsp-peek-declaration)
	nmap <silent><buffer> gY     <Plug>(lsp-type-hierarchy)
	nmap <silent><buffer> gA     <Plug>(lsp-code-action)
	nmap <silent><buffer> ,s     <Plug>(lsp-signature-help)
	nmap <silent><buffer> [d     <Plug>(lsp-previous-diagnostic)
	nmap <silent><buffer> ]d     <Plug>(lsp-next-diagnostic)
	nmap <buffer> <Leader>rn     <Plug>(lsp-rename)
	nmap <buffer> <Leader>F      <plug>(lsp-document-format)
	vmap <buffer> <Leader>F      <plug>(lsp-document-range-format)
endfunction

augroup lsp_user_plugin
	autocmd!

	autocmd User lsp_buffer_enabled call <SID>on_lsp_buffer_enabled()

	" autocmd CompleteDone * if pumvisible() == 0 | pclose | endif

	" autocmd VimResized * call <SID>fix_preview_max_width()

	" autocmd FileType markdown.lsp-hover
	"	\ nnoremap <buffer> K <Nop>
	"	\| nnoremap <silent><buffer>q :pclose<CR>

augroup END
