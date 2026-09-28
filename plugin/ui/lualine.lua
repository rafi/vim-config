-- Plugin: Lualine
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	-- Statusline plugin with many customizations.
	-- NOTE: This extends
	-- $XDG_DATA_HOME/nvim/lazy/LazyVim/lua/lazyvim/plugins/ui.lua
	{
		'lualine.nvim',
		enabled = not vim.g.started_by_firenvim,
		opts = function()
			local icons = LazyVim.config.icons

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
				bg = Snacks.util.color('StatusLine', 'bg'),
				fg = Snacks.util.color('StatusLine'),
			}
			local inactive = {
				bg = Snacks.util.color('StatusLineNC', 'bg'),
				fg = Snacks.util.color('StatusLineNC'),
			}

			local ColorUtil = require('rafi.util.color')
			local theme = {
				normal = {
					a = active,
					b = active,
					c = active,
					x = {
						fg = ColorUtil.brightness_modifier(active.bg, -80),
						bg = active.bg,
					},
					y = {
						fg = active.fg,
						bg = ColorUtil.brightness_modifier(active.bg, -20),
					},
					z = {
						fg = active.fg,
						bg = ColorUtil.brightness_modifier(active.bg, 63),
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

			local opts = {
				options = {
					theme = theme,
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = {
						statusline = {
							'dashboard',
							'alpha',
							'ministarter',
							'snacks_dashboard',
						},
					},
				},
				extensions = { 'lazy', 'fzf', 'man' },
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
								return { fg = Snacks.util.color(hl) }
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
							require('rafi.util.lualine').plugin_title(),
							padding = { left = 0, right = 1 },
							cond = is_plugin_window,
						},
						{
							'filetype',
							icon_only = true,
							padding = { left = 1, right = 0 },
							separator = { right = '' },
							cond = is_file_window,
						},
					},
					lualine_b = {
						-- File-path, toggle navic structure when clicked.
						{
							LazyVim.lualine.pretty_path({ length = 5 }),
							color = { fg = '#D7D7BC' },
							separator = '',
							cond = is_file_window,
							on_click = function()
								vim.g.trouble_lualine = not vim.g.trouble_lualine
								require('lualine').refresh()
							end,
						},
						-- Show buffer number in terminal
						{
							separator = '',
							padding = { left = 1, right = 1 },
							function()
								local s = vim.b.term_title or ''
								local n = vim.b.toggle_number or ''
								if vim.b.snacks_terminal then
									n = vim.b.snacks_terminal.id
								end
								return s .. (n and ' #' .. n or '')
							end,
							cond = function()
								return vim.bo.buftype == 'snacks_terminal'
									or vim.bo.buftype == 'terminal'
							end,
						},
						-- Quickfix/location list title
						{
							separator = '',
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
						-- stylua: ignore
						{
							require('rafi.util.lualine').trails(),
							cond = is_file_window,
							padding = { left = 1, right = 0 },
							color = function() return { fg = Snacks.util.color('Identifier') } end,
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

						-- Search count
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
					},
					lualine_c = {},
					lualine_x = {
						Snacks.profiler.status(),
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
						-- stylua: ignore
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
							color = function() return { fg = Snacks.util.color('Statement') } end,
						},
						-- showmode
						-- stylua: ignore
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
							color = function() return { fg = Snacks.util.color('Constant') } end,
						},
						-- dap status
						-- stylua: ignore
						{
							function() return '  ' .. require('dap').status() end,
							cond = function () return package.loaded['dap'] and require('dap').status() ~= '' end,
							color = function() return { fg = Snacks.util.color('Debug') } end,
						},
						-- lazy.nvim updates
						-- stylua: ignore
						{
							require('lazy.status').updates,
							cond = require('lazy.status').has_updates,
							color = function() return { fg = Snacks.util.color('Comment') } end,
							on_click = function()
								vim.cmd([[Lazy]])
							end,
						},
					},
					lualine_y = {
						{
							require('rafi.util.lualine').filemedia(),
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
							separator = '',
							padding = { left = 1, right = 0 },
						},
						{
							LazyVim.lualine.pretty_path({ length = 3 }),
							padding = { left = 1, right = 0 },
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

			-- Show code structure in statusline.
			-- Allow it to be overriden for some buffer types (see autocmds).
			if vim.g.trouble_lualine and LazyVim.has('trouble.nvim') then
				local trouble = require('trouble')
				local symbols = trouble.statusline({
					mode = 'symbols',
					groups = {},
					title = false,
					filter = { range = true },
					format = '{kind_icon}{symbol.name:Normal}',
					hl_group = 'lualine_c_normal',
				})
				table.insert(opts.sections.lualine_c, {
					symbols and symbols.get,
					cond = function()
						return vim.b.trouble_lualine ~= false and symbols.has()
					end,
				})
			end

			return opts
		end,
	},
}
