" File Types
" ===

augroup user_plugin_filetype " {{{
	autocmd!

	" Reload vim config automatically
	autocmd BufWritePost $VIM_PATH/{*.vim,*.yaml,vimrc} nested
		\ source $MYVIMRC | redraw

	" Highlight current line only on focused window
	autocmd WinEnter,BufEnter,InsertLeave *
		\ if ! &cursorline && &filetype !~# '^\(denite\|clap_\)' && ! &pvw
		\ | setlocal cursorline
		\ | endif
	autocmd WinLeave,BufLeave,InsertEnter *
		\ if &cursorline && &filetype !~# '^\(denite\|clap_\)' && ! &pvw
		\ | setlocal nocursorline
		\ | endif

	" Automatically set read-only for files being edited elsewhere
	autocmd SwapExists * nested let v:swapchoice = 'o'

	" Update diff comparison once leaving insert mode
	autocmd InsertLeave * if &l:diff | diffupdate | endif

	" Equalize window dimensions when resizing vim window
	autocmd VimResized * tabdo wincmd =

	" Force write shada on leaving nvim
	autocmd VimLeave * if has('nvim') | wshada! | else | wviminfo! | endif

	" Check if file changed when its window is focus, more eager than 'autoread'
	autocmd FocusGained * checktime

	autocmd Syntax * if line('$') > 5000 | syntax sync minlines=200 | endif

	" Neovim terminal settings
	if has('nvim')
		autocmd TermOpen * setlocal modifiable
		autocmd TermClose * buffer #
		" autocmd TextYankPost *
		"	\ silent! lua vim.highlight.on_yank {higroup="IncSearch", timeout=150}
	endif

	" Update filetype on save if empty
	autocmd BufWritePost * nested
		\ if &l:filetype ==# '' || exists('b:ftdetect')
		\ |   unlet! b:ftdetect
		\ |   filetype detect
		\ | endif

	" Reload Vim script automatically if setlocal autoread
	autocmd BufWritePost,FileWritePost *.vim nested
		\ if &l:autoread > 0 | source <afile> |
		\   echo 'source ' . bufname('%') |
		\ endif

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	autocmd BufReadPost *
		\ if &ft !~# 'commit' && ! &diff &&
		\      line("'\"") >= 1 && line("'\"") <= line("$")
		\|   execute 'normal! g`"zvzz'
		\| endif

	autocmd FileType crontab setlocal nobackup nowritebackup

	autocmd FileType yaml.docker-compose setlocal expandtab

	autocmd FileType gitcommit setlocal spell

	autocmd FileType gitcommit,qfreplace setlocal nofoldenable

	" https://webpack.github.io/docs/webpack-dev-server.html#working-with-editors-ides-supporting-safe-write
	autocmd FileType css,javascript,javascriptreact setlocal backupcopy=yes

	autocmd FileType php
		\ setlocal matchpairs-=<:> iskeyword+=\\ path+=/usr/local/share/pear

	autocmd FileType python
		\ setlocal expandtab smarttab nosmartindent
		\ | setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80

	autocmd FileType html setlocal path+=./;/

	autocmd FileType markdown
		\ setlocal expandtab spell conceallevel=0
		\ | setlocal autoindent formatoptions=tcroqn2 comments=n:>

	autocmd FileType apache setlocal path+=./;/

augroup END " }}}

" Internal Plugin Settings  {{{
" ------------------------

" PHP {{{
let g:PHP_removeCRwhenUnix = 0

" }}}
" Python {{{
let g:python_highlight_all = 1
" let g:python_highlight_builtins = 1
" let g:python_highlight_exceptions = 1
" let g:python_highlight_string_format = 1
" let g:python_highlight_doctests = 1
" let g:python_highlight_class_vars = 1
" let g:python_highlight_operators = 1

" }}}
" Vim {{{
let g:vimsyntax_noerror = 1
let g:vim_indent_cont = &shiftwidth

" }}}
" Bash {{{
let g:is_bash = 1

" }}}
" Java {{{
let g:java_highlight_functions = 'style'
let g:java_highlight_all = 1
let g:java_highlight_debug = 1
let g:java_allow_cpp_keywords = 1
let g:java_space_errors = 1
let g:java_highlight_functions = 1

" }}}
" JavaScript {{{
let g:SimpleJsIndenter_BriefMode = 1
let g:SimpleJsIndenter_CaseIndentLevel = -1

" }}}
" Ruby {{{
let g:ruby_no_expensive = 1

" }}}
" Folding {{{
" augroup: a
" function: f
let g:vimsyn_folding = 'af'
let g:tex_fold_enabled = 1
let g:xml_syntax_folding = 1
let g:php_folding = 2
let g:php_phpdoc_folding = 1
let g:perl_fold = 1
" }}}
" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
