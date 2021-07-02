" :h fern
" ---
" Problems? https://github.com/lambdalisue/fern.vim/issues

let g:fern#disable_default_mappings = 1

let g:fern#drawer_width = 25
let g:fern#default_hidden = 1

let g:fern#keepalt_on_edit = 1
let g:fern#keepjumps_on_edit = 1

let g:fern#hide_cursor = 1
let g:fern#disable_viewer_auto_duplication = 1
let g:fern#disable_drawer_auto_resize = 0

let g:fern#default_exclude =
	\ '^\(\.git\|\.hg\|\.svn\|\.stversions\|\.mypy_cache\|\.pytest_cache'
	\ . '\|__pycache__\|\.DS_Store\)$'

let g:fern#mark_symbol = ''
" let g:fern#renderer#default#root_symbol = ''

let g:fern_git_status#indexed_character = '◼'
let g:fern_git_status#stained_character = '◼'

" Private
" ---

let s:original_width = g:fern#drawer_width

nnoremap <Plug>(fern-close-drawer) :<C-u>FernDo close -drawer -stay<CR>

highlight! FernCursorLine ctermbg=236 guibg=#323232

function! s:init_fern()
	silent! nnoremap <buffer> f <Nop>
	silent! nnoremap <buffer> F <Nop>
	silent! nnoremap <buffer> t <Nop>
	silent! nnoremap <buffer> T <Nop>
	silent! xnoremap <buffer> f <Nop>
	silent! xnoremap <buffer> F <Nop>
	silent! xnoremap <buffer> t <Nop>
	silent! xnoremap <buffer> T <Nop>
	silent! onoremap <buffer> f <Nop>
	silent! onoremap <buffer> F <Nop>
	silent! onoremap <buffer> t <Nop>
	silent! onoremap <buffer> T <Nop>

	" Perform 'open' on leaf node and 'enter' on branch node
	nmap <buffer><silent> <Plug>(fern-action-open-and-close)
		\ <Plug>(fern-action-open)
		\<Plug>(fern-close-drawer)

	" Open file or expand
	nmap <buffer><expr>
		\ <Plug>(fern-my-open-or-expand)
		\ fern#smart#leaf(
		\   "\<Plug>(fern-action-open-and-close)",
		\   "\<Plug>(fern-action-expand:stay)",
		\   "\<Plug>(fern-action-collapse)",
		\ )

	" Always stay on current node when expading
	nmap <buffer> <Plug>(fern-action-expand) <Plug>(fern-action-expand:stay)

	" Mappings
	nmap <buffer><silent> <Esc>  <Plug>(fern-close-drawer)
	nmap <buffer><silent> q      <Plug>(fern-close-drawer)
	nmap <buffer><silent> <C-c>  <Plug>(fern-action-cancel)
	nmap <buffer><silent> a      <Plug>(fern-action-choice)
	nmap <buffer><silent> C      <Plug>(fern-action-clipboard-copy)
	nmap <buffer><silent> M      <Plug>(fern-action-clipboard-move)
	nmap <buffer><silent> P      <Plug>(fern-action-clipboard-paste)
	nmap <buffer><silent> h      <Plug>(fern-action-collapse)
	nmap <buffer><silent> c      <Plug>(fern-action-copy)
	nmap <buffer><silent> fe     <Plug>(fern-action-exclude)
	nmap <buffer><silent> <<     <Plug>(fern-action-git-stage)
	nmap <buffer><silent> >>     <Plug>(fern-action-git-unstage)

	nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
	nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
	nmap <silent> <buffer> <C-f> <Plug>(fern-action-preview:scroll:down:half)
	nmap <silent> <buffer> <C-b> <Plug>(fern-action-preview:scroll:up:half)

	nmap <buffer><silent> ?      <Plug>(fern-action-help)
	nmap <buffer><silent> !      <Plug>(fern-action-hidden)
	nmap <buffer><silent> I      <Plug>(fern-action-hide-toggle)
	nmap <buffer><silent> fi     <Plug>(fern-action-include)
	nmap <buffer><silent> <BS>   <Plug>(fern-action-leave)
	nmap <buffer><silent> m      <Plug>(fern-action-move)
	nmap <buffer><silent> K      <Plug>(fern-action-new-dir)
	" nmap <buffer><silent>        <Plug>(fern-action-new-file)
	nmap <buffer><silent> N      <Plug>(fern-action-new-path)
	nmap <buffer><silent> e      <Plug>(fern-action-open)
	nmap <buffer><silent> <CR>   <Plug>(fern-action-open-or-enter)
	nmap <buffer><silent> l      <Plug>(fern-my-open-or-expand)
	nmap <buffer><silent> <C-CR> <Plug>(fern-action-open:select)
	nmap <buffer><silent> E      <Plug>(fern-action-open:side)
	nmap <buffer><silent> x      <Plug>(fern-action-open:system)
	nmap <buffer><silent> sg     <Plug>(fern-action-open:right)
	nmap <buffer><silent> sv     <Plug>(fern-action-open:below)
	nmap <buffer><silent> st     <Plug>(fern-action-open:tabedit)
	nmap <buffer><silent> r      <Plug>(fern-action-redraw)
	nmap <buffer><silent> <C-r>  <Plug>(fern-action-reload)
	nmap <buffer><silent> R      <Plug>(fern-action-rename)
	nmap <buffer><silent> .      <Plug>(fern-action-repeat)
	nmap <buffer><silent> i      <Plug>(fern-action-reveal)
	nmap <buffer><silent> B      <Plug>(fern-action-save-as-bookmark)
	nmap <buffer><silent> D      <Plug>(fern-action-trash)
	nmap <buffer><silent> yy     <Plug>(fern-action-yank)
	nmap <buffer><silent> w
		\ :<C-u>call fern#helper#call(funcref('<SID>toggle_width'))<CR>

	" Selection
	nmap <buffer><silent> u <Plug>(fern-action-mark:clear)
	nmap <buffer><silent> J <Plug>(fern-action-mark)j
	nmap <buffer><silent> K <Plug>(fern-action-mark)k
	nmap <buffer><silent><nowait> <Space> <Plug>(fern-action-mark)j

	" Grep inside
	nnoremap <buffer><silent>
		\ <Plug>(fern-user-grep)
		\ :<C-u>call fern#helper#call(funcref('<SID>grep'))<CR>
	nmap <buffer><silent> gr <Plug>(fern-user-grep)

	" Find files inside
	nnoremap <buffer><silent>
		\ <Plug>(fern-user-find)
		\ :<C-u>call fern#helper#call(funcref('<SID>find'))<CR>
	nmap <buffer><silent> gf <Plug>(fern-user-find)

	" Find and enter project root
	nnoremap <buffer><silent>
		\ <Plug>(fern-user-enter-project-root)
		\ :<C-u>call fern#helper#call(funcref('<SID>enter_project_root'))<CR>
	nmap <buffer><expr><silent> ^
		\ fern#smart#scheme("^", {'file': "\<Plug>(fern-user-enter-project-root)"})

	" Open bookmark
	nnoremap <buffer><silent> <Plug>(fern-my-enter-bookmark)
		\ :<C-u>Fern bookmark:///<CR>
	nmap <buffer><expr><silent> o
		\ fern#smart#scheme(
		\   "\<Plug>(fern-my-enter-bookmark)",
		\   { 'bookmark': "\<C-^>" })
endfunction

augroup fern-custom
	autocmd! *
	autocmd FileType fern call s:init_fern()
	autocmd BufEnter <buffer> highlight! link CursorLine FernCursorLine
	autocmd BufLeave <buffer> highlight! link CursorLine NONE
	" autocmd DirChanged * ++nested execute printf('FernDo Fern\ %s\ -drawer\ -stay -drawer -stay', v:event.cwd)
augroup END

function! s:get_selected_nodes(helper) abort
	let nodes = a:helper.sync.get_selected_nodes()
	return empty(nodes) ? [a:helper.sync.get_cursor_node()] : nodes
endfunction

function! s:get_cursor_path(helper) abort
	let l:node = a:helper.sync.get_cursor_node()
	let l:path = l:node._path
	if index([g:fern#STATUS_NONE, g:fern#STATUS_COLLAPSED], l:node.status) >= 0
		let l:path = fnamemodify(l:path, ':h')
	endif
	return l:path
endfunction

function! s:find(helper) abort
	let l:path = s:get_cursor_path(a:helper)
	silent execute 'wincmd w'
	if exists(':Telescope')
		execute 'Telescope find_files cwd=' . fnameescape(l:path)
	elseif exists(':Denite')
		call denite#start([{'name': 'file/rec', 'args': [l:path]}])
	endif
endfunction

function! s:grep(helper) abort
	let l:path = s:get_cursor_path(a:helper)
	silent execute 'wincmd w'
	if exists(':Telescope')
		execute 'Telescope grep_string cwd=' . fnameescape(l:path)
	else
		call denite#start([{'name': 'grep', 'args': [l:path]}])
	endif
endfunction

function! s:enter_project_root(helper) abort
	let root = a:helper.sync.get_root_node()
	let path = root._path
	let path = finddir('.git/..', path . ';')
	execute printf('Fern %s', fnameescape(path))
endfunction

" Toggle Fern drawer window width: original, half, max
function! s:toggle_width(helper) abort
	if ! a:helper.sync.is_drawer()
		return
	endif

	let l:max = 0
	for l:line in range(1, line('$'))
		let l:len = strdisplaywidth(substitute(getline(l:line), '\s\+$', '', ''))
		let l:max = max([l:len + 1, l:max])
	endfor

	let l:current = winwidth(0)
	let l:half = s:original_width + (l:max - s:original_width) / 2
	let g:fern#drawer_width =
		\ l:current == s:original_width ? l:half :
		\ l:current == l:half ? l:max : s:original_width

	execute printf('%d wincmd |', float2nr(g:fern#drawer_width))
endfunction

" vim: set ts=2 sw=2 tw=80 noet :
