setlocal makeprg=jshint\ %
setlocal errorformat=%-P%f,\%E%>\ #%n\ %m,%Z%.%#Line\ %l\\,\ Pos\ %c,\%-G%f\ is\ OK.,%-Q
let b:dispatch = 'jshint %'
nnoremap <buffer> K :!zeal --query "<cword>"&<CR><CR>
