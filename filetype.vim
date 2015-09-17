
" File-type Detection
" ------------------------------------------------

if exists('did_load_filetypes')
	finish
endif

augroup filetypedetect

	autocmd BufNewFile,BufRead */inventory/*        setf ansible
	autocmd BufNewFile,BufRead */playbooks/*/*.yml  setf ansible
	autocmd BufNewFile,BufRead *.j2                 setf jinja
	autocmd BufNewFile,BufRead Tmuxfile,tmux/config set ft=tmux | compiler tmux

augroup END

" }}}
" vim: set ts=2 sw=2 tw=80 noet :
