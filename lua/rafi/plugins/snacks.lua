return {

	-- Snacks picker
	{
		'folke/snacks.nvim',
		keys = function(_, keys)
			if LazyVim.pick.picker.name ~= 'snacks' then
				return
			end
			-- stylua: ignore
			local mappings = {
				{ '<leader><localleader>', function() Snacks.picker() end, mode = { 'n', 'x' }, desc = 'Pickers' },
				{ '<localleader>r', '<leader>sR', remap = true, desc = 'Resume Last' },
				{ '<localleader>u', function() Snacks.picker.spelling() end, mode = { 'n', 'x' }, desc = 'Spellcheck' },
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
			if LazyVim.pick.picker.name ~= 'snacks' then
				return
			end
			return vim.tbl_deep_extend('force', opts or {}, {
				picker = {
					sources = {
						files = {
							hidden = true,
							ignored = true,
						},
						grep = {
							hidden = true,
							ignored = true,
						},
					},
					win = {
						input = {
							keys = {
								['jj'] = { '<esc>', expr = true, mode = 'i' },
								['s'] = false,
								['ss'] = 'flash',
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

	-- Snacks explorer
	{
		'folke/snacks.nvim',
		keys = function(_, keys)
			if not LazyVim.has_extra('editor.snacks_explorer') then
				return
			end
			--- Open callback and toggle Snacks explorer window.
			---@param cb function
			local function open(cb)
				return function()
					local explorer_pickers = Snacks.picker.get({ source = 'explorer' })
					for _, v in pairs(explorer_pickers) do
						if v:is_focused() then
							v:close()
						else
							v:focus()
						end
					end
					if #explorer_pickers == 0 then
						cb()
					end
				end
			end
			-- stylua: ignore
			local mappings = {
				{ '<localleader>e', '<leader>fe', open(function() Snacks.explorer({ cwd = LazyVim.root() }) end), desc = 'Explorer Tree', remap = true },
				{ '<localleader>E', '<leader>fE', open(function() Snacks.explorer() end), desc = 'Explorer Tree (cwd)', remap = true },
				{ '<localleader>a', open(function() Snacks.explorer.reveal({ cwd = LazyVim.root() }) end), desc = 'Reveal in Explorer' },
				{ '<localleader>A', open(function() Snacks.explorer.reveal() end), desc = 'Reveal in Explorer (cwd)' },
			}
			return vim.list_extend(mappings, keys)
		end,
		opts = function(_, opts)
			if not LazyVim.has_extra('editor.snacks_explorer') then
				return
			end
			return vim.tbl_deep_extend('force', opts or {}, {
				image = {},
				picker = {
					sources = {
						explorer = {
							replace_netrw = true,
							hidden = true,
							ignored = true,
							layout = {
								cycle = false,
								auto_hide = { 'input' },
							},
							jump = { close = true },
							actions = {
								-- Find in path.
								find_in_path = function(_, item)
									if not item.dir or not item.open then
										item = item.parent
									end
									LazyVim.pick('files', { cwd = item.file })()
								end,
								-- Grep in path.
								grep_in_path = function(_, item)
									if not item.dir or not item.open then
										item = item.parent
									end
									LazyVim.pick('live_grep', { cwd = item.file })()
								end,
								-- Search and replace in path.
								search_replace_in_path = function(_, item)
									if not item.dir or not item.open then
										item = item.parent
									end
									require('grug-far').open({
										prefills = {
											paths = vim.fn.fnameescape(item.file),
										},
									})
								end,
								toggle_width = function(picker)
									local normal = 30 -- state.window.width
									local large = normal * 1.9
									local small = math.floor(normal / 1.6)
									local cur_width = vim.fn.winwidth(0) -- state.win_width
									local new_width = normal
									if cur_width > normal then
										new_width = small
									elseif cur_width == normal then
										new_width = large
									end
									vim.cmd(new_width .. ' wincmd |')
								end,
							},
							win = {
								list = {
									keys = {
										['K'] = 'toggle_preview',
										['<esc>'] = false,
										['<c-h>'] = false,
										['<c-l>'] = false,
										['sv'] = 'edit_split',
										['sg'] = 'edit_vsplit',
										['st'] = 'edit_tab',
										['gf'] = 'find_in_path',
										['gr'] = 'grep_in_path',
										['gz'] = 'search_replace_in_path',
										['w'] = 'toggle_width',
									},
								},
							},
						},
					},
				},
			})
		end,
	},
}
