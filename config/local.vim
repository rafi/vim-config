" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
" Overrides
" ===
function! s:source_file(path, ...)
	" Source user configuration files with set/global sensitivity
	let use_global = get(a:000, 0, ! has('vim_starting'))
	let abspath = resolve($VIM_PATH . '/' . a:path)
	if ! use_global
		execute 'source' fnameescape(abspath)
		return
	endif

	let tempfile = tempname()
	let content = map(readfile(abspath),
		\ "substitute(v:val, '^\\W*\\zsset\\ze\\W', 'setglobal', '')")
	try
		call writefile(content, tempfile)
		execute printf('source %s', fnameescape(tempfile))
	finally
		if filereadable(tempfile)
			call delete(tempfile)
		endif
	endtry
endfunction

" Set line wrap
set wrap

" Add CoC intellisense support
let g:coc_global_extensions = ['coc-tsserver', 'coc-prettier', 'coc-eslint', 'coc-json', 'coc-html', 'coc-css', 'coc-python', 'coc-reason', 'coc-yaml', 'coc-phpls']
" Load recommended key bindings and settings for CoC
if filereadable($VIM_PATH . '/config/local.vim')
	call s:source_file('config/coc.vim')
endif

" let g:vista#executives = ['coc', 'ctags', 'lcn', 'vim_lsp']
let g:vista_executive_for = {'typescript': 'coc'}

" Ale (automatic linter)
" let g:ale_fix_on_save = 1

" This is for aysncomplete + nvim-lsp (neovim only) support. Require nvim
" > 0.5
" if has('nvim')
" 	if executable('typescript-language-server')
" 		lua require'nvim_lsp'.tsserver.setup{}
" 		au Filetype typescript setl omnifunc=v:lua.vim.lsp.omnifunc
" 		call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
"					\   'name': 'omni-typescript',
"					\   'whitelist': ['typescript'],
"					\   'completor': function('asyncomplete#sources#omni#completor'),
"					\ }))
" 	endif
" endif

" Cmd + Shift + {|} for changing tabs
" Only works in GUI apps
nmap <D-S-{> :tabp<cr>
nmap <D-S-}> :tabn<cr>

" 24 bit color support
execute "set t_8f=\e[38;2;%lu;%lu;%lum"
execute "set t_8b=\e[48;2;%lu;%lu;%lum"

" Save linted code
" let b:ale_fixers = {
" \   'php': [
" \       'prettier',
" \       {buffer, lines -> filter(lines, 'v:val !=~ ''^\s*//''')},
" \   ],
" \}
let g:ale_fix_on_save = 1
" MacNeoVim {{{
" ----------

" }}}

" MacNeoVim {{{
" ----------
" command! Vb normal! <C-v>
" Remap Paste Key Mappings
" ----------
" Insert mode paste
inoremap <C-Insert> <C-r>*
" Command mode paste
cnoremap <C-Insert> <C-r>*
" Normal mode paste
nnoremap <C-Insert> P
" Visual mode paste (without yanking replaced text)
vnoremap <C-Insert> "_c<C-r>+<Esc>
" Remap Copy Key Mappings
" ----------
" Remap copy to work in neovim
vmap <M-[>2;5+ y
" Remap copy to work in vim8
vmap [2;5+ y
" Select all
noremap <C-S-Insert> <Esc>ggVG
" Remap Indent
" ----------
vmap <M-]> >gv|
vmap <M-[> <gv
nmap <M-]> <Esc>v><Esc>
nmap <M-[> <Esc>v<<Esc>
imap <M-]> <C-t>
imap <M-[> <C-d>
" Remap Comment (Requires caw.vim plugin)
" ----------
vmap <M-'> gcc
nmap <M-'> gcc
imap <M-'> <Esc>gcci
" }}}
"
" WhichKey {{{
" ----------
" Define prefix dictionary
autocmd! User vim-which-key call which_key#register('<Space>', "g:which_key_map")
let g:which_key_map =  {}
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <localleader> :<c-u>WhichKey  ';'<CR>
vnoremap <localleader> :<c-u>WhichKeyVisual  ';'<CR>
" Hide status line when whichkey is open
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
" }}}
