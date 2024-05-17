-- Plugin: Lualine
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Statusline plugin with many customizations.
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		event = 'VeryLazy',
		enabled = not vim.g.started_by_firenvim,
		init = function()
			vim.g.qf_disable_statusline = true
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = ' '
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			local Util = require('lazyvim.util')
			local RafiUtil = require('rafi.util')
			local icons = require('lazyvim.config').icons

			local function is_plugin_window()
				return vim.bo.buftype ~= ''
			end

			local function is_file_window()
				return vim.bo.buftype == ''
			end

			local function is_not_prompt()
				return vim.bo.buftype ~= 'prompt'
			end

			local function is_min_width(min)
				if vim.o.laststatus > 2 then
					return vim.o.columns > min
				end
				return vim.fn.winwidth(0) > min
			end

			local active = {
				bg = RafiUtil.ui.bg('StatusLine'),
				fg = RafiUtil.ui.fg('StatusLine'),
			}
			local inactive = {
				bg = RafiUtil.ui.bg('StatusLineNC'),
				fg = RafiUtil.ui.fg('StatusLineNC'),
			}

			local theme = {
				normal = {
					a = active,
					b = active,
					c = active,
					x = {
						fg = RafiUtil.color.brightness_modifier(active.bg, -80),
						bg = active.bg,
					},
					y = {
						fg = active.fg,
						bg = RafiUtil.color.brightness_modifier(active.bg, -20),
					},
					z = {
						fg = active.fg,
						bg = RafiUtil.color.brightness_modifier(active.bg, 63),
					},
				},
				inactive = {
					a = inactive,
					b = inactive,
					c = inactive,
					x = inactive,
					y = inactive,
					z = inactive,
				},
			}

			vim.o.laststatus = vim.g.lualine_laststatus

			return {
				options = {
					theme = theme,
					globalstatus = true,
					disabled_filetypes = {
						statusline = { 'dashboard', 'alpha', 'starter' },
					},
				},
				extensions = {
					'man',
					'lazy',
				},
				sections = {
					lualine_a = {
						-- Left edge block.
						{
							function()
								return '▊'
							end,
							padding = 0,
							separator = '',
							color = function()
								local hl = is_file_window() and 'Statement' or 'Function'
								return LazyVim.ui.fg(hl)
							end,
						},
						-- Readonly/zoomed/hash symbol.
						{
							padding = { left = 1, right = 0 },
							separator = '',
							cond = is_file_window,
							function()
								if vim.bo.buftype == '' and vim.bo.readonly then
									return icons.status.filename.readonly
								elseif vim.t['zoomed'] then
									return icons.status.filename.zoomed
								end
								return ''
							end,
						},
					},
					lualine_b = {
						{
							'branch',
							cond = is_file_window,
							icon = '', --  
							padding = 1,
							on_click = function()
								vim.cmd([[Telescope git_branches]])
							end,
						},
						LazyVim.lualine.root_dir(),
						{
							RafiUtil.lualine.plugin_title(),
							padding = { left = 0, right = 1 },
							cond = is_plugin_window,
						},
						{
							'filetype',
							icon_only = true,
							padding = { left = 1, right = 0 },
							cond = is_file_window,
						},
					},
					lualine_c = {
						{
							LazyVim.lualine.pretty_path(),
							color = { fg = '#D7D7BC' },
							cond = is_file_window,
							on_click = function()
								vim.g.structure_status = not vim.g.structure_status
								require('lualine').refresh()
							end,
						},
						{
							function()
								return '#' .. vim.b['toggle_number']
							end,
							cond = function()
								return vim.bo.buftype == 'terminal'
							end,
						},
						{
							function()
								if vim.fn.win_gettype() == 'loclist' then
									return vim.fn.getloclist(0, { title = 0 }).title
								end
								return vim.fn.getqflist({ title = 0 }).title
							end,
							cond = function()
								return vim.bo.filetype == 'qf'
							end,
							padding = { left = 1, right = 0 },
						},

						-- Whitespace trails
						{
							RafiUtil.lualine.trails(),
							cond = is_file_window,
							padding = { left = 1, right = 0 },
							color = LazyVim.ui.fg('Identifier'),
						},

						{
							'diagnostics',
							symbols = {
								error = icons.status.diagnostics.error,
								warn = icons.status.diagnostics.warn,
								info = icons.status.diagnostics.info,
								hint = icons.status.diagnostics.hint,
							},
						},

						{
							function()
								if vim.v.hlsearch == 0 then
									return ''
								end

								local ok, result =
									pcall(vim.fn.searchcount, { maxcount = 999, timeout = 10 })
								if not ok or next(result) == nil or result.current == 0 then
									return ''
								end

								local denominator = math.min(result.total, result.maxcount)
								return string.format(
									'/%s [%d/%d]',
									vim.fn.getreg('/'),
									result.current,
									denominator
								)
							end,
							separator = '',
							padding = { left = 1, right = 0 },
						},

						{
							function()
								return require('nvim-navic').get_location()
							end,
							padding = { left = 1, right = 0 },
							cond = function()
								return vim.g.structure_status
									and is_min_width(100)
									and package.loaded['nvim-navic']
									and require('nvim-navic').is_available()
							end,
							on_click = function()
								vim.g.structure_status = not vim.g.structure_status
								require('lualine').refresh()
							end,
						},
					},
					lualine_x = {
						-- Diff (git)
						{
							'diff',
							symbols = {
								added = icons.status.git.added,
								modified = icons.status.git.modified,
								removed = icons.status.git.removed,
							},
							padding = 1,
							cond = function()
								return is_file_window() and is_min_width(70)
							end,
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
							on_click = function()
								vim.cmd([[DiffviewFileHistory %]])
							end,
						},
						-- showcmd
						{
							function()
								---@diagnostic disable-next-line: undefined-field
								return require('noice').api.status.command.get()
							end,
							cond = function()
								return package.loaded['noice']
									---@diagnostic disable-next-line: undefined-field
									and require('noice').api.status.command.has()
							end,
							color = LazyVim.ui.fg('Statement'),
						},
						-- showmode
						{
							function()
								---@diagnostic disable-next-line: undefined-field
								return require('noice').api.status.mode.get()
							end,
							cond = function()
								return package.loaded['noice']
									---@diagnostic disable-next-line: undefined-field
									and require('noice').api.status.mode.has()
							end,
							color = LazyVim.ui.fg('Constant'),
						},
						-- dap status
						-- stylua: ignore
						{
							function() return '  ' .. require('dap').status() end,
							cond = function () return package.loaded['dap'] and require('dap').status() ~= '' end,
							color = LazyVim.ui.fg('Debug'),
						},
						-- lazy.nvim updates
						{
							require('lazy.status').updates,
							cond = require('lazy.status').has_updates,
							color = LazyVim.ui.fg('Comment'),
							on_click = function()
								vim.cmd([[Lazy]])
							end,
						},
					},
					lualine_y = {
						{
							RafiUtil.lualine.filemedia(),
							padding = 1,
							cond = function()
								return is_min_width(70)
							end,
							on_click = function()
								vim.cmd([[Telescope filetypes]])
							end,
						},
					},
					lualine_z = {
						{
							function()
								if is_file_window() then
									return '%l/%2c%4p%%'
								end
								return '%l/%L'
							end,
							cond = is_not_prompt,
							padding = 1,
						},
					},
				},
				inactive_sections = {
					lualine_a = {
						{
							'filetype',
							icon_only = true,
							colored = false,
							padding = { left = 1, right = 0 },
						},
						{ Util.lualine.pretty_path(), padding = { left = 1, right = 0 } },
						{
							function()
								return vim.bo.modified
										and vim.bo.buftype == ''
										and icons.status.filename.modified
									or ''
							end,
							cond = is_file_window,
							padding = 1,
							color = { fg = RafiUtil.ui.bg('DiffDelete') },
						},
					},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {
						{
							function()
								return vim.bo.filetype
							end,
							cond = is_file_window,
						},
					},
				},
			}
		end,
	},
}
