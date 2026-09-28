-- Extend and create a/i textobjects
-- Derived from LazyVim (Apache-2.0), modified for this config:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/coding.lua
local pack = require('rafi.pack')

pack.later(function()
	vim.pack.add({ 'https://github.com/nvim-mini/mini.ai' })
	local ai = require('mini.ai')
	local opts = {
		n_lines = 500,
		custom_textobjects = {
			o = ai.gen_spec.treesitter({ -- code block
				a = { '@block.outer', '@conditional.outer', '@loop.outer' },
				i = { '@block.inner', '@conditional.inner', '@loop.inner' },
			}),
			f = ai.gen_spec.treesitter({
				a = '@function.outer',
				i = '@function.inner',
			}), -- function
			c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
			t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' }, -- tags
			d = { '%f[%d]%d+' }, -- digits
			e = { -- Word with case
				{
					'%u[%l%d]+%f[^%l%d]',
					'%f[%S][%l%d]+%f[^%l%d]',
					'%f[%P][%l%d]+%f[^%l%d]',
					'^[%l%d]+%f[^%l%d]',
				},
				'^().*()$',
			},
			g = require('rafi.util.mini').ai_buffer, -- buffer
			u = ai.gen_spec.function_call(), -- u for "Usage"
			U = ai.gen_spec.function_call({ name_pattern = '[%w_]' }), -- no dot in name
		},
	}
	ai.setup(opts)
	require('rafi.util.mini').on_which_key(function()
		require('rafi.util.mini').ai_whichkey(opts)
	end)
end)
