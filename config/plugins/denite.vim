
" denite.nvim
" -----------

" INTERFACE
call denite#custom#option('default', 'prompt', 'λ:')
call denite#custom#option('default', 'vertical_preview', 1)
call denite#custom#option('default', 'short_source_names', 1)

call denite#custom#option('grep', 'empty', 0)
call denite#custom#option('grep', 'vertical_preview', 1)
call denite#custom#option('grep', 'auto_highlight', 0)

call denite#custom#option('list', 'mode', 'normal')
call denite#custom#option('list', 'winheight', 12)

call denite#custom#option('mpc', 'quit', 0)
call denite#custom#option('mpc', 'mode', 'normal')
call denite#custom#option('mpc', 'winheight', 12)

" MATCHERS
" Default is 'matcher_fuzzy'
if &runtimepath =~# '\/cpsm'
	call denite#custom#source(
		\ 'buffer,file_mru,file_old,file_rec,grep,mpc,line',
		\ 'matchers', ['matcher_cpsm', 'matcher_fuzzy'])
endif

" SORTERS
" Default is 'sorter_rank'

" CONVERTERS
" Default is none
call denite#custom#source(
	\ 'buffer,file_mru,file_old',
	\ 'converters', ['converter_relative_word'])

" FIND and GREP COMMANDS
if executable('ag')
	" The Silver Searcher
	call denite#custom#var('file_rec', 'command',
		\ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])

	call denite#custom#var('grep', 'command', ['ag'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', [])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('grep', 'default_opts',
		\ [ '--vimgrep', '--smart-case' ])

elseif executable('ack')
	" Ack command
	call denite#custom#var('grep', 'command', ['ack'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--match'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
	call denite#custom#var('grep', 'default_opts',
			\ ['--ackrc', $HOME.'/.config/ackrc', '-H',
			\ '--nopager', '--nocolor', '--nogroup', '--column'])
endif

" KEY MAPPINGS
let insert_mode_mappings = [
	\  ['jj', '<denite:enter_mode:normal>', 'noremap'],
	\  ['<Esc>', '<denite:enter_mode:normal>', 'noremap'],
	\  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
	\  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
	\  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
	\  ['<Down>', '<denite:assign_next_text>', 'noremap'],
	\  ['<C-Y>', '<denite:redraw>', 'noremap'],
	\ ]

let normal_mode_mappings = [
	\   ["'", '<denite:toggle_select_down>', 'noremap'],
	\   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
	\   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
	\   ['gg', '<denite:move_to_first_line>', 'noremap'],
	\   ['st', '<denite:do_action:tabopen>', 'noremap'],
	\   ['sg', '<denite:do_action:vsplit>', 'noremap'],
	\   ['sv', '<denite:do_action:split>', 'noremap'],
	\   ['sc', '<denite:quit>', 'noremap'],
	\   ['r', '<denite:redraw>', 'noremap'],
	\ ]

for m in insert_mode_mappings
	call denite#custom#map('insert', m[0], m[1], m[2])
endfor
for m in normal_mode_mappings
	call denite#custom#map('normal', m[0], m[1], m[2])
endfor

" vim: set ts=2 sw=2 tw=80 noet :
