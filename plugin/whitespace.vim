" bad-whitespace.vim - Highlights whitespace at the end of lines
" Maintainer:   Bit Connor <bit@mutantlemon.com>
" Version:      0.3

function! s:ShowBadWhitespace(force)
  if a:force
    let b:bad_whitespace_show = 1
  endif
  highlight default BadWhitespace ctermbg=red guibg=red
  autocmd ColorScheme <buffer> highlight default BadWhitespace ctermbg=red guibg=red
  match BadWhitespace /\s\+$/
  autocmd InsertLeave <buffer> match BadWhitespace /\s\+$/
  autocmd InsertEnter <buffer> match BadWhitespace /\s\+\%#\@<!$/
endfunction

function! s:HideBadWhitespace(force)
  if a:force
    let b:bad_whitespace_show = 0
  endif
  match none BadWhitespace
endfunction

function! s:EnableShowBadWhitespace()
  if exists("b:bad_whitespace_show")
    return
  endif
  if &modifiable
    call <SID>ShowBadWhitespace(0)
  else
    call <SID>HideBadWhitespace(0)
  endif
endfunction

function! s:ToggleBadWhitespace()
  if !exists("b:bad_whitespace_show")
    let b:bad_whitespace_show = 0
    if &modifiable
      let b:bad_whitespace_show = 1
    endif
  endif
  if b:bad_whitespace_show
    call <SID>HideBadWhitespace(1)
  else
    call <SID>ShowBadWhitespace(1)
  endif
endfunction

" Run :EraseBadWhitespace to remove end of line white space.
function! s:EraseBadWhitespace(line1,line2)
  let l:save_cursor = getpos(".")
  silent! execute ':' . a:line1 . ',' . a:line2 . 's/\s\+$//'
  call setpos('.', l:save_cursor)
endfunction

command! -range=% EraseBadWhitespace call <SID>EraseBadWhitespace(<line1>,<line2>)
command! ShowBadWhitespace call <SID>ShowBadWhitespace(1)
command! HideBadWhitespace call <SID>HideBadWhitespace(1)
command! ToggleBadWhitespace call <SID>ToggleBadWhitespace()
command! EnableShowBadWhitespace call <SID>EnableShowBadWhitespace()

"autocmd BufWinEnter,WinEnter,FileType * call <SID>EnableShowBadWhitespace()
