" vim-lsp-settings settings :)
" ---

" Apply settings for languages that registered LSP
function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal foldmethod=expr
		\ foldexpr=lsp#ui#vim#folding#foldexpr()
		\ foldtext=lsp#ui#vim#folding#foldtext()

	nmap <silent><buffer> K      <Plug>(lsp-hover)
	nmap <silent><buffer> gdf   :tab LspDefinition<CR>
	nmap <silent><buffer> pdf   <Plug>(lsp-peek-definition)
	nmap <silent><buffer> pdc   <Plug>(lsp-peek-declaration)
	nmap <silent><buffer> pdi    <Plug>(lsp-peek-implementation)
	nmap <silent><buffer> ptd    <Plug>(lsp-peek-type-definition)
	nmap <silent><buffer> pth    <Plug>(lsp-type-hierarchy)
	nmap <silent><buffer> psh    <Plug>(lsp-signature-help)
	nmap <silent><buffer> grf    <Plug>(lsp-references)
	nmap         <buffer> <F2>   <Plug>(lsp-rename)
endfunction

augroup lsp_user_plugin
	autocmd!

	autocmd User lsp_buffer_enabled call <SID>on_lsp_buffer_enabled()

	autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END
