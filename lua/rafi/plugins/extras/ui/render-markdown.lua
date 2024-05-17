return {

	-- Improve viewing Markdown files.
	{
		'MeanderingProgrammer/markdown.nvim',
		name = 'render-markdown',
		ft = { 'markdown' },
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		opts = {
			render_modes = { 'n', 'c' },
			headings = { ' ', '󰉬  ', '󰉭  ', '󰉮  ', '󰉯  ', '󰉰  ' },
			highlights = {
				heading = {
					-- Background of heading line
					backgrounds = { 'TabLineFill' },
					-- Foreground of heading character only
					foregrounds = {
						'markdownH1',
						'markdownH2',
						'markdownH3',
						'markdownH4',
						'markdownH5',
						'markdownH6',
					},
				},
				-- Horizontal break
				dash = 'LineNr',
				-- Code blocks
				code = 'ColorColumn',
				-- Bullet points in list
				bullet = '@include',
				checkbox = {
					-- Unchecked checkboxes
					unchecked = '@markup.list.unchecked',
					-- Checked checkboxes
					checked = '@markup.heading',
				},
				table = {
					-- Header of a markdown table
					head = '@markup.heading',
					-- Non header rows in a markdown table
					row = 'Normal',
				},
				-- LaTeX blocks
				latex = '@markup.math',
				-- Quote character in a block quote
				quote = '@markup.quote',
			},
		},
	},
}
