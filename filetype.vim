
" File Type Detection {{{1
"------------------------------------------------------------------------------

if exists('did_load_filetypes')
	finish
endif

augroup filetypedetect

	" Recognize Less for lazy-loading syntax
	autocmd BufNewFile,BufRead *.less setfiletype less

	autocmd BufRead,BufEnter *i3/config setfiletype i3

	" Tmux
	autocmd BufNewFile,BufRead *tmux.conf*,Tmuxfile,tmux/config setfiletype tmux

	" changelog.vim
	autocmd BufNewFile,BufRead *.changelog setfiletype changelog

	" Ansible
	autocmd BufNewFile,BufRead */group_vars/*,*/host_vars/* setfiletype yaml

	" Misc ini
	autocmd BufNewFile,BufRead php.ini          setfiletype dosini
	autocmd BufNewFile,BufRead php-fpm.conf     setfiletype dosini
	autocmd BufNewFile,BufRead my.cnf           setfiletype dosini

	" Archlinux PKGBUILD
	autocmd BufNewFile,BufRead PKGBUILD setfiletype PKGBUILD
	autocmd BufNewFile,BufRead .AURINFO setfiletype PKGBUILD
	autocmd BufNewFile,BufRead PKGBUILD.vim      setfiletype vim
	autocmd BufNewFile,BufRead *.install,install setfiletype sh

	" systemd
	autocmd BufNewFile,BufRead *.automount setfiletype systemd
	autocmd BufNewFile,BufRead *.mount     setfiletype systemd
	autocmd BufNewFile,BufRead *.path      setfiletype systemd
	autocmd BufNewFile,BufRead *.service   setfiletype systemd
	autocmd BufNewFile,BufRead *.socket    setfiletype systemd
	autocmd BufNewFile,BufRead *.swap      setfiletype systemd
	autocmd BufNewFile,BufRead *.target    setfiletype systemd
	autocmd BufNewFile,BufRead *.timer     setfiletype systemd

	" Markdown
	autocmd BufRead,BufNewFile *.mkd,*.markdown,*.md,*.mdown,*.mkdn
		\ setlocal filetype=mkd spell expandtab autoindent
			\ formatoptions=tcroqn2 comments=n:>

	autocmd BufRead,BufNewFile *.py
			\ setlocal tabstop=2 softtabstop=2 shiftwidth=2

augroup END
