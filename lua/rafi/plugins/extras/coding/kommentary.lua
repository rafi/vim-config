return {

	{
		'b3nj5m1n/kommentary',
		event = 'FileType',
		keys = {
			{ '<Leader>v', '<Plug>kommentary_line_default' },
			{ '<Leader>v', '<Plug>kommentary_visual_default<C-c>', mode = 'x' },
			{ '<Leader>V', '<Plug>kommentary_visual_increase<C-c', mode = 'x' },
		},
		config = function()
			-- Setup context-aware commenting via nvim-ts-context-commentstring
			-- See also lua/plugins/treesitter.lua
			local update_commentstring = {
				hook_function = function()
					-- See https://github.com/JoosepAlviste/nvim-ts-context-commentstring
					require('ts_context_commentstring.internal').update_commentstring({})
				end,
				single_line_comment_string = 'auto',
				multi_line_comment_strings = 'auto',
			}

			local k = require('kommentary.config')
			k.configure_language('typescriptreact', update_commentstring)
			k.configure_language('javascriptreact', update_commentstring)
			k.configure_language('html', update_commentstring)
			k.configure_language('svelte', update_commentstring)
			k.configure_language('markdown', update_commentstring)

			k.configure_language('lua', {
				single_line_comment_string = '--',
				multi_line_comment_strings = { '--[[', ']]' },
				prefer_single_line_comments = true,
			})
		end,
	},

}
