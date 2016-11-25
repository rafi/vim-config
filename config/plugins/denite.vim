
" denite.nvim
" -----------

" INTERFACE
call denite#custom#option('default', 'prompt', 'λ:')
call denite#custom#option('default', 'vertical_preview', 1)

call denite#custom#var('file_rec', 'command',
	\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

" MATCHERS
call denite#custom#source('file_mru', 'matchers', ['matcher_fuzzy'])

" CONVERTERS
call denite#custom#source('file_mru', 'converters',
	\ ['converter_relative_word'])

" GREP COMMAND
" The Silver Searcher for grep source
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'default_opts',
	\ ['--vimgrep', '--smart-case' ])

" KEY MAPPINGS
let insert_mode_mappings = {
	\ '<C-j>': 'move_to_next_line',
	\ '<C-k>': 'move_to_prev_line',
	\ '<C-w>': 'do_action:preview',
	\ '<Esc>': 'enter_mode:normal',
	\ '<C-n>': 'jump_to_next_source',
	\ '<C-p>': 'jump_to_prev_source',
	\ '<C-r>': 'redraw',
	\}

let normal_mode_mappings = {
	\ 'r': 'redraw',
	\ '<C-n>': 'jump_to_next_source',
	\ '<C-p>': 'jump_to_prev_source',
	\}

for [char, value] in items(insert_mode_mappings)
	call denite#custom#map('insert', char, value)
endfor
for [char, value] in items(normal_mode_mappings)
	call denite#custom#map('normal', char, value)
endfor
