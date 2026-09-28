-- Pretty lists to help you solve all code diagnostics
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	vim.pack.add({ 'https://github.com/folke/trouble.nvim' })
	-- Setup creates the :Trouble command, replacing the stub below.
	require('trouble').setup({
		modes = {
			lsp = {
				win = { position = 'right' },
			},
		},
	})
end

pack.later(load)

-- Stub until setup runs, e.g. `nvim +Trouble`.
pack.command('Trouble', load, { desc = 'Trouble' })

local function map(lhs, rhs, desc)
	vim.keymap.set('n', lhs, rhs, { desc = desc })
end

-- stylua: ignore start
map('<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', 'Diagnostics (Trouble)')
map('<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', 'Buffer Diagnostics (Trouble)')
map('<leader>xL', '<cmd>Trouble loclist toggle<CR>', 'Location List (Trouble)')
map('<leader>xQ', '<cmd>Trouble qflist toggle<CR>', 'Quickfix List (Trouble)')
map('gR', function() load() require('trouble').open('lsp_references') end, 'LSP References (Trouble)')
map('<leader>xs', '<cmd>Trouble symbols toggle<CR>', 'Symbols (Trouble)')
map('<leader>xS', '<cmd>Trouble lsp toggle<CR>', 'LSP references/definitions/... (Trouble)')
-- stylua: ignore end

map('[q', function()
	if package.loaded['trouble'] and require('trouble').is_open() then
		require('trouble').prev({ skip_groups = true, jump = true })
	else
		local ok, err = pcall(vim.cmd.cprev)
		if not ok then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end, 'Previous Trouble/Quickfix Item')

map(']q', function()
	if package.loaded['trouble'] and require('trouble').is_open() then
		require('trouble').next({ skip_groups = true, jump = true })
	else
		local ok, err = pcall(vim.cmd.cnext)
		if not ok then
			vim.notify(err, vim.log.levels.ERROR)
		end
	end
end, 'Next Trouble/Quickfix Item')
