
" Lightline
" ---------
"
"         Icons
"   Regular | Powerline
"           |  
"   / •     |  
"   § ‡     |  

" Disable other plugins' statuslines
let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

let g:lightline = {
	\ 'colorscheme': 'jellybeans',
	\ 'mode_map': { 'n': 'N', 'v': 'V', 'i': 'I' },
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'fugitive', 'filename' ] ],
	\   'right': [ [ 'syntastic', 'lineinfo' ], 
	\              ['percent'], 
	\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
	\ },
	\ 'component_function': {
	\   'filename': 'StatusFilename',
	\   'modified': 'StatusModified',
	\   'readonly': 'StatusReadonly',
	\   'fugitive': 'StatusFugitive',
	\   'fileformat': 'StatusFileformat',
	\   'filetype': 'StatusFiletype',
	\   'fileencoding': 'StatusFileencoding',
	\   'mode': 'StatusMode'
	\ },
	\ 'tab_component_function': {
	\   'filename': 'TabFilePath',
	\ },
	\ 'separator': { 'left': '', 'right': '' },
	\ 'component_expand': {
	\   'syntastic': 'SyntasticStatuslineFlag',
	\ },
	\ 'component_type': {
	\   'syntastic': 'error',
	\ },
	\ 'subseparator': { 'left': '•', 'right': '•' }
	\ }

function! StatusModified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! StatusReadonly()
	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '§' : ''
endfunction

function! StatusFilename()
	let fname = expand('%:t')
	return fname == '__Tagbar__' ? g:lightline.fname :
				\ fname =~ '__Gundo\|NERD_tree' ? '' :
				\ &ft == 'vimfiler' ? vimfiler#get_status_string() :
				\ &ft == 'unite' ? unite#get_status_string() :
				\ &ft == 'vimshell' ? vimshell#get_status_string() :
				\ ('' != StatusReadonly() ? StatusReadonly() . ' ' : '') .
				\ ('' != fname ? bufnr('%').') '.ConcisePath(3) : '[No Name]') .
				\ ('' != StatusModified() ? ' ' . StatusModified() : '')
endfunction

function! ConcisePath(n)
	return substitute(expand("%"), "[^/]\\{" . a:n . "}\\zs[^/]\*\\ze/", "", "g")
endfunction

function! StatusFugitive()
	if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
		let _ = fugitive#head()
		return strlen(_) ? '‡ '._ : ''
	endif
	return ''
endfunction

function! StatusFileformat()
	return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! StatusFiletype()
	return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! StatusFileencoding()
	return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! StatusMode()
	return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! StatusPercent()
	return winwidth(0) > 70 ? expand('%03p%%') : ''
endfunction

function! TabFilePath(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let bufnum = buflist[winnr - 1]
	let bufname = expand('#'.bufnum.':t')
	let buffullname = expand('#'.bufnum.':p')
	let buffullnames = []
	let bufnames = []
	for i in range(1, tabpagenr('$'))
		if i != a:n
			let num = tabpagebuflist(i)[tabpagewinnr(i) - 1]
			call add(buffullnames, expand('#' . num . ':p'))
			call add(bufnames, expand('#' . num . ':t'))
		endif
	endfor
	let i = index(bufnames, bufname)
	if strlen(bufname) && i >= 0 && buffullnames[i] != buffullname
		return substitute(buffullname, '.*/\([^/]\+/\)', '\1', '')
	else
		return strlen(bufname) ? bufname : '[No Name]'
	endif
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
	let g:lightline.fname = a:fname
	return lightline#statusline(0)
endfunction

"augroup AutoSyntastic
  "autocmd!
  "autocmd BufWritePost *.c,*.cpp call s:syntastic()
"augroup END

"function! s:syntastic()
	"SyntasticCheck
	"call lightline#update()
"endfunction
