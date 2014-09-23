
" smartchr
"---------
inoremap <expr> , smartchr#one_of(',', ', ')
inoremap <expr> = smartchr#one_of(' = ', ' == ', ' === ')

augroup MyAutoCmd
  " Substitute .. into ->
	autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
	autocmd FileType perl,php inoremap <buffer> <expr> . smartchr#loop('.', '->', '..')
	autocmd FileType perl,php inoremap <buffer> <expr> - smartchr#loop('-', '->')
	autocmd FileType vim inoremap <buffer> <expr> . smartchr#loop('.', '..', '...')

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
