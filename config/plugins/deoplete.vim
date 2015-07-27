" deoplete for nvim
" ---

set completeopt+=noinsert

" <Tab> completion:
" 1. If popup menu is visible, select and insert next item
" 2. Otherwise, if preceding chars are whitespace, insert tab char
" 3. Otherwise, start manual autocomplete
imap <expr><silent><Tab> pumvisible() ? "\<C-n>"
	\ : (<SID>is_whitespace() ? "\<Tab>"
	\ : deoplete#mappings#manual_complete())

" Movement within 'ins-completion-menu'
inoremap <expr><C-j>   "\<Down>"
inoremap <expr><C-k>   "\<Up>"
inoremap <expr><C-f>   pumvisible() ? "\<PageDown>" : "\<Right>"
inoremap <expr><C-b>   pumvisible() ? "\<PageUp>" : "\<Left>"

" <C-d>, <C-u>: Scroll pages in menu
imap     <expr><C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
imap     <expr><C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

" <CR>: If popup menu visible, expand snippet or close popup with selection.
imap <expr><silent><CR> pumvisible() ?
	\ (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : deoplete#mappings#close_popup())
	\ : "\<CR>"

" <S-TAB>: completion back.
inoremap <expr><S-Tab>  pumvisible() ? "\<C-p>" : "\<C-h>"

inoremap <expr><C-y> deoplete#mappings#close_popup()
inoremap <expr><C-e> deoplete#mappings#cancel_popup()

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deolete#mappings#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  deoplete#mappings#smart_close_popup()."\<C-h>"

inoremap <expr> '  pumvisible() ? deoplete#mappings#close_popup() : "'"

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}
