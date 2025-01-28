-- Plugins: UI
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Snazzy tab/bufferline
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
	{
		'bufferline.nvim',
		enabled = not vim.g.started_by_firenvim,
		-- stylua: ignore
		keys = {
			{ '<S-h>', false },
			{ '<S-l>', false },
			{ '<leader>tp', '<Cmd>BufferLinePick<CR>', desc = 'Tab Pick' },
		},
		opts = {
			options = {
				mode = 'tabs',
				separator_style = 'slant',
				show_close_icon = false,
				show_buffer_close_icons = false,
				always_show_bufferline = true,
				custom_areas = {
					right = function()
						local result = {}
						local root = LazyVim.root()
						table.insert(result, {
							text = '%#BufferLineTab# ' .. vim.fn.fnamemodify(root, ':t'),
						})

						-- Session indicator
						if vim.v.this_session ~= '' then
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

	-----------------------------------------------------------------------------
	-- Replaces the UI for messages, cmdline and the popupmenu
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
	{
		'noice.nvim',
		enabled = not vim.g.started_by_firenvim,
		---@type NoiceConfig
		opts = {
			lsp = {
				override = {
					['vim.lsp.util.convert_input_to_markdown_lines'] = true,
					['vim.lsp.util.stylize_markdown'] = true,
					['cmp.entry.get_documentation'] = true,
				},
			},
			messages = {
				view_search = false,
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				lsp_doc_border = true,
			},
			routes = {
				-- See :h ui-messages
				{
					filter = {
						event = 'msg_show',
						any = {
							{ find = '%d+L, %d+B' },
							{ find = '^%d+ changes?; after #%d+' },
							{ find = '^%d+ changes?; before #%d+' },
							{ find = '^Hunk %d+ of %d+$' },
							{ find = '^%d+ fewer lines;?' },
							{ find = '^%d+ more lines?;?' },
							{ find = '^%d+ line less;?' },
							{ find = '^Already at newest change' },
							{ kind = 'wmsg' },
							{ kind = 'emsg', find = 'E486' },
							{ kind = 'quickfix' },
						},
					},
					view = 'mini',
				},
			},
		},
	},

	-----------------------------------------------------------------------------
	-- Collection of small QoL plugins
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/util.lua
	{
		'folke/snacks.nvim',
		opts = {
			dashboard = { enabled = false },
			scroll = { enabled = false },
			terminal = {
				win = { style = 'terminal', wo = { winbar = '' } },
			},
			zen = {
				toggles = { git_signs = true },
				zoom = {
					show = { tabline = false },
					win = { backdrop = true },
				},
			},
		},
		keys = {
			{
				'<leader>N',
				desc = 'Neovim News',
				function()
					---@diagnostic disable-next-line: missing-fields
					Snacks.win({
						file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
						border = 'rounded',
						width = 0.6,
						height = 0.6,
						wo = {
							spell = false,
							wrap = false,
							statuscolumn = ' ',
							conceallevel = 3,
						},
					})
				end,
			},
		},
	},
	{
		'folke/snacks.nvim',
		keys = function(_, keys)
			if LazyVim.pick.want() ~= 'snacks' then
				return
			end
			-- stylua: ignore
			local mappings = {
				{ '<leader><localleader>', function() Snacks.picker() end, mode = { 'n', 'x' }, desc = 'Pickers' },
				{ '<localleader>i', function() Snacks.picker.icons() end, mode = { 'n', 'x' }, desc = 'Spellcheck' },
				{ '<localleader>n', function() Snacks.picker.notifications() end, desc = 'Notifications' },
				{ '<localleader>u', function() Snacks.picker.spelling() end, mode = { 'n', 'x' }, desc = 'Spellcheck' },
				{ '<localleader>/', function() Snacks.picker.search_history() end, mode = { 'n', 'x' }, desc = 'Search History' },
				{ '<leader>gF', function() Snacks.picker.files({ pattern = vim.fn.expand('<cword>') }) end, desc = 'Find File' },
				{
					'<localleader>z',
					mode = { 'n', 'x' },
					desc = 'Zoxide',
					function()
						Snacks.picker.zoxide({
							confirm = function(picker)
								picker:close()
								local item = picker:current()
								if item and item.file then
									vim.cmd.tcd(item.file)
								end
							end,
						})
					end,
				},
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = function(_, opts)
			if LazyVim.pick.want() ~= 'snacks' then
				return
			end
			return vim.tbl_deep_extend('force', opts or {}, {
				picker = {
					win = {
						input = {
							keys = {
								['jj'] = { '<esc>', expr = true, mode = 'i' },
								['sv'] = 'edit_split',
								['sg'] = 'edit_vsplit',
								['st'] = 'edit_tab',
								['.'] = 'toggle_hidden',
								[','] = 'toggle_ignored',
								['e'] = 'qflist',
								['E'] = 'loclist',
								['K'] = 'select_and_prev',
								['J'] = 'select_and_next',
								['*'] = 'select_all',
								['<c-l>'] = { 'preview_scroll_right', mode = { 'i', 'n' } },
								['<c-h>'] = { 'preview_scroll_left', mode = { 'i', 'n' } },
							},
						},
						list = {
							keys = {
								['<c-l>'] = 'preview_scroll_right',
								['<c-h>'] = 'preview_scroll_left',
							},
						},
						preview = {
							keys = {
								['<c-h>'] = 'focus_input',
								['<c-l>'] = 'cycle_win',
							},
						},
					},
				},
			})
		end,
	},

	-----------------------------------------------------------------------------
	-- Hint and fix deviating indentation
	{
		'tenxsoydev/tabs-vs-spaces.nvim',
		event = { 'BufReadPost', 'BufNewFile' },
		opts = {},
	},

	-----------------------------------------------------------------------------
	-- Highlight words quickly
	{
		't9md/vim-quickhl',
		-- stylua: ignore
		keys = {
			{ '<leader>mt', '<Plug>(quickhl-manual-this)', mode = { 'n', 'x' }, desc = 'Highlight word' },
		},
	},
}
