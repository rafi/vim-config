let s:save_cpo = &cpo
set cpo&vim

if !g:loaded_unite
    finish
endif

function! unite#sources#navigate#define()
	return [ s:source_inherits, s:source_namespace ]
endfunction

let s:source_inherits = {
			\ 'name'           : 'navigate/inherits',
			\ 'is_volatile'    : 1,
			\ 'max_candidates' : 200,
			\ 'required_pattern_length': 3,
			\ 'hooks'    : {},
			\ }

function! s:source_inherits.change_candidates(args, context)
	return unite#sources#navigate#find('\s+inherits:[a-zA-Z,]*'.a:context.input)
endfunction

let s:source_namespace = {
			\ 'name'           : 'navigate/namespace',
			\ 'is_volatile'    : 1,
			\ 'max_candidates' : 200,
			\ 'required_pattern_length': 3,
			\ 'hooks'    : {},
			\ }

function! s:source_namespace.change_candidates(args, context)
	return unite#sources#navigate#find('\s+namespace:[a-zA-Z,]*'.a:context.input)
endfunction

function! unite#sources#navigate#find(pattern)
	let l:result = unite#util#system('ag "'.a:pattern.'" .git/tags')
	let l:matches = split(l:result, '\r\n\|\r\|\n')
	let candidates = []
	for line in l:matches
		let parts = matchlist(line, '\v^(.+)\t(.+)\t\/(.*)\/\;\"\t(\w)\t?(.*)$')
		if len(parts) > 0
			let flags = {}
			if len(parts) > 4
				let flags_raw = split(parts[5], '\t')
				for flag_raw in flags_raw
					let [key, val] = split(flag_raw, ':')
					let flags[key] = val
				endfor
			endif
			let filepath = strpart(parts[2], 3)
			let word = '('.parts[4].') '
			if has_key(flags, 'namespace')
				let word .= flags.namespace.'\'
			endif
			let word .= parts[1]
			if has_key(flags, 'inherits')
				let word .= ' extends '.flags.inherits
			endif
			call add(candidates, {
				\ "word": word,
				\ "kind": "jump_list",
				\ "action__path": filepath,
				\ "action__pattern": parts[3],
				\ } )
		endif
	endfor
	return candidates
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
