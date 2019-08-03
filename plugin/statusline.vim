
" Statusline {{{
let s:stl  = " %7*%{&paste ? '=' : ''}%*"         " Paste symbol
let s:stl .= "%4*%{&readonly ? '' : '#'}%*"       " Modifide symbol
let s:stl .= "%6*%{badge#mode('⚠ ', 'Z')}"        " Read-only symbol
let s:stl .= '%*%n'                               " Buffer number
let s:stl .= "%6*%{badge#modified('+')}%0*"       " Write symbol
let s:stl .= ' %1*%{badge#filename()}%*'          " Filename
let s:stl .= ' %<'                                " Truncate here
let s:stl .= '%( %{badge#branch()} %)'           " Git branch name
let s:stl .= "%4*%(%{badge#trails('⤐ %s')} %)"   " Whitespace
let s:stl .= '%(%{badge#syntax()} %)%*'           " syntax check
" let s:stl .= '%{coc#status()} '
let s:stl .= '%='                                 " Align to right
let s:stl .= '%{badge#format()} %4*%*'           " File format
let s:stl .= '%( %{&fenc} %)'                     " File encoding
let s:stl .= '%4*%*%( %{&ft} %)'                 " File type
let s:stl .= '%3*%2* %l/%2c%4p%% '               " Line and column
let s:stl .= '%{badge#indexing()}%*'              " Indexing tags indicator

" Non-active Statusline {{{
let s:stl_nc = " %{badge#mode('⚠ ', 'Z')}%n"   " Readonly & buffer
let s:stl_nc .= "%6*%{badge#modified('+')}%*"  " Write symbol
let s:stl_nc .= ' %{badge#filename()}'         " Relative supername
let s:stl_nc .= '%='                           " Align to right
let s:stl_nc .= '%{&ft} '                      " File type
" }}}

let s:disable_statusline =
	\ 'denite\|defx\|vista\|tagbar\|undotree\|diff\|peekaboo\|sidemenu'

function! s:setstatus()
	if &filetype =~? 'defx'
		let &l:statusline = '%y %<%=%{b:defx["context"]["buffer_name"]}%= %l/%L'
	elseif &filetype !~? s:disable_statusline
		let &l:statusline = s:stl
	endif
endfunction

function! s:setstatusinactive()
	if &filetype =~? 'defx'
		let &l:statusline = '%y %= %l/%L'
	elseif &filetype !~? s:disable_statusline
		let &l:statusline = s:stl_nc
	endif
endfunction

augroup user_statusline
	autocmd!

	autocmd FileType,WinEnter,BufWinEnter,BufReadPost * call s:setstatus()
	autocmd WinLeave * call s:setstatusinactive()
	autocmd BufNewFile,ShellCmdPost,BufWritePost * call s:setstatus()
	autocmd FileChangedShellPost,ColorScheme * call s:setstatus()
	autocmd FileReadPre,ShellCmdPost,FileWritePost * call s:setstatus()
	autocmd User CocStatusChange,CocGitStatusChange call s:setstatus()
	autocmd User CocDiagnosticChange call s:setstatus()
augroup END

" }}}
