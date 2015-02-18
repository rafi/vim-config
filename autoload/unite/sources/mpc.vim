let s:save_cpo = &cpo
set cpo&vim

let s:source = { 'name': 'mpc' }

function! s:source.gather_candidates(args, context)

	if index(a:args, '!') >= 0
		call unite#sources#rhythmbox#toggle()
		call system('mpc toggle')
		return
	endif

	return map(split(system('mpc playlist'), "\n"), '{
		\ "word": v:val,
		\ "source": "mpc",
		\ "kind": "command",
		\ "action__command": "call system(''mpc play ".(v:key+1)."'')"
		\ }')
endfunction

function! unite#sources#mpc#define()
  return executable('mpc') ? [s:source] : []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
