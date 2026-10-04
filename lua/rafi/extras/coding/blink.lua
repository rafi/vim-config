-- Code completion with blink.cmp
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/coding/blink.lua
local pack = require('rafi.pack')

pack.on_event('InsertEnter,CmdlineEnter', function()
	vim.pack.add({
		'https://github.com/rafamadriz/friendly-snippets',
		-- Tagged releases download a prebuilt fuzzy matcher library.
		{
			src = 'https://github.com/saghen/blink.cmp',
			version = vim.version.range('1.*'),
		},
	})

	local blink = require('rafi.util.blink')

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	local opts = {
		snippets = {
			preset = 'default',
			expand = blink.expand,
		},

		appearance = {
			-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- adjusts spacing to ensure icons are aligned
			nerd_font_variant = 'mono',
			kind_icons = vim.deepcopy(require('rafi.util.icons').kinds),
		},

		completion = {
			-- experimental auto-brackets support
			accept = { auto_brackets = { enabled = true } },
			-- Don't select by default, auto insert on selection
			list = { selection = { preselect = false, auto_insert = true } },
			menu = { draw = { treesitter = { 'lsp' } } },
			documentation = { auto_show = true, auto_show_delay_ms = 200 },
			ghost_text = { enabled = vim.g.ai_cmp ~= false },
		},

		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
			per_filetype = {
				lua = { inherit_defaults = true, 'lazydev' },
			},
			providers = {
				lazydev = {
					name = 'LazyDev',
					module = 'lazydev.integrations.blink',
					score_offset = 100, -- above LSP items
				},
			},
		},

		cmdline = {
			enabled = true,
			keymap = {
				preset = 'cmdline',
				['<Right>'] = false,
				['<Left>'] = false,
			},
			completion = {
				list = { selection = { preselect = false } },
				menu = {
					auto_show = function()
						return vim.fn.getcmdtype() == ':'
					end,
				},
				ghost_text = { enabled = true },
			},
		},

		keymap = {
			preset = 'enter',
			['<C-y>'] = { 'select_and_accept' },
			['<C-j>'] = { 'select_next', 'fallback' },
			['<C-k>'] = { 'select_prev', 'fallback' },
			['<C-d>'] = { 'select_next', 'fallback' },
			['<C-u>'] = { 'select_prev', 'fallback' },
			['<C-h>'] = { 'snippet_backward', 'fallback' },
			['<C-l>'] = { 'snippet_forward', 'fallback' },
			['<Tab>'] = {
				blink.map({ 'snippet_forward', 'ai_nes', 'ai_accept' }),
				'fallback',
			},
		},
	}
	if vim.g.cmp_supertab then
		opts.keymap = vim.tbl_extend('force', opts.keymap, blink.supertab())
	end

	require('blink.cmp').setup(opts)
end)
