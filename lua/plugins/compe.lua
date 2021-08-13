-- plugin: nvim-compe
-- see: https://github.com/hrsh7th/nvim-compe
-- rafi settings

-- defaults:
-- THROTTLE_TIME = 80
-- SOURCE_TIMEOUT = 200
-- RESOLVE_TIMEOUT = 800
-- INCOMPLETE_DELAY = 400

require('compe').setup({
	-- debug = false,
	-- min_length = 1,
	-- preselect = 'enable',
	max_abbr_width = math.ceil(vim.o.columns / 3),
	max_kind_width = 20,
	max_menu_width = 10,
	source = {
		path = true,
		buffer = { kind = '  ', menu = '[Buf]' },  --     
		nvim_lsp = true,
		nvim_lua = true,
		vsnip = { kind = ' ⮡  (Snippet)' },  -- ⮡
		orgmode = true,
		tmux = { kind = '  ', all_panes = true },  --   
		calc = false,
		spell = {
			kind = ' ',  --  
			filetypes = {'mail', 'gitcommit', 'markdown', 'text'},
		},
	},
	documentation = {
		border = 'rounded',
		max_width = 120,
		min_width = 60,
		max_height = math.floor(vim.o.lines * 0.3),
		min_height = 1,
		winhighlight = 'NormalFloat:CompeDocumentation,FloatBorder:UserBorder',
	}
})

-- Register compe-tmux
require('compe').register_source('tmux', require('compe_tmux'))

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
	local col = vim.fn.col('.') - 1
	return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- autopairs confirm selection
-- see windwp/nvim-autopairs
_G.confirm_completion = function()
	local npairs = require('nvim-autopairs')
	if vim.fn.pumvisible() == 0 then
		return npairs.autopairs_cr()
	elseif vim.fn.complete_info()['selected'] ~= -1 then
		return vim.fn['compe#confirm'](npairs.autopairs_cr())
		-- return vim.fn['compe#confirm'](npairs.esc('<cr>'))
	else
		return npairs.esc('<cr>')
	end
end

-- delimiMate confirm selection
-- see https://github.com/Raimondi/delimitMate
-- _G.confirm_completion = function()
-- 	if vim.fn.pumvisible() == 0 then
-- 		return t '<Plug>delimitMateCR'
-- 	elseif vim.fn.complete_info()['selected'] ~= -1 then
-- 	  return vim.fn['compe#confirm']({ keys = t '<Plug>delimitMateCR', mode = '' })
-- 	else
-- 		return t '<C-e><Plug>delimitMateCR'
-- 	end
-- end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t '<C-n>'
	elseif vim.fn['vsnip#available'](1) == 1 then
		return t '<Plug>(vsnip-expand-or-jump)'
	elseif check_back_space() then
		return t '<Tab>'
	else
		return vim.fn['compe#complete']()
	end
end

_G.s_tab_complete = function()
	if vim.fn.pumvisible() == 1 then
		return t '<C-p>'
	elseif vim.fn['vsnip#jumpable'](-1) == 1 then
		return t '<Plug>(vsnip-jump-prev)'
	else
		-- If <S-Tab> is not working in your terminal, change it to <C-h>
		return t '<C-h>'
	end
end

local keymap = vim.api.nvim_set_keymap
local args = { expr = true, noremap = true, silent = true }

keymap('i', '<C-Space>', 'compe#complete()', args)
keymap('i', '<CR>', 'v:lua.confirm_completion()', args)
keymap('i', '<C-e>', "compe#close('<C-e>')", args)
keymap('i', '<C-u>', "compe#scroll({ 'delta': 4 })", args)
keymap('i', '<C-d>', "compe#scroll({ 'delta': -4 })", args)

keymap('i', '<Tab>', 'v:lua.tab_complete()', { expr = true })
keymap('s', '<Tab>', 'v:lua.tab_complete()', { expr = true })
keymap('i', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })
keymap('s', '<S-Tab>', 'v:lua.s_tab_complete()', { expr = true })

-- vim: set ts=2 sw=2 tw=80 noet :
