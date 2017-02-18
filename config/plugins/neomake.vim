
" Neomake
" ---------
let g:neomake_verbose = 1
let g:neomake_serialize = 1
let g:neomake_serialize_abort_on_error = 0
let g:airline#extensions#neomake#enabled = 0

" JAVASCRIPT / JSX
" ----------------
let g:neomake_jsx_enabled_makers = ['eslint']
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_javascript_eslint_exe = './node_modules/.bin/eslint'

" YAML / ANSIBLE
" --------------
let g:neomake_yaml_enabled_makers = ['yamllint']
let g:neomake_ansible_enabled_makers = ['yamllint']
let g:neomake_ansible_yamllint_maker = neomake#makers#ft#yaml#yamllint()

" vim: set ts=2 sw=2 tw=80 noet :
