
" NERDTree
" --------
let g:NERDTreeMinimalUI = 1
let g:NERDTreeWinSize = 25
let g:NERDTreeCascadeOpenSingleChildDir = 1
let g:NERDTreeCascadeSingleChildDir = 0
let g:NERDTreeShowHidden = 1
let g:NERDTreeRespectWildIgnore = 1
let g:NERDTreeAutoDeleteBuffer = 0
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeHijackNetrw = 1

" Custom plugins
" ---
function! s:SID()
	if ! exists('s:sid')
		let s:sid = matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
	endif
	return s:sid
endfunction
let s:SNR = '<SNR>'.s:SID().'_'

" Diff file
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

" Project root
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
	let project_dir = block#root()
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

" Denite fine/grep
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
	let path = a:node.path
	let cwd = path.isDirectory ? path.str() : path.getParent().str()
	execute 'Denite file_rec:'.cwd
endfunction

function! s:grep_dir(node)
	let path = a:node.path
	let cwd = path.isDirectory ? path.str() : path.getParent().str()
	execute 'Denite -buffer-name=grep grep:'.cwd
endfunction

" Yank path
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

" Toggle width
" ---
call NERDTreeAddKeyMap({
	\ 'key': 'w',
	\ 'callback': s:SNR.'toggle_width',
	\ 'quickhelpText': 'Toggle window width' })

function! s:toggle_width()
	let l:maxi = 0
	for l:z in range(1, line('$'))
		let l:aktlen = len(getline(l:z))
		if l:aktlen > l:maxi
			let l:maxi = l:aktlen
		endif
	endfor
	exe 'vertical resize '.(l:maxi == winwidth('.') ? g:NERDTreeWinSize : l:maxi)
endfunction

" Modify .local.vimrc of project
" ---
call NERDTreeAddMenuItem({
	\ 'text': '(l)ocal rc',
	\ 'shortcut': 'l',
	\ 'callback': s:SNR.'modify_localvimrc'})

function! s:modify_localvimrc()
	let currentDir = g:NERDTreeDirNode.GetSelected().path.str({'format': 'Cd'})
	let oldCWD = getcwd()
	try
		execute 'cd '.currentDir
		call writefile([
			\ 'lcd <sfile>:h',
			\ '" set isk+=!,?',
			\ ],
			\ '.local.vimrc')
	catch
		execute 'cd '.oldCWD
	endtry
endfunction

" Smart h/l navigation
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

" vim: set ts=2 sw=2 tw=80 noet :
