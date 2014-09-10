function! PhpSyntaxOverride()
	hi! def link phpDocTags phpDefine
endfunction

augroup phpSyntaxOverride
	autocmd!
	autocmd FileType php call PhpSyntaxOverride()
augroup END
