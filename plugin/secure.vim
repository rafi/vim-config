"
" Prevent various Vim features from keeping the contents of pass(1) password
" files (or any other purely temporary files) in plaintext on the system.
"
" Either append this to the end of your .vimrc, or install it as a plugin with
" a plugin manager like Tim Pope's Pathogen.
"
" Author: Tom Ryder <tom@sanctum.geek.nz>
"

" Don't backup files in temp directories or shm
if exists('&backupskip')
	set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
endif

" Don't keep swap files in temp directories or shm
if has('autocmd')
	augroup swapskip
		autocmd!
		silent! autocmd BufNewFile,BufReadPre
			\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
			\ setlocal noswapfile
	augroup END
endif

" Don't keep undo files in temp directories or shm
if has('persistent_undo') && has('autocmd')
	augroup undoskip
		autocmd!
		silent! autocmd BufWritePre
			\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
			\ setlocal noundofile
	augroup END
endif

" Don't keep viminfo for files in temp directories or shm
if has('viminfo')
	if has('autocmd')
		augroup viminfoskip
			autocmd!
			silent! autocmd BufNewFile,BufReadPre
				\ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
				\ setlocal viminfo=
		augroup END
	endif
endif
