-- plugin: gina.vim
-- :h gina.txt
-- see: https://github.com/lambdalisue/gina.vim
-- rafi settings

local command_alias = vim.fn['gina#custom#command#alias']
local command_option = vim.fn['gina#custom#command#option']
local custom_execute = vim.fn['gina#custom#execute']
local action_alias = vim.fn['gina#custom#action#alias']

-- Commands
--

-- status
command_option('status', '-s')
command_option('status', '-b')

-- log
command_option('log', '--graph')
command_option('log', '-M')

-- lg (log --all)
command_alias('log', 'lg')
command_option('lg', '--all')
command_option('lg', '-M')

-- commit
command_option('commit', '--opener', 'below vnew')
command_option('commit', '-v|--verbose')

command_option('/\\%(status\\|commit\\)', '-u|--untracked-files')

-- Look 'n Feel
--

local winwidth = vim.fn.winwidth(0)
local width_half = winwidth / 2
local width_quarter = winwidth / 4

-- command_option('/\v(status|branch|ls|grep|changes)', '--opener', 'botright 10split')
-- command_option('/\v(blame|diff|log)', '--opener', 'tabnew')

-- Blame
command_option('blame', '--width', '40')
vim.g['gina#command#blame#formatter#format'] = '%au: %su%=on %ti %ma%in'
vim.g['gina#command#blame#formatter#separator'] = '… '
vim.g['gina#command#blame#formatter#current_mark'] = '>'

vim.g['gina#command#blame#formatter#timestamp_months'] = 3
vim.g['gina#command#blame#formatter#timestamp_format1'] = '%d %b'
vim.g['gina#command#blame#formatter#timestamp_format2'] = '%d/%b/%Y'

-- Open in vertical split
command_option('/\\%(branch\\|changes\\|grep\\)',
	'--opener', 'vsplit')

-- Open in bottom horizontal split
command_option('/\\%(log\\|reflog\\)',
	'--opener', 'below new')

-- log - Move to bottom
custom_execute('log',
	'wincmd J | execute "resize" &previewheight | setlocal winfixheight')

-- changes/ls - Fixed window, half-size
custom_execute('/\\%(changes\\|ls\\)',
	'vertical resize ' .. width_half .. ' | setlocal winfixwidth')

-- branch - Fixed window, quarter-size
custom_execute(
	'/\\%(branch\\)',
	'vertical resize ' .. width_quarter .. ' | setlocal winfixwidth')

-- Mappings
--

local opts = {noremap = 1, silent = 1}
-- local nowait = {noremap = 1, silent = 1, nowait = 1}
local nmap = vim.fn['gina#custom#mapping#nmap']

-- Alias 'p'/'dp' globally
action_alias('/.*', 'dp', 'diff:preview')
nmap('/.*', 'dp', ":<C-u>call gina#action#call('dp')<CR>", opts)
-- nmap('/.*', 'p', ":<C-u>call gina#action#call('preview')<CR>", nowait)

-- Preview commits
action_alias('/\\%(blame\\|log\\)', 'preview', 'show:commit:preview')

nmap('status', 'go', '<Plug>(gina-status-browse)')

-- Echo chunk info with K
nmap('blame', 'K', '<Plug>(gina-blame-echo)')
nmap('blame', 'p', '<cmd>call v:lua.gina_popup("Gina show HEAD --opener=split")<CR>', opts)

-- Blame mappings
vim.g['gina#command#blame#use_default_mappings'] = 0
nmap('blame', '<Return>', '<Plug>(gina-blame-open)')
nmap('blame', '<Backspace>', '<Plug>(gina-blame-back)')
nmap('blame', '<C-r>', '<Plug>(gina-blame-C-L)')

-- vim: set ts=2 sw=0 tw=80 noet :
