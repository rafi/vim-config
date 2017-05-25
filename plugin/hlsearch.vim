" Disable hlsearch when you are done searching
" Credits: https://github.com/romainl/vim-cool

let s:save_cpo = &cpoptions
set cpoptions&vim

augroup hlsearch
	autocmd!
	" trigger when hlsearch is toggled
	autocmd OptionSet hlsearch call <SID>toggle(v:option_old, v:option_new)
augroup END

function! s:StartHL()
	silent! if v:hlsearch && !search('\%#\zs'.@/,'cnW')
		call <SID>StopHL()
	endif
endfunction

function! s:StopHL()
	if ! v:hlsearch || mode() !=? 'n'
		return
	else
		silent call feedkeys("\<Plug>(StopHL)", 'm')
	endif
endfunction

function! s:toggle(old, new)
	if a:old == 0 && a:new == 1
		" nohls --> hls
		"   set up
		noremap  <expr> <Plug>(StopHL) execute('nohlsearch')[-1]
		noremap! <expr> <Plug>(StopHL) execute('nohlsearch')[-1]

		autocmd hlsearch CursorMoved * call <SID>StartHL()
		autocmd hlsearch InsertEnter * call <SID>StopHL()
	elseif a:old == 1 && a:new == 0
		" hls --> nohls
		"   tear down
		nunmap <expr> <Plug>(StopHL)
		unmap! <expr> <Plug>(StopHL)

		autocmd! hlsearch CursorMoved
		autocmd! hlsearch InsertEnter
	else
		" nohls --> nohls
		"   do nothing
		return
	endif
endfunction

call <SID>toggle(0, &hlsearch)

let &cpoptions = s:save_cpo
