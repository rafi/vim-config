" vim-lsp-settings settings :)
" ---

" Apply settings for languages that registered LSP
function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal foldmethod=expr
		\ foldexpr=lsp#ui#vim#folding#foldexpr()
		\ foldtext=lsp#ui#vim#folding#foldtext()

	nmap <silent><buffer> K      <Plug>(lsp-hover)
	nmap <silent><buffer> <C-]>  <Plug>(lsp-definition)
	nmap <silent><buffer> g<C-]> <Plug>(lsp-peek-definition)
	nmap <silent><buffer> gd     <Plug>(lsp-peek-declaration)
	nmap <silent><buffer> gi     <Plug>(lsp-peek-implementation)
	nmap <silent><buffer> gy     <Plug>(lsp-peek-type-definition)
	nmap <silent><buffer> gY     <Plug>(lsp-type-hierarchy)
	nmap <silent><buffer> ,s     <Plug>(lsp-signature-help)
	nmap <silent><buffer> gr     <Plug>(lsp-references)
	nmap         <buffer> <F2>   <Plug>(lsp-rename)
endfunction

augroup lsp_user_plugin
	autocmd!

	autocmd User lsp_buffer_enabled call <SID>on_lsp_buffer_enabled()

	autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
