
" File-type Detection
" ------------------------------------------------

if exists('did_load_filetypes')
	finish
endif

augroup filetypedetect

	autocmd BufNewFile,BufRead */playbooks/*.{yml,yaml}  setfiletype yaml.ansible
	autocmd BufNewFile,BufRead */inventory/*             setfiletype ansible_hosts

	autocmd BufRead,BufNewFile */.kube/config set filetype=yaml
	autocmd BufRead,BufNewFile */templates/*.yaml,*/templates/*.tpl set filetype=yaml.gotexttmpl

	autocmd BufNewFile,BufRead .tern-project setfiletype json
	autocmd BufNewFile,BufRead .jsbeautifyrc setfiletype json
	autocmd BufNewFile,BufRead .eslintrc     setfiletype json
	autocmd BufNewFile,BufRead .jscsrc       setfiletype json

	autocmd BufNewFile,BufReadPost *.{feature,story} setfiletype cucumber
	autocmd BufNewFile,BufRead Jenkinsfile           setfiletype groovy
	autocmd BufNewFile,BufRead Tmuxfile,tmux/config  setfiletype tmux

	"autocmd BufNewFile,BufReadPost *.mmd setfiletype markdown

augroup END

" vim: set ts=2 sw=2 tw=80 noet :
