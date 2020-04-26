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
" 		cal asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
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
" Alacritty will send <C-r>* and <C-e>c for paste and copy respecitively
" Remap vim 'paste from register *' command to 'p' in normal mode

" Remap Paste Key Mappings
" ----------
" This binding is preferred over the one below it as it preserves formatting on multi-line pastes
inoremap <C-Insert> <Esc>p`]a
" inoremap <C-Insert> <C-r>*
nnoremap <C-Insert> P
vnoremap <C-Insert> "0p
" Remap Copy Key Mapping to yank
vnoremap <M-[>2;5+ y

" }}}
" vim: set foldmethod=marker ts=2 sw=2 tw=80 noet :
