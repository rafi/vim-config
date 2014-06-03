
" Lightline
" ---------
" Icons:
"   Regular | Powerline
"           |  
"   / •     |  
"   § ‡     |  

let g:lightline = {
	\ 'colorscheme': 'jellybeans',
	\ 'active': {
	\   'left': [ [ 'mode', 'paste' ],
	\             [ 'fugitive', 'filename' ] ]
	\ },
	\ 'component_function': {
	\   'filename': 'StatusFilename',
	\   'modified': 'StatusModified',
	\   'readonly': 'StatusReadonly',
	\   'fugitive': 'StatusFugitive',
	\   'fileformat': 'StatusFileformat',
	\   'filetype': 'StatusFiletype',
	\   'fileencoding': 'StatusFileencoding',
	\   'mode': 'StatusMode',
	\ },
	\ 'tab_component_function': {
	\   'filename': 'TabFilePath',
	\ },
	\ 'separator': { 'left': '', 'right': '' },
	\ 'subseparator': { 'left': '/', 'right': '•' }
	\ }

function! StatusModified()
	return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! StatusReadonly()
	return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '§' : ''
endfunction

function! StatusFilename()
	return ('' != StatusReadonly() ? StatusReadonly() . ' ' : '') .
				\ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
				\  &ft == 'unite' ? unite#get_status_string() : 
				\  &ft == 'vimshell' ? vimshell#get_status_string() :
				\  &ft == 'minibufexpl' ? '' :
				\ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
				\ ('' != StatusModified() ? ' ' . StatusModified() : '')
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

function! TabFilePath(n)
	let bufnr = tabpagebuflist(a:n)[tabpagewinnr(a:n) - 1]
	let bufname = expand('#' . bufnr . ':t')
	let buffullname = expand('#' . bufnr . ':p')
	let fname = substitute(buffullname, getcwd().'/', '', 'N/A')
	return fname
endfunction
