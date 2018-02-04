
" NERDTree
" --------
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinSize = 25
let g:NERDTreeCascadeOpenSingleChildDir = 1
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeShowHidden = 1
let g:NERDTreeRespectWildIgnore = 0
let g:NERDTreeAutoDeleteBuffer = 0
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeBookmarksFile = $VARPATH.'/treemarks'
let NERDTreeIgnore = [
	\ '\.git$', '\.hg$', '\.svn$', '\.stversions$', '\.pyc$', '\.svn$',
	\ '\.DS_Store$', '\.sass-cache$', '__pycache__$', '\.egg-info$', '\.cache$'
	\ ]

autocmd MyAutoCmd FileType nerdtree call s:nerdtree_settings()

function! s:nerdtree_settings() abort
	setlocal expandtab " Enabling vim-indent-guides
	vertical resize 25
endfunction

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
autocmd MyAutoCmd WinEnter * if exists('t:NERDTreeBufName') &&
	\ bufwinnr(t:NERDTreeBufName) != -1 && winnr("$") == 1 | q | endif

" if the current window is NERDTree, move focus to the next window
autocmd MyAutoCmd TabLeave * call s:NERDTreeUnfocus()
function! s:NERDTreeUnfocus()
	if exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) == winnr()
		let l:winNum = 1
		while (l:winNum <= winnr('$'))
			let l:buf = winbufnr(l:winNum)

			if buflisted(l:buf) && getbufvar(l:buf, '&modifiable') == 1 &&
					\ ! empty(getbufvar(l:buf, '&buftype'))
				exec l:winNum.'wincmd w'
				return
			endif
			let l:winNum = l:winNum + 1
		endwhile
		wincmd w
	endif
endfunction

" Private helpers {{{
function! s:SID()
	if ! exists('s:sid')
		let s:sid = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
	endif
	return s:sid
endfunction
let s:SNR = '<SNR>'.s:SID().'_'

function! s:get_containing_dir(node)
	let path = a:node.path
	if ! path.isDirectory || ! a:node.isOpen
		let path = path.getParent()
	endif
	return path.str()
endfunction
" }}}

" Custom plugins
" ---

" Plugin: Open diff split on current file {{{
" ---
call NERDTreeAddKeyMap({
	\ 'key': 'gd',
	\ 'callback': s:SNR.'diff',
	\ 'quickhelpText': 'open diff on current file',
	\ 'scope': 'FileNode' })

function! s:diff(node)
	wincmd w
	diffthis
	execute 'vsplit '.fnameescape(a:node.path.str())
	diffthis
endfunction
" }}}

" Plugin: Jump to project root / user home {{{
" ---
call NERDTreeAddKeyMap({
	\ 'key': '&',
	\ 'callback': s:SNR.'jump_project_root',
	\ 'quickhelpText': 'Open current git root' })

call NERDTreeAddKeyMap({
	\ 'key': 'gh',
	\ 'callback': s:SNR.'jump_home',
	\ 'quickhelpText': 'open user home directory' })

function! s:jump_project_root()
	let project_dir = badge#root()
	if ! empty(project_dir)
		call s:_set_root(project_dir)
	endif
endfunction

function! s:jump_home()
	call s:_set_root($HOME)
endfunction

function! s:_set_root(dir)
	let path = g:NERDTreePath.New(a:dir)
	let node = g:NERDTreeDirNode.New(path, b:NERDTree)
	call b:NERDTree.changeRoot(node)
endfunction
" }}}

" Plugin: Create a new file or dir in path {{{
" ---
call NERDTreeAddKeyMap({
	\ 'key': 'N',
	\ 'callback': s:SNR.'create_in_path',
	\ 'quickhelpText': 'Create file or dir',
	\ 'scope': 'Node' })

function! s:create_in_path(node)
	if a:node.path.isDirectory && ! a:node.isOpen
		call a:node.parent.putCursorHere(0, 0)
	endif

	call NERDTreeAddNode()
endfunction
" }}}

" Plugin: Find and grep in path using Denite {{{
" ---
call NERDTreeAddKeyMap({
	\ 'key': 'gf',
	\ 'callback': s:SNR.'find_in_path',
	\ 'quickhelpText': 'Search in dir',
	\ 'scope': 'Node' })
call NERDTreeAddKeyMap({
	\ 'key': 'gr',
	\ 'callback': s:SNR.'grep_dir',
	\ 'quickhelpText': 'Grep in dir',
	\ 'scope': 'Node' })

function! s:find_in_path(node)
	execute 'Denite file_rec:'.s:get_containing_dir(a:node)
endfunction

function! s:grep_dir(node)
	execute 'Denite -buffer-name=grep grep:'.s:get_containing_dir(a:node)
endfunction
" }}}

" Plugin: Yank path {{{
" ---
call NERDTreeAddKeyMap({
	\ 'key': 'yy',
	\ 'callback': s:SNR.'yank_path',
	\ 'quickhelpText': 'yank current node',
	\ 'scope': 'Node' })

function! s:yank_path(node)
	let l:path = a:node.path.str()
	call setreg('*', l:path)
	echomsg 'Yank node: '.l:path
endfunction
" }}}

" Plugin: Toggle width {{{
" ---
call NERDTreeAddKeyMap({
	\ 'key': 'w',
	\ 'callback': s:SNR.'toggle_width',
	\ 'quickhelpText': 'Toggle window width' })

function! s:toggle_width()
	let l:max = 0
	for l:z in range(1, line('$'))
		let l:len = len(getline(l:z))
		if l:len > l:max
			let l:max = l:len
		endif
	endfor
	exe 'vertical resize '.(l:max == winwidth('.') ? g:NERDTreeWinSize : l:max)
endfunction
" }}}

" Menu-item: Modify .local.vimrc of project {{{
" ---
call NERDTreeAddMenuItem({
	\ 'text': '(l)ocal rc',
	\ 'shortcut': 'l',
	\ 'callback': s:SNR.'modify_localvimrc'})

function! s:modify_localvimrc()
	let current_dir = g:NERDTreeDirNode.GetSelected().path.str({'format': 'Cd'})
	if empty(current_dir)
		echoerr 'Unable to find current directory'
		return
	endif
	let lvimrc_path = current_dir.'/.local.vimrc'
	let cwd = getcwd()
	if ! filereadable(lvimrc_path)
		call writefile([
			\ 'lcd <sfile>:h',
			\ '" set isk+=!,?',
			\ ],
			\ lvimrc_path)
	endif
	wincmd w
	execute 'vsplit '.fnameescape(lvimrc_path)
endfunction
" }}}

" Plugin: Smart h/l navigation {{{
" @see https://github.com/jballanc/nerdtree-space-keys
" ---
call NERDTreeAddKeyMap({
	\ 'key':           'l',
	\ 'callback':      s:SNR.'descendTree',
	\ 'quickhelpText': 'open tree and go to first child',
	\ 'scope':         'DirNode' })
call NERDTreeAddKeyMap({
	\ 'key':           'l',
	\ 'callback':      s:SNR.'openFile',
	\ 'quickhelpText': 'open file',
	\ 'scope':         'FileNode' })
call NERDTreeAddKeyMap({
	\ 'key':           'h',
	\ 'callback':      s:SNR.'closeOrAscendTree',
	\ 'quickhelpText': 'close dir or move to parent dir',
	\ 'scope':         'DirNode' })
call NERDTreeAddKeyMap({
	\ 'key':           'h',
	\ 'callback':      s:SNR.'ascendTree',
	\ 'quickhelpText': 'move to parent dir',
	\ 'scope':         'FileNode' })

function! s:descendTree(dirnode)
	call a:dirnode.open()
	call b:NERDTree.render()
	if a:dirnode.getChildCount() > 0
		let chld = a:dirnode.getChildByIndex(0, 1)
		call chld.putCursorHere(0, 0)
	end
endfunction

function! s:openFile(filenode)
	call a:filenode.activate({'reuse': 'all', 'where': 'p'})
endfunction

function! s:closeOrAscendTree(dirnode)
	if a:dirnode.isOpen
		call a:dirnode.close()
		call b:NERDTree.render()
	else
		call s:ascendTree(a:dirnode)
	endif
endfunction

function! s:ascendTree(node)
	let parent = a:node.parent
	if parent != {}
		call parent.putCursorHere(0, 0)
		if parent.isOpen
			call parent.close()
			call b:NERDTree.render()
		end
	end
endfunction
" }}}

" Plugin: Execute file with system associated utility {{{
" ---
call NERDTreeAddKeyMap({
	\ 'key': 'x',
	\ 'callback': s:SNR.'execute_system_associated',
	\ 'quickhelpText': 'Execute system associated',
	\ 'scope': 'FileNode' })

function! s:execute_system_associated(filenode)
	let current_dir = getcwd()
	let path = a:filenode.parent.path.str()

	" if exists(g:nerdtree_plugin_open_cmd)
	" 	let cmd = g:nerdtree_plugin_open_cmd.' '.path
	" 	call system(cmd)
	" endif

	" Snippet from vital.vim
	try
		execute (haslocaldir() ? 'lcd' : 'cd') fnameescape(path)
		let filename = fnamemodify(a:filenode.path.str(), ':p')

		let s:is_unix = has('unix')
		let s:is_windows = has('win16') || has('win32') || has('win64') || has('win95')
		let s:is_cygwin = has('win32unix')
		let s:is_mac = !s:is_windows && !s:is_cygwin
					\ && (has('mac') || has('macunix') || has('gui_macvim') ||
					\   (!isdirectory('/proc') && executable('sw_vers')))
		" As of 7.4.122, the system()'s 1st argument is converted internally by Vim.
		" Note that Patch 7.4.122 does not convert system()'s 2nd argument and
		" return-value. We must convert them manually.
		let s:need_trans = v:version < 704 || (v:version == 704 && !has('patch122'))

		" Detect desktop environment.
		if s:is_windows
			" For URI only.
			if s:need_trans
				let filename = iconv(filename, &encoding, 'char')
			endif
			" Note:
			"   # and % required to be escaped (:help cmdline-special)
			silent execute printf(
						\ '!start rundll32 url.dll,FileProtocolHandler %s',
						\ escape(filename, '#%'),
						\)
		elseif s:is_cygwin
			" Cygwin.
			call system(printf('%s %s', 'cygstart',
						\ shellescape(filename)))
		elseif executable('xdg-open')
			" Linux.
			call system(printf('%s %s &', 'xdg-open',
						\ shellescape(filename)))
		elseif exists('$KDE_FULL_SESSION') && $KDE_FULL_SESSION ==# 'true'
			" KDE.
			call system(printf('%s %s &', 'kioclient exec',
						\ shellescape(filename)))
		elseif exists('$GNOME_DESKTOP_SESSION_ID')
			" GNOME.
			call system(printf('%s %s &', 'gnome-open',
						\ shellescape(filename)))
		elseif executable('exo-open')
			" Xfce.
			call system(printf('%s %s &', 'exo-open',
						\ shellescape(filename)))
		elseif s:is_mac && executable('open')
			" Mac OS.
			call system(printf('%s %s &', 'open',
						\ shellescape(filename)))
		else
			throw 'vital: System.File: open(): Not supported.'
		endif
	finally
		execute (haslocaldir() ? 'lcd' : 'cd') fnameescape(current_dir)
	endtry
endfunction
" }}}

" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
