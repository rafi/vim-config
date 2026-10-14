-- Better yank and paste: yank ring, history picker, cycle after put
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/yanky.lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/gbprod/yanky.nvim' })
	require('yanky').setup({
		system_clipboard = {
			sync_with_ring = not vim.env.SSH_CONNECTION,
		},
		highlight = { timer = 150 },
	})
end

-- Yank history picker in snacks. Selecting an entry puts it after the
-- cursor.
local function snacks_history()
	local items = {}
	for i, entry in ipairs(require('yanky.history').all()) do
		local text = entry.regcontents or ''
		items[#items + 1] = {
			idx = i,
			text = text,
			preview = { text = text, ft = entry.filetype },
			entry = entry,
		}
	end
	Snacks.picker.pick({
		title = 'Yank History',
		items = items,
		format = 'text',
		preview = 'preview',
		confirm = function(picker, item)
			picker:close()
			if item then
				vim.fn.setreg('"', item.entry.regcontents, item.entry.regtype)
				vim.cmd('normal! ""p')
			end
		end,
	})
end

local function history()
	load()
	local picker = require('rafi.util.pick').picker
	if picker and picker.name == 'telescope' then
		pcall(require('telescope').load_extension, 'yank_history')
		require('telescope').extensions.yank_history.yank_history({})
	elseif not picker and _G.Snacks then
		snacks_history()
	else
		vim.cmd('YankyRingHistory')
	end
end

-- Loads on first yank, put or command.
pack.on_event('BufReadPost,BufNewFile', load)
pack.command({ 'YankyRingHistory', 'YankyClearHistory' }, load, {
	nargs = '*',
})

-- Expr maps can't load plugins. If yanky isn't loaded, load it right
-- after and replay the key with its count and register.
---@param lhs string
---@param plug string
---@param desc string
---@param mode? string|string[]
local function map(lhs, plug, desc, mode)
	vim.keymap.set(mode or 'n', lhs, function()
		if loaded then
			return plug
		end
		local prefix = (vim.v.register ~= '"' and '"' .. vim.v.register or '')
			.. (vim.v.count > 0 and vim.v.count or '')
		vim.schedule(function()
			load()
			local keys = vim.api.nvim_replace_termcodes(plug, true, true, true)
			vim.api.nvim_feedkeys(prefix .. keys, 'm', false)
		end)
		return ''
	end, { expr = true, remap = true, desc = desc })
end

-- NOTE: Conflict: yanky wins over core `p`, `P` and `y`, including core's
-- x-mode `p` that keeps the register.
local function apply()
	-- stylua: ignore start
	vim.keymap.set({ 'n', 'x' }, '<leader>p', history, { desc = 'Open Yank History' })
	map('y', '<Plug>(YankyYank)', 'Yank Text', { 'n', 'x' })
	map('p', '<Plug>(YankyPutAfter)', 'Put Text After Cursor', { 'n', 'x' })
	map('P', '<Plug>(YankyPutBefore)', 'Put Text Before Cursor', { 'n', 'x' })
	map('gp', '<Plug>(YankyGPutAfter)', 'Put Text After Selection', { 'n', 'x' })
	map('gP', '<Plug>(YankyGPutBefore)', 'Put Text Before Selection', { 'n', 'x' })
	map('[y', '<Plug>(YankyCycleForward)', 'Cycle Forward Through Yank History')
	map(']y', '<Plug>(YankyCycleBackward)', 'Cycle Backward Through Yank History')
	map(']p', '<Plug>(YankyPutIndentAfterLinewise)', 'Put Indented After Cursor (Linewise)')
	map('[p', '<Plug>(YankyPutIndentBeforeLinewise)', 'Put Indented Before Cursor (Linewise)')
	map(']P', '<Plug>(YankyPutIndentAfterLinewise)', 'Put Indented After Cursor (Linewise)')
	map('[P', '<Plug>(YankyPutIndentBeforeLinewise)', 'Put Indented Before Cursor (Linewise)')
	map('>p', '<Plug>(YankyPutIndentAfterShiftRight)', 'Put and Indent Right')
	map('<p', '<Plug>(YankyPutIndentAfterShiftLeft)', 'Put and Indent Left')
	map('>P', '<Plug>(YankyPutIndentBeforeShiftRight)', 'Put Before and Indent Right')
	map('<P', '<Plug>(YankyPutIndentBeforeShiftLeft)', 'Put Before and Indent Left')
	map('=p', '<Plug>(YankyPutAfterFilter)', 'Put After Applying a Filter')
	map('=P', '<Plug>(YankyPutBeforeFilter)', 'Put Before Applying a Filter')
	-- stylua: ignore end
end

apply()
vim.api.nvim_create_autocmd('User', {
	pattern = 'RafiKeymaps',
	once = true,
	callback = apply,
})
