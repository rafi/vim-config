" :h gina
" ---
" Problems? https://github.com/lambdalisue/gina.vim/issues

call gina#custom#command#alias('status', 'st')
call gina#custom#command#option('st', '-s')
call gina#custom#command#option('status', '-b')

" call gina#custom#command#option('/\v(status|branch|ls|grep|changes)', '--opener', 'botright 10split')
" call gina#custom#command#option('/\v(blame|diff|log)', '--opener', 'tabnew')
call gina#custom#command#option('commit', '--opener', 'below vnew')
call gina#custom#command#option('commit', '--verbose')

let s:width_quarter = string(winwidth(0) / 4)
let s:width_half = string(winwidth(0) / 2)

call gina#custom#command#option('blame', '--width', s:width_quarter)
let g:gina#command#blame#formatter#format = '%au: %su%= on %ti %ma%in'

" Open in vertical split
call gina#custom#command#option(
	\ '/\%(branch\|changes\|grep\|log\|reflog\)',
	\ '--opener', 'vsplit'
	\)

" Fixed medium width types
call gina#custom#execute(
	\ '/\%(changes\|ls\)',
	\ 'vertical resize ' . s:width_half . ' | setlocal winfixwidth'
	\)

" Fixed small width special types
call gina#custom#execute(
	\ '/\%(branch\)',
	\ 'vertical resize ' . s:width_quarter . ' | setlocal winfixwidth'
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

" vim: set ts=2 sw=2 tw=80 noet :
