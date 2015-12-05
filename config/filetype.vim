
" File Types {{{
"-------------------------------------------------

augroup MyAutoCmd

	" Update filetype on save if empty
	autocmd BufWritePost *
				\ if &l:filetype ==# '' || exists('b:ftdetect')
				\ |   unlet! b:ftdetect
				\ |   filetype detect
				\ | endif

	autocmd FileType crontab setlocal nobackup nowritebackup

	autocmd FileType gitcommit setlocal spell

	autocmd FileType gitcommit,qfreplace setlocal nofoldenable

	autocmd FileType zsh setlocal foldenable foldmethod=marker

	" Improved include pattern
	autocmd FileType html
				\ setlocal includeexpr=substitute(v:fname,'^\\/','','') |
				\ setlocal path+=./;/

	autocmd FileType markdown
				\ setlocal spell expandtab autoindent
					\ formatoptions=tcroqn2 comments=n:>

	autocmd FileType apache setlocal path+=./;/

	autocmd FileType cam setlocal nonumber synmaxcol=10000

	autocmd FileType go highlight default link goErr WarningMsg |
				\ match goErr /\<err\>/

augroup END

" }}}
" Internal Plugin Settings " {{{
" ------------------------

" PHP "{{{
let g:php_folding = 2
let g:php_phpdoc_folding = 1
let g:PHP_removeCRwhenUnix = 0

" }}}
" Python "{{{
let g:python_highlight_all = 1

" }}}
" XML "{{{
let g:xml_syntax_folding = 1

" }}}
" Vim "{{{
let g:vimsyntax_noerror = 1
"let g:vim_indent_cont = 0

" }}}
" Bash "{{{
let g:is_bash = 1

" }}}
" Java "{{{
let g:java_highlight_functions = 'style'
let g:java_highlight_all = 1
let g:java_highlight_debug = 1
let g:java_allow_cpp_keywords = 1
let g:java_space_errors = 1
let g:java_highlight_functions = 1

" }}}
" JavaScript "{{{
let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1

" }}}
" Vim script "{{{
" augroup: a
" function: f
" lua: l
" perl: p
" ruby: r
" python: P
" tcl: t
" mzscheme: m
let g:vimsyn_folding = 'af'

" }}}
" Markdown "{{{
let g:markdown_fenced_languages = [
	\  'coffee',
	\  'css',
	\  'erb=eruby',
	\  'javascript',
	\  'js=javascript',
	\  'json=javascript',
	\  'ruby',
	\  'sass',
	\  'xml',
	\  'vim'
	\]

" }}}
" }}}
" vim: set ts=2 sw=2 tw=80 noet :
