" Jump entire buffers from jumplist
" ---
"
" Commands:
" - JumpBuffer: Finds next (1) or previous (-1) file in jumplist

if exists('g:loaded_jumpbuffer')
	finish
endif
let g:loaded_jumpfiles = 1

" direction - 1=forward, -1=backward
" Credits: https://superuser.com/a/1455940/252171
function! JumpBuffer(direction)
	let [ jumplist, curjump ] = getjumplist()
	let jumpcmdstr = a:direction > 0 ? '<C-o>' : '<C-i>'
	let jumpcmdchr = a:direction > 0 ? "\<C-o>" : "\<C-i>"
	let searchrange = a:direction > 0
		\ ? range(curjump - 1, 0, -1)
		\ : range(curjump + 1, len(jumplist))

	for i in searchrange
		let l:nr = jumplist[i]['bufnr']
		if l:nr != bufnr('%') && bufname(l:nr) !~? "^\a\+://"
			let n = abs((i - curjump) * a:direction)
			echo 'Executing' jumpcmdstr n . ' times'
			execute 'normal! ' . n . jumpcmdchr
			break
		endif
	endfor
endfunction
