return {

	-- Window with buffer text overview, scrollbar and highlights
	{
		'nvim-mini/mini.map',
		event = 'LazyFile',
		keys = {
			{ '<Leader>mn', '<cmd>lua MiniMap.toggle()<CR>', desc = 'Mini map' },
		},
		opts = function()
			-- local minimap = require('mini.map')
			return {
				-- See: `:h MiniMap.gen_integration`
				-- If enabled, increase (or remove) width setting.
				-- integrations = {
				-- 	minimap.gen_integration.diagnostic(),
				-- 	minimap.gen_integration.builtin_search(),
				-- 	minimap.gen_integration.gitsigns(),
				-- },
				symbols = {
					scroll_line = '⎕', -- '⎕', '█', '🮚', '▶'
					scroll_view = '┊', -- '⎮', '╎', '┋', '┊'
				},
				window = {
					show_integration_count = false,
					width = 1,
					winblend = 40,
				},
			}
		end,
		config = function(_, opts)
			local minimap = require('mini.map')
			minimap.setup(opts)
			minimap.open()
		end,
	},
}
