" Statusline
" ---

let s:stl  = " %7*%{&paste ? '=' : ''}%*"         " Paste symbol
let s:stl .= "%4*%{&readonly ? '' : '#'}%*"       " Modified symbol
let s:stl .= "%6*%{badge#mode('🔒', '🔎')}"       " Read-only symbol
let s:stl .= '%*%n'                               " Buffer number
let s:stl .= "%6*%{badge#modified('+')}%0*"       " Write symbol
let s:stl .= ' %1*%{badge#filename()}%* '         " Filename
let s:stl .= '%{%badge#syntax()%}'                " Syntax lint
let s:stl .= "%4*%(%{badge#trails('␣%s')} %)%*"   " Whitespace
let s:stl .= '%<'                                 " Start truncating here
let s:stl .= '%( %{badge#branch()} %)'           " Git branch name
let s:stl .= '%3*%(%{badge#indexing()} %)%*'      " Indexing indicator
let s:stl .= '%3*%(%{badge#gitstatus()} %)%*'     " Git status
let s:stl .= '%='                                 " Align to right
let s:stl .= '%{badge#format()} '                 " File format
let s:stl .= '%(%4*%* %{&fenc} %)'               " File encoding
let s:stl .= '%(%4*%* %{&ft} %)'                 " File type
let s:stl .= '%3*%2* %l/%2c%4p%% '               " Line and column

" Non-active Statusline
let s:stl_nc = " %{badge#mode('🔒', '🔎')}%n"  " Read-only symbol
let s:stl_nc .= "%6*%{badge#modified('+')}%*"  " Unsaved changes symbol
let s:stl_nc .= ' %{badge#filename()}'         " Relative supername
let s:stl_nc .= ' %4*%{%badge#syntax()%}%*'    " Syntax lint
let s:stl_nc .= '%='                           " Align to right
let s:stl_nc .= '%{&ft} '                      " File type

" Status-line blacklist
let s:statusline_filetypes_ignore = get(g:, 'statusline_filetypes_ignore',
	\ 'defx\|denite\|vista\|undotree\|diff\|sidemenu\|qf\|Trouble')

let s:statusline_filetypes = get(g:, 'statusline_filetypes', {
	\ 'defx': ['%{fnamemodify(getcwd(), ":t")}%=%l/%L'],
	\ 'magit': [
	\   '%y %{badge#gitstatus()}%<%=%{fnamemodify(badge#filename(), ":~")}%=%l/%L',
	\   '%y %{badge#gitstatus()}%= %l/%L'],
	\ 'minimap': [' '],
	\ 'Trouble': ['%y %=%-15(%l,%c%V%) %P'],
	\ 'denite-filter': ['%#Normal#'],
	\ 'lsp-quickpick-filter': ['%#Normal#'],
	\ })
" %t%{exists('w:quickfix_title')? ' '.w:quickfix_title : ''} %=%-15(%l,%c%V%) %P

" s:set_state replaces current statusline
function! s:set_state(filetype, index, default)
	" Skip statusline render during session loading
	if &previewwindow || exists('g:SessionLoad') "|| empty(a:filetype)
		return
	endif
	if has_key(s:statusline_filetypes, a:filetype)
		let l:states = s:statusline_filetypes[a:filetype]
		let l:want = get(l:states, a:index, l:states[0])
		if &l:statusline != l:want
			let &l:statusline = l:want
		endif
	elseif a:filetype !~# s:statusline_filetypes_ignore
		if &l:statusline != a:default
			let &l:statusline = a:default
		endif
	endif
endfunction

" Bind to Vim events
augroup user_statusline
	autocmd!

	" Set active/inactive statusline templates
	autocmd VimEnter,ColorScheme, * let &l:statusline = s:stl
	autocmd FileType,WinEnter,BufWinEnter * call s:set_state(&filetype, 0, s:stl)
	autocmd WinLeave * call s:set_state(&filetype, 1, s:stl_nc)

	" Redraw on Vim events
	autocmd FileChangedShellPost,BufFilePost,BufNewFile,BufWritePost * redrawstatus

	" Redraw on Plugins custom events
	" autocmd User ALELintPost,ALEFixPost redrawstatus
	" autocmd User NeomakeJobFinished redrawstatus
	" autocmd User GutentagsUpdating redrawstatus
	" coc
	" autocmd User CocStatusChange,CocGitStatusChange redrawstatus
	" autocmd User CocDiagnosticChange redrawstatus
	" vim-lsp
	" autocmd User lsp_diagnostics_updated redrawstatus
augroup END

" vim: set ts=2 sw=2 tw=80 noet :
