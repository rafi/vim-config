
" Commands
"---------------------------------------------------------
" Autocommands {{{
augroup MyAutoCmd

	" More eager than 'autoread'.
	autocmd WinEnter,FocusGained * checktime

	" If session is loaded, write session file on quit
	autocmd VimLeavePre *
		\ if ! empty(v:this_session) && ! exists('g:SessionLoad')
		\ |   execute 'mksession! '.fnameescape(v:this_session)
		\ | endif

	" Write tags automatically in the background for Git repositories.
	autocmd BufWritePost *
		\ if finddir('.git/', getcwd().';') !=? '' && get(g:, 'ctags_compile', 0)
		\ |   call <SID>shell_bg('ctags', 's:tags_job_handler')
		\ | endif

	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid or when inside an event handler
	autocmd BufReadPost *
		\ if &ft !~ '^git\c' && ! &diff && line("'\"") > 0 && line("'\"") <= line("$")
		\|   exe 'normal! g`"zvzz'
		\| endif

	" Disable paste and/or update diff when leaving insert mode
	autocmd InsertLeave *
			\ if &paste | setlocal nopaste mouse=a | echo 'nopaste' | endif |
			\ if &l:diff | diffupdate | endif

	" Open Quickfix window automatically
	autocmd QuickFixCmdPost [^l]* leftabove copen
		\ | wincmd p | redraw!
	autocmd QuickFixCmdPost l* leftabove lopen
		\ | wincmd p | redraw!

	" Fix window position of help/quickfix
	autocmd FileType help if &l:buftype ==# 'help'
		\ | wincmd L | endif
	autocmd FileType qf   if &l:buftype ==# 'quickfix'
		\ | wincmd J | endif

augroup END

" }}}
" Commands {{{
" --------

command! ZoomToggle call s:ZoomToggle()

" Save and persist session
command! -bar -complete=file -nargs=? SessionSave
	\ call s:session_save(<q-args>)

" Remove end of line white space.
command! -range=% WhitespaceErase call <SID>WhitespaceErase(<line1>,<line2>)

" Diff command credits: https://github.com/Shougo/shougo-s-github
" Display diff with the file.
command! -nargs=1 -complete=file Diff vertical diffsplit <args>
" Display diff from last save.
command! DiffOrig vert new | setlocal bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" Disable diff mode.
command! -nargs=0 Undiff setlocal nodiff noscrollbind wrap

" }}}
" Functions {{{
"----------

" Makes * and # work on visual mode too.
" See: http://github.com/nelstrom/vim-visual-star-search
function! VSetSearch(cmdtype) "{{{
	let temp = @s
	normal! gv"sy
	let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
	let @s = temp
endfunction "}}}

" Append modeline after last line in buffer
" See: http://vim.wikia.com/wiki/Modeline_magic
function! AppendModeline() "{{{
	let l:modeline = printf(' vim: set ts=%d sw=%d tw=%d %set :',
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, '%s', l:modeline, '')
	call append(line('$'), l:modeline)
endfunction "}}}

" Nicer fold text
" See: http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! FoldText() "{{{
	let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
	let lines_count = v:foldend - v:foldstart + 1
	let lines_count_text = '| ' . printf('%10s', lines_count . ' lines') . ' |'
	let foldchar = matchstr(&fillchars, 'fold:\zs.')
	let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
	let foldtextend = lines_count_text . repeat(foldchar, 8)
	let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
	return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction "}}}

function! s:tags_job_handler(job_id, data, event)
	if a:event ==? 'stdout'
		echomsg 'Tags index completed. ('.self.project.')'.join(a:data)
	elseif a:event ==? 'stderr'
		echoerr 'Unable to run ctags for '.self.project.': '.join(a:data)
	endif
endfunction

function! s:shell_bg(cmd, callback)
	if ! executable(a:cmd)
		return
	endif

	let l:msg = '['.getcwd().'] Running background command: '.a:cmd
	if has('nvim')
		echo l:msg
		let l:job = jobstart([a:cmd], {
			\   'project': ProjectName(),
			\   'on_stdout': function(a:callback),
			\   'on_stderr': function(a:callback)
			\ })
	elseif exists('*vimproc#system_bg')
		echo l:msg
		call vimproc#system_bg(a:cmd)
	else
		echoerr 'For background tasks please use Neovim or install vimproc plugin.'
	endif
endfunction

function! ProjectName()
	let dir = ProjectRoot()
	return fnamemodify(dir ? dir : getcwd(), ':t')
endfunction

function! ProjectRoot()
	let dir = getbufvar('%', 'project_dir')
	let curr_dir = getcwd()
	if empty(dir) || getbufvar('%', 'project_dir_last_cwd') != curr_dir
		let patterns = ['.git', '.git/', '_darcs/', '.hg/', '.bzr/', '.svn/']
		for pattern in patterns
			let is_dir = stridx(pattern, '/') != -1
			let match = is_dir ? finddir(pattern, curr_dir.';')
				\ : findfile(pattern, curr_dir.';')
			if ! empty(match)
				let dir = fnamemodify(match, is_dir ? ':p:h:h' : ':p:h')
				call setbufvar('%', 'project_dir', dir)
				call setbufvar('%', 'project_dir_last_cwd', curr_dir)
				break
			endif
		endfor
	endif
	return dir
endfunction

function! s:session_save(file) abort
	if ! isdirectory(g:session_directory)
		call mkdir(g:session_directory, 'p')
	endif
	let file_name = empty(a:file) ? block#project() : a:file
	let file_path = g:session_directory.file_name.'.vim'
	execute 'mksession! '.fnameescape(file_path)
	echo 'Tracking session in '.fnamemodify(file_path, ':~:.')
	let v:this_session = file_path
endfunction

" Zoom / Restore window
function! s:ZoomToggle() "{{{
	if exists('t:zoomed') && t:zoomed > -1
		execute t:zoom_winrestcmd
		let t:zoomed = -1
	else
		let t:zoom_winrestcmd = winrestcmd()
		resize
		vertical resize
		let t:zoomed = bufnr('%')
	endif
endfunction "}}}

" Whitespace "{{{
if v:version >= 702
	augroup WhitespaceMatch "{{{
		autocmd!
		autocmd VimEnter,BufWinEnter * call <SID>ToggleWhitespace('n')
		autocmd InsertEnter * call <SID>ToggleWhitespace('i')
		autocmd InsertLeave * call <SID>ToggleWhitespace('n')
	augroup END "}}}
endif

function! s:ToggleWhitespace(mode) "{{{
	if &buftype =~? 'nofile\|help\|quickfix' || &filetype ==? ''
		return
	elseif a:mode ==? ''
		call matchdelete(w:whitespace_match_id)
		return
	else
		let l:pattern = (a:mode ==# 'i') ? '\s\+\%#\@<!$' : '\s\+$\| \+\ze\t'
		if exists('w:whitespace_match_id')
			call matchdelete(w:whitespace_match_id)
			call matchadd('ExtraWhitespace', l:pattern, 10, w:whitespace_match_id)
		else
			let w:whitespace_match_id = matchadd('ExtraWhitespace', l:pattern)
		endif
	endif
endfunction "}}}

function! s:WhitespaceErase(line1, line2) "{{{
	let l:save_cursor = getpos('.')
	silent! execute ':'.a:line1.','.a:line2.'s/\s\+$//'
	call setpos('.', l:save_cursor)
endfunction "}}}

"}}}

" vim: set ts=2 sw=2 tw=80 noet :
