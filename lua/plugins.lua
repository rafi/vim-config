return {

	-- Enable GitHub's Copilot
	{ import = "rafi.plugins.extras.coding.copilot" },

	-- Enable yaml-companion
	{ import = "rafi.plugins.extras.lsp.yaml-companion" },

	-- Enable yaml plugins
	{ import = "rafi.plugins.extras.lang.yaml" },

	-- Enable go plugins
	{ import = "rafi.plugins.extras.lang.go" },

	-- Enable docker plugins
	{ import = "rafi.plugins.extras.lang.docker" },

	-- Enable python plugins
	{ import = "rafi.plugins.extras.lang.python" },

	-- Accerelated-jk plugin
	{
		"rainbowhxch/accelerated-jk.nvim",
		lazy = false,
	},

	-- Waka Time coding tracker plugin
	{
		"wakatime/vim-wakatime",
		lazy = false,
	},

	-- Change bufferline options
	{
		"akinsho/bufferline.nvim",
		highlights = {
			-- tab = {
			--     fg = '<colour-value-here>',
			--     bg = '<colour-value-here>',
			-- },
			-- tab_selected = {
			--     fg = '<colour-value-here>',
			--     bg = '<colour-value-here>',
			-- },
			-- tab_separator = {
			--   fg = '<colour-value-here>',
			--   bg = '<colour-value-here>',
			-- },
			-- tab_separator_selected = {
			--   fg = '<colour-value-here>',
			--   bg = '<colour-value-here>',
			--   sp = '<colour-value-here>',
			--   underline = '<colour-value-here>',
			-- },
		},
		opts = {
			options = {
				indicator = {
					style = "icon",
					icon = "▎",
				},
				show_tab_indicators = true,
				style_preset = "minimal",
				separator_style = "thin",
				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					local icon = level:match("error") and " " or " "
					return " " .. icon .. count
				end,
			},
		},
	},
}
