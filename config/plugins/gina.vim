" :h gina
" ---
" Problems? https://github.com/lambdalisue/gina.vim/issues

let g:gina#command#blame#formatter#format = '%au: %su%= on %ti %ma%in'

call gina#custom#command#alias('status', 'st')
call gina#custom#command#option('st', '-s')

" Open in vertical split
call gina#custom#command#option(
	\ '/\%(branch\|changes\|grep\|log\|reflog\)',
	\ '--opener', 'vsplit'
	\)

" Fixed small width special types
call gina#custom#execute(
	\ '/\%(branch\|grep\)',
	\ 'vertical resize 30 | setlocal winfixwidth'
	\)

" Alias 'p'/'dp' globally
call gina#custom#action#alias('/.*', 'dp', 'diff:preview')
call gina#custom#mapping#nmap('/.*', 'dp', ':<C-u>call gina#action#call(''dp'')<CR>', {'noremap': 1, 'silent': 1})
" call gina#custom#action#alias('/\%(blame\|log\)', 'preview', 'botright show:commit:preview')
call gina#custom#mapping#nmap('/.*', 'p',
	\ ':<C-u>call gina#action#call(''preview'')<CR>',
	\ {'noremap': 1, 'silent': 1, 'nowait': 1})

" Echo chunk info with K
call gina#custom#mapping#nmap('blame', 'K', '<Plug>(gina-blame-echo)')

" Blame mappings
let g:gina#command#blame#use_default_mappings = 0
call gina#custom#mapping#nmap('blame', '<Return>', '<Plug>(gina-blame-open)')
call gina#custom#mapping#nmap('blame', '<Backspace>', '<Plug>(gina-blame-back)')
call gina#custom#mapping#nmap('blame', '<C-r>', '<Plug>(gina-blame-C-L)')
