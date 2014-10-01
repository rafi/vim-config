setlocal makeprg=jshint\ %
setlocal suffixesadd=.js
setlocal errorformat=%-P%f,\%E%>\ #%n\ %m,%Z%.%#Line\ %l\\,\ Pos\ %c,\%-G%f\ is\ OK.,%-Q
nnoremap <buffer> K :!zeal --query "<cword>"&<CR><CR>
