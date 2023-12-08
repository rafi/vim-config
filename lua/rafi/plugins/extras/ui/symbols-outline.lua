return {

	{
		'simrat39/symbols-outline.nvim',
		cmd = { 'SymbolsOutline', 'SymbolsOutlineOpen' },
		keys = {
			{ '<Leader>o', '<cmd>SymbolsOutline<CR>', desc = 'Symbols Outline' },
		},
		opts = function()
			local Config = require('lazyvim.config')
			local defaults = require('symbols-outline.config').defaults
			local opts = {
				width = 30,
				autofold_depth = 0,
				keymaps = {
					hover_symbol = 'K',
					toggle_preview = 'p',
				},
				symbols = {},
				symbol_blacklist = {},
			}
			local filter = Config.kind_filter

			if type(filter) == 'table' then
				filter = filter.default
				if type(filter) == 'table' then
					for kind, symbol in pairs(defaults.symbols) do
						opts.symbols[kind] = {
							icon = Config.icons.kinds[kind] or symbol.icon,
							hl = symbol.hl,
						}
						if not vim.tbl_contains(filter, kind) then
							table.insert(opts.symbol_blacklist, kind)
						end
					end
				end
			end
			return opts
		end,
		init = function()
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_outline', {}),
				pattern = 'Outline',
				callback = function()
					vim.opt_local.winhighlight = 'CursorLine:WildMenu'
					vim.opt_local.signcolumn = 'auto'
				end,
			})
		end,
	},
}
