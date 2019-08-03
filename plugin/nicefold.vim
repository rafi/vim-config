" Nice Fold
" ---
"
" Behaviors:
" - Improve folds performance after modification
" - Set a nice pattern for collapsed folds

if exists('g:loaded_nicefold')
	finish
endif
let g:loaded_nicefold = 1

" Fast fold
" Credits: https://github.com/Shougo/shougo-s-github
augroup plugin_fastfold
	autocmd!
	autocmd TextChangedI,TextChanged *
		\  if &l:foldenable && &l:foldmethod !=# 'manual'
		\|   let b:foldmethod_save = &l:foldmethod
		\|   let &l:foldmethod = 'manual'
		\| endif

	autocmd BufWritePost *
		\  if &l:foldmethod ==# 'manual' && exists('b:foldmethod_save')
		\|   let &l:foldmethod = b:foldmethod_save
		\|   execute 'normal! zx'
		\| endif
augroup END

if has('folding')
	set foldtext=FoldText()
endif

" Improved Vim fold-text
" See: http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
function! FoldText()
	" Get first non-blank line
	let fs = v:foldstart
	while getline(fs) =~? '^\s*$' | let fs = nextnonblank(fs + 1)
	endwhile
	if fs > v:foldend
		let line = getline(v:foldstart)
	else
		let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
	endif

	let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
	let foldSize = 1 + v:foldend - v:foldstart
	let foldSizeStr = ' ' . foldSize . ' lines '
	let foldLevelStr = repeat('+--', v:foldlevel)
	let lineCount = line('$')
	let foldPercentage = printf('[%.1f', (foldSize*1.0)/lineCount*100) . '%] '
	let expansionString = repeat('.', w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
	return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction
