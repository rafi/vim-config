return {
	{
		'akinsho/bufferline.nvim',
		event = 'VeryLazy',
		opts = {
			options = {
				mode = 'tabs',
				separator_style = 'slant',
				show_close_icon = false,
				show_buffer_close_icons = false,
				diagnostics = false,
				always_show_bufferline = true,
				diagnostics_indicator = function(_, _, diag)
					local icons = require('rafi.config').icons.diagnostics
					local ret = (diag.error and icons.Error .. diag.error .. ' ' or '')
						.. (diag.warning and icons.Warn .. diag.warning or '')
					return vim.trim(ret)
				end,
				custom_areas = {
					right = function()
						local project_root = require('rafi.lib.badge').project()
						local result = {}
						local part = {}
						part.text = '%#BufferLineTab# ' .. project_root
						table.insert(result, part)

						-- Session indicator
						if vim.v['this_session'] ~= '' then
							table.insert(result, { text = '%#BufferLineTab#  ' })
						end
						return result
					end,
				},
				offsets = {
					{
						filetype = 'neo-tree',
						text = 'Neo-tree',
						highlight = 'Directory',
						text_align = 'center',
					},
				},
			},
		},
	},
}
