
" File-type Detection
" ------------------------------------------------

if exists('did_load_filetypes')
	finish
endif

augroup filetypedetect

	autocmd BufNewFile,BufReadPost *.feature,*.story setf cucumber

	autocmd BufNewFile,BufRead */inventory/*         setf ansible
	autocmd BufNewFile,BufRead */playbooks/*/*.yml   setf ansible

	autocmd BufNewFile,BufRead .tern-project         setf json

	autocmd BufNewFile,BufRead Tmuxfile,tmux/config  setf tmux

"	autocmd BufNewFile,BufRead *.j2                  setf jinja

augroup END

" vim: set ts=2 sw=2 tw=80 noet :
