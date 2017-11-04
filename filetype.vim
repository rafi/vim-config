
" File-type Detection
" ------------------------------------------------

if exists('did_load_filetypes')
	finish
endif

augroup filetypedetect

	autocmd BufNewFile,BufRead */inventory/*.{yml,yaml}    setfiletype ansible
	autocmd BufNewFile,BufRead */inventories/*.{yml,yaml}  setfiletype ansible
	autocmd BufNewFile,BufRead */playbooks/*.{yml,yaml}    setfiletype ansible

	autocmd BufNewFile,BufRead .tern-project setfiletype json
	autocmd BufNewFile,BufRead .jsbeautifyrc setfiletype json
	autocmd BufNewFile,BufRead .eslintrc     setfiletype json
	autocmd BufNewFile,BufRead .jscsrc       setfiletype json

	autocmd BufNewFile,BufReadPost *.{feature,story} setfiletype cucumber
	autocmd BufNewFile,BufRead Jenkinsfile           setfiletype groovy
	autocmd BufNewFile,BufRead Tmuxfile,tmux/config  setfiletype tmux

augroup END

" vim: set ts=2 sw=2 tw=80 noet :
