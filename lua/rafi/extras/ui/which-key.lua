-- Popup with possible key bindings of the command you started typing
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/editor.lua
local pack = require('rafi.pack')

local loaded = false
local function load()
	if loaded then
		return
	end
	loaded = true
	-- Sources plugin/which-key.lua, whose auto-setup timer is skipped
	-- once setup below has run.
	vim.pack.add({ 'https://github.com/folke/which-key.nvim' })
	-- stylua: ignore
	require('which-key').setup({
		preset = 'helix',
		icons = {
			breadcrumb = '»',
			separator = '󰁔  ', -- ➜
		},
		delay = function(ctx)
			return ctx.plugin and 0 or 400
		end,
		spec = {
			{
				mode = { 'n', 'x' },
				{ '<leader><tab>', group = 'tabs' },
				{ '<leader>c', group = 'code' },
				{ '<leader>d', group = 'debug' },
				{ '<leader>dp', group = 'profiler' },
				{ '<leader>f', group = 'file/find' },
				{ '<leader>g', group = 'git' },
				{ '<leader>gh', group = 'hunks' },
				{ '<leader>q', group = 'quit/session' },
				{ '<leader>s', group = 'search' },
				{ '<leader>u', group = 'ui' },
				{ '<leader>x', group = 'diagnostics/quickfix' },
				{ '[', group = 'prev' },
				{ ']', group = 'next' },
				{ 'g', group = 'goto' },
				{ 'gs', group = 'surround' },
				{ 'z', group = 'fold' },
				{
					'<leader>b',
					group = 'buffer',
					expand = function()
						return require('which-key.extras').expand.buf()
					end,
				},
				{
					'<leader>w',
					group = 'windows',
					proxy = '<c-w>',
					expand = function()
						return require('which-key.extras').expand.win()
					end,
				},
				-- Better descriptions
				{ 'gx', desc = 'Open with system app' },
			},
			{
				{ 'gs', group = nil },
				{ 'gz', group = 'surround', icon = { icon = '󱞹 ', color = 'cyan' } },
				{ ';d', group = 'lsp' },
				{ ';',  group = 'picker' },
				{ '<leader>cl', group = 'calls' },
				{ '<leader>ci', group = 'info' },
				{ '<leader>fw', group = 'workspace' },
				{ '<leader>ght', group = 'toggle' },
				{ '<leader>ht', group = 'toggle' },
				{ '<leader>m',  group = 'tools', icon = { icon = '󱁤 ', color = 'blue' } },
				{ '<leader>md', group = 'diff', icon = { icon = ' ', color = 'green' } },
				{ '<leader>z', group = 'notes' },
				{ '<leader>w', group = nil },
			},
		},
	})
	-- Run callbacks from rafi.util.mini.on_which_key().
	vim.api.nvim_exec_autocmds(
		'User',
		{ pattern = 'WhichKeyLoaded', modeline = false }
	)
end

pack.later(load)

-- Setup defers its real load with vim.schedule(), so on the first press
-- schedule show() behind it.
local function show(opts)
	return function()
		local config = package.loaded['which-key.config']
		if config and rawget(config, 'loaded') then
			return require('which-key').show(opts)
		end
		load()
		vim.schedule(function()
			require('which-key').show(opts)
		end)
	end
end

vim.keymap.set(
	'n',
	'<leader>bk',
	show({ global = false }),
	{ desc = 'Buffer Keymaps (which-key)' }
)
vim.keymap.set(
	'n',
	'<c-w><space>',
	show({ keys = '<c-w>', loop = true }),
	{ desc = 'Window Hydra Mode (which-key)' }
)
