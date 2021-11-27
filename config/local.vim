" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

" GitHub Copilot
imap <silent><script><expr> <C-L> copilot#Accept()
let g:copilot_no_tab_map = v:true
let g:copilot_assume_mapped = v:true
