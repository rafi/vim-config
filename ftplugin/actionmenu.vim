" actionmenu
" ---
" Forked from: https://github.com/kizza/actionmenu.nvim

" Style the buffer every time
setlocal signcolumn=no
setlocal sidescrolloff=0 scrolloff=0
setlocal listchars= showbreak= nowrap
setlocal completeopt+=menuone
setlocal completeopt+=noinsert

" Only load once
if get(s:, 'loaded')
	" subsequent times, just open pum
	call actionmenu#open_pum()
	finish
endif
let s:loaded = 1

" Defaults
let s:selected_item = 0

function! actionmenu#clear_conflicting_autocmds()
	silent! autocmd! deoplete CompleteDone
	silent! autocmd! neosnippet CompleteDone
endfunction

function! actionmenu#open_pum()
	call feedkeys("i\<C-x>\<C-u>")
	call actionmenu#clear_conflicting_autocmds()
endfunction

function! actionmenu#select_item()
	call actionmenu#clear_conflicting_autocmds()
	if pumvisible()
		call feedkeys("\<C-y>")
		if ! empty(v:completed_item)
			let s:selected_item = copy(v:completed_item)
		endif
	endif
	call actionmenu#close_pum()
endfunction

function! actionmenu#close_pum()
	call feedkeys("\<esc>")
endfunction

function! actionmenu#on_insert_leave()
	let l:index = -1
	if type(s:selected_item) == type({})
		let l:index = s:selected_item['user_data']
	endif
	if l:index ==# ''
		let l:index = -1
	endif
	let s:selected_item = 0
	let l:data = l:index > -1 ? g:actionmenu#items[l:index] : {}
	call actionmenu#callback(l:index, l:data)
endfunction

function! actionmenu#pum_item_to_action_item(item, index) abort
	if type(a:item) == type('')
		return { 'word': a:item, 'user_data': a:index }
	else
		return { 'word': a:item['word'], 'user_data': a:index }
	endif
endfunction

" Mappings
mapclear <buffer>
inoremap <buffer> <expr> <CR> actionmenu#select_item()
imap <buffer> <C-y> <CR>
imap <buffer> <C-e> <esc>
inoremap <buffer> <Up> <C-p>
inoremap <buffer> <Down> <C-n>
inoremap <buffer> k <C-p>
inoremap <buffer> j <C-n>

" Events
augroup actionmenu
	autocmd!
	autocmd InsertLeave <buffer> :call actionmenu#on_insert_leave()
augroup END

" Pum completion function
function! actionmenu#complete_func(findstart, base)
	if a:findstart
		return 1
	else
		return map(copy(g:actionmenu#items), {
			\ index, item ->
			\   actionmenu#pum_item_to_action_item(item, index)
			\ }
			\)
	endif
endfunction

" Set the pum completion function
setlocal completefunc=actionmenu#complete_func

doautocmd InsertEnter
call deoplete#custom#buffer_option('auto_complete', v:false)

" Open the pum immediately
call actionmenu#open_pum()
