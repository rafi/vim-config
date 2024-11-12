return {

	{
		'neovim/nvim-lspconfig',
		opts = { document_highlight = { enabled = false } },
	},

	-- Highlights other uses of the word under the cursor
	{
		'RRethy/vim-illuminate',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { 'lsp' },
			},
			under_cursor = false,
			modes_allowlist = { 'n', 'no', 'nt' },
			filetypes_denylist = {
				'DiffviewFileHistory',
				'DiffviewFiles',
				'fugitive',
				'git',
				'minifiles',
				'neo-tree',
				'Outline',
				'SidebarNvim',
			},
		},
		keys = {
			{ ']]', desc = 'Next Reference' },
			{ '[[', desc = 'Prev Reference' },
		},
		config = function(_, opts)
			require('illuminate').configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set('n', key, function()
					require('illuminate')['goto_' .. dir .. '_reference'](false)
				end, {
					desc = dir:sub(1, 1):upper() .. dir:sub(2) .. ' Reference',
					buffer = buffer,
				})
			end

			Snacks.toggle({
				name = 'Illuminate',
				get = function()
					return not require('illuminate.engine').is_paused()
				end,
				set = function(enabled)
					local m = require('illuminate')
					if enabled then
						m.resume()
					else
						m.pause()
					end
				end,
			}):map('<leader>ux')

			map(']]', 'next')
			map('[[', 'prev')

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd('FileType', {
				group = vim.api.nvim_create_augroup('rafi_illuminate', {}),
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map(']]', 'next', buffer)
					map('[[', 'prev', buffer)
				end,
			})
		end,
	},
}
