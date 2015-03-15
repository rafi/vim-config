
" smartchr
"---------

augroup MyAutoCmd

	autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
	autocmd FileType perl,php inoremap <buffer> <expr> . smartchr#loop('.', '->', '..')
	autocmd FileType perl,php inoremap <buffer> <expr> - smartchr#loop('-', '->')
	autocmd FileType lisp,scheme,clojure inoremap <buffer> <expr> = =

	autocmd FileType vim,sh,php,c,perl
			\ inoremap <buffer> <expr> , smartchr#one_of(', ', ',')
			\| inoremap <buffer> <expr> =
			\  search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')
			\  ? '<bs>= ' : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
			\  : smartchr#one_of(' = ', '=', ' == ')

	autocmd FileType haskell,int-ghci
				\ inoremap <buffer> <expr> + smartchr#loop('+', ' ++ ')
				\| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
				\| inoremap <buffer> <expr> $ smartchr#loop(' $ ', '$')
				\| inoremap <buffer> <expr> \ smartchr#loop('\ ', '\')
				\| inoremap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
				\| inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..')

	autocmd FileType scala
				\ inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
				\| inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' => ')
				\| inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
				\| inoremap <buffer> <expr> . smartchr#loop('.', ' => ')

	autocmd FileType eruby
				\ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
				\| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')

augroup END

" vim: set ts=2 sw=2 tw=80 noet :
