-- Plugin: Lualine
-- https://github.com/rafi/vim-config

return {

	-----------------------------------------------------------------------------
	{
		'nvim-lualine/lualine.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		event = 'VeryLazy',
		init = function()
			vim.g.qf_disable_statusline = true
		end,
		opts = function()
			local icons = require('rafi.config').icons
			local get_color = require('rafi.lib.color').get_color
			local fg = function(...) return { fg = get_color('fg', ...) } end

			local function filepath()
				local fpath = require('rafi.lib.badge').filepath(0, 3, 5)
				-- % char must be escaped in statusline.
				return fpath:gsub('%%', '%%%%')
			end

			local function is_file_window()
				return vim.bo.buftype == ''
			end

			local function is_min_width(min)
				if vim.o.laststatus > 2 then
					return vim.o.columns > min
				end
				return vim.fn.winwidth(0) > min
			end

			local active = {
				fg = get_color('fg', { 'StatusLine' }, '#000000'),
				bg = get_color('bg', { 'StatusLine' }, '#000000'),
			}
			local inactive = {
				fg = get_color('fg', { 'StatusLineNC' }, '#666656'),
				bg = get_color('bg', { 'StatusLineNC' }, '#000000'),
			}

			local theme = {
				normal = {
					a = active,
					b = active,
					c = active,
					x = active,
					y = {
						fg = active.fg,
						bg = require('rafi.lib.color').brightness_modifier(active.bg, -20),
					},
					z = {
						fg = active.fg,
						bg = require('rafi.lib.color').brightness_modifier(active.bg, 63),
					},
				},
				inactive = {
					a = inactive, b = inactive, c = inactive,
					x = inactive, y = inactive, z = inactive,
				},
			}

			return {
				options = {
					theme = theme,
					globalstatus = true,
					always_divide_middle = false,
					disabled_filetypes = { statusline = { 'dashboard', 'alpha' } },
					component_separators = '',
					section_separators   = '',
				},
				extensions = {
					'man',
				},
				sections = {
					lualine_a = {
						-- Left edge block.
						{
							function() return '▊' end,
							color = fg({'Directory'}, '#51afef'),
							padding = 0,
						},

						-- Readonly/zoomed/hash symbol.
						{
							padding = { left = 1, right = 0 },
							cond = is_file_window,
							function()
								if vim.bo.buftype == '' and vim.bo.readonly then
									return icons.status.filename.readonly
								elseif vim.t['zoomed'] then
									return icons.status.filename.zoomed
								end
								return '%*#'
							end,
						},

						-- Buffer number.
						{ function() return '%n' end, cond = is_file_window, padding = 0 },

						-- Modified symbol.
						{
							function()
								return vim.bo.modified and icons.status.filename.modified or ''
							end,
							cond = is_file_window,
							padding = 0,
							color = { fg = get_color('bg', {'DiffDelete'}, '#ec5f67') },
						},
					},
					lualine_b = {
						{
							function() return require('rafi.lib.badge').icon() end,
							padding = { left = 1, right = 0 },
						},
						{
							filepath,
							padding = 1,
							color = { fg = '#D7D7BC' },
							separator = '',
						},
						{
							'branch',
							cond = is_file_window,
							icon = '',
							padding = 1,
						},
						{
							function() return '#' .. vim.b['toggle_number'] end,
							cond = function() return vim.bo.buftype == 'terminal' end,
						},
						{
							function()
								if vim.fn.win_gettype() == 'loclist' then
									return vim.fn.getloclist(0, { title = 0 }).title
								end
								return vim.fn.getqflist({ title = 0 }).title
							end,
							cond = function() return vim.bo.filetype == 'qf' end,
							padding = { left = 1, right = 0 },
						},
					},
					lualine_c = {
						{
							'diagnostics',
							padding = { left = 1, right = 0 },
							symbols = {
								error = icons.status.diagnostics.error,
								warn = icons.status.diagnostics.warn,
								info = icons.status.diagnostics.info,
								hint = icons.status.diagnostics.hint,
							},
						},

						-- Whitespace trails
						{
							function() return require('rafi.lib.badge').trails('␣') end,
							cond = is_file_window,
							padding = { left = 1, right = 0 },
							color = { fg = get_color('bg', {'Identifier'}, '#b294bb') },
						},

						-- Start truncating here
						{ function() return '%<' end, padding = 0 },

						{
							'diff',
							symbols = {
								added = icons.status.git.added,
								modified = icons.status.git.modified,
								removed = icons.status.git.removed,
							},
							padding = { left = 1, right = 0 },
							cond = function()
								return is_file_window() and is_min_width(70)
							end,
						},
						-- {
						-- 	function() return require('nvim-navic').get_location() end,
						-- 	padding = { left = 1, right = 0 },
						-- 	cond = function()
						-- 		return is_min_width(100)
						-- 			and package.loaded['nvim-navic']
						-- 			and require('nvim-navic').is_available()
						-- 	end,
						-- },
					},
					lualine_x = {
						-- showcmd
						{
							function() return require('noice').api.status.command.get() end,
							cond = function()
								return package.loaded['noice']
									and require('noice').api.status.command.has()
							end,
							color = fg({'Statement'}),
						},
						-- showmode
						{
							function() return require('noice').api.status.mode.get() end,
							cond = function()
								return package.loaded['noice']
									and require('noice').api.status.mode.has()
							end,
							color = fg({'Constant'}),
						},
						-- search count
						{
							function() require('noice').api.status.search.get() end,
							cond = function()
								return package.loaded['noice']
									and require('noice').api.status.search.has()
							end,
							color = { fg = "#ff9e64" },
						},
						-- lazy.nvim updates
						{
							require('lazy.status').updates,
							cond = require('lazy.status').has_updates,
							color = fg({'Comment'}),
							separator = { left = '' },
						},
					},
					lualine_y = {
						{
							function() return require('rafi.lib.badge').filemedia('  ') end,
							cond = function() return is_min_width(70) end,
							separator = { left = '' },
							padding = 1,
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
							cond = function()
								return vim.bo.filetype ~= 'TelescopePrompt'
							end,
							separator = { left = '' },
							padding = 1,
						},
					},
				},
				inactive_sections = {
					lualine_a = {
						{
							function() return require('rafi.lib.badge').icon() end,
							padding = 1,
						},
						{ filepath, padding = { left = 1, right = 0 } },
						{
							function()
								return vim.bo.modified
									and vim.bo.buftype == ''
									and icons.status.filename.modified
									or ''
							end,
							cond = is_file_window,
							padding = 1,
							color = { fg = get_color('bg', {'DiffDelete'}, '#ec5f67') },
						},
					},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {
						{ function() return vim.bo.filetype end, cond = is_file_window },
					}
				},
			}
		end,
	},

}
