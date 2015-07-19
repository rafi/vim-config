" deoplete for nvim
" ---

set completeopt+=noinsert

" <TAB>: completion.
imap <expr><silent> <Tab>
	\ pumvisible() ? "\<C-n>" :
	\ <SID>check_back_space() ? "\<Tab>" :
	\ deoplete#mappings#manual_complete()

function! s:check_back_space() "{{{
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}

" <S-TAB>: completion back.
inoremap <expr><S-Tab>  pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <expr><C-y> deoplete#mappings#close_popup()
inoremap <expr><C-e> deoplete#mappings#cancel_popup()

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deolete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#mappings#smart_close_popup()."\<C-h>"

inoremap <expr> '  pumvisible() ? deoplete#mappings#close_popup() : "'"
