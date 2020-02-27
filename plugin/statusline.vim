" Statusline
" ---

let s:stl  = " %7*%{&paste ? '=' : ''}%*"         " Paste symbol
let s:stl .= "%4*%{&readonly ? '' : '#'}%*"       " Modified symbol
let s:stl .= "%6*%{badge#mode('⚠ ', 'Z')}"        " Read-only symbol
let s:stl .= '%*%n'                               " Buffer number
let s:stl .= "%6*%{badge#modified('+')}%0*"       " Write symbol
let s:stl .= ' %1*%{badge#filename()}%* '         " Filename
let s:stl .= '%( %{badge#branch()} %)'           " Git branch name
let s:stl .= '%4*%(%{badge#syntax()} %)%*'        " Syntax lint
let s:stl .= "%4*%(%{badge#trails('␣%s')} %)%*"   " Whitespace
let s:stl .= '%3*%(%{badge#indexing()} %)%*'      " Indexing indicator
let s:stl .= '%3*%(%{badge#gitstatus()} %)%*'     " Git status
let s:stl .= '%='                                 " Align to right
let s:stl .= '%<'                                 " Truncate here
let s:stl .= '%{badge#format()} %4*%*'           " File format
let s:stl .= '%( %{&fenc} %)'                     " File encoding
let s:stl .= '%4*%*%( %{&ft} %)'                 " File type
let s:stl .= '%3*%2* %l/%2c%4p%% '               " Line and column

" Non-active Statusline
let s:stl_nc = " %{badge#mode('⚠ ', 'Z')}%n"   " Read-only symbol
let s:stl_nc .= "%6*%{badge#modified('+')}%*"  " Unsaved changes symbol
let s:stl_nc .= ' %{badge#filename()}'         " Relative supername
let s:stl_nc .= '%='                           " Align to right
let s:stl_nc .= '%{&ft} '                      " File type

" Status-line blacklist
let s:disable_statusline =
	\ 'defx\|denite\|vista\|tagbar\|undotree\|diff\|peekaboo\|sidemenu'

function! s:active()
	if &filetype ==# 'defx'
		let &l:statusline = '%y %<%=%{badge#filename()}%= %l/%L'
	elseif &filetype ==# 'magit'
		let &l:statusline = '%y %{badge#gitstatus()}%<%=%{badge#filename()}%= %l/%L'
	elseif &filetype !~# s:disable_statusline
		let &l:statusline = s:stl
	endif
endfunction

function! s:inactive()
	if &filetype ==# 'defx'
		let &l:statusline = '%y %= %l/%L'
	elseif &filetype ==# 'magit'
		let &l:statusline = '%y %{badge#gitstatus()}%= %l/%L'
	elseif &filetype !~# s:disable_statusline
		let &l:statusline = s:stl_nc
	endif
endfunction

augroup user_statusline
	autocmd!

	" Set active/inactive statusline templates
	autocmd VimEnter,ColorScheme,FileType,WinEnter,BufWinEnter * call s:active()
	autocmd WinLeave * call s:inactive()

	" Redraw on Vim events
	autocmd FileChangedShellPost,BufFilePost,BufNewFile,BufWritePost * redrawstatus

	" Redraw on Plugins custom events
	autocmd User ALELintPost,ALEFixPost redrawstatus
	autocmd User NeomakeJobFinished redrawstatus
	autocmd User GutentagsUpdating redrawstatus
	autocmd User CocStatusChange,CocGitStatusChange redrawstatus
	autocmd User CocDiagnosticChange redrawstatus
augroup END

" vim: set ts=2 sw=2 tw=80 noet :
