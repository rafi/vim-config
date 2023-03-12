-- Plugin: Lualine
-- https://github.com/rafi/vim-config

-- Color table for highlights
local colors = {
	active = {
		fg = '#a8a897', -- '#bbc2cf',
		bg = '#30302c',
		boundary = '#51afef',
		paste = '#98be65',
		filepath = '#D7D7BC',
		progress = '#4e4e43',
	},
	inactive = {
		fg = '#666656',
		bg = '#30302c',
	},
	filemode = {
		modified = '#ec5f67',
		readonly = '#ec5f67',
	},
	diagnostics = {
		error = '#ec5f67',
		warn = '#ECBE7B',
		info = '#008080',
		hint = '#006080',
	},
	git = {
		added = '#516C31',
		modified = '#974505',
		deleted = '#B73944',
	},
}

local palette_active = {
	a = { fg = colors.active.fg, bg = colors.active.bg },
	b = { fg = colors.active.fg, bg = colors.active.bg },
	c = { fg = colors.active.fg, bg = colors.active.bg },
	y = { fg = colors.active.fg, bg = colors.active.bg },
	z = { fg = colors.active.fg, bg = colors.active.progress },
}

local palette_inactive = {
	a = { fg = colors.inactive.fg, bg = colors.inactive.bg },
	b = { fg = colors.inactive.fg, bg = colors.inactive.bg },
	c = { fg = colors.inactive.fg, bg = colors.inactive.bg },
	y = { fg = colors.inactive.fg, bg = colors.inactive.bg },
	z = { fg = colors.inactive.fg, bg = colors.inactive.bg },
}

-- Reference
-- Explorer:                         
-- Misc: ﬘ ⌯ ☱ ♯ 
-- Analysis: ✖ ✘ ✗ ⬪ ▪ ▫
-- Quickfix:               
-- Location:            
-- Lock: ⚠  ⚿  � � � �
-- Version: 
-- Zoom: � �
-- Unknown: ⯑

-- Amount of padding for icons
local function icon_padding()
	return vim.g.global_symbol_padding or ' '
end

-- File path
local function filepath()
	local fpath = require('rafi.lib.badge').filepath(0, 3, 5)
	return fpath:gsub('%%', '%%%%')
end

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
		opts = {
			options = {
				always_divide_middle = false,
				component_separators = { left = '', right = ''},
				section_separators   = { left = '', right = ''},
				theme = {
					normal   = palette_active,
					inactive = palette_inactive,
					insert   = palette_active,
					visual   = palette_active,
					replace  = palette_active,
					command  = palette_active,
				},
			},

			extensions = {
				-- Extension: Only name and line-count
				{
					sections = {
						lualine_a = {
							{
								function() return '▊' end,
								color = { fg = colors.active.boundary },
								padding = { left = 0, right = 1 },
							},
							{
								function() return require('rafi.lib.badge').icon() end,
								padding = 0
							},
						},
						lualine_z = { function() return '%l/%L' end },
					},
					inactive_sections = {
						lualine_a = { function() return require('rafi.lib.badge').icon() end },
						lualine_z = { function() return '%l/%L' end },
					},
					filetypes = {'Trouble', 'DiffviewFiles', 'NeogitStatus', 'Outline'},
				},
				-- Extension: File-explorer
				{
					sections = {
						lualine_a = {
							{
								function() return '▊' end,
								color = { fg = colors.active.boundary },
								padding = 0,
							},
							{ function() return '' end, padding = 1 },
							{ function() return '%<' end, padding = { left = 1, right = 0 }},
							{
								function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':~') end,
								padding = { left = 0, right = 1 },
							}
						},
						lualine_z = { function() return '%l/%L' end },
					},
					inactive_sections = {
						lualine_a = {
							{ function() return '' end, padding = 1 },
							{ function() return '%<' end, padding = { left = 1, right = 0 }},
							{
								function() return vim.fn.fnamemodify(vim.fn.getcwd(), ':~') end,
								padding = { left = 0, right = 1 },
							}
						},
						lualine_z = { function() return '%l/%L' end },
					},
					filetypes = {'neo-tree'},
				},
				-- Extension: Quickfix
				{
					sections = {
						lualine_a = {
							{
								function()
									if vim.fn.win_gettype() == 'loclist' then
										return '' .. icon_padding() .. 'Location List'
									end
									return '' .. icon_padding() .. 'Quickfix List'
								end,
								padding = { left = 1, right = 0 },
							},
							{
								function()
									if vim.fn.win_gettype() == 'loclist' then
										return vim.fn.getloclist(0, {title = 0}).title
									end
									return vim.fn.getqflist({title = 0}).title
								end
							},
						},
						lualine_z = { function() return '%l/%L' end },
					},
					filetypes = {'qf'},
				},
			},

			-- ACTIVE STATE --
			sections = {
				lualine_a = {
					-- Box boundary
					{
						function() return '▊' end,
						color = { fg = colors.active.boundary },
						padding = { left = 0, right = 1 },
					},

					-- Paste mode sign
					{
						function() return vim.go.paste and '=' or '' end,
						padding = 0,
						color = { fg = colors.active.paste }
					},

					-- Readonly or zoomed
					{
						function()
							return require('rafi.lib.badge').filemode('%*#', '🔒', '🔎')
						end,
						padding = 0,
						color = { fg = colors.filemode.readonly },
					},

					-- Buffer number
					{ function() return '%n' end, padding = 0 },

					-- Modified sign
					{
						function() return vim.bo.modified and '+' or '' end,
						padding = 0,
						color = { fg = colors.filemode.modified }
					},

					-- File icon
					{
						function() return require('rafi.lib.badge').icon() end,
						padding = { left = 1, right = #icon_padding() }
					},

					-- File path
					{ filepath, color = { fg = colors.active.filepath }, padding = 0 },

					-- Diagnostics
					{
						'diagnostics',
						sources = { 'nvim_diagnostic' },
						symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
						diagnostics_color = {
							error = { fg = colors.diagnostics.error },
							warn = { fg = colors.diagnostics.warn },
							info = { fg = colors.diagnostics.info },
							hint = { fg = colors.diagnostics.hint },
						},
						padding = { left = 1, right = 0 },
					},

					-- Start truncating here
					{ function() return '%<' end, padding = { left = 0, right = 0 }},

					-- Whitespace trails
					{
						function() return require('rafi.lib.badge').trails('␣') end,
						padding = { left = 1, right = 0 }
					},

					-- Git branch
					{
						'branch',
						icon = '',
						padding = { left = 1, right = 0 },
					},

					-- Git status
					{
						'diff',
						symbols = { added = '₊', modified = '∗', removed = '₋' },
						diff_color = {
							added = { fg = colors.git.added },
							modified = { fg = colors.git.modified },
							removed = { fg = colors.git.deleted },
						},
						cond = function() return vim.fn.winwidth(0) > 70 end,
						padding = { left = 1, right = 0 },
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = { function() return '%=' end },
				lualine_y = {
					-- File format, encoding and type.
					{
						function() return require('rafi.lib.badge').filemedia('  ') end,
						cond = function() return vim.fn.winwidth(0) > 60 end,
						padding = { left = 0, right = 1 },
					},
				},
				lualine_z = {
					-- Border
					{
						function () return '' end,
						padding = 0,
						color = { fg = colors.active.progress, bg = colors.active.bg }
					},

					{ function() return '%l/%2c%4p%%' end },
				}
			},

			-- INACTIVE STATE --
			inactive_sections = {
				lualine_a = {
					{
						function() return require('rafi.lib.badge').icon() end,
						padding = { left = 1, right = #icon_padding() }
					},
					{ filepath, padding = 0 },
					{
						function() return vim.bo.modified and '+' or '' end,
						color = { fg = colors.filemode.modified }
					},
				},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{ function() return vim.bo.filetype end },
				}
			}
		}
	}

}
