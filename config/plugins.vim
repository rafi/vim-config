
" Plugin Settings {{{1
"------------------------------------------------------------------------------

let g:neocomplete#enable_at_startup = 1    " Enable neocomplete
let g:unite_source_history_yank_enable = 1 " Unite: Store yank history
let delimitMate_expand_cr = 1              " delimitMate
let g:vim_markdown_initial_foldlevel = 5   " Markdown: Don't start all folded
let g:Gitv_DoNotMapCtrlKey = 1             " Gitv: Do not map ctrl keys
let g:choosewin_label = 'SDFGHJKLZXCVBNM'  " ChooseWin: Window labels
let g:echodoc_enable_at_startup = 1        " Enable autocomplete information
let g:DisableAutoPHPFolding = 1            " Do not fold automatically

" Set syntastic signs, must be in vimrc
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol = '⚠'
let g:syntastic_warning_symbol = ''

" neosnippet
let g:neosnippet#enable_snipmate_compatibility = 0
let g:neosnippet#disable_runtime_snippets = { '_': 1 }

" vim-go, do not mess with my neosnippet config!
let g:go_loaded_gosnippets = 1
let g:go_snippet_engine = "neosnippet"

" Emmet
let g:use_emmet_complete_tag = 1
let g:user_emmet_leader_key = '<C-z>'
let g:user_emmet_mode = 'i'
let g:user_emmet_install_global = 0
autocmd FileType html EmmetInstall

" Enable omni completions for file types
autocmd FileType c setlocal omnifunc=ccomplete#Complete
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType go setlocal omnifunc=go#complete#Complete
autocmd FileType html,mustache setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=tern#Complete
autocmd FileType php setlocal omnifunc=phpcomplete#CompletePHP
if has('python3')
	autocmd FileType python setlocal omnifunc=python3complete#Complete
else
	autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
endif
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType sql setlocal omnifunc=sqlcomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
