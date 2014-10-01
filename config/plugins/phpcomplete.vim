
" phpcomplete
" -----------

function! PhpSyntaxOverride()
	hi! def link phpDocTags phpDefine
endfunction

augroup phpSyntaxOverride
	autocmd!
	autocmd FileType php call PhpSyntaxOverride()
augroup END

" vim: set ts=2 sw=2 tw=80 noet :
