
" VimFiler
" --------

" Icons: │ ┃ ┆ ┇ ┊ ┋ ╎ ╏
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_restore_alternate_file = 1
let g:vimfiler_tree_indentation = 1
let g:vimfiler_tree_leaf_icon = '┆'
let g:vimfiler_tree_opened_icon = '▼'
let g:vimfiler_tree_closed_icon = '▷'
let g:vimfiler_file_icon = ' '
let g:vimfiler_readonly_file_icon = '⭤'
let g:vimfiler_marked_file_icon = '✓'
"let g:vimfiler_preview_action = 'auto_preview'
let g:vimfiler_ignore_pattern =
	\ '^\%(\.git\|\.idea\|\.DS_Store\|\.vagrant\|node_modules\|.*\.pyc\)$'

if has('mac')
	let g:vimfiler_quick_look_command = 'qlmanage -p'
else
	let g:vimfiler_quick_look_command = 'gloobus-preview'
endif

call vimfiler#custom#profile('default', 'context', {
	\  'safe': 0,
	\  'winwidth': 25,
	\  'explorer': 1,
	\  'auto_expand': 1,
	\  'no_quit': 1,
	\  'parent': 0,
	\  'split': 1,
	\  'toggle': 1,
	\ })

function! s:selected(...) " {{{
	" Returns selected items, or current cursor directory position
	" Provide an argument to limit results with an integer.

	let marked_files = vimfiler#get_marked_files()
	if empty(marked_files)
		let file_dir = vimfiler#get_file_directory()
		if empty(file_dir)
			return '.'
		endif
		call add(marked_files, { 'action__path': file_dir })
	endif

	if a:0 > 0
		let marked_files = marked_files[: a:1]
	endif

	return join(map(marked_files, 'v:val.action__path'), "\n")
endfunction "}}}

function! s:change_vim_current_dir() "{{{
	let selected = s:selected(1)
  let vimfiler = vimfiler#get_current_vimfiler()
  call vimfiler#set_current_vimfiler(vimfiler)

  let windows = unite#helper#get_choose_windows()
  if empty(windows)
    rightbelow vnew
  elseif len(windows) == 1
    execute windows[0].'wincmd w'
  else
    let alt_winnr = winnr('#')
    let [tabnr, winnr] = [tabpagenr(), winnr()]
    let [old_tabnr, old_winnr] = [tabnr, winnr]
		let winnr = unite#helper#choose_window()

    if tabnr != tabpagenr()
      execute 'tabnext' tabnr
    endif

    if (winnr == 0  || (winnr == old_winnr && tabnr == old_tabnr))
          \ && alt_winnr > 0
      " Use alternative window
      let winnr = alt_winnr
    endif

    if winnr == 0 || (winnr == old_winnr && tabnr == old_tabnr)
      rightbelow vnew
    else
      execute winnr.'wincmd w'
    endif
  endif

  execute 'lcd '
        \ fnameescape(selected)
endfunction "}}}

" vim: set ts=2 sw=2 tw=80 noet :
